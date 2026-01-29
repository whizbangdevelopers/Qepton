# hCaptcha Setup Guide

This document covers hCaptcha configuration for the Qepton demo playground.

## Overview

hCaptcha is used as a gate for the demo login page to prevent automated abuse while allowing legitimate users to try Qepton without authentication.

## Getting a Site Key

1. Sign up at [hcaptcha.com](https://www.hcaptcha.com/) (free tier available)
2. Add your site domain (e.g., `qepton-demo.github.io`)
3. Copy the **Site Key** from your dashboard

## Recommended Settings

| Setting            | Value              | Reason                                      |
| ------------------ | ------------------ | ------------------------------------------- |
| Behavior           | Always Challenge   | Shows checkbox every time for demo gate     |
| Passing Threshold  | Easy or Auto       | Low friction for legitimate users           |
| Actions            | Default            | Not needed for single captcha use case      |

Avoid "Moderate" or "Difficult" thresholds - the goal is to prevent bots, not block real users.

## Configuration

### GitHub Actions Secret

Add the site key as a repository secret in **dev**:

- **Secret name:** `VITE_HCAPTCHA_SITEKEY`
- **Value:** Your hCaptcha site key

### Workflow Usage

The secret is passed to the build in `.github/workflows/demo-deploy.yml`:

```yaml
- name: Build SPA for demo
  env:
    VITE_DEMO_MODE: 'true'
    VITE_HCAPTCHA_SITEKEY: ${{ secrets.VITE_HCAPTCHA_SITEKEY }}
  run: npx quasar build -m spa
```

### Code Usage

In `src/pages/DemoLoginPage.vue`:

```typescript
const hcaptchaSiteKey =
  import.meta.env.VITE_HCAPTCHA_SITEKEY || '10000000-ffff-ffff-ffff-000000000001'
```

The fallback key (`10000000-ffff-ffff-ffff-000000000001`) is hCaptcha's test key which shows a red warning message in development.

## Development vs Production

| Environment | Site Key Source          | Behavior                          |
| ----------- | ------------------------ | --------------------------------- |
| Development | Fallback test key        | Red "testing only" warning shown  |
| Production  | `VITE_HCAPTCHA_SITEKEY`  | Normal captcha, no warning        |

## Captcha Reset on Logout

When users logout from the demo, the captcha state must be reset so they see the captcha again. This is handled in `onMounted`:

```typescript
onMounted(() => {
  // Reset captcha state on mount (handles returning after logout)
  captchaVerified.value = false
  error.value = ''

  // Reset hCaptcha widget if it exists
  if (window.hcaptcha) {
    window.hcaptcha.reset()
  }
  // ...
})
```

## Troubleshooting

### Red warning text in captcha

The message "This captcha is for testing only" appears when using the test site key. Deploy with a real `VITE_HCAPTCHA_SITEKEY` secret to remove it.

### Captcha not resetting after logout

Ensure the `onMounted` hook resets both `captchaVerified` and calls `window.hcaptcha.reset()`.

### Captcha not loading

Check browser console for errors. Common issues:
- Ad blockers may block hCaptcha
- CSP headers may need `https://js.hcaptcha.com` allowed
