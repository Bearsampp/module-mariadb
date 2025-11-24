<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-mariadb.svg?style=flat-square)](https://github.com/bearsampp/module-mariadb/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-mariadb/total.svg?style=flat-square)

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving MariaDB.

## Build System

This project uses **Gradle** as its build system. The legacy Ant build has been fully replaced with a modern, pure Gradle implementation.

### Quick Start

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

### Prerequisites

| Requirement       | Version       | Purpose                                  |
|-------------------|---------------|------------------------------------------|
| **Java**          | 8+            | Required for Gradle execution            |
| **Gradle**        | 7.0+          | Build automation tool                    |
| **7-Zip**         | Latest        | Archive creation (required for 7z)       |

### Available Tasks

| Task                      | Description                                      |
|---------------------------|--------------------------------------------------|
| `release`                 | Build release package (interactive/non-interactive) |
| `releaseAll`              | Build all available versions                     |
| `clean`                   | Clean build artifacts and temporary files        |
| `verify`                  | Verify build environment and dependencies        |
| `info`                    | Display build configuration information          |
| `listVersions`            | List available bundle versions in bin/           |
| `listReleases`            | List releases from modules-untouched             |
| `validateProperties`      | Validate build.properties configuration          |
| `checkModulesUntouched`   | Check modules-untouched integration              |

For complete documentation, see [.gradle-docs/README.md](.gradle-docs/README.md)

## CI/CD Testing

This module includes automated testing for all MariaDB versions using GitHub Actions:

- **Smart Version Detection**: Automatically detects which versions to test from PR changes
  - 📦 Primary: Detects versions from `/bin` directory changes (e.g., `bin/mariadb11.8.3/`)
  - 📋 Fallback: Extracts versions from PR title
  - 🔄 Final Fallback: Tests latest 5 versions if no versions detected
- **Efficient Testing**: Only tests relevant versions, reducing CI runtime
- **Comprehensive Validation**: Tests download, extraction, and executable functionality
- **Automated PR Comments**: Results posted directly to pull requests

For detailed information about the testing workflow, see [docs/CI-CD-TESTING.md](docs/CI-CD-TESTING.md)

## Documentation

- **Build Documentation**: [.gradle-docs/README.md](.gradle-docs/README.md)
- **Task Reference**: [.gradle-docs/TASKS.md](.gradle-docs/TASKS.md)
- **Configuration Guide**: [.gradle-docs/CONFIGURATION.md](.gradle-docs/CONFIGURATION.md)
- **CI/CD Testing**: [docs/CI-CD-TESTING.md](docs/CI-CD-TESTING.md)
- **Module Downloads**: https://bearsampp.com/module/mariadb

## Issues

Issues must be reported on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).
