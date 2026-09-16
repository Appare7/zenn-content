// articles/ 配下の記事が参照している images/ の画像に 3MB 超がないか確認する。
// 使い方: npm run check-images
// 終了コード: 超過 0 件 → 0 / 1 件以上 → 1（参照先が無い画像は警告のみ）
import { readdirSync, readFileSync, statSync, existsSync } from "node:fs";
import { join, resolve, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const REPO = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const LIMIT_BYTES = 3 * 1024 * 1024;
const RAW_PREFIX = /^https:\/\/raw\.githubusercontent\.com\/Appare7\/zenn-content\/[^/]+\/images\//;

const articlesDir = join(REPO, "articles");
const refs = new Map(); // 画像の絶対パス → 最初に参照した記事

for (const name of readdirSync(articlesDir).filter((f) => f.endsWith(".md"))) {
  const md = readFileSync(join(articlesDir, name), "utf8");
  for (const m of md.matchAll(/!\[[^\]]*\]\(([^)]+)\)/g)) {
    let target = m[1].trim().split(/\s+/)[0]; // "=300x" などの幅指定を捨てる
    if (target.startsWith("/images/")) target = join(REPO, target);
    else if (RAW_PREFIX.test(target)) target = join(REPO, "images", target.replace(RAW_PREFIX, ""));
    else continue; // それ以外の外部 URL は対象外
    if (!refs.has(target)) refs.set(target, name);
  }
}

let over = 0;
for (const [file, article] of refs) {
  if (!existsSync(file)) {
    console.error(`missing: articles/${article} -> ${file.replace(REPO, "")}`);
    continue;
  }
  const bytes = statSync(file).size;
  if (bytes > LIMIT_BYTES) {
    over++;
    console.log(`${file.replace(REPO + "/", "")}  ${(bytes / 1024 / 1024).toFixed(2)} MB (${bytes} bytes)`);
  }
}
console.error(`checked ${refs.size} images, ${over} over limit`);
process.exit(over > 0 ? 1 : 0);
