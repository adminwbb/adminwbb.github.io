#!/usr/bin/env python3
"""根据文章标题重命名 Markdown 文件"""

import os
import re
import sys

def rename_by_title(directory):
    """遍历目录下的所有 .md 文件，根据 frontmatter 中的 title 重命名"""
    files = [f for f in os.listdir(directory) if f.endswith('.md')]
    renamed = []
    errors = []

    for f in files:
        filepath = os.path.join(directory, f)
        try:
            with open(filepath, 'r', encoding='utf-8') as file:
                content = file.read()

            # Extract title from frontmatter
            match = re.search(r'^title:\s*["\']?(.+?)["\']?\s*$', content, re.MULTILINE)
            if match:
                title = match.group(1).strip()
                # Sanitize filename - remove invalid chars, limit length
                new_name = re.sub(r'[<>:"/\\|?*\x00-\x1f]', '', title)
                new_name = new_name.strip()[:80]
                if not new_name:
                    new_name = f
                if not new_name.endswith('.md'):
                    new_name += '.md'

                if new_name != f:
                    # Handle duplicates
                    base_name = new_name
                    counter = 1
                    while os.path.exists(os.path.join(directory, new_name)) and new_name != f:
                        name, ext = os.path.splitext(base_name)
                        new_name = f"{name}_{counter}{ext}"
                        counter += 1

                    old_path = filepath
                    new_path = os.path.join(directory, new_name)
                    os.rename(old_path, new_path)
                    renamed.append((f, new_name))
            else:
                errors.append(f"No title found: {f}")
        except Exception as e:
            errors.append(f"{f}: {e}")

    return renamed, errors

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: rename_by_title.py <directory>")
        sys.exit(1)

    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print(f"Error: {directory} is not a directory")
        sys.exit(1)

    renamed, errors = rename_by_title(directory)
    print(f"Renamed: {len(renamed)}")
    for old, new in renamed:
        print(f"  {old} -> {new}")
    if errors:
        print(f"Errors: {len(errors)}")
        for e in errors:
            print(f"  {e}")