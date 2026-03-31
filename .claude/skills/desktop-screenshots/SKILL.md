---
name: desktop-screenshots
description: Retrieve image files from the Desktop screenshots directory. Use when a user asks to list, find, filter, or copy screenshots from `~/Desktop/screenshots`, including requests like getting the latest screenshot, all PNG/JPG files, or files within a date range.
---

# Desktop Screenshots

## Overview

Fetch screenshots from `~/Desktop/screenshots` quickly and consistently with a reusable script.
Prefer the bundled script for listing, filtering, sorting, and optional copying.

## Workflow

1. Resolve the source directory.
- Default to `~/Desktop/screenshots`.
- If the user specifies another path, use that path.

2. Run the script for listing/filtering.
- Use `scripts/get_screenshots.py`.
- Choose options based on the request:
  - Latest files: `--latest N`
  - Max result count: `--limit N`
  - Extensions: `--ext png --ext jpg`
  - Output format: `--json`

3. Copy files only when requested.
- Use `--copy-to <dir>` to copy matched files.
- Keep source files unchanged.

4. Report clear results.
- Return absolute paths for selected files.
- If no files match, state that explicitly.
- If the source directory does not exist, state it and ask for an alternate path.

## Commands

```bash
# Latest screenshot (human-readable)
python3 scripts/get_screenshots.py --latest 1

# Latest 5 PNG/JPG screenshots as JSON
python3 scripts/get_screenshots.py --latest 5 --ext png --ext jpg --json

# Up to 20 screenshots and copy to another folder
python3 scripts/get_screenshots.py --limit 20 --copy-to /tmp/selected-shots --json
```

## Notes

- Sort order is newest first by modification time.
- Supported default extensions are `png`, `jpg`, `jpeg`, `webp`, `gif`, `bmp`, `tiff`, `heic`.
- Use `--ext` repeatedly to narrow file types.
