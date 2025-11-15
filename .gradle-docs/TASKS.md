# Gradle Tasks Reference

This document describes the tasks implemented in the current Groovy `build.gradle` for the MariaDB module. The build focuses on packaging MariaDB versions and sourcing binaries from the modules-untouched repository.

## Table of Contents

- [Overview](#overview)
- [Tasks](#tasks)
  - [info](#info)
  - [release](#release)
  - [releaseAll](#releaseall)
  - [clean](#clean)
  - [verify](#verify)
  - [listReleases](#listreleases)
  - [listVersions](#listversions)
  - [validateProperties](#validateproperties)
  - [checkModulesUntouched](#checkmodulesuntouched)
- [Examples](#examples)
- [Outputs and Paths](#outputs-and-paths)

## Overview

Key characteristics of this build:
- Version sources: modules-untouched `mariadb.properties` with fallback URL construction
- Local overlay: files under `bin/mariadb<version>` are overlaid on downloaded contents
- Temporary working dirs under shared `<buildBase>/tmp`
- Packaging to 7z (default) or zip, plus hash files

## Tasks

### info

Display build configuration (paths, Java/Gradle, bundle properties).

Usage:
```bash
gradle info
```

Output: human-readable summary of configuration and environment.

---

### release

Build a release package for a specific MariaDB version.

Usage (non-interactive):
```bash
gradle release -PbundleVersion=12.0.2
```

Usage (interactive):
```bash
gradle release
```
The interactive mode lists versions found under `bin/` and `bin/archived/` and lets you pick by index or exact version.

Behavior:
1. Resolve download URL from modules-untouched (or fallback format)
2. Download archive to `<buildBase>/tmp/downloads/mariadb/`
3. Extract to `<buildBase>/tmp/extract/mariadb/<version>/`
4. Find extracted MariaDB root folder (contains `bin/mysqld.exe`)
5. Prepare under `<buildBase>/tmp/bundles_prep/bins/mariadb/mariadb<version>/`
6. Overlay files from local `bin/mariadb<version>` if present
7. Package to `<buildBase>/<bundle.type>/<bundle.name>/<bundle.release>/`
8. Generate MD5/SHA1/SHA256/SHA512 files

Requirements:
- Java 8+
- 7-Zip installed (for 7z format) or switch to `bundle.format=zip`

---

### releaseAll

Prepare all locally available versions (found under `bin/` and `bin/archived/`). This task copies files to the prep location but does not create release archives.

Usage:
```bash
gradle releaseAll
```

---

### clean

Clean Gradle's local `./build` directory used by tasks; does not remove the shared `<buildBase>`.

Usage:
```bash
gradle clean
```

---

### verify

Verify the environment is ready for building.

Checks:
- Java 8+
- `build.properties` exists
- `dev` directory exists at `<repo_root>/../dev`
- `bin/` directory exists
- 7-Zip installed when `bundle.format=7z`

Usage:
```bash
gradle verify
```

---

### listReleases

List available versions from the remote modules-untouched `mariadb.properties`.

Usage:
```bash
gradle listReleases
```

---

### listVersions

List versions available locally under `bin/` and `bin/archived/`.

Usage:
```bash
gradle listVersions
```

---

### validateProperties

Validate required keys in `build.properties` (`bundle.name`, `bundle.release`, `bundle.type`, `bundle.format`).

Usage:
```bash
gradle validateProperties
```

---

### checkModulesUntouched

Verify connectivity to modules-untouched and display available versions plus the version resolution strategy.

Usage:
```bash
gradle checkModulesUntouched
```

## Examples

```bash
# Show build info
gradle info

# Build a specific version
gradle release -PbundleVersion=12.0.2

# Interactive selection
gradle release

# Prepare all versions (no archive)
gradle releaseAll

# Verify environment
gradle verify

# List remote and local versions
gradle listReleases
gradle listVersions
```

## Outputs and Paths

- Build base path priority:
  1) `build.path` in `build.properties`
  2) `BEARSAMPP_BUILD_PATH` environment variable
  3) Default: `<repo_root>/../bearsampp-build`

- Temporary directories:
  - Downloads: `<buildBase>/tmp/downloads/mariadb/`
  - Extract: `<buildBase>/tmp/extract/mariadb/<version>/`
  - Prep: `<buildBase>/tmp/bundles_prep/bins/mariadb/mariadb<version>/`
  - Build (copy): `<buildBase>/tmp/bundles_build/bins/mariadb/mariadb<version>/`

- Archives and hashes:
  - `<buildBase>/<bundle.type>/<bundle.name>/<bundle.release>/bearsampp-mariadb-<version>-<bundle.release>.<7z|zip>`
  - Hash files: `.md5`, `.sha1`, `.sha256`, `.sha512`

**Output**:
```
> Task :release
Processed: module-mariadb/bin/mariadb10.11.14/bearsampp.conf
Processed: module-mariadb/bin/mariadb11.8.3/bearsampp.conf
Processed: module-mariadb/bin/mariadb12.0.2/bearsampp.conf
BUILD SUCCESSFUL in 3s
3 actionable tasks: 3 executed
```

---

### bundle

**Description**: Creates a compressed archive (7z or zip) of the module.

**Dependencies**: `release`

**Usage**:
```bash
./gradlew bundle
```

**What it does**:
1. Compresses `module-mariadb` directory
2. Creates archive with naming: `bearsampp-mariadb-${version}.${format}`
3. Uses optimal compression settings
4. Reports file size

**Compression settings**:

**7z format**:
```
-t7z           # 7z archive type
-m0=lzma2      # LZMA2 compression method
-mx=9          # Maximum compression level
-mfb=64        # Fast bytes: 64
-md=32m        # Dictionary size: 32MB
-ms=on         # Solid archive
```

**zip format**:
```
-tzip          # ZIP archive type
-mx=9          # Maximum compression level
```

**Output**:
```
> Task :bundle
Bundle created: C:/Bearsampp-build/bearsampp-mariadb-2025.8.21.7z
Bundle size: 245 MB
BUILD SUCCESSFUL in 45s
4 actionable tasks: 4 executed
```

---

### build

**Description**: Executes the complete build process (default task).

**Dependencies**: `bundle`

**Usage**:
```bash
./gradlew build
# or simply
./gradlew
```

**What it does**:
1. Runs all build tasks in sequence
2. Creates final distribution archive
3. Reports build summary

**Output**:
```
> Task :clean
> Task :init
Initialized build directory: C:/Bearsampp-build/module-mariadb
> Task :release
Processed: module-mariadb/bin/mariadb10.11.14/bearsampp.conf
Processed: module-mariadb/bin/mariadb11.8.3/bearsampp.conf
Processed: module-mariadb/bin/mariadb12.0.2/bearsampp.conf
> Task :bundle
Bundle created: C:/Bearsampp-build/bearsampp-mariadb-2025.8.21.7z
Bundle size: 245 MB
> Task :build
Build completed successfully!
Bundle: bearsampp-mariadb-2025.8.21.7z
BUILD SUCCESSFUL in 48s
5 actionable tasks: 5 executed
```

---

## Utility Tasks

### validate

**Description**: Validates configuration files for correctness.

**Dependencies**: None

**Usage**:
```bash
./gradlew validate
```

**What it validates**:
1. `bin/` directory exists
2. All `bearsampp.conf` files contain required properties:
   - `mariadbVersion`
   - `bundleRelease`
3. Configuration syntax is correct

**Success output**:
```
> Task :validate
✓ All configuration files are valid
BUILD SUCCESSFUL in 1s
1 actionable task: 1 executed
```

**Failure output**:
```
> Task :validate FAILED
ERROR: bin/mariadb12.0.2/bearsampp.conf missing mariadbVersion

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':validate'.
> Configuration validation failed
```

**When to use**:
- Before committing changes
- After adding new MariaDB versions
- When troubleshooting build issues
- As part of CI/CD pipeline

---

### listVersions

**Description**: Lists all available MariaDB versions from `releases.properties`.

**Dependencies**: None

**Usage**:
```bash
./gradlew listVersions
```

**Output**:
```
> Task :listVersions
Available MariaDB versions:
  - 10.3.37
  - 10.4.27
  - 10.4.30
  - 10.4.33
  - 10.4.34
  - 10.5.18
  - 10.5.21
  ...
  - 11.8.2
  - 11.8.3
  - 12.0.2
BUILD SUCCESSFUL in 1s
1 actionable task: 1 executed
```

**When to use**:
- To check available versions
- Before adding a new version
- For documentation purposes
- To verify `releases.properties` is correct

---

## Task Dependencies

### Dependency Graph

```
build
  └── bundle
       └── release
            └── init
                 └── clean

validate (independent)
listVersions (independent)
```

### Execution Order

When you run `./gradlew build`, tasks execute in this order:

1. `clean` - Remove old build artifacts
2. `init` - Copy files to build directory
3. `release` - Process configuration files
4. `bundle` - Create archive
5. `build` - Final summary

### Skipping Dependencies

You can run tasks independently:

```bash
# Run only release (will still run init and clean)
./gradlew release

# Run only bundle (will run all prerequisites)
./gradlew bundle

# Run validate independently
./gradlew validate
```

---

## Task Examples

### Example 1: Clean Build

```bash
# Complete clean build
./gradlew clean build

# Output shows all tasks
> Task :clean
> Task :init
> Task :release
> Task :bundle
> Task :build
BUILD SUCCESSFUL in 50s
```

---

### Example 2: Validate Before Build

```bash
# Validate first
./gradlew validate

# If successful, build
./gradlew build
```

---

### Example 3: Build with Custom Path

```bash
# Set custom build path
set BEARSAMPP_BUILD_PATH=D:/MyBuilds

# Build
./gradlew build

# Output will use custom path
Bundle created: D:/MyBuilds/bearsampp-mariadb-2025.8.21.7z
```

---

### Example 4: Debug Build Issues

```bash
# Run with debug output
./gradlew build --debug

# Or with info level
./gradlew build --info

# Or with stack traces
./gradlew build --stacktrace
```

---

### Example 5: Parallel Execution

```bash
# Run multiple tasks
./gradlew clean validate build

# Tasks run in optimal order
> Task :clean
> Task :validate
> Task :init
> Task :release
> Task :bundle
> Task :build
```

---

### Example 6: Dry Run

```bash
# See what would be executed
./gradlew build --dry-run

# Output shows task order without execution
:clean SKIPPED
:init SKIPPED
:release SKIPPED
:bundle SKIPPED
:build SKIPPED
```

---

## Custom Task Options

### Gradle Command-Line Options

| Option              | Description                              | Example                          |
|---------------------|------------------------------------------|----------------------------------|
| `--info`            | Info level logging                       | `./gradlew build --info`         |
| `--debug`           | Debug level logging                      | `./gradlew build --debug`        |
| `--stacktrace`      | Show stack traces on errors              | `./gradlew build --stacktrace`   |
| `--dry-run`         | Show tasks without executing             | `./gradlew build --dry-run`      |
| `--no-daemon`       | Don't use Gradle daemon                  | `./gradlew build --no-daemon`    |
| `--refresh-dependencies` | Force refresh of dependencies       | `./gradlew build --refresh-dependencies` |
| `--parallel`        | Execute tasks in parallel                | `./gradlew build --parallel`     |
| `--max-workers=N`   | Set maximum worker threads               | `./gradlew build --max-workers=4`|
| `--console=plain`   | Plain console output                     | `./gradlew build --console=plain`|
| `--quiet`           | Quiet output (errors only)               | `./gradlew build --quiet`        |

---

### Environment Variables

| Variable                  | Description                    | Example                          |
|---------------------------|--------------------------------|----------------------------------|
| `BEARSAMPP_BUILD_PATH`    | Custom build directory         | `set BEARSAMPP_BUILD_PATH=D:/Build` |
| `JAVA_HOME`               | Java installation directory    | `set JAVA_HOME=C:/Java/jdk-17`   |
| `GRADLE_OPTS`             | JVM options for Gradle         | `set GRADLE_OPTS=-Xmx2g`         |
| `GRADLE_USER_HOME`        | Gradle user home directory     | `set GRADLE_USER_HOME=D:/.gradle`|

---

### Task Configuration

You can modify task behavior by editing `build.gradle.kts`:

```kotlin
// Change compression level
tasks.bundle {
    // Modify 7z command arguments
}

// Add custom validation
tasks.validate {
    doLast {
        // Custom validation logic
    }
}

// Add pre/post build hooks
tasks.build {
    doFirst {
        println("Starting build...")
    }
    doLast {
        println("Build complete!")
    }
}
```

---

## Task Performance

### Typical Execution Times

| Task       | Duration | Notes                              |
|------------|----------|------------------------------------|
| `clean`    | 1-2s     | Fast, just deletes directory       |
| `init`     | 2-5s     | Depends on file count/size         |
| `release`  | 1-2s     | Fast, text replacement only        |
| `bundle`   | 30-60s   | Depends on compression & file size |
| `build`    | 35-70s   | Total of all tasks                 |
| `validate` | 1s       | Fast, just reads config files      |

### Optimization Tips

1. **Use Gradle Daemon** (default):
   - Keeps Gradle in memory
   - Faster subsequent builds
   - Disable with `--no-daemon` if needed

2. **Incremental Builds**:
   - Gradle caches task outputs
   - Only reruns changed tasks
   - Use `clean` to force full rebuild

3. **Parallel Execution**:
   ```bash
   ./gradlew build --parallel
   ```

4. **Increase Memory**:
   ```bash
   set GRADLE_OPTS=-Xmx4g
   ./gradlew build
   ```

---

## Troubleshooting Tasks

### Task Not Found

**Error**: `Task 'xyz' not found`

**Solution**: Check available tasks:
```bash
./gradlew tasks --all
```

---

### Task Failed

**Error**: `Task ':bundle' FAILED`

**Solution**: Run with stack trace:
```bash
./gradlew bundle --stacktrace
```

---

### Task Skipped

**Output**: `:bundle UP-TO-DATE`

**Reason**: Task output hasn't changed

**Solution**: Force re-run:
```bash
./gradlew clean bundle
```

---

### Slow Task Execution

**Solution**: Enable parallel execution:
```bash
./gradlew build --parallel --max-workers=4
```

---

## See Also

- [Main Documentation](README.md)
- [Configuration Guide](CONFIGURATION.md)
- [Migration Guide](MIGRATION.md)
- [Gradle Documentation](https://docs.gradle.org/)
