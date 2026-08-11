import fs from "node:fs";
import path from "node:path";

// astro commands always run with cwd = web/, so the repo-root api/ dir is one level up.
// (import.meta.url is not usable here: Vite relocates this module during the build,
// which would silently point the path at the wrong directory.)
const apiDir = path.resolve(process.cwd(), "../api");

export interface ImageSummary {
  digest: string;
  registry: string;
  repository: string;
  tag: string | null;
  architecture: string | null;
  os: string | null;
  size: number | null;
}

export interface PackageEntry {
  ecosystem: string;
  name: string;
  version: string;
}

export interface ImageDetail extends ImageSummary {
  packages: PackageEntry[];
}

export type EcosystemPackages = Record<string, Record<string, string[]>>;

function readJSON<T>(...segments: string[]): T {
  const filePath = path.join(apiDir, ...segments);
  return JSON.parse(fs.readFileSync(filePath, "utf-8")) as T;
}

export function getImages(): ImageSummary[] {
  return readJSON<{ images: ImageSummary[] }>("images.json").images;
}

export function getImageDetail(digest: string): ImageDetail {
  return readJSON<ImageDetail>("images", `${digest}.json`);
}

export function getEcosystems(): string[] {
  return readJSON<{ ecosystems: string[] }>("packages.json").ecosystems;
}

export function getEcosystemPackages(ecosystem: string): EcosystemPackages {
  return readJSON<EcosystemPackages>("packages", `${ecosystem}.json`);
}

export function formatBytes(bytes: number | null): string {
  if (bytes == null) return "–";
  const units = ["B", "KB", "MB", "GB", "TB"];
  let n = bytes;
  let i = 0;
  while (n >= 1024 && i < units.length - 1) {
    n /= 1024;
    i++;
  }
  return `${n.toFixed(i === 0 ? 0 : 1)} ${units[i]}`;
}

export function shortDigest(digest: string): string {
  return digest.slice(0, 12);
}
