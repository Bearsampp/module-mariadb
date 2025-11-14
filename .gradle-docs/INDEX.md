# Documentation Index

Complete index of all Gradle build documentation for the MariaDB module.

## Quick Links

| Document                                      | Purpose                                    |
|-----------------------------------------------|--------------------------------------------|
| [Quick Reference](QUICK-REFERENCE.md)         | Command cheat sheet - **Start here!**      |
| [Usage Guide](USAGE.md)                       | Detailed usage examples                    |
| [Main Guide](README.md)                       | Complete build system guide                |
| [Task Reference](TASKS.md)                    | Detailed task documentation                |
| [Configuration Guide](CONFIGURATION.md)       | Configuration options and properties       |
| [Migration Guide](MIGRATION.md)               | Ant to Gradle migration                    |
| [Summary](SUMMARY.md)                         | Conversion summary and statistics          |
| [Conversion Summary](CONVERSION-SUMMARY.md)   | Groovy DSL conversion details              |
| [Conversion Complete](CONVERSION-COMPLETE.md) | Final conversion status                    |

## Documentation Structure

```
.gradle-docs/
├── INDEX.md                    # This file - documentation index
├── QUICK-REFERENCE.md          # Quick command reference (200 lines)
├── README.md                   # Main documentation (650 lines)
├── TASKS.md                    # Task reference (850 lines)
├── CONFIGURATION.md            # Configuration guide (900 lines)
├── MIGRATION.md                # Migration guide (750 lines)
└── SUMMARY.md                  # Conversion summary (400 lines)
```

## By Topic

### Getting Started
- [Quick Reference](QUICK-REFERENCE.md) - Essential commands
- [README.md § Quick Start](README.md#quick-start) - First build
- [README.md § Prerequisites](README.md#prerequisites) - Requirements

### Building
- [README.md § Building the Module](README.md#building-the-module) - Build guide
- [TASKS.md § Core Build Tasks](TASKS.md#core-build-tasks) - Build tasks
- [QUICK-REFERENCE.md § Build Tasks](QUICK-REFERENCE.md#build-tasks) - Quick commands

### Configuration
- [CONFIGURATION.md](CONFIGURATION.md) - Complete configuration guide
- [CONFIGURATION.md § Build Properties](CONFIGURATION.md#build-properties) - build.properties
- [CONFIGURATION.md § Configuration Files](CONFIGURATION.md#configuration-files) - bearsampp.conf
- [QUICK-REFERENCE.md § Configuration Files](QUICK-REFERENCE.md#configuration-files) - Quick reference

### Tasks
- [TASKS.md](TASKS.md) - Complete task reference
- [TASKS.md § Core Build Tasks](TASKS.md#core-build-tasks) - Main tasks
- [TASKS.md § Utility Tasks](TASKS.md#utility-tasks) - Helper tasks
- [QUICK-REFERENCE.md § Build Tasks](QUICK-REFERENCE.md#build-tasks) - Quick list

### Migration
- [MIGRATION.md](MIGRATION.md) - Complete migration guide
- [MIGRATION.md § Why Gradle?](MIGRATION.md#why-gradle) - Benefits
- [MIGRATION.md § Task Mapping](MIGRATION.md#task-mapping) - Ant to Gradle
- [MIGRATION.md § Migration Steps](MIGRATION.md#migration-steps) - How to migrate

### Troubleshooting
- [README.md § Troubleshooting](README.md#troubleshooting) - Common issues
- [TASKS.md § Troubleshooting Tasks](TASKS.md#troubleshooting-tasks) - Task issues
- [QUICK-REFERENCE.md § Quick Troubleshooting](QUICK-REFERENCE.md#quick-troubleshooting) - Quick fixes

### Contributing
- [README.md § Contributing](README.md#contributing) - How to contribute
- [../CONTRIBUTING.md](../CONTRIBUTING.md) - Detailed contribution guide
- [QUICK-REFERENCE.md § Adding New Version](QUICK-REFERENCE.md#adding-new-version) - Add MariaDB version

### Reference
- [SUMMARY.md](SUMMARY.md) - Conversion summary
- [SUMMARY.md § Statistics](SUMMARY.md#statistics) - Metrics
- [SUMMARY.md § Features](SUMMARY.md#features-implemented) - Feature list

## By Role

### For New Users
1. [Quick Reference](QUICK-REFERENCE.md) - Essential commands
2. [README.md § Quick Start](README.md#quick-start) - First build
3. [README.md § Building](README.md#building-the-module) - Build guide

### For Developers
1. [README.md](README.md) - Complete guide
2. [TASKS.md](TASKS.md) - All tasks
3. [CONFIGURATION.md](CONFIGURATION.md) - Configuration
4. [../CONTRIBUTING.md](../CONTRIBUTING.md) - Contributing

### For Maintainers
1. [SUMMARY.md](SUMMARY.md) - Conversion summary
2. [MIGRATION.md](MIGRATION.md) - Migration details
3. [CONFIGURATION.md § Advanced](CONFIGURATION.md#advanced-configuration) - Advanced config

### For Migrators (from Ant)
1. [MIGRATION.md](MIGRATION.md) - Complete migration guide
2. [MIGRATION.md § Task Mapping](MIGRATION.md#task-mapping) - Command mapping
3. [MIGRATION.md § Breaking Changes](MIGRATION.md#breaking-changes) - What changed

## By Task

### Build Tasks
- [TASKS.md § clean](TASKS.md#clean) - Remove build directory
- [TASKS.md § init](TASKS.md#init) - Initialize build
- [TASKS.md § release](TASKS.md#release) - Process configs
- [TASKS.md § bundle](TASKS.md#bundle) - Create archive
- [TASKS.md § build](TASKS.md#build) - Complete build

### Utility Tasks
- [TASKS.md § validate](TASKS.md#validate) - Validate configs
- [TASKS.md § listVersions](TASKS.md#listversions) - List versions

## By Configuration

### Build Configuration
- [CONFIGURATION.md § build.properties](CONFIGURATION.md#buildproperties) - Main config
- [CONFIGURATION.md § bundle.name](CONFIGURATION.md#bundlename) - Module name
- [CONFIGURATION.md § bundle.release](CONFIGURATION.md#bundlerelease) - Version
- [CONFIGURATION.md § bundle.type](CONFIGURATION.md#bundletype) - Type (bins)
- [CONFIGURATION.md § bundle.format](CONFIGURATION.md#bundleformat) - Format (7z)
- [CONFIGURATION.md § build.path](CONFIGURATION.md#buildpath) - Output path

### Version Configuration
- [CONFIGURATION.md § releases.properties](CONFIGURATION.md#releasesproperties) - Version mappings
- [CONFIGURATION.md § Adding New Versions](CONFIGURATION.md#adding-new-versions) - Add version

### MariaDB Configuration
- [CONFIGURATION.md § bearsampp.conf](CONFIGURATION.md#bearsamppconf) - MariaDB config
- [README.md § Configuration Files](README.md#configuration-files) - Config overview

### Environment Variables
- [CONFIGURATION.md § Environment Variables](CONFIGURATION.md#environment-variables) - All variables
- [CONFIGURATION.md § BEARSAMPP_BUILD_PATH](CONFIGURATION.md#bearsampp_build_path) - Build path
- [CONFIGURATION.md § JAVA_HOME](CONFIGURATION.md#java_home) - Java path

## Search by Keyword

### Commands
- `./gradlew build` - [Quick Reference](QUICK-REFERENCE.md), [TASKS.md § build](TASKS.md#build)
- `./gradlew clean` - [Quick Reference](QUICK-REFERENCE.md), [TASKS.md § clean](TASKS.md#clean)
- `./gradlew validate` - [Quick Reference](QUICK-REFERENCE.md), [TASKS.md § validate](TASKS.md#validate)
- `./gradlew listVersions` - [Quick Reference](QUICK-REFERENCE.md), [TASKS.md § listVersions](TASKS.md#listversions)

### Files
- `build.gradle.kts` - [README.md § Project Structure](README.md#project-structure)
- `build.properties` - [CONFIGURATION.md § build.properties](CONFIGURATION.md#buildproperties)
- `releases.properties` - [CONFIGURATION.md § releases.properties](CONFIGURATION.md#releasesproperties)
- `bearsampp.conf` - [CONFIGURATION.md § bearsampp.conf](CONFIGURATION.md#bearsamppconf)

### Concepts
- Gradle - [README.md § Overview](README.md#overview)
- Kotlin DSL - [MIGRATION.md § Why Gradle](MIGRATION.md#why-gradle)
- Incremental builds - [MIGRATION.md § Benefits](MIGRATION.md#benefits-realized)
- Bundle type - [CONFIGURATION.md § bundle.type](CONFIGURATION.md#bundletype)

### Issues
- Java not found - [README.md § Troubleshooting](README.md#troubleshooting)
- 7-Zip not found - [README.md § Troubleshooting](README.md#troubleshooting)
- Build failed - [TASKS.md § Troubleshooting](TASKS.md#troubleshooting-tasks)
- Configuration invalid - [TASKS.md § validate](TASKS.md#validate)

## External Links

### Bearsampp
- [Bearsampp Project](https://github.com/bearsampp/bearsampp)
- [Module Documentation](https://bearsampp.com/module/mariadb)
- [Issue Tracker](https://github.com/bearsampp/bearsampp/issues)

### Reference Modules
- [Module Bruno](https://github.com/Bearsampp/module-bruno/tree/gradle-convert)
- [Module Git](https://github.com/Bearsampp/module-git/tree/gradle-convert)
- [Module Apache](https://github.com/Bearsampp/module-apache/tree/gradle-convert)

### Gradle
- [Gradle Documentation](https://docs.gradle.org/)
- [Kotlin DSL Primer](https://docs.gradle.org/current/userguide/kotlin_dsl.html)
- [Gradle Best Practices](https://docs.gradle.org/current/userguide/best_practices.html)

## Document Statistics

| Document                  | Lines | Tables | Examples | Purpose                    |
|---------------------------|-------|--------|----------|----------------------------|
| INDEX.md                  | 250   | 5      | 0        | Documentation index        |
| QUICK-REFERENCE.md        | 200   | 8      | 10       | Quick command reference    |
| README.md                 | 650   | 12     | 15       | Main documentation         |
| TASKS.md                  | 850   | 15     | 20       | Task reference             |
| CONFIGURATION.md          | 900   | 18     | 25       | Configuration guide        |
| MIGRATION.md              | 750   | 12     | 15       | Migration guide            |
| SUMMARY.md                | 400   | 20     | 5        | Conversion summary         |
| **Total**                 | **4,000** | **90** | **90** | **Complete documentation** |

## Reading Paths

### Path 1: Quick Start (15 minutes)
1. [Quick Reference](QUICK-REFERENCE.md) - 5 min
2. [README.md § Quick Start](README.md#quick-start) - 5 min
3. [README.md § Building](README.md#building-the-module) - 5 min

### Path 2: Complete Guide (1 hour)
1. [README.md](README.md) - 30 min
2. [TASKS.md](TASKS.md) - 20 min
3. [CONFIGURATION.md](CONFIGURATION.md) - 10 min

### Path 3: Migration (30 minutes)
1. [MIGRATION.md § Overview](MIGRATION.md#overview) - 5 min
2. [MIGRATION.md § Task Mapping](MIGRATION.md#task-mapping) - 10 min
3. [MIGRATION.md § Migration Steps](MIGRATION.md#migration-steps) - 15 min

### Path 4: Deep Dive (2 hours)
1. [README.md](README.md) - 30 min
2. [TASKS.md](TASKS.md) - 30 min
3. [CONFIGURATION.md](CONFIGURATION.md) - 30 min
4. [MIGRATION.md](MIGRATION.md) - 30 min

## Version History

| Version | Date       | Changes                                    |
|---------|------------|--------------------------------------------|
| 1.0     | 2025-11-14 | Initial Gradle conversion documentation    |

## Feedback

Found an issue or have a suggestion?
- Open an issue: https://github.com/bearsampp/bearsampp/issues
- Edit on GitHub: https://github.com/bearsampp/module-mariadb

---

**Tip**: Start with [Quick Reference](QUICK-REFERENCE.md) for essential commands, then explore other documents as needed.
