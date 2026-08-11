import argparse
import json
import sqlite3
from pathlib import Path
import urllib.parse


def write_json(path: Path, data):
    path.parent.mkdir(parents=True, exist_ok=True)

    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, sort_keys=True)
        f.write("\n")


def build_api(db_path: Path, output: Path):
    db = sqlite3.connect(db_path)
    db.row_factory = sqlite3.Row

    images = db.execute("""
        SELECT
            digest, 
            registry,
            repository,
            tag, 
            architecture,
            os,
            size 
        FROM images
        ORDER BY repository, tag
    """).fetchall()

    write_json(
        output / "images.json",
        {"images": [dict(image) for image in images]},
    )

    for image in images:
        digest = image["digest"]

        packages = db.execute(
            """ 
            SELECT ecosystem, name, version 
            FROM packages 
            WHERE image_digest = ? 
            ORDER BY ecosystem, name 
        """,
            (digest,),
        ).fetchall()

        data = dict(image)
        data["packages"] = [dict(package) for package in packages]
        write_json(
            output / "images" / f"{urllib.parse.quote_plus(digest)}.json",
            data,
        )

    packages = db.execute("""
        SELECT ecosystem, name, version, image_digest
        FROM packages
        ORDER BY ecosystem, name, version
    """).fetchall()

    ecosystem_index = {}

    for package in packages:
        ecosystem = package["ecosystem"]
        name = package["name"]
        version = package["version"]
        digest = package["image_digest"]

        packages_for_ecosystem = ecosystem_index.setdefault(ecosystem, {})
        versions = packages_for_ecosystem.setdefault(
            name,
            {},
        )
        digests = versions.setdefault(
            version,
            [],
        )

        if digest not in digests:
            digests.append(digest)
    for ecosystem, packages_for_ecosystem in ecosystem_index.items():
        write_json(
            output / "packages" / f"{urllib.parse.quote_plus(ecosystem)}.json",
            packages_for_ecosystem,
        )

    write_json(
        output / "packages.json",
        {"ecosystems": sorted(ecosystem_index.keys())},
    )

    db.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--db", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)

    args = parser.parse_args()

    build_api(args.db, args.output)
