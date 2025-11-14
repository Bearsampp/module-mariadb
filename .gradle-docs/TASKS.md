# Gradle Tasks Reference

This document provides detailed information about all available Gradle tasks in the MariaDB module.

## Table of Contents

- [Core Build Tasks](#core-build-tasks)
- [Utility Tasks](#utility-tasks)
- [Task Dependencies](#task-dependencies)
- [Task Examples](#task-examples)
- [Custom Task Options](#custom-task-options)

## Core Build Tasks

### clean

**Description**: Removes the build directory and all generated files.

**Usage**:
```bash
./gradlew clean
```

**What it does**:
- Deletes `${buildPath}/module-mariadb` directory
- Removes all temporary build artifacts
- Prepares for a fresh build

**When to use**:
- Before creating a release build
- When build artifacts are corrupted
- To free up disk space
- After changing build configuration

**Output**:
```
> Task :clean
BUILD SUCCESSFUL in 1s
1 actionable task: 1 executed
```

---

### init

**Description**: Initializes the build directory structure and copies source files.

**Dependencies**: `clean`

**Usage**:
```bash
./gradlew init
```

**What it does**:
1. Creates build directory: `${buildPath}/module-mariadb`
2. Copies `bin/` directory with all MariaDB versions
3. Copies `releases.properties` to build directory
4. Preserves directory structure

**Files copied**:
```
${buildPath}/module-mariadb/
├── bin/
│   ├── mariadb10.11.14/
│   ├── mariadb11.8.3/
│   └── mariadb12.0.2/
└── releases.properties
```

**Output**:
```
> Task :init
Initialized build directory: C:/Bearsampp-build/module-mariadb
BUILD SUCCESSFUL in 2s
2 actionable tasks: 2 executed
```

---

### release

**Description**: Processes configuration files and replaces version placeholders.

**Dependencies**: `init`

**Usage**:
```bash
./gradlew release
```

**What it does**:
1. Finds all `bearsampp.conf` files in build directory
2. Replaces `@RELEASE_VERSION@` with actual release version
3. Validates processed files
4. Reports processed files

**Example transformation**:

**Before** (`bearsampp.conf`):
```ini
mariadbVersion = "12.0.2"
bundleRelease = "@RELEASE_VERSION@"
```

**After**:
```ini
mariadbVersion = "12.0.2"
bundleRelease = "2025.8.21"
```

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
