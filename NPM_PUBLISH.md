# NPM Publishing Guide

This document explains how to publish `@imperiohub/cli` to npm.

## Prerequisites

Before publishing, you need to:

1. **Create an NPM account** at https://www.npmjs.com/signup
2. **Create an access token** with publish permissions:
   - Go to https://www.npmjs.com/settings/YOUR_USERNAME/tokens
   - Click "Generate New Token" → "Classic Token"
   - Select "Automation" type (recommended for CI/CD)
   - Copy the token (you won't see it again!)

3. **Add the token to GitHub Secrets**:
   - Go to your repository settings
   - Navigate to **Settings** → **Secrets and variables** → **Actions**
   - Click "New repository secret"
   - Name: `NPM_TOKEN`
   - Value: Paste your npm token
   - Click "Add secret"

## Publishing Process

The package is automatically published to npm when you create a git tag:

### 1. Update Version (Local)

```bash
# Update version in package.json
npm version patch  # 1.0.0 → 1.0.1
# or
npm version minor  # 1.0.0 → 1.1.0
# or
npm version major  # 1.0.0 → 2.0.0
```

### 2. Create and Push Tag

```bash
# Push the changes and tag
git push origin claude/npm-package-setup-01JUWCKNUzFCLY9Etesm8JZW
git push origin --tags
```

### 3. Automatic Publishing

GitHub Actions will automatically:
- Detect the new tag
- Extract the version number
- Update package.json
- Publish to npm
- Create a GitHub Release

### 4. Verify Publication

After a few minutes, check:
- NPM: https://www.npmjs.com/package/@imperiohub/cli
- GitHub Releases: https://github.com/imperiohub-dev/sh-scripting/releases

## Manual Publishing (Not Recommended)

If you need to publish manually:

```bash
# Login to npm
npm login

# Publish (first time)
npm publish --access public

# Publish updates
npm version patch
npm publish
```

## Version Guidelines

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible

## Example Workflow

```bash
# 1. Make your changes
git add .
git commit -m "feat: add new backend packages"

# 2. Bump version and create tag
npm version minor  # Creates v1.1.0 tag

# 3. Push everything
git push origin claude/npm-package-setup-01JUWCKNUzFCLY9Etesm8JZW
git push origin --tags

# 4. Wait for GitHub Actions to publish
# Check: https://github.com/imperiohub-dev/sh-scripting/actions

# 5. Verify on npm
# Check: https://www.npmjs.com/package/@imperiohub/cli
```

## Troubleshooting

### Error: "You do not have permission to publish"

- Verify your NPM_TOKEN is correct in GitHub Secrets
- Check that your npm account has publish permissions
- Ensure the package name is available or you own it

### Error: "Tag already exists"

```bash
# Delete local tag
git tag -d v1.0.0

# Delete remote tag
git push origin :refs/tags/v1.0.0

# Create new tag
npm version 1.0.1
git push origin --tags
```

### Error: "Version already published"

- You cannot republish the same version
- Bump the version: `npm version patch`
- Push the new tag

## Package Scope

This package is published under the `@imperiohub` scope:
- Ensure you have permissions to publish to this scope
- First-time publishing requires the `--access public` flag (already in workflow)
