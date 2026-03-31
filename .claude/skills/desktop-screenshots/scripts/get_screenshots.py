#!/usr/bin/env python3
"""List and optionally copy screenshot images from a directory."""

import argparse
import json
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path

DEFAULT_EXTS = {"png", "jpg", "jpeg", "webp", "gif", "bmp", "tiff", "heic"}


@dataclass
class Shot:
  path: Path
  mtime: float
  size: int


def parse_args():
  parser = argparse.ArgumentParser(description="Get screenshots from a directory")
  parser.add_argument("--dir", default="~/Desktop/screenshots", help="Source directory")
  parser.add_argument("--latest", type=int, default=0, help="Return latest N files")
  parser.add_argument("--limit", type=int, default=0, help="Maximum result count")
  parser.add_argument("--ext", action="append", default=[], help="Extension filter, repeatable")
  parser.add_argument("--copy-to", default="", help="Copy matched files to directory")
  parser.add_argument("--json", action="store_true", help="Output JSON")
  return parser.parse_args()


def normalize_exts(values):
  if not values:
    return DEFAULT_EXTS
  out = set()
  for value in values:
    cleaned = f"{value}".strip().lower().lstrip(".")
    if cleaned:
      out.add(cleaned)
  return out or DEFAULT_EXTS


def collect(source_dir, exts):
  shots = []
  for path in source_dir.iterdir():
    if not path.is_file():
      continue
    if path.suffix.lower().lstrip(".") not in exts:
      continue
    stat = path.stat()
    shots.append(Shot(path=path.resolve(), mtime=stat.st_mtime, size=stat.st_size))
  shots.sort(key=lambda item: item.mtime, reverse=True)
  return shots


def cut(shots, latest, limit):
  out = shots
  if latest and latest > 0:
    out = out[:latest]
  if limit and limit > 0:
    out = out[:limit]
  return out


def copy_files(shots, target_dir):
  target_dir.mkdir(parents=True, exist_ok=True)
  copied = []
  for shot in shots:
    target = target_dir / shot.path.name
    if target.exists():
      stem = target.stem
      suffix = target.suffix
      i = 1
      while target.exists():
        target = target_dir / f"{stem}-{i}{suffix}"
        i += 1
    shutil.copy2(shot.path, target)
    copied.append(target.resolve())
  return copied


def to_payload(shots, copied=None):
  payload = []
  for index, shot in enumerate(shots):
    item = {
      "path": str(shot.path),
      "name": shot.path.name,
      "mtime": datetime.fromtimestamp(shot.mtime).isoformat(),
      "size": shot.size,
    }
    if copied and index < len(copied):
      item["copied_to"] = str(copied[index])
    payload.append(item)
  return payload


def main():
  args = parse_args()
  source_dir = Path(args.dir).expanduser()
  if not source_dir.exists() or not source_dir.is_dir():
    print(f"Source directory not found: {source_dir}", file=sys.stderr)
    return 2

  exts = normalize_exts(args.ext)
  shots = collect(source_dir, exts)
  selected = cut(shots, args.latest, args.limit)

  copied = None
  if args.copy_to:
    copied = copy_files(selected, Path(args.copy_to).expanduser())

  payload = to_payload(selected, copied)

  if args.json:
    print(json.dumps(payload, ensure_ascii=False, indent=2))
  else:
    if not payload:
      print("No screenshots found")
      return 0
    for item in payload:
      line = f"{item['mtime']}  {item['path']}"
      if "copied_to" in item:
        line = f"{line}  ->  {item['copied_to']}"
      print(line)

  return 0


if __name__ == "__main__":
  raise SystemExit(main())
