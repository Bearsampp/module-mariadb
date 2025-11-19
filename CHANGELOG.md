# Changelog

All notable changes to the MariaDB module will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Pure Gradle build system with Kotlin DSL
- Gradle wrapper for automatic Gradle installation
- Comprehensive documentation in `.gradle-docs/` directory
  - Main README with quick start guide
  - Detailed task reference (TASKS.md)
  - Configuration guide (CONFIGURATION.md)
  - Ant to Gradle migration guide (MIGRATION.md)
- New Gradle tasks:
  - `validate`: Validate configuration files
  - `listVersions`: List all available MariaDB versions
- Environment variable support for build path (`BEARSAMPP_BUILD_PATH`)
- Incremental build support
- Build caching for faster subsequent builds
- Better error messages and logging
- Type-safe configuration with Kotlin DSL

### Changed
- Migrated from Apache Ant to Gradle build system
- Updated README.md with Gradle build instructions
- Improved build output formatting
- Enhanced configuration file processing
- Optimized 7z compression settings

### Removed
- Apache Ant build files (build.xml, build-commons.xml, build-properties.xml)
- Ant-specific configuration

### Fixed
- Cross-platform path handling
- Configuration file encoding issues
- Build reproducibility

## [2025.8.21] - 2025-08-21

### Added
- MariaDB 11.8.3 support
- MariaDB 12.0.2 support
- MariaDB 10.11.14 support

### Updated
- Multiple MariaDB version updates across 10.x, 11.x series
- Release properties with latest download URLs

## Previous Releases

See [releases.properties](releases.properties) for complete version history.

---

## Migration Notes

### From Ant to Gradle

If you were using the Ant build system:

**Old command**:
```bash
ant build
```

**New command**:
```bash
./gradlew build
```

See [Migration Guide](.gradle-docs/MIGRATION.md) for complete migration instructions.

### Breaking Changes

1. **Build command changed**: Use `./gradlew` instead of `ant`
2. **Property override**: Use environment variables instead of `-D` flags
3. **Build output**: Different format and structure

### Compatibility

- **Java**: Requires Java 17 or higher (previously Java 8+)
- **7-Zip**: Still required for archive creation
- **Build properties**: `build.properties` format unchanged
- **Configuration files**: `bearsampp.conf` format unchanged
- **Bundle type**: Remains `bins` (unchanged)

---

## Upgrade Guide

### For Developers

1. Install Java 17+
2. Remove old Ant files (if present)
3. Run `./gradlew build`
4. Update IDE to import as Gradle project

### For CI/CD

1. Update build scripts to use `./gradlew`
2. Add Java 17 setup step
3. Cache Gradle dependencies
4. Update environment variables

See [Migration Guide](.gradle-docs/MIGRATION.md) for detailed instructions.

---

## Links

- [GitHub Repository](https://github.com/bearsampp/module-mariadb)
- [Issue Tracker](https://github.com/bearsampp/bearsampp/issues)
- [Documentation](https://bearsampp.com/module/mariadb)
- [Bearsampp Project](https://github.com/bearsampp/bearsampp)
