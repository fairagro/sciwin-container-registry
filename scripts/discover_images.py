import json
import sys
import requests
from argparse import ArgumentParser

parser = ArgumentParser("discover_images")
parser.add_argument("--namespaces", nargs="+", default=[])
args = parser.parse_args()


def read_page(url):
    res = requests.get(url)
    body = res.json()

    # pagination is only allowed if login, we dont care as we build index incrementally
    return body["results"]


def latest_tag(namespace, repo):
    endpoint = (
        f"https://hub.docker.com/v2/repositories/{namespace}/{repo}/tags/"
        "?page_size=1&ordering=last_updated"
    )
    results = read_page(endpoint)
    return results[0]["name"] if results else None


images = []

for namespace in args.namespaces:
    endpoint = f"https://hub.docker.com/v2/repositories/{namespace}/?page_size=30&ordering=last_updated"
    results = read_page(endpoint)
    repos = [r["name"] for r in results if r["status"] == 1]

    for repo in repos:
        tag = latest_tag(namespace, repo)
        if tag:
            images.append(f"{namespace}/{repo}:{tag}")

with open("images.json", "w") as f:
    json.dump(images, f, indent=4)
