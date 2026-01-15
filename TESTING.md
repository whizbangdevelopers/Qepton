# Testing Documentation

Qepton includes a comprehensive test suite covering unit tests, integration tests, and end-to-end tests. This document summarizes the testing infrastructure and test coverage.

## Test Summary

| Test Type | Framework | Tests | Status |
|-----------|-----------|-------|--------|
| Unit Tests | Vitest | 316 | Automated (CI) |
| E2E Tests | Playwright | 90+ | Manual/Docker |

## Running Tests

### Unit Tests

```bash
# Run all unit tests
npm run test

# Run tests in watch mode
npm run test:unit

# Run tests with coverage report
npm run test:coverage

# Run tests with UI
npm run test:unit:ui
```

### E2E Tests

E2E tests require a running application instance and a GitHub test account. See the `e2e-docker/` directory in the development repository for the Docker-based test environment.

## Unit Test Coverage

### Services (5 test files, 100+ tests)

| Service | Tests | Coverage |
|---------|-------|----------|
| `github-api.spec.ts` | 6 | GitHub API operations: auth, gists CRUD, pagination, settings sync |
| `parser.spec.ts` | 40+ | Description parsing, tag extraction, language detection |
| `search.spec.ts` | 25+ | Fuzzy search, filtering, ranking algorithms |
| `languages.spec.ts` | 30+ | Language detection, file extension mapping, CodeMirror modes |
| `jupyter.spec.ts` | 27 | Notebook rendering, cell extraction, metadata parsing |

### Stores (4 test files, 80+ tests)

| Store | Tests | Coverage |
|-------|-------|----------|
| `gists.spec.ts` | 25+ | Gist state management, sync operations, caching |
| `search.spec.ts` | 20+ | Search state, query management, result caching |
| `ui.spec.ts` | 15+ | UI state, dialogs, theme management |
| `settings.spec.ts` | 20+ | User preferences, persistence, defaults |

### Composables (1 test file, 30+ tests)

| Composable | Tests | Coverage |
|------------|-------|----------|
| `useKeyboardNavigation.spec.ts` | 30+ | Vim-style navigation, focus management, key bindings |

### Utilities (1 test file, 27 tests)

| Utility | Tests | Coverage |
|---------|-------|----------|
| `languageDetection.spec.ts` | 27 | File type detection, shebang parsing, content analysis |

## E2E Test Coverage (Playwright)

E2E tests validate the complete user workflow using a real GitHub test account.

### Authentication (`auth.spec.ts`) - 9 tests
- Login page display and branding
- Token input validation
- Invalid token error handling
- Successful authentication flow
- Username and avatar display
- Session persistence across reloads
- Logout functionality

### Gist Management (`gists.spec.ts`) - 25 tests
- Gist list display after login
- User info in sidebar
- Gist selection and detail view
- Language and tag sections
- Sync functionality
- **CRUD Operations:**
  - New gist modal with all form fields
  - Edit gist modal with existing data
  - Delete confirmation dialog
  - Cancel operations
- Share button and clipboard copy
- Version history dialog
- Change visibility (clone) dialog with warnings

### Keyboard Shortcuts (`keyboard-shortcuts.spec.ts`) - 38 tests
- **Help Dialog:**
  - Help button visibility
  - Shortcuts, Features, Languages, Tips tabs
  - Dialog close functionality
- **Global Shortcuts:**
  - `Cmd/Ctrl+N` - New gist
  - `Cmd/Ctrl+E` - Edit gist
  - `Shift+Space` - Open search
  - `Cmd/Ctrl+D` - Toggle dashboard
  - `Escape` - Close modals
- **Keyboard Focus Setting:**
  - Focus indicator visibility toggle
  - Settings dialog integration
- **Keyboard Navigation:**
  - `j/k` keys for list navigation
  - Arrow keys support
  - `Enter` to select
  - `Escape` to clear focus
  - `Tab` to switch panes
  - `Home/g` to jump to first item
  - Input field focus exclusion

### Search (`search.spec.ts`) - 7 tests
- Search button visibility
- Dialog open/close (button and shortcut)
- Short query message
- Search by description
- Navigate to result

### Tags (`tags.spec.ts`) - 10 tests
- Languages section display
- Tags section display
- All Gists option
- Gist count display
- Filter by language tag
- Return to all gists
- Tag color picker
- Solid icon on color assignment
- Tag colors toggle in settings

### Navigation (`navigation.spec.ts`) - 12 tests
- **Languages Section:**
  - Display LANGUAGES header
  - Language tags after load
  - Filter by language
- **Tags Section:**
  - Display TAGS header
- **All Gists:**
  - Display option
  - Show count
  - Reset filters
- **Pinned Tags:**
  - Manage button

### UI Modes (`ui-modes.spec.ts`) - 18 tests
- Theme toggle button and functionality
- About and Dashboard buttons
- **Immersive Mode:**
  - Toggle with `Cmd/Ctrl+I`
- **Dashboard:**
  - Open with button
  - Statistics display (Total Gists, Total Tags)
  - Close functionality
- **About Dialog:**
  - Open with button
  - App info display (version)
  - Close functionality
- **Settings Dialog:**
  - Languages and Editor tabs
  - Supported languages list
  - Editor preferences (Line Wrapping, Tab Size)

### Content Rendering (`rendering.spec.ts`) - 6 tests
- Gist content display in dialog
- CodeMirror editor rendering
- Syntax highlighting
- Markdown preview toggle
- Copy button functionality

## CI/CD Integration

Tests run automatically on GitHub Actions:

- **Trigger:** Push to `main`, Pull Requests to `main`
- **Jobs:**
  - `unit-tests` - Runs Vitest with coverage
  - `lint` - Runs ESLint
  - `build` - Builds SPA and PWA (after tests pass)

Coverage reports are uploaded as artifacts and retained for 30 days.

## Test Configuration

### Vitest (`vitest.config.ts`)
- Environment: jsdom
- Coverage: v8 provider
- Reporters: text, json, html

### Playwright (in `e2e-docker/`)
- Browsers: Chromium, Firefox, WebKit
- Real GitHub API integration
- Docker-based test environment
