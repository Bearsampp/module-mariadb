# Configuration Guide

This guide explains how to configure the MariaDB module Gradle build system.

## Table of Contents

- [Build Properties](#build-properties)
- [Environment Variables](#environment-variables)
- [Paths and Directories](#paths-and-directories)
- [Version Resolution](#version-resolution)
- [Archive Configuration](#archive-configuration)
- [Configuration Best Practices](#configuration-best-practices)

---

## Build Properties

### build.properties

The main configuration file for the build system.

**Location**: `./build.properties`

**Format**: Java Properties file

**Example**:
```properties
bundle.name = mariadb
bundle.release = 2025.8.21
bundle.type = bins
bundle.format = 7z

#build.path = C:/Bearsampp-build
```

### Property Reference

| Property         | Type   | Required | Default             | Description                                   |
|------------------|--------|----------|---------------------|-----------------------------------------------|
| `bundle.name`    | String | Yes      | `mariadb`           | Module name (fixed for this repository)       |
| `bundle.release` | String | Yes      | -                   | Release version (YYYY.M.D format)             |
| `bundle.type`    | String | Yes      | `bins`              | Bundle type: `bins`, `apps`, or `tools`       |
| `bundle.format`  | String | Yes      | `7z`                | Archive format: `7z` or `zip`                 |
| `build.path`     | String | No       | (see below)         | Build output directory (optional override)    |

---

### bundle.name

**Purpose**: Identifies the module name.

**Value**: `mariadb` (fixed)

**Usage**: Used in archive names and directory paths.

**Example**:
```properties
bundle.name = mariadb
```

**Note**: This value should not be changed for the MariaDB module.

---

### bundle.release

**Purpose**: Specifies the release version.

**Format**: `YYYY.M.D` (date-based versioning)

**Examples**:
```properties
bundle.release = 2025.8.21    # August 21, 2025
bundle.release = 2025.12.1    # December 1, 2025
bundle.release = 2026.1.15    # January 15, 2026
```

**Usage**:
- Used in archive filenames: `bearsampp-mariadb-{version}-{bundle.release}.7z`
- Used in output directory paths: `{buildBase}/bins/mariadb/{bundle.release}/`

**Rules**:
- `YYYY`: Four-digit year
- `M`: Month (1-12, no leading zero)
- `D`: Day (1-31, no leading zero)

---

### bundle.type

**Purpose**: Categorizes the bundle type.

**Valid values**:
- `bins`: Binary modules (databases, servers)
- `apps`: Applications
- `tools`: Development tools

**Standard value for MariaDB**: `bins`

**Example**:
```properties
bundle.type = bins
```

**Usage**: Determines output directory structure:
```
{buildBase}/{bundle.type}/{bundle.name}/{bundle.release}/
```

---

### bundle.format

**Purpose**: Specifies the archive compression format.

**Valid values**:
- `7z`: 7-Zip format (recommended, better compression)
- `zip`: ZIP format (wider compatibility)

**Comparison**:

| Format | Compression | Speed    | Requirements | Compatibility |
|--------|-------------|----------|--------------|---------------|
| `7z`   | Excellent   | Slower   | 7-Zip        | Requires 7-Zip|
| `zip`  | Good        | Faster   | Built-in     | Universal     |

**Examples**:
```properties
# Use 7z for releases (better compression)
bundle.format = 7z
```

```properties
# Use zip for testing (faster, no 7-Zip required)
bundle.format = zip
```

---

### build.path

**Purpose**: Overrides the default build output directory.

**Default resolution order**:
1. `build.path` in `build.properties` (if uncommented)
2. `BEARSAMPP_BUILD_PATH` environment variable (if set)
3. Default: `{repo_root}/../bearsampp-build`

**Example**:
```properties
# Uncomment and modify to use custom path
build.path = D:/MyBuilds
```

**Requirements**:
- Must be an absolute path
- Must be writable
- Will be created if it doesn't exist
- Use forward slashes `/`

**Valid examples**:
```properties
build.path = C:/Bearsampp-build
build.path = D:/Build/Bearsampp
build.path = E:/Projects/bearsampp-builds
```

---

## Environment Variables

### BEARSAMPP_BUILD_PATH

**Purpose**: Override build output directory.

**Type**: String (absolute path)

**Priority**: Higher than `build.properties`, lower than explicit `build.path` setting

**Usage**:
```bash
# Windows CMD
set BEARSAMPP_BUILD_PATH=D:/MyBuilds
gradle release -PbundleVersion=12.0.2

# Windows PowerShell
$env:BEARSAMPP_BUILD_PATH="D:/MyBuilds"
gradle release -PbundleVersion=12.0.2
```

---

### JAVA_HOME

**Purpose**: Java installation directory.

**Type**: String (absolute path)

**Required**: Yes

**Usage**:
```bash
# Windows
set JAVA_HOME=C:\Program Files\Java\jdk-17

# Verify
java -version
```

---

### 7Z_HOME

**Purpose**: 7-Zip installation directory (optional).

**Type**: String (absolute path)

**Required**: Only when `bundle.format=7z` and 7-Zip not in PATH

**Usage**:
```bash
# Windows
set 7Z_HOME=C:\Program Files\7-Zip

# Verify
7z --help
```

**7-Zip lookup order**:
1. `%7Z_HOME%/7z.exe`
2. Common install paths:
   - `C:\Program Files\7-Zip\7z.exe`
   - `C:\Program Files (x86)\7-Zip\7z.exe`
   - `D:\Program Files\7-Zip\7z.exe`
   - `D:\Program Files (x86)\7-Zip\7z.exe`
3. System PATH: `where 7z.exe`

---

### GRADLE_OPTS

**Purpose**: JVM options for Gradle.

**Type**: String (JVM arguments)

**Optional**: Yes

**Usage**:
```bash
# Increase memory for large builds
set GRADLE_OPTS=-Xmx2g -Xms512m

# Enable debugging
set GRADLE_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
```

**Common options**:
```bash
-Xmx2g                        # Maximum heap size: 2GB
-Xms512m                      # Initial heap size: 512MB
-XX:MaxMetaspaceSize=512m     # Metaspace limit
-Dfile.encoding=UTF-8         # File encoding
```

---

## Paths and Directories

### Build Base Path Resolution

The build base path is determined in this order:

1. **build.properties** (if `build.path` is set and uncommented)
2. **Environment variable** (`BEARSAMPP_BUILD_PATH`)
3. **Default**: `{repo_root}/../bearsampp-build`

**Example resolution**:
```
Repository: E:/Bearsampp-development/module-mariadb
Default:    E:/Bearsampp-development/bearsampp-build
```

---

### Directory Structure

```
{buildBase}/
├── tmp/                                    # Temporary build files
│   ├── downloads/mariadb/                  # Downloaded archives
│   │   └── mariadb-12.0.2-win64.7z
│   ├── extract/mariadb/                    # Extracted archives
│   │   └── 12.0.2/
│   │       └── mariadb-12.0.2-winx64/
│   ├── bundles_prep/bins/mariadb/          # Prepared bundles
│   │   └── mariadb12.0.2/
│   └── bundles_build/bins/mariadb/         # Build staging
│       └── mariadb12.0.2/
└── bins/mariadb/                           # Final archives
    └── 2025.8.21/                          # Release version
        ├── bearsampp-mariadb-12.0.2-2025.8.21.7z
        ├── bearsampp-mariadb-12.0.2-2025.8.21.7z.md5
        ├── bearsampp-mariadb-12.0.2-2025.8.21.7z.sha1
        ├── bearsampp-mariadb-12.0.2-2025.8.21.7z.sha256
        └── bearsampp-mariadb-12.0.2-2025.8.21.7z.sha512
```

---

### Path Variables

| Variable                  | Description                              | Example                                          |
|---------------------------|------------------------------------------|--------------------------------------------------|
| `buildBasePath`           | Build output base directory              | `E:/Bearsampp-development/bearsampp-build`       |
| `buildTmpPath`            | Temporary files directory                | `{buildBase}/tmp`                                |
| `bundleTmpDownloadPath`   | Downloaded archives                      | `{buildBase}/tmp/downloads/mariadb`              |
| `bundleTmpExtractPath`    | Extracted archives                       | `{buildBase}/tmp/extract/mariadb`                |
| `bundleTmpPrepPath`       | Prepared bundles                         | `{buildBase}/tmp/bundles_prep/bins/mariadb`      |
| `bundleTmpBuildPath`      | Build staging                            | `{buildBase}/tmp/bundles_build/bins/mariadb`     |

---

## Version Resolution

### Strategy

The build uses a two-tier strategy for resolving MariaDB binaries:

1. **Primary Source**: Remote `mariadb.properties` from modules-untouched
   - URL: `https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/mariadb.properties`
   - Contains direct download URLs for each version
   - Fetched at build time

2. **Fallback**: Standard URL format construction
   - Format: `https://github.com/Bearsampp/modules-untouched/releases/download/mariadb-{version}/mariadb-{version}-win64.7z`
   - Used when version not found in `mariadb.properties` or fetch fails

---

### Version Sources

#### Remote (modules-untouched)

**Primary source for downloads**

**Check available versions**:
```bash
gradle listReleases
```

**Example output**:
```
Available MariaDB Releases (modules-untouched):
--------------------------------------------------------------------------------
  10.11.14   -> https://github.com/Bearsampp/modules-untouched/releases/...
  11.8.3     -> https://github.com/Bearsampp/modules-untouched/releases/...
  12.0.2     -> https://github.com/Bearsampp/modules-untouched/releases/...
--------------------------------------------------------------------------------
Total releases: 25
```

---

#### Local (bin/ directory)

**Used for overlay files and local-only builds**

**Structure**:
```
bin/
├── mariadb10.11.14/
│   ├── bearsampp.conf
│   └── (optional: additional files to overlay)
├── mariadb11.8.3/
│   └── bearsampp.conf
├── mariadb12.0.2/
│   └── bearsampp.conf
└── archived/
    └── mariadb10.4.27/
        └── bearsampp.conf
```

**Check local versions**:
```bash
gradle listVersions
```

---

### Build Process

When you run `gradle release -PbundleVersion=12.0.2`:

1. **Check local binaries**: Look for `bin/mariadb12.0.2/bin/mysqld.exe`
2. **If not found locally**:
   - Fetch `mariadb.properties` from modules-untouched
   - Download archive to `tmp/downloads/mariadb/`
   - Extract to `tmp/extract/mariadb/12.0.2/`
   - Find MariaDB root directory (contains `bin/mysqld.exe`)
3. **Prepare bundle**:
   - Copy MariaDB files to `tmp/bundles_prep/bins/mariadb/mariadb12.0.2/`
   - Overlay files from `bin/mariadb12.0.2/` if present
4. **Package**:
   - Copy to `tmp/bundles_build/bins/mariadb/mariadb12.0.2/`
   - Create archive in `bins/mariadb/2025.8.21/`
   - Generate hash files

---

## Archive Configuration

### Archive Naming

**Format**: `bearsampp-{bundle.name}-{version}-{bundle.release}.{format}`

**Examples**:
```
bearsampp-mariadb-12.0.2-2025.8.21.7z
bearsampp-mariadb-11.8.3-2025.8.21.zip
bearsampp-mariadb-10.11.14-2025.8.21.7z
```

---

### Archive Structure

The archive contains a top-level folder with the version:

```
bearsampp-mariadb-12.0.2-2025.8.21.7z
└── mariadb12.0.2/              ← Version folder at root
    ├── bin/
    │   ├── mysqld.exe
    │   ├── mysql.exe
    │   ├── mysqladmin.exe
    │   └── ...
    ├── lib/
    ├── share/
    ├── my.ini
    └── bearsampp.conf
```

**Verification**:
```bash
# List archive contents
7z l bearsampp-build/bins/mariadb/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.7z

# Expected output:
#   mariadb12.0.2/bin/mysqld.exe
#   mariadb12.0.2/bin/mysql.exe
#   mariadb12.0.2/lib/...
```

---

### Hash Files

Each archive is accompanied by hash sidecar files for integrity verification:

| File Extension | Algorithm | Hash Length |
|----------------|-----------|-------------|
| `.md5`         | MD5       | 32 chars    |
| `.sha1`        | SHA-1     | 40 chars    |
| `.sha256`      | SHA-256   | 64 chars    |
| `.sha512`      | SHA-512   | 128 chars   |

**Example**:
```
bearsampp-mariadb-12.0.2-2025.8.21.7z
bearsampp-mariadb-12.0.2-2025.8.21.7z.md5
bearsampp-mariadb-12.0.2-2025.8.21.7z.sha1
bearsampp-mariadb-12.0.2-2025.8.21.7z.sha256
bearsampp-mariadb-12.0.2-2025.8.21.7z.sha512
```

**Hash file format**:
```
{hash} {filename}
```

**Example `.md5` file**:
```
a1b2c3d4e5f6... bearsampp-mariadb-12.0.2-2025.8.21.7z
```

**Verification**:
```bash
# Windows (PowerShell)
Get-FileHash bearsampp-mariadb-12.0.2-2025.8.21.7z -Algorithm SHA256

# Linux/Mac
sha256sum bearsampp-mariadb-12.0.2-2025.8.21.7z
```

---

## Configuration Best Practices

### 1. Version Control

**Do commit**:
- ✓ `build.properties` (with `build.path` commented out)
- ✓ `bin/*/bearsampp.conf` files
- ✓ `.editorconfig`
- ✓ `.gitignore`
- ✓ Documentation files

**Don't commit**:
- ✗ Build output (`*.7z`, `*.zip`, `*.md5`, etc.)
- ✗ `.gradle/` directory
- ✗ `build/` directory
- ✗ `bearsampp-build/` directory
- ✗ IDE-specific files (`.idea/`, `*.iml`, `.vscode/`)

---

### 2. Release Checklist

Before creating a release:

- [ ] Update `bundle.release` in `build.properties`
- [ ] Verify versions exist in modules-untouched: `gradle listReleases`
- [ ] Check local versions: `gradle listVersions`
- [ ] Validate environment: `gradle verify`
- [ ] Test build: `gradle release -PbundleVersion=12.0.2`
- [ ] Verify archive contents
- [ ] Check hash files
- [ ] Commit changes
- [ ] Create git tag: `git tag -a 2025.8.21 -m "Release 2025.8.21"`
- [ ] Push: `git push origin main --tags`

---

### 3. Configuration Validation

Always validate after making changes:

```bash
# Validate build.properties
gradle validateProperties

# Verify environment
gradle verify

# List available versions
gradle listVersions
gradle listReleases

# Test build
gradle clean
gradle release -PbundleVersion=12.0.2
```

---

### 4. Custom Build Paths

**For development**:
```properties
# build.properties
build.path = D:/Dev/Builds
```

**For CI/CD**:
```bash
# Set environment variable
export BEARSAMPP_BUILD_PATH=/var/builds/bearsampp
gradle release -PbundleVersion=12.0.2
```

**For testing**:
```bash
# Temporary override
set BEARSAMPP_BUILD_PATH=C:/Temp/TestBuilds
gradle release -PbundleVersion=12.0.2
```

---

### 5. Archive Format Selection

**Use 7z when**:
- Creating release builds
- Disk space is limited
- Download bandwidth is limited
- 7-Zip is available

**Use zip when**:
- Testing builds
- 7-Zip is not available
- Maximum compatibility is needed
- Build speed is priority

---

## Troubleshooting

### Configuration Issues

#### Invalid build.properties

**Error**: `Missing required properties`

**Solution**:
```bash
# Validate configuration
gradle validateProperties

# Check for required properties:
# - bundle.name
# - bundle.release
# - bundle.type
# - bundle.format
```

---

#### Invalid build path

**Error**: `Access denied` or `Cannot create directory`

**Solution**:
1. Check path is absolute
2. Verify write permissions
3. Try different location:
   ```properties
   build.path = D:/Builds
   ```

---

#### 7-Zip not found

**Error**: `7-Zip not found`

**Solution**:
1. Install 7-Zip from https://www.7-zip.org/
2. Add to PATH or set `7Z_HOME`
3. Or use zip format:
   ```properties
   bundle.format = zip
   ```

---

## See Also

- [Main Documentation](README.md)
- [Task Reference](TASKS.md)
- [Gradle Properties Documentation](https://docs.gradle.org/current/userguide/build_environment.html)
