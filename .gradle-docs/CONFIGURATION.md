# Configuration Guide

This document provides detailed information about configuring the MariaDB module build system.

## Table of Contents

- [Build Properties](#build-properties)
- [Release Properties](#release-properties)
- [Configuration Files](#configuration-files)
- [Environment Variables](#environment-variables)
- [Advanced Configuration](#advanced-configuration)

## Build Properties

### build.properties

The `build.properties` file contains the main build configuration.

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

| Property         | Type     | Required | Default Value          | Description                                    |
|------------------|----------|----------|------------------------|------------------------------------------------|
| `bundle.name`    | String   | Yes      | `mariadb`              | Module name (do not change)                    |
| `bundle.release` | String   | Yes      | -                      | Release version (YYYY.M.D format)              |
| `bundle.type`    | String   | Yes      | `bins`                 | Bundle type: `bins`, `apps`, or `tools`        |
| `bundle.format`  | String   | Yes      | `7z`                   | Archive format: `7z` or `zip`                  |
| `build.path`     | String   | No       | `C:/Bearsampp-build`   | Build output directory (optional)              |

### Property Details

#### bundle.name

**Purpose**: Identifies the module name.

**Valid values**: `mariadb` (fixed)

**Usage**: Used in:
- Archive naming: `bearsampp-${bundle.name}-${bundle.release}.${bundle.format}`
- Build directory: `${build.path}/module-${bundle.name}`
- Task configuration

**Example**:
```properties
bundle.name = mariadb
```

**Note**: Do not change this value as it's tied to the module identity.

---

#### bundle.release

**Purpose**: Specifies the release version.

**Format**: `YYYY.M.D` (date-based versioning)
- `YYYY`: Four-digit year
- `M`: Month (1-12, no leading zero)
- `D`: Day (1-31, no leading zero)

**Valid examples**:
```properties
bundle.release = 2025.8.21    # August 21, 2025
bundle.release = 2025.12.1    # December 1, 2025
bundle.release = 2026.1.15    # January 15, 2026
```

**Invalid examples**:
```properties
bundle.release = 2025.08.21   # ❌ Leading zero in month
bundle.release = 2025.8.5.1   # ❌ Too many components
bundle.release = v2025.8.21   # ❌ Prefix not allowed
bundle.release = 1.0.0        # ❌ Not date-based
```

**Usage**: Replaced in:
- `bearsampp.conf` files: `@RELEASE_VERSION@` → `2025.8.21`
- Archive filename: `bearsampp-mariadb-2025.8.21.7z`
- Build metadata

---

#### bundle.type

**Purpose**: Categorizes the module type.

**Valid values**:
- `bins`: Binary executables (MariaDB, MySQL, etc.)
- `apps`: Applications (Adminer, phpMyAdmin, etc.)
- `tools`: Development tools (Git, Composer, etc.)

**Current value**: `bins` (MariaDB is a binary module)

**Example**:
```properties
bundle.type = bins
```

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

**Example**:
```properties
# Use 7z for releases (better compression)
bundle.format = 7z

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

**Valid examples**:
```properties
build.path = C:/Bearsampp-build
build.path = D:/Build/Bearsampp
build.path = E:/Projects/bearsampp-builds
build.path = C:\\Bearsampp-build
```

**Invalid examples**:
```properties
build.path = ./build              # ❌ Relative path
build.path = build                # ❌ Relative path
build.path = C:\Bearsampp-build   # ❌ Unescaped backslashes
```

---

## Release Properties

### releases.properties

The `releases.properties` file maps MariaDB versions to their download URLs.

**Location**: `./releases.properties`

**Format**: Java Properties file (key = value)

**Example**:
```properties
10.11.14 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.8.21/bearsampp-mariadb-10.11.14-2025.8.21.7z
11.8.3 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.8.21/bearsampp-mariadb-11.8.3-2025.8.21.7z
12.0.2 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.7z
```

### Property Format

**Key**: MariaDB version number
**Value**: Download URL

**Syntax**:
```properties
<version> = <url>
```

**Version format**:
- Major.Minor.Patch: `10.11.14`
- With suffix: `11.1.1-RC`, `11.5.1-RC`

**URL format**:
```
https://github.com/Bearsampp/module-mariadb/releases/download/<tag>/bearsampp-mariadb-<version>-<release>.7z
```

### Adding New Versions

1. **Add entry to releases.properties**:
   ```properties
   12.1.0 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.9.1/bearsampp-mariadb-12.1.0-2025.9.1.7z
   ```

2. **Create version directory**:
   ```
   bin/mariadb12.1.0/
   ```

3. **Add bearsampp.conf**:
   ```ini
   mariadbVersion = "12.1.0"
   mariadbExe = "bin/mysqld.exe"
   mariadbCliExe = "bin/mysql.exe"
   mariadbAdmin = "bin/mysqladmin.exe"
   mariadbConf = "my.ini"
   mariadbPort = "3307"
   mariadbRootUser = "root"
   mariadbRootPwd = ""
   
   bundleRelease = "@RELEASE_VERSION@"
   ```

4. **Validate**:
   ```bash
   ./gradlew validate
   ```

### Version Ordering

Versions are sorted alphanumerically:
```properties
10.3.37
10.4.27
10.5.18
...
11.8.3
12.0.2
```

---

## Configuration Files

### bearsampp.conf

Each MariaDB version has a `bearsampp.conf` file.

**Location**: `bin/mariadb<version>/bearsampp.conf`

**Format**: INI-style configuration

**Example**: `bin/mariadb12.0.2/bearsampp.conf`
```ini
mariadbVersion = "12.0.2"
mariadbExe = "bin/mysqld.exe"
mariadbCliExe = "bin/mysql.exe"
mariadbAdmin = "bin/mysqladmin.exe"
mariadbConf = "my.ini"
mariadbPort = "3307"
mariadbRootUser = "root"
mariadbRootPwd = ""

bundleRelease = "@RELEASE_VERSION@"
```

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
