#!/usr/bin/env python3
import requests
import json
import os
import re
import subprocess
import sys

# GitHub repository details
REPO_OWNER = "iarunsaragadam"
REPO_NAME = "flutter-docker"
GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")

def get_flutter_releases():
    """Fetch the latest Flutter releases from the Flutter GitHub repo."""
    url = "https://api.github.com/repos/flutter/flutter/releases"
    headers = {"Accept": "application/vnd.github.v3+json"}
    
    if GITHUB_TOKEN:
        headers["Authorization"] = f"Bearer {GITHUB_TOKEN}"
    
    response = requests.get(url, headers=headers)
    
    if response.status_code != 200:
        print(f"Error: Unable to fetch Flutter releases. Status code: {response.status_code}")
        print(response.text)
        return []
    
    releases = response.json()
    
    # Filter stable releases and extract version tags
    stable_releases = []
    for release in releases:
        tag_name = release["tag_name"]
        # Check if it's a stable version tag (e.g., v3.29.0)
        if re.match(r"^v\d+\.\d+\.\d+$", tag_name) and not release["prerelease"]:
            stable_releases.append(tag_name)
    
    return stable_releases

def get_existing_tags():
    """Get existing tags from our repository."""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/tags"
    headers = {"Accept": "application/vnd.github.v3+json"}
    
    if GITHUB_TOKEN:
        headers["Authorization"] = f"Bearer {GITHUB_TOKEN}"
    
    response = requests.get(url, headers=headers)
    
    if response.status_code != 200:
        print(f"Error: Unable to fetch repository tags. Status code: {response.status_code}")
        print(response.text)
        return []
    
    tags = response.json()
    return [tag["name"] for tag in tags]

def get_existing_packages():
    """Get existing packages from GitHub Container Registry."""
    url = f"https://api.github.com/users/{REPO_OWNER}/packages/container/flutter-web-builder/versions"
    headers = {"Accept": "application/vnd.github.v3+json"}
    
    if GITHUB_TOKEN:
        headers["Authorization"] = f"Bearer {GITHUB_TOKEN}"
    
    response = requests.get(url, headers=headers)
    
    if response.status_code != 200:
        print(f"Error: Unable to fetch package versions. Status code: {response.status_code}")
        print(response.text)
        return []
    
    versions = response.json()
    package_tags = []
    
    for version in versions:
        for tag in version.get("metadata", {}).get("container", {}).get("tags", []):
            package_tags.append(tag)
    
    return package_tags

def create_tag(version):
    """Create a new tag in the repository to trigger the Docker build workflow."""
    url = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/git/refs"
    headers = {
        "Accept": "application/vnd.github.v3+json",
        "Authorization": f"Bearer {GITHUB_TOKEN}"
    }
    
    # First, get the SHA of the latest commit
    response = requests.get(
        f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/git/refs/heads/main", 
        headers=headers
    )
    
    if response.status_code != 200:
        print(f"Error: Unable to get the latest commit. Status code: {response.status_code}")
        print(response.text)
        return False
    
    sha = response.json()["object"]["sha"]
    
    # Create the tag
    data = {
        "ref": f"refs/tags/{version}",
        "sha": sha
    }
    
    response = requests.post(url, headers=headers, json=data)
    
    if response.status_code == 201:
        print(f"Successfully created tag {version}")
        return True
    else:
        print(f"Error: Failed to create tag {version}. Status code: {response.status_code}")
        print(response.text)
        return False

def main():
    if not GITHUB_TOKEN:
        print("Error: GITHUB_TOKEN environment variable not set")
        sys.exit(1)
    
    # Get the latest Flutter stable releases
    flutter_versions = get_flutter_releases()
    
    if not flutter_versions:
        print("No Flutter releases found")
        sys.exit(0)
    
    # Get existing tags from our repository
    existing_tags = get_existing_tags()
    
    # Get existing packages from GHCR
    existing_packages = get_existing_packages()
    
    # Combine both lists to get all versions we've already processed
    processed_versions = set(existing_tags + existing_packages)
    
    # Find missing versions (Flutter releases that we haven't built Docker images for)
    missing_versions = [version for version in flutter_versions if version not in processed_versions]
    
    if not missing_versions:
        print("No new Flutter versions to process")
        sys.exit(0)
    
    print(f"Found {len(missing_versions)} new Flutter versions to process")
    
    # Process the 5 most recent missing versions to avoid overloading GitHub Actions
    for version in missing_versions[:5]:
        print(f"Creating tag for Flutter version {version}")
        create_tag(version)

if __name__ == "__main__":
    main()