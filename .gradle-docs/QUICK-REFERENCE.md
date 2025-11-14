# Quick Reference Card

Quick reference for common Gradle tasks and commands.

## Essential Commands

```bash
# Build everything (default)
./gradlew build

# Clean build directory
./gradlew clean

# Validate configuration
./gradlew validate

# List MariaDB versions
./gradlew listVersions
```

## Build Tasks

| Command                  | Description                          |
|--------------------------|--------------------------------------|
| `./gradlew build`        | Complete build (default)             |
| `./gradlew clean`        | Remove build directory               |
| `./gradlew init`         | Initialize build directory           |
| `./gradlew release`      | Process configuration files          |
| `./gradlew bundle`       | Create distribution archive          |
| `./gradlew validate`     | Validate configuration files         |
| `./gradlew listVersions` | List available MariaDB versions      |

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
| `releases.properties`  | Version mappings                     |
| `bin/*/bearsampp.conf` | MariaDB version configurations       |

## Environment Variables

| Variable                | Default Value        | Description              |
|-------------------------|----------------------|--------------------------|
| `BEARSAMPP_BUILD_PATH`  | `C:/Bearsampp-build` | Build output directory   |
| `JAVA_HOME`             | (required)           | Java installation path   |
| `GRADLE_OPTS`           | `-Xmx64m -Xms64m`    | JVM options for Gradle   |

## build.properties

```properties
bundle.name = mariadb          # Module name
bundle.release = 2025.8.21     # Release version (YYYY.M.D)
bundle.type = bins             # Bundle type (bins/apps/tools)
bundle.format = 7z             # Archive format (7z/zip)
#build.path = C:/Bearsampp-build  # Optional build path
```

## bearsampp.conf Template

```ini
mariadbVersion = "X.X.X"
mariadbExe = "bin/mysqld.exe"
mariadbCliExe = "bin/mysql.exe"
mariadbAdmin = "bin/mysqladmin.exe"
mariadbConf = "my.ini"
mariadbPort = "3307"
mariadbRootUser = "root"
mariadbRootPwd = ""

bundleRelease = "@RELEASE_VERSION@"
```

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
├── bin/                   # MariaDB binaries
│   └── mariadbX.X.X/
│       └── bearsampp.conf
├── gradle/wrapper/        # Gradle wrapper
├── build.gradle.kts       # Build script
├── build.properties       # Configuration
└── releases.properties    # Version mappings
```

## Adding New Version

```bash
# 1. Create directory
mkdir bin/mariadbX.X.X

# 2. Add binaries to bin/mariadbX.X.X/

# 3. Create bearsampp.conf
# (Use template above)

# 4. Update releases.properties
# X.X.X = https://github.com/.../bearsampp-mariadb-X.X.X-YYYY.M.D.7z

# 5. Update build.properties
# bundle.release = YYYY.M.D

# 6. Validate and build
./gradlew validate
./gradlew clean build
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
