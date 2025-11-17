# Gradle Tasks Reference

This document describes all available Gradle tasks for the MariaDB module build system.

## Table of Contents

- [Overview](#overview)
- [Core Build Tasks](#core-build-tasks)
- [Verification Tasks](#verification-tasks)
- [Information Tasks](#information-tasks)
- [Task Examples](#task-examples)
- [Task Options](#task-options)

---

## Overview

The MariaDB module build system provides tasks organized into three main groups:

| Group            | Purpose                                          |
|------------------|--------------------------------------------------|
| **build**        | Build and package tasks                          |
| **verification** | Verification and validation tasks                |
| **help**         | Help and information tasks                       |

---

## Core Build Tasks

### release

Build and package a release for a specific MariaDB version.

**Group**: build

**Usage**:
```bash
# Non-interactive (specify version)
gradle release -PbundleVersion=12.0.2

# Interactive (choose from available versions)
gradle release
```

**What it does**:
1. Validates environment and version
2. Checks if binaries exist locally in `bin/mariadb{version}/`
3. If not found, downloads from modules-untouched:
   - Fetches `mariadb.properties` from modules-untouched
   - Downloads MariaDB archive
   - Extracts to `tmp/extract/mariadb/{version}/`
4. Prepares bundle in `tmp/bundles_prep/bins/mariadb/mariadb{version}/`
5. Overlays files from local `bin/mariadb{version}/` if present
6. Copies to `tmp/bundles_build/bins/mariadb/mariadb{version}/`
7. Creates archive in `{buildBase}/bins/mariadb/{bundle.release}/`
8. Generates hash files (MD5, SHA1, SHA256, SHA512)

**Requirements**:
- Java 8+
- 7-Zip (for 7z format) or use `bundle.format=zip`
- Internet connection (if downloading from modules-untouched)

**Output**:
```
Building mariadb 12.0.2
Bundle path: E:/Bearsampp-development/module-mariadb/bin/mariadb12.0.2

Copying MariaDB files...
Overlaying bundle files from bin directory...

Copying to bundles_build directory...
Non-zip version available at: <buildBase>/tmp/bundles_build/bins/mariadb/mariadb12.0.2

Preparing archive...
Compressing mariadb12.0.2 to bearsampp-mariadb-12.0.2-2025.8.21.7z...
Archive created: <buildBase>/bins/mariadb/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.7z
Generating hash files...
  Created: bearsampp-mariadb-12.0.2-2025.8.21.7z.md5
  Created: bearsampp-mariadb-12.0.2-2025.8.21.7z.sha1
  Created: bearsampp-mariadb-12.0.2-2025.8.21.7z.sha256
  Created: bearsampp-mariadb-12.0.2-2025.8.21.7z.sha512

[SUCCESS] Release build completed successfully for version 12.0.2
```

---

### releaseAll

Build all available versions found in `bin/` and `bin/archived/` directories.

**Group**: build

**Usage**:
```bash
gradle releaseAll
```

**What it does**:
1. Scans `bin/` and `bin/archived/` for all MariaDB versions
2. Prepares each version (copies to prep directory)
3. Reports success/failure for each version
4. Provides summary of results

**Note**: This task only prepares versions (copies files), it does not create archives.

**Output**:
```
Building releases for 15 mariadb versions

[1/15] Building mariadb 10.11.14...
[SUCCESS] mariadb 10.11.14 completed

[2/15] Building mariadb 11.8.3...
[SUCCESS] mariadb 11.8.3 completed

...

Build Summary
Total versions: 15
Successful:     15
Failed:         0

[SUCCESS] All versions built successfully!
```

---

### clean

Clean build artifacts and temporary files.

**Group**: build

**Usage**:
```bash
gradle clean
```

**What it does**:
- Removes local `build/` directory
- Does not remove shared `bearsampp-build/` directory

**Output**:
```
[SUCCESS] Build artifacts cleaned
```

---

## Verification Tasks

### verify

Verify build environment and dependencies.

**Group**: verification

**Usage**:
```bash
gradle verify
```

**What it checks**:
- Java version (8+)
- `build.properties` exists
- `dev` directory exists
- `bin` directory exists
- 7-Zip installed (when `bundle.format=7z`)

**Output**:
```
Verifying build environment for module-mariadb...

Environment Check Results:
------------------------------------------------------------
  [PASS]     Java 8+
  [PASS]     build.properties
  [PASS]     dev directory
  [PASS]     bin directory
  [PASS]     7-Zip
------------------------------------------------------------

[SUCCESS] All checks passed! Build environment is ready.

You can now run:
  gradle release -PbundleVersion=12.0.2   - Build release for version
  gradle listVersions                     - List available versions
```

---

### validateProperties

Validate `build.properties` configuration.

**Group**: verification

**Usage**:
```bash
gradle validateProperties
```

**What it validates**:
- Required properties exist:
  - `bundle.name`
  - `bundle.release`
  - `bundle.type`
  - `bundle.format`
- Properties are not empty

**Output**:
```
Validating build.properties...
[SUCCESS] All required properties are present:
    bundle.name = mariadb
    bundle.release = 2025.8.21
    bundle.type = bins
    bundle.format = 7z
```

---

## Information Tasks

### info

Display build configuration information.

**Group**: help

**Usage**:
```bash
gradle info
```

**What it shows**:
- Project information (name, version, description)
- Bundle properties (name, release, type, format)
- Paths (project, root, dev, build, temp directories)
- Java information (version, home)
- Gradle information (version, home)
- Available task groups
- Quick start commands

**Output**:
```
================================================================
          Bearsampp Module MariaDB - Build Info
================================================================

Project:        module-mariadb
Version:        2025.8.21
Description:    Bearsampp Module - mariadb

Bundle Properties:
  Name:         mariadb
  Release:      2025.8.21
  Type:         bins
  Format:       7z

Paths:
  Project Dir:  E:/Bearsampp-development/module-mariadb
  Root Dir:     E:/Bearsampp-development
  Dev Path:     E:/Bearsampp-development/dev
  Build Base:   E:/Bearsampp-development/bearsampp-build
  ...

Java:
  Version:      17
  Home:         C:/Program Files/Java/jdk-17

Gradle:
  Version:      8.5
  Home:         C:/Gradle/gradle-8.5

Available Task Groups:
  * build        - Build and package tasks
  * help         - Help and information tasks
  * verification - Verification tasks

Quick Start:
  gradle tasks                              - List all available tasks
  gradle info                               - Show this information
  gradle release -PbundleVersion=12.0.2     - Build specific version
  gradle releaseAll                         - Build all versions
  gradle clean                              - Clean build artifacts
  gradle verify                             - Verify build environment
```

---

### listVersions

List available bundle versions in `bin/` and `bin/archived/` directories.

**Group**: help

**Usage**:
```bash
gradle listVersions
```

**Output**:
```
Available mariadb versions:
------------------------------------------------------------
  10.11.14        [bin]
  11.8.3          [bin]
  12.0.2          [bin]
  10.4.27         [bin/archived]
  10.5.18         [bin/archived]
------------------------------------------------------------
Total versions: 5

To build a specific version:
  gradle release -PbundleVersion=12.0.2
```

---

### listReleases

List all available releases from modules-untouched `mariadb.properties`.

**Group**: help

**Usage**:
```bash
gradle listReleases
```

**What it does**:
- Fetches `mariadb.properties` from modules-untouched repository
- Lists all available versions with download URLs

**Output**:
```
Fetching mariadb.properties from modules-untouched repository...
  URL: https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/mariadb.properties
  ✓ Successfully loaded 25 versions from modules-untouched

Available MariaDB Releases (modules-untouched):
--------------------------------------------------------------------------------
  10.11.14   -> https://github.com/Bearsampp/modules-untouched/releases/...
  11.8.3     -> https://github.com/Bearsampp/modules-untouched/releases/...
  12.0.2     -> https://github.com/Bearsampp/modules-untouched/releases/...
  ...
--------------------------------------------------------------------------------
Total releases: 25
```

---

### checkModulesUntouched

Check modules-untouched repository integration and available versions.

**Group**: verification

**Usage**:
```bash
gradle checkModulesUntouched
```

**What it does**:
- Verifies connectivity to modules-untouched repository
- Fetches and displays available versions
- Shows version resolution strategy

**Output**:
```
======================================================================
Modules-Untouched Integration Check
======================================================================

Repository URL:
  https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/mariadb.properties

Fetching mariadb.properties from modules-untouched...
  ✓ Successfully loaded 25 versions from modules-untouched

======================================================================
Available Versions in modules-untouched
======================================================================
  10.11.14
  11.8.3
  12.0.2
  ...
======================================================================
Total versions: 25

======================================================================
[SUCCESS] modules-untouched integration is working
======================================================================

Version Resolution Strategy:
  1. Check modules-untouched mariadb.properties (remote)
  2. Construct standard URL format (fallback)
```

---

## Task Examples

### Example 1: Complete Build Workflow

```bash
# 1. Verify environment
gradle verify

# 2. List available versions
gradle listVersions

# 3. Build specific version
gradle release -PbundleVersion=12.0.2

# 4. Verify output
ls bearsampp-build/bins/mariadb/2025.8.21/
```

---

### Example 2: Interactive Build

```bash
# Start interactive mode
gradle release

# Output:
# ======================================================================
# Interactive Release Mode
# ======================================================================
#
# Available versions:
#    1. 10.11.14        [bin]
#    2. 11.8.3          [bin]
#    3. 12.0.2          [bin]
#
# Enter version to build (index or version string):

# Enter: 3
# or
# Enter: 12.0.2
```

---

### Example 3: Build All Versions

```bash
# Prepare all versions
gradle releaseAll

# Check prepared versions
ls bearsampp-build/tmp/bundles_prep/bins/mariadb/
```

---

### Example 4: Debugging

```bash
# Run with info logging
gradle release -PbundleVersion=12.0.2 --info

# Run with debug logging
gradle release -PbundleVersion=12.0.2 --debug

# Run with stack traces
gradle release -PbundleVersion=12.0.2 --stacktrace
```

---

### Example 5: Clean Build

```bash
# Clean and build
gradle clean
gradle release -PbundleVersion=12.0.2
```

---

### Example 6: Check Remote Versions

```bash
# List remote versions
gradle listReleases

# Check integration
gradle checkModulesUntouched

# List local versions
gradle listVersions
```

---

## Task Options

### Gradle Command-Line Options

| Option              | Description                              | Example                          |
|---------------------|------------------------------------------|----------------------------------|
| `--info`            | Info level logging                       | `gradle release --info`          |
| `--debug`           | Debug level logging                      | `gradle release --debug`         |
| `--stacktrace`      | Show stack traces on errors              | `gradle release --stacktrace`    |
| `--dry-run`         | Show tasks without executing             | `gradle release --dry-run`       |
| `--no-daemon`       | Don't use Gradle daemon                  | `gradle release --no-daemon`     |
| `--console=plain`   | Plain console output                     | `gradle release --console=plain` |
| `--quiet`           | Quiet output (errors only)               | `gradle release --quiet`         |

---

### Environment Variables

| Variable                  | Description                    | Example                          |
|---------------------------|--------------------------------|----------------------------------|
| `BEARSAMPP_BUILD_PATH`    | Custom build directory         | `set BEARSAMPP_BUILD_PATH=D:/Build` |
| `JAVA_HOME`               | Java installation directory    | `set JAVA_HOME=C:/Java/jdk-17`   |
| `7Z_HOME`                 | 7-Zip installation directory   | `set 7Z_HOME=C:/Program Files/7-Zip` |
| `GRADLE_OPTS`             | JVM options for Gradle         | `set GRADLE_OPTS=-Xmx2g`         |

---

### Project Properties

| Property          | Description                    | Example                          |
|-------------------|--------------------------------|----------------------------------|
| `bundleVersion`   | Version to build               | `-PbundleVersion=12.0.2`         |

---

## Task Performance

### Typical Execution Times

| Task                    | Duration | Notes                              |
|-------------------------|----------|------------------------------------|
| `info`                  | <1s      | Fast, just displays information    |
| `verify`                | 1-2s     | Fast, checks environment           |
| `listVersions`          | <1s      | Fast, scans directories            |
| `listReleases`          | 2-5s     | Depends on network speed           |
| `validateProperties`    | <1s      | Fast, validates config             |
| `checkModulesUntouched` | 2-5s     | Depends on network speed           |
| `release` (cached)      | 5-10s    | When binaries already downloaded   |
| `release` (download)    | 30-120s  | Depends on download speed          |
| `releaseAll`            | 1-5min   | Depends on number of versions      |
| `clean`                 | 1-2s     | Fast, just deletes directory       |

---

## Troubleshooting

### Task Not Found

**Error**: `Task 'xyz' not found`

**Solution**: List available tasks:
```bash
gradle tasks --all
```

---

### Task Failed

**Error**: `Task ':release' FAILED`

**Solution**: Run with stack trace:
```bash
gradle release -PbundleVersion=12.0.2 --stacktrace
```

---

### Download Failed

**Error**: `Failed to download from modules-untouched`

**Solution**:
1. Check internet connection
2. Verify version exists: `gradle listReleases`
3. Try again with debug logging: `gradle release --debug`

---

### 7-Zip Not Found

**Error**: `7-Zip not found`

**Solution**:
1. Install 7-Zip from https://www.7-zip.org/
2. Add to PATH or set `7Z_HOME` environment variable
3. Or use zip format: Edit `build.properties` and set `bundle.format=zip`

---

## See Also

- [Main Documentation](README.md)
- [Configuration Guide](CONFIGURATION.md)
- [Gradle Documentation](https://docs.gradle.org/)
