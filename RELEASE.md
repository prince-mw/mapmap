# MapMap Release Process

This document describes how to create release packages for MapMap.

## Automated Release via GitHub Actions

### Creating a Tagged Release

1. **Update version number:**
   ```bash
   echo "0.6.4" > VERSION.txt
   git add VERSION.txt
   git commit -m "Bump version to 0.6.4"
   ```

2. **Create and push a tag:**
   ```bash
   git tag v0.6.4
   git push origin v0.6.4
   ```

3. **GitHub Actions will automatically:**
   - Build Windows x64 executable
   - Build Linux x64 executable
   - Create release packages
   - Upload artifacts to GitHub Releases

4. **Access the release:**
   - Go to https://github.com/YOUR_USERNAME/mapmap/releases
   - Download the packages from the latest release

### Manual Release Trigger

You can also trigger a release manually without creating a tag:

1. Go to: https://github.com/YOUR_USERNAME/mapmap/actions
2. Select "Release Build" workflow
3. Click "Run workflow"
4. Enter the version number (e.g., 0.6.4)
5. Click "Run workflow"

The artifacts will be available in the Actions tab under the workflow run.

## Manual Build Process

### Windows

**Prerequisites:**
- Qt 5.15+ with MinGW
- GStreamer 1.22+ (runtime and development files)
- 7-Zip (for creating archives)

**Build steps:**

1. **Using the build script:**
   ```batch
   cd /path/to/mapmap
   scripts\build-windows-release.bat
   ```

2. **Manual build:**
   ```batch
   set QTDIR=C:\Qt\5.15.2\mingw81_64
   set PATH=%QTDIR%\bin;%PATH%
   set GSTREAMER_1_0_ROOT_MINGW_X86_64=C:\gstreamer\1.0\mingw_x86_64
   
   qmake mapmap.pro CONFIG+=release
   mingw32-make -j%NUMBER_OF_PROCESSORS%
   ```

3. **Create package:**
   - Run `windeployqt` on the executable
   - Copy GStreamer DLLs
   - Create ZIP archive

### Linux

**Prerequisites:**
- Qt5 development packages
- GStreamer 1.0 development packages
- Build tools (gcc, make, etc.)

**Build steps:**

```bash
# Install dependencies (Ubuntu/Debian)
sudo apt-get install -y \
  liblo-dev qtbase5-dev qttools5-dev-tools qtmultimedia5-dev \
  libqt5opengl5-dev qtwebengine5-dev libgstreamer1.0-dev \
  libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-good

# Build
qmake mapmap.pro CONFIG+=release
make -j$(nproc)

# Create package
VERSION=$(cat VERSION.txt)
PACKAGE_NAME="MapMap-${VERSION}-Linux-x64"
mkdir -p ${PACKAGE_NAME}
cp mapmap README.md LICENSE INSTALL.md CHANGELOG.md ${PACKAGE_NAME}/
tar czf ${PACKAGE_NAME}.tar.gz ${PACKAGE_NAME}
```

### macOS

**Prerequisites:**
- Xcode Command Line Tools
- Qt5 (installed via Homebrew or official installer)
- GStreamer framework
- liblo

**Build steps:**

```bash
# Install dependencies
brew install qt5 liblo gstreamer

# Build
./scripts/build.sh
```

This will create a .app bundle and optionally a .dmg file.

## Release Checklist

Before creating a release:

- [ ] Update VERSION.txt
- [ ] Update CHANGELOG.md with release notes
- [ ] Test the application on target platforms
- [ ] Ensure all dependencies are included
- [ ] Verify README and documentation are current
- [ ] Run tests (if available)
- [ ] Create git tag with version number
- [ ] Push tag to trigger automated build
- [ ] Download and test release packages
- [ ] Update project website/documentation
- [ ] Announce release

## Continuous Integration

The project uses GitHub Actions for CI/CD:

- **`.github/workflows/ubuntu-build.yml`**: Builds on Ubuntu (runs on every push)
- **`.github/workflows/qt-windows.yml`**: Builds on Windows (runs on every push)
- **`.github/workflows/release.yml`**: Creates release packages (runs on tags)

### Workflow Triggers

All workflows can be triggered by:
- Push to `develop` or `master` branches
- Pull requests to `develop` or `master`
- Tags matching `v*` (release workflow only)
- Manual workflow dispatch

## Artifacts

GitHub Actions uploads build artifacts:

- **Retention**: 90 days for releases, 30 days for regular builds
- **Location**: Actions tab → Workflow run → Artifacts section
- **Format**: 
  - Windows: ZIP archive
  - Linux: TAR.GZ archive
  - macOS: DMG image (if implemented)

## Troubleshooting

### Windows Build Issues

**Missing DLLs:**
- Ensure GStreamer is installed at `C:\gstreamer\1.0\mingw_x86_64`
- Run `windeployqt` to copy Qt dependencies

**Build fails:**
- Check Qt and MinGW are in PATH
- Verify GStreamer environment variable is set

### Linux Build Issues

**Missing dependencies:**
- Install all required development packages
- Check pkg-config can find Qt5 and GStreamer

**Runtime errors:**
- Ensure GStreamer plugins are installed
- Set `GST_PLUGIN_PATH` if needed

## Support

For issues with releases:
- Check GitHub Issues: https://github.com/mapmapteam/mapmap/issues
- Review INSTALL.md for platform-specific instructions
- Visit the project website: https://mapmapteam.github.io/
