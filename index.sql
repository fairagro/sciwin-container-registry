CREATE TABLE IF NOT EXISTS images (
    digest TEXT PRIMARY KEY,
    registry TEXT NOT NULL,
    repository TEXT NOT NULL,
    tag TEXT,
    architecture TEXT,
    os TEXT,
    size INTEGER,
    sbom_path TEXT NOT NULL,
    scanned_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS packages (
    image_digest TEXT NOT NULL,
    ecosystem TEXT NOT NULL,
    name TEXT NOT NULL,
    version TEXT NOT NULL,

    PRIMARY KEY (
        image_digest,
        ecosystem,
        name
        version
    )

    FOREIGN KEY (image_digest)
        REFERENCES images(digest)
);

CREATE INDEX IF NOT EXISTS packages_name
ON packages(ecosystem, name);

CREATE INDEX IF NOT EXISTS packages_name_version
ON packages(ecosystem, name, version);
