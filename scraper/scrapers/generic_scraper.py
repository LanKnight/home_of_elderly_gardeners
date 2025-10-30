import re
from typing import List, Dict, Optional
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse


def _make_absolute(src: str, base: Optional[str]) -> str:
    if not src:
        return src
    src = src.strip()
    # protocol-relative
    if src.startswith('//'):
        return 'https:' + src
    # absolute already
    parsed = urlparse(src)
    if parsed.scheme:
        return src
    if base:
        return urljoin(base, src)
    return src


def _extract_thumbnail_for_video_tag(v_tag, soup, base: Optional[str]) -> Optional[str]:
    # poster attribute on video
    poster = v_tag.get('poster')
    if poster:
        return _make_absolute(poster, base)

    # try og:image
    og = soup.find('meta', property='og:image')
    if og and og.get('content'):
        return _make_absolute(og.get('content'), base)

    # try link rel image_src
    link_img = soup.find('link', rel='image_src')
    if link_img and link_img.get('href'):
        return _make_absolute(link_img.get('href'), base)

    # try nearest img inside parent
    img = v_tag.find('img')
    if img and img.get('src'):
        return _make_absolute(img.get('src'), base)

    return None


def find_video_urls_from_html(html: str, base_url: str = '') -> List[Dict]:
    soup = BeautifulSoup(html, 'html.parser')
    results: List[Dict] = []

    # Resolve base tag if present
    base_tag = soup.find('base')
    base = base_tag.get('href') if base_tag and base_tag.get('href') else base_url

    # Try <video> tags
    for v in soup.find_all('video'):
        src = None
        # <video src="...">
        if v.get('src'):
            src = v.get('src')
        # <source src=...> (may be multiple; pick first)
        source = v.find('source')
        if source and source.get('src'):
            src = source.get('src')

        if src:
            abs_src = _make_absolute(src, base)
            thumb = _extract_thumbnail_for_video_tag(v, soup, base)
            results.append({'title': v.get('title') or '', 'source': abs_src, 'thumbnail': thumb})

    # Try meta og:video
    og_video = soup.find('meta', property='og:video')
    if og_video and og_video.get('content'):
        src = _make_absolute(og_video.get('content'), base)
        thumb = None
        # try og:image for thumbnail
        og_img = soup.find('meta', property='og:image')
        if og_img and og_img.get('content'):
            thumb = _make_absolute(og_img.get('content'), base)
        results.append({'title': '', 'source': src, 'thumbnail': thumb})

    # Try links to common video file extensions
    for a in soup.find_all('a', href=True):
        href = a['href']
        if re.search(r'\.(mp4|m3u8|webm|ogg)(\?|$)', href, re.I):
            abs_href = _make_absolute(href, base)
            # attempt to find a nearby img for thumbnail
            thumb = None
            # check for <img> inside the link
            img = a.find('img')
            if img and img.get('src'):
                thumb = _make_absolute(img.get('src'), base)
            results.append({'title': a.get_text(strip=True) or '', 'source': abs_href, 'thumbnail': thumb})

    # Deduplicate preserving order by absolute source
    seen = set()
    unique: List[Dict] = []
    for item in results:
        src = item.get('source')
        if not src:
            continue
        if src in seen:
            continue
        seen.add(src)
        unique.append({'title': item.get('title', ''), 'source': src, 'thumbnail': item.get('thumbnail')})

    return unique


def fetch_videos_for_url(url: str, limit: int = 20) -> List[Dict]:
    try:
        headers = {
            'User-Agent': 'Mozilla/5.0 (compatible; ScraperBot/1.0)'
        }
        resp = requests.get(url, headers=headers, timeout=10)
        resp.raise_for_status()
        html = resp.text
        base = resp.url
        items = find_video_urls_from_html(html, base_url=base)

        # Return top N
        return items[:limit]
    except Exception as e:
        # On error, return empty list
        return []
