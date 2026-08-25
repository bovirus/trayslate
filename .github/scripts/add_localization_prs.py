#!/usr/bin/env python3
"""
Adds entries to CHANGELOG.md for merged pull requests that modified files
inside the 'locale/' directory. Uses GitHub API with the provided token.
"""

import os
import re
import subprocess
import json
import sys

# Environment variables
token = os.environ["GITHUB_TOKEN"]
current_tag = os.environ["CURRENT_TAG"]
repo = os.environ["GITHUB_REPOSITORY"]  # format "owner/repo"

def get_previous_tag():
    """Find the tag immediately preceding the current one."""
    result = subprocess.run(
        ["git", "tag", "--sort=-creatordate"],
        capture_output=True, text=True, check=True
    )
    tags = result.stdout.strip().split("\n")
    for tag in tags:
        if tag != current_tag:
            return tag
    return None

previous_tag = get_previous_tag()
if not previous_tag:
    print("No previous tag found, skipping localization PR addition.")
    sys.exit(0)

print(f"Previous tag: {previous_tag}, current tag: {current_tag}")

def get_tag_date(tag):
    """Get the ISO date of a given tag."""
    result = subprocess.run(
        ["git", "log", "-1", "--format=%aI", tag],
        capture_output=True, text=True, check=True
    )
    return result.stdout.strip()

prev_date = get_tag_date(previous_tag)
print(f"Date of previous tag: {prev_date}")

# Query merged PRs updated after the previous tag
url = f"https://api.github.com/repos/{repo}/pulls"
headers = [
    "-H", f"Authorization: Bearer {token}",
    "-H", "Accept: application/vnd.github+json"
]
params = [
    "--data-urlencode", "state=closed",
    "--data-urlencode", "base=main",   # change to your default branch if needed
    "--data-urlencode", "sort=updated",
    "--data-urlencode", "direction=desc",
    "--data-urlencode", "per_page=100"
]
cmd = ["curl", "-s", *headers, "-G", url, *params]

response = subprocess.run(cmd, capture_output=True, text=True, check=True)
pulls = json.loads(response.stdout)

localization_prs = []
for pr in pulls:
    merged_at = pr.get("merged_at")
    if not merged_at or merged_at <= prev_date:
        continue

    pr_number = pr["number"]
    files_url = f"https://api.github.com/repos/{repo}/pulls/{pr_number}/files"
    files_cmd = ["curl", "-s", *headers, files_url]
    files_response = subprocess.run(files_cmd, capture_output=True, text=True, check=True)
    files = json.loads(files_response.stdout)

    changed_locale_files = [f["filename"] for f in files if f["filename"].startswith("locale/")]
    if changed_locale_files:
        author = pr["user"]["login"]
        pr_html_url = pr["html_url"]
        files_str = ", ".join(changed_locale_files)
        line = f"- {files_str} by @{author} in [#{pr_number}]({pr_html_url})"
        localization_prs.append(line)

if not localization_prs:
    print("No PRs modified locale/, nothing to add.")
    sys.exit(0)

print(f"Found {len(localization_prs)} localization PR(s).")

# Insert into CHANGELOG.md
changelog_path = "CHANGELOG.md"

# Read existing content if file exists, then remove it to avoid permission issues
if os.path.exists(changelog_path):
    with open(changelog_path, "r", encoding="utf-8") as f:
        content = f.read()
    os.remove(changelog_path)
else:
    content = ""

localization_header = "### 🌐 Localization"
insert_block = "\n".join(localization_prs)

if localization_header in content:
    pattern = re.compile(
        rf"({re.escape(localization_header)}\s*\n)(?=###|\Z)",
        re.MULTILINE
    )
    new_content = pattern.sub(
        lambda m: m.group(1) + insert_block + "\n",
        content,
        count=1
    )
else:
    # Insert before "Fixed Bugs" section if it exists, otherwise at end
    fixed_bugs_header = "### 🐛 Fixed Bugs"
    fixed_bugs_idx = content.find(fixed_bugs_header)
    if fixed_bugs_idx != -1:
        insert_pos = fixed_bugs_idx
    else:
        insert_pos = len(content)

    new_content = content[:insert_pos].rstrip() + "\n\n" + localization_header + "\n" + insert_block + "\n" + content[insert_pos:]

with open(changelog_path, "w", encoding="utf-8") as f:
    f.write(new_content)

print("Localization PR entries added to CHANGELOG.md")