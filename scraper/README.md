# Video Scraper (prototype)

This folder contains a small FastAPI-based scraper prototype that tries to extract video sources
from a provided page URL.

Prerequisites
- Python 3.8+
- Install requirements:

```bash
python -m pip install -r requirements.txt
```

Run the service locally:

```bash
uvicorn app:app --reload --host 127.0.0.1 --port 8000
```

Example usage (after running service):

Request:
```
GET http://127.0.0.1:8000/videos?url=https://example.com/page
```

The endpoint will attempt to find `<video>` tags, `<source>` tags, `og:video` meta tags and direct links to `.mp4`, `.m3u8`, `.webm` files.

Notes
- This is a simple prototype meant to demonstrate integration with the Flutter app. For real-world scraping you may need:
  - Playwright / Selenium for JS-rendered pages
  - Robust rate-limiting, retries, error handling
  - Respect robots.txt and site terms of service
  - Authentication handling if required by the target site
