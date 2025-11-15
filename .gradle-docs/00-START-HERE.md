# Start Here - Gradle Build Documentation

Welcome to the MariaDB module Gradle build documentation!

## 📚 Documentation Overview

All documentation for the Gradle build system is organized in this directory.

### Quick Navigation

| If you want to...                          | Read this document                        |
|--------------------------------------------|-------------------------------------------|
| Get started quickly                        | [QUICK-REFERENCE.md](QUICK-REFERENCE.md)  |
| Understand the build system                | [README.md](README.md)                    |
| Learn about all tasks                      | [TASKS.md](TASKS.md)                      |
| Configure the build                        | [CONFIGURATION.md](CONFIGURATION.md)      |
| Migrate from Ant                           | [MIGRATION.md](MIGRATION.md)              |
| Browse all documentation                   | [INDEX.md](INDEX.md)                      |

## 🚀 Quick Start (5 minutes)

### 1. Verify environment
```bash
gradle verify
```

### 2. List available local versions
```bash
gradle listVersions
```

### 3. Build interactively
```bash
gradle release
# Select version(s) when prompted
```

### 4. Build a specific version (non-interactive)
```bash
gradle release -PbundleVersion=12.0.2
```

### 5. Prepare all local versions (no archive)
```bash
gradle releaseAll
```

## 📖 Documentation Files

### Core Documentation
- **[README.md](README.md)** - Complete build system guide
  - Overview, prerequisites, project structure
  - Build configuration, tasks, troubleshooting
  - Release management, contributing

- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** - Command cheat sheet
  - Essential commands
  - Common tasks
  - Quick troubleshooting


### Task & Configuration
- **[TASKS.md](TASKS.md)** - Detailed task reference
  - All tasks explained
  - Examples and options
  - Performance tips

- **[CONFIGURATION.md](CONFIGURATION.md)** - Configuration guide
  - Complete property reference
  - Environment variables
  - Advanced configuration

### Migration & History
- **[MIGRATION.md](MIGRATION.md)** - Ant to Gradle migration
  - Why Gradle?
  - Feature comparison
  - Migration steps

- **[SUMMARY.md](SUMMARY.md)** - Conversion summary
  - Files created/updated/removed
  - Statistics and metrics
  - Checklist

### Reference
- **[INDEX.md](INDEX.md)** (250 lines) - Complete documentation index
  - By topic
  - By role
  - By task
  - Search by keyword

### Tips
- Use `gradle info` to print all important paths and environment details.
- If 7-Zip is not detected and `bundle.format=7z`, install 7-Zip or set `7Z_HOME`.

## 🎯 Common Tasks

### List Versions
```bash
gradle listVersions
```
Shows all available MariaDB versions in `bin/` and `bin/archived/`

### Build Specific Version
```bash
gradle release
# Interactive prompt - select version number
```

### Build Multiple Versions
```bash
gradle release
# Enter: 1,3,5 (comma-separated)
```

### Build All Local Versions (no archive)
```bash
gradle releaseAll
```
Prepares all versions found under `bin/` and `bin/archived/`.

### Validate Configuration
```bash
gradle validateProperties
```
Validates required keys in `build.properties`.

### Verify Environment
```bash
gradle verify
```
Checks Java, dev path, bin directory, and 7‑Zip (when using 7z format).

### Clean Build Directory
```bash
gradle clean
```

## 📊 Documentation Statistics

| Category          | Files | Lines  | Purpose                        |
|-------------------|-------|--------|--------------------------------|
| Core Docs         | 3     | 1,500  | Main guides and references     |
| Task & Config     | 2     | 1,750  | Detailed technical docs        |
| Migration         | 1     | 700    | Conversion and history         |
| Reference         | 1     | 250    | Complete index                 |
| Utilities         | 0     | -      | Helper scripts                 |
| **Total**         | **7** | **4,200+** | **Current documentation**   |

## 🔍 Finding Information

### By Experience Level

**Beginner** (Never used Gradle)
1. [QUICK-REFERENCE.md](QUICK-REFERENCE.md) - Learn basic commands
2. [README.md § Quick Start](README.md#quick-start) - First build
3. [TASKS.md](TASKS.md) - Task examples and usage

**Intermediate** (Some Gradle experience)
1. [README.md](README.md) - Complete guide
2. [TASKS.md](TASKS.md) - All tasks
3. [CONFIGURATION.md](CONFIGURATION.md) - Configuration options

**Advanced** (Gradle expert)
1. [CONFIGURATION.md § Advanced](CONFIGURATION.md#advanced-configuration)
2. [MIGRATION.md](MIGRATION.md) - Technical details
3. [SUMMARY.md](SUMMARY.md) - Implementation details

### By Task

**Building**
- [QUICK-REFERENCE.md § Build Tasks](QUICK-REFERENCE.md#build-tasks)
- [TASKS.md § Core Build Tasks](TASKS.md#core-build-tasks)

**Configuring**
- [CONFIGURATION.md](CONFIGURATION.md)
- [README.md § Configuration](README.md#configuration)

**Troubleshooting**
- [QUICK-REFERENCE.md § Troubleshooting](QUICK-REFERENCE.md#troubleshooting)
- [README.md § Troubleshooting](README.md#troubleshooting)
- [TASKS.md § Troubleshooting](TASKS.md#troubleshooting-tasks)

**Migrating from Ant**
- [MIGRATION.md](MIGRATION.md)

## 💡 Tips

1. **Start with Quick Reference** - Get up and running in 5 minutes
2. **Use Interactive Mode** - `gradle release` prompts for version selection
3. **Validate First** - Run `gradle validateProperties` before building
4. **Check Documentation Index** - [INDEX.md](INDEX.md) has everything organized
5. **Read Examples** - See examples in [TASKS.md](TASKS.md)

## 🆘 Getting Help

1. **Check Quick Reference** - [QUICK-REFERENCE.md](QUICK-REFERENCE.md)
2. **Search Index** - [INDEX.md](INDEX.md) has keyword search
3. **Read Troubleshooting** - Each doc has troubleshooting section
4. **Open Issue** - https://github.com/bearsampp/bearsampp/issues

## 📝 Documentation Standards

All documentation in this directory follows these standards:
- ✓ Markdown format
- ✓ Clear headings and structure
- ✓ Code examples with syntax highlighting
- ✓ Tables for structured data
- ✓ Cross-references between documents
- ✓ Troubleshooting sections
- ✓ Real-world examples

## 🔗 External Resources

- **Bearsampp Project**: https://github.com/bearsampp/bearsampp
- **Module Documentation**: https://bearsampp.com/module/mariadb
- **Gradle Documentation**: https://docs.gradle.org/
- **Issue Tracker**: https://github.com/bearsampp/bearsampp/issues

---

**Ready to start?** → [QUICK-REFERENCE.md](QUICK-REFERENCE.md)

**Need details?** → [README.md](README.md)

**Want everything?** → [INDEX.md](INDEX.md)
