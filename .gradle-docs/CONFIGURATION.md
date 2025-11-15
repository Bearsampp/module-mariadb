# Configuration Guide

This guide explains how to configure the MariaDB module Gradle build and how paths, versions, and packaging are determined.

## Table of Contents

- [Build Properties](#build-properties)
- [Paths and Directories](#paths-and-directories)
- [Environment Variables](#environment-variables)
- [Version Resolution](#version-resolution)
- [Packaging](#packaging)
- [Requirements](#requirements)

## Build Properties

### build.properties

The `build.properties` file contains the main build configuration.

Location: `./build.properties`

Format: Java Properties file

Example:
```properties
bundle.name = mariadb
bundle.release = 2025.8.21
bundle.type = bins
bundle.format = 7z

#build.path = C:/Bearsampp-build
```

Property reference:

| Property         | Type   | Required | Default             | Description                                   |
|------------------|--------|----------|---------------------|-----------------------------------------------|
| `bundle.name`    | String | Yes      | `mariadb`           | Module name (fixed for this repo)             |
| `bundle.release` | String | Yes      | -                   | Date-based bundle release (YYYY.M.D)          |
| `bundle.type`    | String | Yes      | `bins`              | One of `bins`, `apps`, `tools`                |
| `bundle.format`  | String | Yes      | `7z`                | `7z` or `zip`                                 |
| `build.path`     | String | No       | `<root>/bearsampp-build` | Build base path (overrides env if set)   |

Notes:
- `bundle.release` is used in the archive name and output directory path.
- The build does not rewrite configuration files; it only copies/overlays files.

## Paths and Directories

Build base path resolution priority:
1. `build.path` in `build.properties` (if set)
2. Environment variable `BEARSAMPP_BUILD_PATH`
3. Default: `<repo_root>/../bearsampp-build`

Temporary working directories (under `<buildBase>/tmp`):
- Downloads: `<buildBase>/tmp/downloads/mariadb/`
- Extract: `<buildBase>/tmp/extract/mariadb/<version>/`
- Prep: `<buildBase>/tmp/bundles_prep/bins/mariadb/mariadb<version>/`
- Build (copy): `<buildBase>/tmp/bundles_build/bins/mariadb/mariadb<version>/`

Final archives and hashes:
- `<buildBase>/<bundle.type>/<bundle.name>/<bundle.release>/bearsampp-mariadb-<version>-<bundle.release>.<7z|zip>`
- Hash files alongside: `.md5`, `.sha1`, `.sha256`, `.sha512`

## Environment Variables

| Variable               | Purpose                                      |
|------------------------|----------------------------------------------|
| `BEARSAMPP_BUILD_PATH` | Optional override for the build base path    |
| `JAVA_HOME`            | Path to JDK 8+                               |
| `7Z_HOME`              | Optional. Explicit 7-Zip installation path   |

7-Zip lookup order:
1. `%7Z_HOME%/7z.exe`
2. Common install paths (e.g., `C:\Program Files\7-Zip\7z.exe`)
3. System `PATH` via `where 7z.exe`

## Version Resolution

The build downloads MariaDB from the modules-untouched repository using this strategy:
1. Fetch remote `mariadb.properties` file:
   `https://raw.githubusercontent.com/Bearsampp/modules-untouched/main/modules/mariadb.properties`
2. If the requested version is present, use the provided URL.
3. If not present or fetch fails, construct the fallback URL:
   `https://github.com/Bearsampp/modules-untouched/releases/download/mariadb-<version>/mariadb-<version>-win64.7z`

Local overlays:
- If `bin/mariadb<version>` exists locally, its files are overlaid onto the downloaded/extracted content during packaging.

## Packaging

Packaging format is controlled by `bundle.format`:
- `7z`: Requires 7-Zip. The build calls `7z a -t7z` to create the archive.
- `zip`: Uses Gradle's Zip task.

For each archive, the build also generates `.md5`, `.sha1`, `.sha256`, and `.sha512` files.

## Requirements

- Java 8+ (JDK)
- 7-Zip installed and discoverable when `bundle.format=7z`
- `dev` directory must exist at `<repo_root>/../dev` (project layout assumption)
- Internet access to download from modules-untouched (unless using only local `bin/` sources)

**Note**: This value should remain `bins` for the MariaDB module.

---

#### bundle.format

**Purpose**: Specifies the archive compression format.

**Valid values**:
- `7z`: 7-Zip format (recommended, better compression)
- `zip`: ZIP format (wider compatibility)

**Compression comparison**:

| Format | Compression Ratio | Speed    | Compatibility |
|--------|-------------------|----------|---------------|
| `7z`   | Excellent (~40%)  | Slower   | Requires 7-Zip|
| `zip`  | Good (~60%)       | Faster   | Universal     |

Examples:
```properties
# Use 7z for releases (better compression)
bundle.format = 7z
```
or
```properties
# Use zip for testing (faster)
bundle.format = zip
```

**Archive sizes** (approximate):
- 7z: ~245 MB
- zip: ~380 MB

---

#### build.path

**Purpose**: Specifies the build output directory.

**Default**: `C:/Bearsampp-build`

**Override methods**:

1. **In build.properties** (uncomment and modify):
   ```properties
   build.path = D:/MyBuilds
   ```

2. **Environment variable** (takes precedence):
   ```bash
   set BEARSAMPP_BUILD_PATH=D:/MyBuilds
   ./gradlew build
   ```

**Path requirements**:
- Must be an absolute path
- Must be writable
- Will be created if it doesn't exist
- Use forward slashes `/` or escaped backslashes `\\`

Valid examples:
```properties
build.path = C:/Bearsampp-build
```
```properties
build.path = D:/Build/Bearsampp
```
```properties
build.path = E:/Projects/bearsampp-builds
```
```properties
build.path = C:\\Bearsampp-build
```

Invalid examples:
```properties
build.path = ./build              # ❌ Relative path
```
```properties
build.path = build                # ❌ Relative path
```
```properties
build.path = C:\\Bearsampp-build   # ❌ Unescaped backslashes (single backslashes)
```

---

## Configuration Files

The Gradle build copies files from the source (downloaded archive or local `bin/mariadb<version>`) and overlays local files. It does not edit or template configuration files.

### Property Reference

| Property          | Type   | Required | Description                              | Example Value          |
|-------------------|--------|----------|------------------------------------------|------------------------|
| `mariadbVersion`  | String | Yes      | MariaDB version number                   | `"12.0.2"`             |
| `mariadbExe`      | String | Yes      | Path to server executable                | `"bin/mysqld.exe"`     |
| `mariadbCliExe`   | String | Yes      | Path to client executable                | `"bin/mysql.exe"`      |
| `mariadbAdmin`    | String | Yes      | Path to admin tool                       | `"bin/mysqladmin.exe"` |
| `mariadbConf`     | String | Yes      | Configuration file name                  | `"my.ini"`             |
| `mariadbPort`     | String | Yes      | Default port number                      | `"3307"`               |
| `mariadbRootUser` | String | Yes      | Default root username                    | `"root"`               |
| `mariadbRootPwd`  | String | Yes      | Default root password (empty)            | `""`                   |
| `bundleRelease`   | String | Yes      | Release version (placeholder)            | `"@RELEASE_VERSION@"`  |

### Property Details

#### mariadbVersion

**Purpose**: Identifies the MariaDB version.

**Format**: Quoted string with version number

**Examples**:
```ini
mariadbVersion = "12.0.2"
mariadbVersion = "11.8.3"
mariadbVersion = "10.11.14"
mariadbVersion = "11.1.1-RC"
```

**Rules**:
- Must match directory name (without `mariadb` prefix)
- Must be quoted
- Should match official MariaDB version

---

#### mariadbExe

**Purpose**: Relative path to MariaDB server executable.

**Format**: Quoted string with forward slashes

**Standard value**: `"bin/mysqld.exe"`

**Example**:
```ini
mariadbExe = "bin/mysqld.exe"
```

**Note**: Path is relative to the MariaDB version directory.

---

#### mariadbCliExe

**Purpose**: Relative path to MariaDB client executable.

**Format**: Quoted string with forward slashes

**Standard value**: `"bin/mysql.exe"`

**Example**:
```ini
mariadbCliExe = "bin/mysql.exe"
```

---

#### mariadbAdmin

**Purpose**: Relative path to MariaDB admin tool.

**Format**: Quoted string with forward slashes

**Standard value**: `"bin/mysqladmin.exe"`

**Example**:
```ini
mariadbAdmin = "bin/mysqladmin.exe"
```

---

#### mariadbConf

**Purpose**: Name of the MariaDB configuration file.

**Format**: Quoted string

**Standard value**: `"my.ini"`

**Example**:
```ini
mariadbConf = "my.ini"
```

---

#### mariadbPort

**Purpose**: Default port number for MariaDB.

**Format**: Quoted string with port number

**Standard value**: `"3307"`

**Example**:
```ini
mariadbPort = "3307"
```

**Note**: Uses 3307 to avoid conflict with MySQL (3306).

---

#### mariadbRootUser

**Purpose**: Default root username.

**Format**: Quoted string

**Standard value**: `"root"`

**Example**:
```ini
mariadbRootUser = "root"
```

---

#### mariadbRootPwd

**Purpose**: Default root password.

**Format**: Quoted string (empty for no password)

**Standard value**: `""`

**Example**:
```ini
mariadbRootPwd = ""
```

**Security note**: Empty by default for local development.

---

#### bundleRelease

**Purpose**: Release version (replaced during build).

**Format**: Quoted string with placeholder

**Value**: `"@RELEASE_VERSION@"`

**Example**:
```ini
bundleRelease = "@RELEASE_VERSION@"
```

**Build process**:
- Before: `bundleRelease = "@RELEASE_VERSION@"`
- After: `bundleRelease = "2025.8.21"`

---

## Environment Variables

### BEARSAMPP_BUILD_PATH

**Purpose**: Override build output directory.

**Type**: String (absolute path)

**Default**: `C:/Bearsampp-build`

**Usage**:
```bash
# Windows CMD
set BEARSAMPP_BUILD_PATH=D:/MyBuilds
./gradlew build

# Windows PowerShell
$env:BEARSAMPP_BUILD_PATH="D:/MyBuilds"
./gradlew build

# Linux/Mac
export BEARSAMPP_BUILD_PATH=/home/user/builds
./gradlew build
```

**Priority**: Environment variable > build.properties > default

---

### JAVA_HOME

**Purpose**: Java installation directory.

**Type**: String (absolute path)

**Required**: Yes

**Usage**:
```bash
# Windows
set JAVA_HOME=C:\Program Files\Java\jdk-17

# Linux/Mac
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
```

**Verification**:
```bash
echo %JAVA_HOME%           # Windows CMD
echo $env:JAVA_HOME        # Windows PowerShell
echo $JAVA_HOME            # Linux/Mac
```

---

### GRADLE_OPTS

**Purpose**: JVM options for Gradle.

**Type**: String (JVM arguments)

**Default**: `-Xmx64m -Xms64m`

**Usage**:
```bash
# Increase memory
set GRADLE_OPTS=-Xmx2g -Xms512m

# Enable debugging
set GRADLE_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005
```

**Common options**:
```bash
-Xmx2g              # Maximum heap size: 2GB
-Xms512m            # Initial heap size: 512MB
-XX:MaxMetaspaceSize=512m  # Metaspace limit
-Dfile.encoding=UTF-8      # File encoding
```

---

### GRADLE_USER_HOME

**Purpose**: Gradle user home directory.

**Type**: String (absolute path)

**Default**: `~/.gradle` (Linux/Mac) or `%USERPROFILE%\.gradle` (Windows)

**Usage**:
```bash
# Custom location
set GRADLE_USER_HOME=D:/.gradle
```

**Contains**:
- Gradle wrapper downloads
- Dependency cache
- Build cache
- Daemon logs

---

## Advanced Configuration

### Custom Compression Settings

Edit `build.gradle.kts` to modify compression:

```kotlin
tasks.bundle {
    when (bundleFormat) {
        "7z" -> {
            commandLine("7z", "a", "-t7z",
                "-m0=lzma2",    // Compression method
                "-mx=9",        // Compression level (0-9)
                "-mfb=64",      // Fast bytes
                "-md=32m",      // Dictionary size
                "-ms=on",       // Solid archive
                outputFile.absolutePath,
                "module-${bundleName}")
        }
    }
}
```

**Compression levels**:
- `-mx=0`: No compression (fastest)
- `-mx=5`: Normal compression
- `-mx=9`: Maximum compression (slowest)

**Dictionary sizes**:
- `-md=16m`: 16 MB (faster, less compression)
- `-md=32m`: 32 MB (balanced)
- `-md=64m`: 64 MB (slower, better compression)

---

### Custom Validation Rules

Add custom validation in `build.gradle.kts`:

```kotlin
tasks.validate {
    doLast {
        // Custom validation
        fileTree("bin").matching {
            include("**/bearsampp.conf")
        }.forEach { confFile ->
            val content = confFile.readText()
            
            // Check port number
            if (!content.contains("mariadbPort = \"3307\"")) {
                println("WARNING: ${confFile.name} uses non-standard port")
            }
            
            // Check for empty password
            if (content.contains("mariadbRootPwd = \"\"")) {
                println("INFO: ${confFile.name} has empty root password")
            }
        }
    }
}
```

---

### Build Hooks

Add pre/post build actions:

```kotlin
tasks.build {
    doFirst {
        println("=".repeat(50))
        println("Starting MariaDB module build")
        println("Version: ${bundleRelease}")
        println("=".repeat(50))
    }
    
    doLast {
        println("=".repeat(50))
        println("Build completed successfully!")
        println("Output: ${buildPath}/bearsampp-${bundleName}-${bundleRelease}.${bundleFormat}")
        println("=".repeat(50))
    }
}
```

---

### Multi-Format Builds

Build both 7z and zip:

```kotlin
tasks.register("bundleAll") {
    dependsOn("bundle7z", "bundleZip")
}

tasks.register("bundle7z", Exec::class) {
    // 7z bundle
}

tasks.register("bundleZip", Exec::class) {
    // zip bundle
}
```

---

## Configuration Best Practices

### 1. Version Control

**Do commit**:
- `build.properties` (with commented `build.path`)
- `releases.properties`
- `bearsampp.conf` files
- `.editorconfig`

**Don't commit**:
- Build output (`*.7z`, `*.zip`)
- `.gradle/` directory
- `build/` directory
- IDE files (`.idea/`, `*.iml`)

---

### 2. Release Checklist

Before creating a release:

- [ ] Update `bundle.release` in `build.properties`
- [ ] Update `releases.properties` with new versions
- [ ] Add/update `bearsampp.conf` files
- [ ] Run `./gradlew validate`
- [ ] Run `./gradlew clean build`
- [ ] Test the generated archive
- [ ] Commit and tag

---

### 3. Configuration Validation

Always validate after changes:

```bash
# Validate configuration
./gradlew validate

# List versions
./gradlew listVersions

# Test build
./gradlew clean build
```

---

### 4. Documentation

Keep documentation in sync:

- Update `.gradle-docs/` when changing build process
- Document custom configurations
- Add examples for new features
- Update version tables

---

## See Also

- [Main Documentation](README.md)
- [Task Reference](TASKS.md)
- [Migration Guide](MIGRATION.md)
- [Gradle Properties Documentation](https://docs.gradle.org/current/userguide/build_environment.html)
