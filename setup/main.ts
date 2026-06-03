import type { AppContext } from '@slidev/types'
import type { RouteLocationRaw, Router } from 'vue-router'

// GitHub Pages serves this repository below the owner domain, while Vue Router expects app-relative paths.
const GITHUB_PAGES_BASE = '/graduation-presentation'

function normalizeRouteLocation(location: RouteLocationRaw): RouteLocationRaw {
  if (typeof location === 'string')
    return stripGitHubPagesBase(location)

  if (!location || !('path' in location) || typeof location.path !== 'string')
    return location

  return {
    ...location,
    path: stripGitHubPagesBase(location.path),
  }
}

function stripGitHubPagesBase(path: string): string {
  if (path === GITHUB_PAGES_BASE)
    return '/'

  if (path.startsWith(`${GITHUB_PAGES_BASE}/`))
    return path.slice(GITHUB_PAGES_BASE.length)

  return path
}

function normalizeRouterNavigation(router: Router): void {
  const push = router.push.bind(router)
  const replace = router.replace.bind(router)
  const resolve = router.resolve.bind(router)

  router.push = (location => push(normalizeRouteLocation(location))) as Router['push']
  router.replace = (location => replace(normalizeRouteLocation(location))) as Router['replace']
  router.resolve = ((location, currentLocation) =>
    resolve(normalizeRouteLocation(location), currentLocation)) as Router['resolve']
}

/**
 * Keeps Slidev navigation app-relative while assets remain rooted under the GitHub Pages project path.
 *
 * @param context - Slidev app context created before mount; `context.router` must be the active Vue Router instance.
 * @returns Nothing.
 * @throws Never throws intentionally; Vue Router may still reject invalid downstream navigations.
 * @sideEffects State: wraps `router.push`, `router.replace`, and `router.resolve` for the current Slidev app instance.
 */
export default function setupMain({ router }: AppContext): void {
  // Slidev 52 prefixes slide paths with the Vite base while Vue Router also applies that base.
  // On GitHub Pages this double-prefixes URLs, so router inputs must stay app-relative.
  normalizeRouterNavigation(router)
}
