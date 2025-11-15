# MariaDB Module - Gradle Build Documentation

<p align="center">
  <a href="https://bearsampp.com/contribute" target="_blank">
    <img width="250" src="../img/Bearsampp-logo.svg" alt="Bearsampp Logo">
  </a>
</p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-mariadb.svg?style=flat-square)](https://github.com/bearsampp/module-mariadb/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-mariadb/total.svg?style=flat-square)

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Build Configuration](#build-configuration)
- [Gradle Tasks](#gradle-tasks)
- [Building the Module](#building-the-module)
- [Configuration Files](#configuration-files)
- [Release Management](#release-management)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Overview

This is a module of the [Bearsampp project](https://github.com/bearsampp/bearsampp) involving MariaDB. The module has been converted to use a pure Gradle build system for improved maintainability and cross-platform compatibility.

### Key Features

- Pure Gradle build (Groovy DSL), no Ant required
- Automated download and extraction of MariaDB binaries
- Version resolution from modules-untouched repository with safe fallback
- Standardized output layout under a shared `bearsampp-build` directory
- Optional 7z or zip packaging with integrity hashes (MD5/SHA1/SHA256/SHA512)

## Prerequisites

| Tool   | Version | Required | Purpose                         |
|--------|---------|----------|---------------------------------|
| Java   | 8+      | Yes      | Gradle runtime                  |
| Gradle | 7+      | Yes      | Build automation (local or via wrapper) |
| 7-Zip  | Latest  | Yes      | Required when `bundle.format=7z`|
| Git    | 2.0+    | No       | Optional (for development)      |

### Environment Variables

| Variable               | Default Value                         | Description                                                      |
|------------------------|---------------------------------------|------------------------------------------------------------------|
| `BEARSAMPP_BUILD_PATH` | If `build.path` not set: `<root>/bearsampp-build` | Optional override for build output base folder                   |
| `JAVA_HOME`            | (required)                            | Java installation directory                                      |

## Project Structure

```
module-mariadb/
├── .gradle-docs/              # Gradle build documentation
│   ├── README.md              # Main documentation (this file)
│   ├── TASKS.md               # Detailed task reference
│   ├── CONFIGURATION.md       # Configuration guide
│   └── MIGRATION.md           # Ant to Gradle migration guide
├── bin/                       # MariaDB binaries by version
│   ├── mariadb10.11.14/
│   │   └── bearsampp.conf     # Version-specific configuration
│   ├── mariadb11.8.3/
│   │   └── bearsampp.conf
│   └── mariadb12.0.2/
│       └── bearsampp.conf
├── img/                       # Project images
│   └── Bearsampp-logo.svg
├── .editorconfig              # Editor configuration
├── .gitignore                 # Git ignore rules
├── build.gradle               # Main Gradle build script (Groovy)
├── build.properties           # Build configuration
├── LICENSE                    # Project license
├── README.md                  # Project overview
├── releases.properties        # (Legacy) Not used by Gradle build
└── settings.gradle            # Gradle settings
```

## Build Configuration

### build.properties

The main configuration file for the build:

```properties
bundle.name = mariadb
bundle.release = 2025.8.21
bundle.type = bins
bundle.format = 7z

#build.path = C:/Bearsampp-build
```

| Property         | Description                              | Default Value          |
|------------------|------------------------------------------|------------------------|
| `bundle.name`    | Module name                              | `mariadb`              |
| `bundle.release` | Release version (YYYY.M.D format)        | `2025.8.21`            |
| `bundle.type`    | Bundle type (bins/apps/tools)            | `bins`                 |
| `bundle.format`  | Archive format (7z/zip)                  | `7z`                   |
| `build.path`     | Build output directory (optional)        | `C:/Bearsampp-build`   |

### Version Resolution Strategy

The build no longer uses local `releases.properties` for downloads.

Order of resolution for MariaDB binaries:
1. Load remote `mariadb.properties` from modules-untouched (primary)
   - URL: `https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/mariadb.properties`
2. If a version is not listed or the fetch fails, construct a standard fallback URL:
   - `https://github.com/Bearsampp/modules-untouched/releases/download/mariadb-${version}/mariadb-${version}-win64.7z`

## Gradle Tasks

The default task is `info`. Key tasks provided by this build:

| Task                    | Description                                                                 |
|-------------------------|-----------------------------------------------------------------------------|
| `info`                  | Display build configuration, paths, Java/Gradle versions                   |
| `release -PbundleVersion=X.Y.Z` | Build a specific MariaDB version (downloads if missing, packages and hashes) |
| `release`               | Interactive mode: choose a version from `bin/` or `bin/archived/`          |
| `releaseAll`            | Prepares all available versions (copies into tmp prep). Does not archive.  |
| `clean`                 | Cleans Gradle build dir only (`./build`)                                   |
| `verify`                | Environment checks: Java, build.properties, dev dir, 7-Zip (for 7z)        |
| `listReleases`          | List versions from remote modules-untouched `mariadb.properties`           |
| `listVersions`          | List versions found under local `bin/` and `bin/archived/`                 |
| `validateProperties`    | Validate required keys in `build.properties`                               |
| `checkModulesUntouched` | Verify connectivity and list versions from modules-untouched               |

### Task Execution Examples

```bash
# Show build info (default)
gradle info

# Build specific version (non-interactive)
gradle release -PbundleVersion=12.0.2

# Build interactively (choose from local versions)
gradle release

# Prepare all locally available versions (no archive)
gradle releaseAll

# Verify environment
gradle verify

# List releases from modules-untouched
gradle listReleases

# List local versions
gradle listVersions

# Debugging
gradle info --stacktrace --info
```

## Building the Module

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/bearsampp/module-mariadb.git
   cd module-mariadb
   ```

2. **Verify prerequisites**:
   ```bash
   java -version    # Should be 1.8+ (8 or newer)
   7z --help        # Required when using 7z archive format
   ```

3. **Build a release archive for a version**:
   ```bash
   # Example: build MariaDB 12.0.2
   gradle release -PbundleVersion=12.0.2
   ```

4. **Find the output**:
   ```
   <buildBase>/<bundle.type>/<bundle.name>/<bundle.release>/
     bearsampp-mariadb-<bundleVersion>-<bundle.release>.7z
   # Example:
   <repo_root>/../bearsampp-build/bins/mariadb/2025.8.21/
     bearsampp-mariadb-12.0.2-2025.8.21.7z
   ```

### Custom Build Path

To use a custom build directory:

```bash
# Option 1: Set environment variable
set BEARSAMPP_BUILD_PATH=D:/MyBuilds
gradle build

# Option 2: Edit build.properties
# Uncomment and modify:
# build.path = D:/MyBuilds
```

### Build Process Flow (release task)

```
resolve version URL (modules-untouched → fallback)
  ↓
download to bearsampp-build/tmp/downloads/mariadb/
  ↓
extract to bearsampp-build/tmp/extract/mariadb/<version>/
  ↓
prepare contents under bearsampp-build/tmp/bundles_prep/bins/mariadb/mariadb<version>/
  ↓
copy dev/bin overlay (if present)
  ↓
archive to <buildBase>/<bundle.type>/<bundle.name>/<bundle.release>/
  ↓
generate MD5/SHA1/SHA256/SHA512 files
```

## Configuration Files

The Gradle build does not modify `bearsampp.conf` files. It copies content from the source directory (local `bin/mariadb<version>` or the downloaded archive) and overlays any files present in your local `bin` folder for that version. Ensure your configuration files are already correct inside the source directory you provide.

## Release Management

### Creating a New Release

1. Update bundle release (date) in `build.properties`:
   ```properties
   bundle.release = 2025.9.1
   ```

2. Add a new MariaDB version (optional):
   - Option A: Place binaries under `bin/mariadbX.X.X/` (local build uses these)
   - Option B: Ensure the version exists in modules-untouched `mariadb.properties` so the build can download it automatically

3. Build and test:
   ```bash
   gradle verify
   gradle release -PbundleVersion=12.0.2
   ```

4. **Commit and tag**:
   ```bash
   git add .
   git commit -m "Release 2025.9.1"
   git tag -a 2025.9.1 -m "Release 2025.9.1"
   git push origin main --tags
   ```

### Version Numbering

Bearsampp uses a date-based versioning scheme:

```
YYYY.M.D
```

- `YYYY`: Four-digit year
- `M`: Month (1-12, no leading zero)
- `D`: Day (1-31, no leading zero)

Examples:
- `2025.8.21` → August 21, 2025
- `2025.12.1` → December 1, 2025

## Troubleshooting

### Common Issues

#### Java Not Found

**Error**: `ERROR: JAVA_HOME is not set`

**Solution**:
```bash
# Windows
set JAVA_HOME=C:\Program Files\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%

# Verify
java -version
```

#### 7-Zip Not Found

**Error**: `Cannot run program "7z"`

**Solution**:
- Install 7-Zip from https://www.7-zip.org/
- Add to PATH: `C:\Program Files\7-Zip`
- Verify: `7z --help`

#### Build Directory Access Denied

**Error**: `Access denied` when creating build directory

**Solution**:
- Run terminal as Administrator
- Or change `build.path` to a user-writable location

#### Dev path not found

The build expects a sibling `dev` directory at `<repo_root>/../dev`. If it is missing you will see:

```
Dev path not found: <path>.
Please ensure the 'dev' project exists in <root>
```

Create the required `dev` directory or adjust your workspace layout.

### Debug Mode

Run Gradle with additional logging:

```bash
# Info level
gradle build --info

# Debug level
gradle build --debug

# Stack traces
gradle build --stacktrace
```

### Clean Build

If you encounter persistent issues:

```bash
# Clean everything
gradle clean

# Clean Gradle cache
gradle clean --no-daemon

# Delete .gradle directory
rm -rf .gradle
gradle build
```

## Contributing

### Development Workflow

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-feature
   ```
3. **Make changes and test**:
   ```bash
   gradle clean build validate
   ```
4. **Commit with clear messages**:
   ```bash
   git commit -m "Add: New MariaDB 12.1.0 support"
   ```
5. **Push and create pull request**:
   ```bash
   git push origin feature/my-feature
   ```

### Code Style

- Follow existing code formatting
- Use `.editorconfig` settings
- Keep `build.gradle.kts` organized and commented
- Update documentation for any changes

### Testing Checklist

- [ ] `gradle clean` completes successfully
- [ ] `gradle build` creates valid archive
- [ ] `gradle validate` passes all checks
- [ ] Archive extracts correctly
- [ ] `bearsampp.conf` files have correct release version
- [ ] Documentation is updated

## Additional Resources

- **Main Documentation**: [README.md](../README.md)
- **Task Reference**: [TASKS.md](TASKS.md)
- **Configuration Guide**: [CONFIGURATION.md](CONFIGURATION.md)
- **Migration Guide**: [MIGRATION.md](MIGRATION.md)
- **Bearsampp Project**: https://github.com/bearsampp/bearsampp
- **Module Documentation**: https://bearsampp.com/module/mariadb
- **Issue Tracker**: https://github.com/bearsampp/bearsampp/issues

## License

This project is licensed under the terms specified in the [LICENSE](../LICENSE) file.

---

**Note**: For issues and support, please report on the [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).
