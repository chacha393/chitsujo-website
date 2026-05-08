import { cpSync, existsSync, mkdirSync, readdirSync, rmSync, statSync } from "node:fs";
import { basename, join } from "node:path";

const root = process.cwd();
const outDir = join(root, "_site");

const copyEntries = [
  "assets",
  "css",
  "data",
  "js",
  "CNAME",
  "diary.html",
  "gallery.html",
  "index.html",
  "index_main.html",
  "maintenance.html",
  "profile.html",
];

rmSync(outDir, { force: true, recursive: true });
mkdirSync(outDir, { recursive: true });

for (const entry of copyEntries) {
  const source = join(root, entry);

  if (!existsSync(source)) {
    continue;
  }

  cpSync(source, join(outDir, basename(entry)), {
    recursive: statSync(source).isDirectory(),
  });
}

const copied = readdirSync(outDir).sort();
console.log(`Built _site with ${copied.length} top-level entries.`);
