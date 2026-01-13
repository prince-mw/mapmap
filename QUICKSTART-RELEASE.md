# Quick Start: Creating a Windows Release

This guide will help you quickly create a Windows release package for MapMap using GitHub Actions.

## Option 1: Automatic Release (Recommended)

### Step 1: Update Version
```bash
# Update the version number
echo "0.6.4" > VERSION.txt
git add VERSION.txt
git commit -m "Release version 0.6.4"
```

### Step 2: Create and Push Tag
```bash
# Create a version tag
git tag v0.6.4

# Push the tag to GitHub
git push origin v0.6.4
```

### Step 3: Wait for Build
1. Go to your GitHub repository
2. Click on the "Actions" tab
3. You'll see the "Release Build" workflow running
4. Wait for it to complete (usually 10-15 minutes)

### Step 4: Download Release
1. Go to the "Releases" section of your repository
2. You'll find a new release with the tag `v0.6.4`
3. Download `MapMap-0.6.4-Windows-x64.zip`

## Option 2: Manual Trigger (No Tag Required)

### Step 1: Go to Actions
1. Navigate to https://github.com/YOUR_USERNAME/mapmap/actions
2. Click on "Release Build" in the left sidebar

### Step 2: Trigger Workflow
1. Click the "Run workflow" button (top right)
2. Select the branch (usually `master` or `develop`)
3. Enter the version number in the input field
4. Click "Run workflow"

### Step 3: Download Artifacts
1. Wait for the workflow to complete
2. Click on the completed workflow run
3. Scroll down to the "Artifacts" section
4. Download `MapMap-Windows-x64-VERSION.zip`

## What's Included in the Windows Package?

The release package includes:
- ✅ MapMap.exe (main executable)
- ✅ All Qt dependencies (DLLs)
- ✅ GStreamer runtime libraries
- ✅ GStreamer plugins for video processing
- ✅ Documentation (README, LICENSE, INSTALL)
- ✅ Windows-specific instructions

## Testing the Release

1. Extract the ZIP file
2. Navigate to the extracted folder
3. Double-click `MapMap.exe`
4. The application should start without errors

## Troubleshooting

### Build Fails
- Check the Actions log for errors
- Ensure all required secrets are configured
- Verify the code builds locally

### Missing DLLs in Package
- The workflow automatically includes GStreamer DLLs
- If you encounter missing DLLs, report an issue

### Workflow Not Triggering
- Ensure you pushed the tag: `git push origin v0.6.4`
- Check the workflow file is in `.github/workflows/`
- Verify Actions are enabled in repository settings

## Next Steps

After creating a release:
1. Test the package on a clean Windows machine
2. Update the project website with download links
3. Announce the release to users
4. Monitor for any reported issues

## Additional Resources

- Full release documentation: See [RELEASE.md](RELEASE.md)
- Installation guide: See [INSTALL.md](INSTALL.md)
- Building from source: See [README.md](README.md)
