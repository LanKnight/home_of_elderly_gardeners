from fastapi import FastAPI, Query
from typing import List
from .scrapers.generic_scraper import fetch_videos_for_url

app = FastAPI(title='Video Scraper API')


@app.get('/videos')
def videos(url: str = Query(..., description='Target page URL to scrape'), limit: int = 20):
    """
    Scrape the given URL for video sources and return JSON list.
    Example: /videos?url=https://example.com/page
    """
    items = fetch_videos_for_url(url, limit=limit)
    return {'videos': items}
