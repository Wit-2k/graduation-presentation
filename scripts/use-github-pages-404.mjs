import { copyFile } from 'node:fs/promises'

await copyFile(
  new URL('../public/404.html', import.meta.url),
  new URL('../dist/404.html', import.meta.url),
)
