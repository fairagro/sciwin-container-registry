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

    if "results" not in body:
        print(f"warning: stopping pagination at {url}: {body}", file=sys.stderr)
        return []

    results = body["results"]

    if body.get("next"):
        results += read_page(body["next"])

    return results


images = []

for namespace in args.namespaces:
    endpoint = f"https://hub.docker.com/v2/repositories/{namespace}/?page_size=100&ordering=last_updated"
    results = read_page(endpoint)
    names = [f"{r['namespace']}/{r['name']}" for r in results if r["status"] == 1]
    images += names

with open("images.json", "w") as f:
    json.dump(images, f, indent=4)
