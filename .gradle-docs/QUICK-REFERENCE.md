# Quick Reference Card

Quick reference for common Gradle tasks and commands used by this module's Groovy `build.gradle`.

## Essential Commands

```bash
# Show build info (default task)
gradle info

# Build one version (download if needed, then package)
gradle release -PbundleVersion=12.0.2

# Select a version interactively from local bin/ folders
gradle release

# Prepare all local versions (no packaging)
gradle releaseAll

# Verify environment
gradle verify

# Clean Gradle build dir
gradle clean

# List versions
gradle listReleases
gradle listVersions
```

## Tasks

| Command                         | Description                                         |
|---------------------------------|-----------------------------------------------------|
| `gradle info`                   | Show configuration, paths, Java/Gradle versions     |
| `gradle release -PbundleVersion`| Build specific version (non-interactive)            |
| `gradle release`                | Interactive version selection                        |
| `gradle releaseAll`             | Prepare all local versions (no archive)             |
| `gradle verify`                 | Environment checks                                  |
| `gradle listReleases`           | List releases from modules-untouched                |
| `gradle listVersions`           | List versions under `bin/` and `bin/archived/`      |
| `gradle validateProperties`     | Validate `build.properties` keys                    |

## Common Options

| Option              | Description                    | Example                          |
|---------------------|--------------------------------|----------------------------------|
| `--info`            | Info level logging             | `./gradlew build --info`         |
| `--debug`           | Debug level logging            | `./gradlew build --debug`        |
| `--stacktrace`      | Show stack traces              | `./gradlew build --stacktrace`   |
| `--no-daemon`       | Don't use Gradle daemon        | `./gradlew build --no-daemon`    |
| `--dry-run`         | Show tasks without executing   | `./gradlew build --dry-run`      |
| `--quiet`           | Quiet output (errors only)     | `./gradlew build --quiet`        |

## Configuration Files

| File                   | Purpose                              |
|------------------------|--------------------------------------|
| `build.properties`     | Build configuration                  |
| `bin/*/*`              | MariaDB version files (copied/overlaid) |

## Environment Variables

| Variable               | Default Value                           | Description                      |
|------------------------|-----------------------------------------|----------------------------------|
| `BEARSAMPP_BUILD_PATH` | If `build.path` not set: `<root>/bearsampp-build` | Build output base directory      |
| `JAVA_HOME`            | (required)                              | Java installation path           |
| `GRADLE_OPTS`          | (optional)                              | JVM options for Gradle           |

## build.properties

```properties
bundle.name = mariadb          # Module name
bundle.release = 2025.8.21     # Release (YYYY.M.D)
bundle.type = bins             # Bundle type (bins/apps/tools)
bundle.format = 7z             # Archive format (7z/zip)
#build.path = C:/Bearsampp-build  # Optional build base path
```

## Notes on configuration files

The Gradle build does not edit config files. It copies the downloaded contents and overlays any files from your local `bin/mariadb<version>` directory.

## Quick Troubleshooting

| Issue                     | Solution                                  |
|---------------------------|-------------------------------------------|
| Java not found            | Set `JAVA_HOME` environment variable      |
| 7-Zip not found           | Install 7-Zip and add to PATH             |
| Permission denied         | Run `chmod +x gradlew` (Linux/Mac)        |
| Build failed              | Run with `--stacktrace` for details       |
| Configuration invalid     | Run `./gradlew validate`                  |

## File Structure

```
module-mariadb/
├── .gradle-docs/          # Documentation
├── bin/                   # MariaDB binaries (optional local source)
│   └── mariadbX.X.X/
├── build.gradle           # Groovy build script
├── build.properties       # Configuration
└── settings.gradle        # Gradle settings
```

## Adding New Version

```bash
# Option A: Local binaries
mkdir bin/mariadbX.X.X
# Place binaries into bin/mariadbX.X.X/

# Option B: Remote version
# Ensure version X.X.X exists in modules-untouched mariadb.properties

# Update release date (optional)
# Edit build.properties: bundle.release = YYYY.M.D

# Build
gradle release -PbundleVersion=X.X.X
```

## Git Workflow

```bash
# Update fork
git fetch upstream
git merge upstream/main

# Create branch
git checkout -b feature/my-feature

# Make changes
# ...

# Test
./gradlew clean build validate

# Commit
git add .
git commit -m "Add: Description"

# Push
git push origin feature/my-feature

# Create PR on GitHub
```

## Documentation Links

- **Main Guide**: [README.md](README.md)
- **Tasks**: [TASKS.md](TASKS.md)
- **Configuration**: [CONFIGURATION.md](CONFIGURATION.md)
- **Migration**: [MIGRATION.md](MIGRATION.md)
- **Summary**: [SUMMARY.md](SUMMARY.md)

## Support

- **Issues**: https://github.com/bearsampp/bearsampp/issues
- **Docs**: https://bearsampp.com/module/mariadb
- **Project**: https://github.com/bearsampp/bearsampp

---

**Tip**: Run `./gradlew tasks` to see all available tasks.
