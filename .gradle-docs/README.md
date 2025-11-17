# Bearsampp Module MariaDB - Gradle Build Documentation

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation](#installation)
- [Build Tasks](#build-tasks)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Troubleshooting](#troubleshooting)
- [Migration Guide](#migration-guide)

---

## Overview

The Bearsampp Module MariaDB project has been converted to a **pure Gradle build system**, replacing the legacy Ant build configuration. This provides:

- **Modern Build System**     - Native Gradle tasks and conventions
- **Better Performance**       - Incremental builds and caching
- **Simplified Maintenance**   - Pure Groovy/Gradle DSL
- **Enhanced Tooling**         - IDE integration and dependency management
- **Cross-Platform Support**   - Works on Windows, Linux, and macOS

### Project Information

| Property          | Value                                    |
|-------------------|------------------------------------------|
| **Project Name**  | module-mariadb                           |
| **Group**         | com.bearsampp.modules                    |
| **Type**          | MariaDB Module Builder                   |
| **Build Tool**    | Gradle 7.x+                              |
| **Language**      | Groovy (Gradle DSL)                      |

---

## Quick Start

### Prerequisites

| Requirement       | Version       | Purpose                                  |
|-------------------|---------------|------------------------------------------|
| **Java**          | 8+            | Required for Gradle execution            |
| **Gradle**        | 7.0+          | Build automation tool                    |
| **7-Zip**         | Latest        | Archive creation (required for 7z)       |

### Basic Commands

```bash
# Display build information
gradle info

# List all available tasks
gradle tasks

# Verify build environment
gradle verify

# Build a release (interactive)
gradle release

# Build a specific version (non-interactive)
gradle release -PbundleVersion=12.0.2

# Clean build artifacts
gradle clean
```

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/bearsampp/module-mariadb.git
cd module-mariadb
```

### 2. Verify Environment

```bash
gradle verify
```

This will check:
- Java version (8+)
- Required files (build.properties)
- Directory structure (bin/, dev/)
- Build dependencies

### 3. List Available Versions

```bash
gradle listVersions
```

### 4. Build Your First Release

```bash
# Interactive mode (prompts for version)
gradle release

# Or specify version directly
gradle release -PbundleVersion=12.0.2
```

---

## Build Tasks

### Core Build Tasks

| Task                  | Description                                      | Example                                  |
|-----------------------|--------------------------------------------------|------------------------------------------|
| `release`             | Build and package release (interactive/non-interactive) | `gradle release -PbundleVersion=12.0.2` |
| `releaseAll`          | Build all available versions (prep only)         | `gradle releaseAll`                      |
| `clean`               | Clean build artifacts and temporary files        | `gradle clean`                           |

### Verification Tasks

| Task                      | Description                                  | Example                                      |
|---------------------------|----------------------------------------------|----------------------------------------------|
| `verify`                  | Verify build environment and dependencies    | `gradle verify`                              |
| `validateProperties`      | Validate build.properties configuration      | `gradle validateProperties`                  |

### Information Tasks

| Task                | Description                                      | Example                    |
|---------------------|--------------------------------------------------|----------------------------|
| `info`              | Display build configuration information          | `gradle info`              |
| `listVersions`      | List available bundle versions in bin/           | `gradle listVersions`      |
| `listReleases`      | List all available releases from modules-untouched | `gradle listReleases`    |
| `checkModulesUntouched` | Check modules-untouched integration          | `gradle checkModulesUntouched` |

### Task Groups

| Group            | Purpose                                          |
|------------------|--------------------------------------------------|
| **build**        | Build and package tasks                          |
| **verification** | Verification and validation tasks                |
| **help**         | Help and information tasks                       |

---

## Configuration

### build.properties

The main configuration file for the build:

```properties
bundle.name     = mariadb
bundle.release  = 2025.8.21
bundle.type     = bins
bundle.format   = 7z
```

| Property          | Description                          | Example Value  |
|-------------------|--------------------------------------|----------------|
| `bundle.name`     | Name of the bundle                   | `mariadb`      |
| `bundle.release`  | Release version                      | `2025.8.21`    |
| `bundle.type`     | Type of bundle                       | `bins`         |
| `bundle.format`   | Archive format                       | `7z`           |

### gradle.properties

Gradle-specific configuration:

```properties
# Gradle daemon configuration
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true

# JVM settings
org.gradle.jvmargs=-Xmx2g -XX:MaxMetaspaceSize=512m
```

### Directory Structure

```
module-mariadb/
├── .gradle-docs/          # Gradle documentation
│   ├── README.md          # Main documentation
│   ├── TASKS.md           # Task reference
│   └── CONFIGURATION.md   # Configuration guide
├── bin/                   # MariaDB version bundles
│   ├── mariadb10.11.14/
│   ├── mariadb11.8.3/
│   ├── mariadb12.0.2/
│   └── archived/          # Archived versions
│       └── ...
bearsampp-build/                    # External build directory (outside repo)
├── tmp/                            # Temporary build files
│   ├── bundles_prep/bins/mariadb/  # Prepared bundles
│   ├── bundles_build/bins/mariadb/ # Build staging
│   ├── downloads/mariadb/          # Downloaded dependencies
│   └── extract/mariadb/            # Extracted archives
└── bins/mariadb/                   # Final packaged archives
    └── 2025.8.21/                  # Release version
        ├── bearsampp-mariadb-12.0.2-2025.8.21.7z
        ├── bearsampp-mariadb-12.0.2-2025.8.21.7z.md5
        └── ...
├── build.gradle           # Main Gradle build script
├── settings.gradle        # Gradle settings
├── build.properties       # Build configuration
└── releases.properties    # (Legacy - not used by Gradle)
```

---

## Architecture

### Build Process Flow

```
1. User runs: gradle release -PbundleVersion=12.0.2
                    ↓
2. Validate environment and version
                    ↓
3. Check if binaries exist in bin/mariadb12.0.2/
                    ↓
4. If not found, download from modules-untouched
   - Fetch mariadb.properties from modules-untouched
   - Download MariaDB archive
   - Extract to tmp/extract/
                    ↓
5. Create preparation directory (tmp/bundles_prep/)
                    ↓
6. Copy MariaDB files to prep directory
                    ↓
7. Overlay bundle files from bin/ directory
                    ↓
8. Copy to bundles_build directory
                    ↓
9. Package prepared folder into archive
   - Archive includes top-level folder: mariadb{version}/
   - Location: bearsampp-build/bins/mariadb/{bundle.release}/
                    ↓
10. Generate hash files (MD5, SHA1, SHA256, SHA512)
```

### Version Resolution Strategy

The build uses a two-tier strategy for resolving MariaDB binaries:

1. **Primary Source**: Remote `mariadb.properties` from modules-untouched
   - URL: `https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/mariadb.properties`
   - Contains direct download URLs for each version

2. **Fallback**: Standard URL format construction
   - Format: `https://github.com/Bearsampp/modules-untouched/releases/download/mariadb-{version}/mariadb-{version}-win64.7z`
   - Used when version not found in mariadb.properties or fetch fails

### Packaging Details

- **Archive name format**: `bearsampp-mariadb-{version}-{bundle.release}.{7z|zip}`
- **Location**: `bearsampp-build/bins/mariadb/{bundle.release}/`
  - Example: `bearsampp-build/bins/mariadb/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.7z`
- **Content root**: The top-level folder inside the archive is `mariadb{version}/` (e.g., `mariadb12.0.2/`)
- **Structure**: The archive contains the MariaDB version folder at the root with all MariaDB files inside

**Archive Structure Example**:
```
bearsampp-mariadb-12.0.2-2025.8.21.7z
└── mariadb12.0.2/          ← Version folder at root
    ├── bin/
    │   ├── mysqld.exe
    │   ├── mysql.exe
    │   └── ...
    ├── lib/
    ├── share/
    ├── my.ini
    └── bearsampp.conf
```

**Verification Commands**:

```bash
# List archive contents with 7z
7z l bearsampp-build/bins/mariadb/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.7z | more

# You should see entries beginning with:
#   mariadb12.0.2/bin/mysqld.exe
#   mariadb12.0.2/bin/mysql.exe
#   mariadb12.0.2/lib/...
#   mariadb12.0.2/...

# Extract and inspect with PowerShell
Expand-Archive -Path bearsampp-build/bins/mariadb/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.zip -DestinationPath .\_inspect
Get-ChildItem .\_inspect\mariadb12.0.2 | Select-Object Name

# Expected output:
#   bin/
#   lib/
#   share/
#   my.ini
#   bearsampp.conf
#   ...
```

**Note**: This archive structure matches other Bearsampp module patterns where archives contain `{module}{version}/` at the root. This ensures consistency across all Bearsampp modules.

**Hash Files**: Each archive is accompanied by hash sidecar files:
- `.md5` - MD5 checksum
- `.sha1` - SHA-1 checksum
- `.sha256` - SHA-256 checksum
- `.sha512` - SHA-512 checksum

Example:
```
bearsampp-build/bins/mariadb/2025.8.21/
├── bearsampp-mariadb-12.0.2-2025.8.21.7z
├── bearsampp-mariadb-12.0.2-2025.8.21.7z.md5
├── bearsampp-mariadb-12.0.2-2025.8.21.7z.sha1
├── bearsampp-mariadb-12.0.2-2025.8.21.7z.sha256
└── bearsampp-mariadb-12.0.2-2025.8.21.7z.sha512
```

---

## Troubleshooting

### Common Issues

#### Issue: "Dev path not found"

**Symptom:**
```
Dev path not found: E:/Bearsampp-development/dev
```

**Solution:**
This error indicates the `dev` project is missing from the parent directory. Ensure the `dev` project exists at the expected location or adjust your workspace layout.

---

#### Issue: "Bundle version not found"

**Symptom:**
```
Bundle version not found: E:/Bearsampp-development/module-mariadb/bin/mariadb12.0.99
```

**Solution:**
1. List available versions: `gradle listVersions`
2. Use an existing version: `gradle release -PbundleVersion=12.0.2`
3. Or download will be attempted from modules-untouched

---

#### Issue: "Failed to download from modules-untouched"

**Symptom:**
```
Failed to download from modules-untouched: Connection refused
```

**Solution:**
1. Check internet connectivity
2. Verify version exists: `gradle listReleases`
3. Check modules-untouched repository is accessible
4. Manually download and place in `bin/mariadb{version}/`

---

#### Issue: "Java version too old"

**Symptom:**
```
Java 8+ required
```

**Solution:**
1. Check Java version: `java -version`
2. Install Java 8 or higher
3. Update JAVA_HOME environment variable

---

#### Issue: "7-Zip not found"

**Symptom:**
```
7-Zip not found. Please install 7-Zip or set 7Z_HOME environment variable.
```

**Solution:**
1. Install 7-Zip from https://www.7-zip.org/
2. Add to PATH or set 7Z_HOME environment variable
3. Verify: `7z --help`

---

### Debug Mode

Run Gradle with debug output:

```bash
gradle release -PbundleVersion=12.0.2 --info
gradle release -PbundleVersion=12.0.2 --debug
gradle release -PbundleVersion=12.0.2 --stacktrace
```

### Clean Build

If you encounter issues, try a clean build:

```bash
gradle clean
gradle release -PbundleVersion=12.0.2
```

---

## Migration Guide

### From Ant to Gradle

The project has been fully migrated from Ant to Gradle. Here's what changed:

#### Removed Files

| File              | Status    | Replacement                |
|-------------------|-----------|----------------------------|
| `build.xml`       | ✗ Removed | `build.gradle`             |

#### Command Mapping

| Ant Command                          | Gradle Command                              |
|--------------------------------------|---------------------------------------------|
| `ant release`                        | `gradle release`                            |
| `ant release -Dinput.bundle=12.0.2`  | `gradle release -PbundleVersion=12.0.2`     |
| `ant clean`                          | `gradle clean`                              |

#### Key Differences

| Aspect              | Ant                          | Gradle                           |
|---------------------|------------------------------|----------------------------------|
| **Build File**      | XML (build.xml)              | Groovy DSL (build.gradle)        |
| **Task Definition** | `<target name="...">`        | `tasks.register('...')`          |
| **Properties**      | `<property name="..." />`    | `ext { ... }`                    |
| **Dependencies**    | Manual downloads             | Automatic with repositories      |
| **Caching**         | None                         | Built-in incremental builds      |
| **IDE Support**     | Limited                      | Excellent (IntelliJ, Eclipse)    |

#### Version Resolution Changes

**Ant (Old)**:
- Used local `releases.properties` file
- Manual URL management

**Gradle (New)**:
- Fetches from modules-untouched `mariadb.properties`
- Automatic fallback to standard URL format
- Better error handling and reporting

---

## Additional Resources

- [Gradle Documentation](https://docs.gradle.org/)
- [Bearsampp Project](https://github.com/bearsampp/bearsampp)
- [MariaDB Downloads](https://mariadb.org/download/)
- [Modules Untouched Repository](https://github.com/Bearsampp/modules-untouched)

---

## Support

For issues and questions:

- **GitHub Issues**: https://github.com/bearsampp/module-mariadb/issues
- **Bearsampp Issues**: https://github.com/bearsampp/bearsampp/issues
- **Documentation**: https://bearsampp.com/module/mariadb

---

**Last Updated**: 2025-01-31  
**Version**: 2025.8.21  
**Build System**: Pure Gradle (no wrapper, no Ant)

Notes:
- This project deliberately does not ship the Gradle Wrapper. Install Gradle 7+ locally and run with `gradle ...`.
- Legacy Ant files (e.g., Eclipse `.launch` referencing `build.xml`) are deprecated and not used by the build.
- Local `releases.properties` is no longer used for version resolution. Versions are sourced from modules-untouched.
