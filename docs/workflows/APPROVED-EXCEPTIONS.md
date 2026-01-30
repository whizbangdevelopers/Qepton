# Approved Exceptions

This document lists known warnings, linting issues, and other exceptions that have been reviewed and approved by the team. These are safe to ignore.

## IDE/Linter Warnings

### GitHub Actions Workflow Environment Names

**File:** `.github/workflows/deploy-pages.yml`
**Warning:** `Value 'github-pages' is not valid`
**Tool:** VSCode YAML extension / GitHub Actions schema validator

**Explanation:**
The IDE's YAML schema validator cannot access repository-specific GitHub environments, so it flags `environment: github-pages` as invalid. However, `github-pages` is a standard environment that GitHub automatically creates when GitHub Pages is enabled for a repository.

**Evidence:**
- [GitHub Docs: Using environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- This workflow has been successfully deploying to GitHub Pages

**Approved:** 2026-01-19
**Reviewed by:** Development Team

---

### GitHub Actions Workflow Custom Environments

**Files:** `.github/workflows/release.yml`
**Warning:** `Value 'production-release' is not valid`
**Tool:** VSCode YAML extension / GitHub Actions schema validator

**Explanation:**
The IDE's YAML schema validator cannot access repository-specific GitHub environments. The `production-release` environment is a custom environment created in the repository settings that requires manual approval before the "publish" job runs. This provides a gate for post-release testing before making releases public.

**Evidence:**
- Environment is configured at: Settings → Environments → production-release
- [GitHub Docs: Using environments for deployment](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)

**Approved:** 2026-01-22
**Reviewed by:** Development Team

---

### Secrets That Don't Exist Yet (By Design)

**Files:** `.github/workflows/snap.yml`
**Warning:** `Context access might be invalid: secrets.SNAPCRAFT_STORE_CREDENTIALS`
**Tool:** VSCode YAML extension / GitHub Actions schema validator

**Explanation:**
The `SNAPCRAFT_STORE_CREDENTIALS` secret will be added when Snap Store publishing is ready. The workflow handles this gracefully with conditional checks:
```yaml
if: ... && env.SNAPCRAFT_STORE_CREDENTIALS != ''
```
Steps that require this secret are skipped when it's not set, so the workflow runs successfully without it.

**Approved:** 2026-01-22
**Reviewed by:** Development Team

---

## Adding New Exceptions

When adding a new exception:

1. Describe the warning/error clearly
2. Identify the file(s) affected
3. Explain why it's a false positive or acceptable
4. Link to documentation or evidence
5. Record the approval date and reviewer
