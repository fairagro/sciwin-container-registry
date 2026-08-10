import json
import sqlite3
import os
from argparse import ArgumentParser
from datetime import datetime, timezone

parser = ArgumentParser("add_index")
parser.add_argument("--index", required=False)  # sqlite
parser.add_argument("--sboms", required=True)  # dir
parser.add_argument("--scheme", required=False)  # scheme

args = parser.parse_args()

if not args.scheme and not args.index:
    raise Exception("Needs either scheme or index")

db = sqlite3.connect(args.index)
check = db.execute(
    "SELECT name FROM sqlite_master WHERE type='table' AND name='packages'"
)
if not check.fetchone():
    with open(args.scheme, "r", encoding="utf-8") as f:
        cursor = db.cursor()
        cursor.executescript(f.read())
        db.commit()

items = [
    os.path.join(root, f)
    for root, _, files in os.walk(args.sboms)
    for f in files
    if f.endswith(".json")
]

scanned_at = datetime.now(timezone.utc).isoformat()

for sbom_path in items:
    with open(sbom_path, "r", encoding="utf-8") as f:
        sbom = json.load(f)

    source = sbom["source"]
    metadata = source.get("metadata", {})

    digest = source["id"]
    repository = source["name"]
    registry = "docker.io"
    if "/" in repository:
        first, _, rest = repository.partition("/")
        if "." in first or ":" in first or first == "localhost":
            registry = first
            repository = rest

    tags = metadata.get("tags") or []
    tag = tags[0] if tags else None
    architecture = metadata.get("architecture") or None
    os_name = metadata.get("os") or None

    db.execute(
        """
        INSERT INTO images
            (digest, registry, repository, tag, architecture, os, sbom_path, scanned_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ON CONFLICT(digest) DO UPDATE SET
            registry=excluded.registry,
            repository=excluded.repository,
            tag=excluded.tag,
            architecture=excluded.architecture,
            os=excluded.os,
            sbom_path=excluded.sbom_path,
            scanned_at=excluded.scanned_at
        """,
        (digest, registry, repository, tag, architecture, os_name, sbom_path, scanned_at),
    )

    packages = [
        (digest, artifact["type"], artifact["name"], artifact["version"])
        for artifact in sbom.get("artifacts", [])
    ]
    db.executemany(
        """
        INSERT INTO packages (image_digest, ecosystem, name, version)
        VALUES (?, ?, ?, ?)
        ON CONFLICT(image_digest, ecosystem, name) DO UPDATE SET version=excluded.version
        """,
        packages,
    )

db.commit()
db.close()
