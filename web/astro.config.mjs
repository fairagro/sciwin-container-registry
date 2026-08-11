import { defineConfig } from "astro/config";

// GITHUB_REPOSITORY is set automatically in GitHub Actions (e.g. "fairagro/sciwin-container-registry"),
// so the Pages project-page base path is derived rather than hardcoded.
const [owner, repo] = (process.env.GITHUB_REPOSITORY ?? "").split("/");

export default defineConfig({
  site: owner ? `https://${owner}.github.io` : undefined,
  base: repo ? `/${repo}` : "/",
  trailingSlash: "always",
});
