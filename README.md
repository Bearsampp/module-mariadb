<p align="center"><a href="https://bearsampp.com/contribute" target="_blank"><img width="250" src="img/Bearsampp-logo.svg"></a></p>

[![GitHub release](https://img.shields.io/github/release/bearsampp/module-mariadb.svg?style=flat-square)](https://github.com/bearsampp/module-mariadb/releases/latest)
![Total downloads](https://img.shields.io/github/downloads/bearsampp/module-mariadb/total.svg?style=flat-square)

This is a module of [Bearsampp project](https://github.com/bearsampp/bearsampp) involving MariaDB.

## Quick Start

### Prerequisites

| Tool     | Version | Required | Purpose                    |
|----------|---------|----------|----------------------------|
| Java JDK | 17+     | Yes      | Gradle runtime             |
| 7-Zip    | Latest  | Yes      | Archive creation           |
| Git      | 2.0+    | Yes      | Version control            |

### Building

```bash
# Clone the repository
git clone https://github.com/bearsampp/module-mariadb.git
cd module-mariadb

# Build the module
gradle build

# Output: C:/Bearsampp-build/bearsampp-mariadb-2025.8.21.7z
```

### Available Tasks

| Task           | Description                          |
|----------------|--------------------------------------|
| `build`        | Complete build (default)             |
| `clean`        | Remove build directory               |
| `validate`     | Validate configuration files         |
| `listVersions` | List available MariaDB versions      |

## Documentation

### Build System

- **[Gradle Build Documentation](.gradle-docs/README.md)** - Complete build system guide
- **[Task Reference](.gradle-docs/TASKS.md)** - Detailed task documentation
- **[Configuration Guide](.gradle-docs/CONFIGURATION.md)** - Configuration options
- **[Migration Guide](.gradle-docs/MIGRATION.md)** - Ant to Gradle migration

### Module Information

- **Official Documentation**: https://bearsampp.com/module/mariadb
- **Downloads**: https://github.com/bearsampp/module-mariadb/releases

## Project Structure

```
module-mariadb/
├── .gradle-docs/          # Build documentation
├── bin/                   # MariaDB binaries by version
│   ├── mariadb10.11.14/
│   ├── mariadb11.8.3/
│   └── mariadb12.0.2/
├── build.gradle           # Gradle build script (Groovy)
├── build.properties       # Build configuration
├── settings.gradle        # Gradle settings
└── releases.properties    # Version mappings
```

## Configuration

### build.properties

```properties
bundle.name = mariadb
bundle.release = 2025.8.21
bundle.type = bins
bundle.format = 7z

#build.path = C:/Bearsampp-build
```

### Environment Variables

| Variable                | Default Value        | Description              |
|-------------------------|----------------------|--------------------------|
| `BEARSAMPP_BUILD_PATH`  | `C:/Bearsampp-build` | Build output directory   |
| `JAVA_HOME`             | (required)           | Java installation path   |

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make changes and test: `gradle clean build validate`
4. Commit: `git commit -m "Add: Description"`
5. Push: `git push origin feature/my-feature`
6. Create a Pull Request

## Issues

Issues must be reported on [Bearsampp repository](https://github.com/bearsampp/bearsampp/issues).

## License

See [LICENSE](LICENSE) file for details.
