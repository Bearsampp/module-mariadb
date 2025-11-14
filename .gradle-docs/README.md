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

- **Pure Gradle Build**: Modern build system using Gradle 8.5+ with Groovy DSL
- **Automated Bundling**: Creates 7z/zip archives ready for distribution
- **Version Management**: Tracks multiple MariaDB versions via `releases.properties`
- **Configuration Processing**: Automatically processes `bearsampp.conf` files
- **Validation Tasks**: Built-in validation for configuration integrity

## Prerequisites

| Tool                | Version      | Required | Purpose                          |
|---------------------|--------------|----------|----------------------------------|
| Java JDK            | 17+          | Yes      | Gradle runtime                   |
| Gradle              | 8.5+         | Yes      | Build automation                 |
| 7-Zip               | Latest       | Yes      | Archive creation                 |
| Git                 | 2.0+         | Yes      | Version control                  |

### Environment Variables

| Variable                  | Default Value          | Description                        |
|---------------------------|------------------------|------------------------------------|
| `BEARSAMPP_BUILD_PATH`    | `C:/Bearsampp-build`   | Build output directory             |
| `JAVA_HOME`               | (required)             | Java installation directory        |

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
├── releases.properties        # Version release mappings
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

### releases.properties

Maps MariaDB versions to their download URLs:

```properties
10.11.14 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.8.21/bearsampp-mariadb-10.11.14-2025.8.21.7z
11.8.3 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.8.21/bearsampp-mariadb-11.8.3-2025.8.21.7z
12.0.2 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.8.21/bearsampp-mariadb-12.0.2-2025.8.21.7z
```

## Gradle Tasks

### Core Build Tasks

| Task       | Description                                      | Dependencies        |
|------------|--------------------------------------------------|---------------------|
| `clean`    | Removes build directory                          | None                |
| `init`     | Initializes build directory and copies files     | `clean`             |
| `release`  | Processes configuration files                    | `init`              |
| `bundle`   | Creates distribution archive                     | `release`           |
| `build`    | Complete build process (default)                 | `bundle`            |

### Utility Tasks

| Task           | Description                                   | Dependencies        |
|----------------|-----------------------------------------------|---------------------|
| `validate`     | Validates configuration files                 | None                |
| `listVersions` | Lists all available MariaDB versions          | None                |

### Task Execution Examples

```bash
# Build the complete module (default task)
gradle build

# Clean build directory
gradle clean

# Validate configuration files
gradle validate

# List all MariaDB versions
gradle listVersions

# Run specific task
gradle release

# Run with info logging
gradle build --info

# Run with debug logging
gradle build --debug
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
   java -version    # Should be 17+
   7z --help        # Should display 7-Zip help
   ```

3. **Build the module**:
   ```bash
   gradle build
   ```

4. **Find the output**:
   ```
   C:/Bearsampp-build/bearsampp-mariadb-2025.8.21.7z
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

### Build Process Flow

```
clean
  ↓
init (copy files to build directory)
  ↓
release (process bearsampp.conf files)
  ↓
bundle (create 7z/zip archive)
  ↓
build (complete)
```

## Configuration Files

### bearsampp.conf

Each MariaDB version has a `bearsampp.conf` file in its `bin/mariadbX.X.X/` directory:

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

| Property          | Description                          | Example Value       |
|-------------------|--------------------------------------|---------------------|
| `mariadbVersion`  | MariaDB version number               | `"12.0.2"`          |
| `mariadbExe`      | Path to MariaDB server executable    | `"bin/mysqld.exe"`  |
| `mariadbCliExe`   | Path to MariaDB client executable    | `"bin/mysql.exe"`   |
| `mariadbAdmin`    | Path to MariaDB admin tool           | `"bin/mysqladmin.exe"` |
| `mariadbConf`     | Configuration file name              | `"my.ini"`          |
| `mariadbPort`     | Default port number                  | `"3307"`            |
| `mariadbRootUser` | Default root username                | `"root"`            |
| `mariadbRootPwd`  | Default root password                | `""`                |
| `bundleRelease`   | Release version (auto-replaced)      | `"2025.8.21"`       |

The `@RELEASE_VERSION@` placeholder is automatically replaced during the build process.

## Release Management

### Creating a New Release

1. **Update version** in `build.properties`:
   ```properties
   bundle.release = 2025.9.1
   ```

2. **Add new MariaDB version** (if applicable):
   - Add binary files to `bin/mariadbX.X.X/`
   - Create `bearsampp.conf` in the version directory
   - Update `releases.properties`

3. **Build and test**:
   ```bash
   gradle clean build
   gradle validate
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

#### Configuration Validation Failed

**Error**: `Configuration validation failed`

**Solution**:
```bash
# Check which files are invalid
gradle validate

# Ensure all bearsampp.conf files contain required properties
# - mariadbVersion
# - bundleRelease
```

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
