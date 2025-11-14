# Start Here - Gradle Build Documentation

Welcome to the MariaDB module Gradle build documentation!

## 📚 Documentation Overview

All documentation for the Gradle build system is organized in this directory.

### Quick Navigation

| If you want to...                          | Read this document                        |
|--------------------------------------------|-------------------------------------------|
| **Get started quickly**                    | [QUICK-REFERENCE.md](QUICK-REFERENCE.md)  |
| **See usage examples**                     | [USAGE.md](USAGE.md)                      |
| **Understand the build system**            | [README.md](README.md)                    |
| **Learn about all tasks**                  | [TASKS.md](TASKS.md)                      |
| **Configure the build**                    | [CONFIGURATION.md](CONFIGURATION.md)      |
| **Migrate from Ant**                       | [MIGRATION.md](MIGRATION.md)              |
| **See conversion details**                 | [CONVERSION-SUMMARY.md](CONVERSION-SUMMARY.md) |
| **Browse all documentation**               | [INDEX.md](INDEX.md)                      |

## 🚀 Quick Start (5 minutes)

### 1. List Available Versions
```bash
gradle listVersions
```

### 2. Build Interactively
```bash
gradle release
# Select version(s) when prompted
```

### 3. Build All Versions
```bash
gradle build
```

## 📖 Documentation Files

### Core Documentation
- **[README.md](README.md)** (650 lines) - Complete build system guide
  - Overview, prerequisites, project structure
  - Build configuration, tasks, troubleshooting
  - Release management, contributing

- **[QUICK-REFERENCE.md](QUICK-REFERENCE.md)** (200 lines) - Command cheat sheet
  - Essential commands
  - Common tasks
  - Quick troubleshooting

- **[USAGE.md](USAGE.md)** - Detailed usage examples
  - Step-by-step workflows
  - Real-world examples
  - Best practices

### Task & Configuration
- **[TASKS.md](TASKS.md)** (850 lines) - Detailed task reference
  - All tasks explained
  - Examples and options
  - Performance tips

- **[CONFIGURATION.md](CONFIGURATION.md)** (900 lines) - Configuration guide
  - Complete property reference
  - Environment variables
  - Advanced configuration

### Migration & History
- **[MIGRATION.md](MIGRATION.md)** (750 lines) - Ant to Gradle migration
  - Why Gradle?
  - Feature comparison
  - Migration steps

- **[SUMMARY.md](SUMMARY.md)** (400 lines) - Conversion summary
  - Files created/updated/removed
  - Statistics and metrics
  - Checklist

- **[CONVERSION-SUMMARY.md](CONVERSION-SUMMARY.md)** - Groovy DSL details
  - Groovy vs Kotlin comparison
  - No wrapper approach
  - Key differences

- **[CONVERSION-COMPLETE.md](CONVERSION-COMPLETE.md)** - Final status
  - What was done
  - File summary
  - Next steps

### Reference
- **[INDEX.md](INDEX.md)** (250 lines) - Complete documentation index
  - By topic
  - By role
  - By task
  - Search by keyword

### Utilities
- **[verify-gradle-conversion.bat](verify-gradle-conversion.bat)** - Verification script
  - Checks all files are in place
  - Validates configuration
  - Reports status

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

### Build All Versions
```bash
gradle build
```
Non-interactive - builds everything

### Validate Configuration
```bash
gradle validate
```
Checks all `bearsampp.conf` files

### Clean Build Directory
```bash
gradle clean
```

## 📊 Documentation Statistics

| Category          | Files | Lines  | Purpose                        |
|-------------------|-------|--------|--------------------------------|
| Core Docs         | 3     | 1,500  | Main guides and references     |
| Task & Config     | 2     | 1,750  | Detailed technical docs        |
| Migration         | 4     | 2,300  | Conversion and history         |
| Reference         | 1     | 250    | Complete index                 |
| Utilities         | 1     | -      | Helper scripts                 |
| **Total**         | **11**| **5,800+** | **Complete documentation** |

## 🔍 Finding Information

### By Experience Level

**Beginner** (Never used Gradle)
1. [QUICK-REFERENCE.md](QUICK-REFERENCE.md) - Learn basic commands
2. [README.md § Quick Start](README.md#quick-start) - First build
3. [USAGE.md](USAGE.md) - See examples

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
- [USAGE.md](USAGE.md)

**Configuring**
- [CONFIGURATION.md](CONFIGURATION.md)
- [README.md § Configuration](README.md#configuration)

**Troubleshooting**
- [QUICK-REFERENCE.md § Troubleshooting](QUICK-REFERENCE.md#troubleshooting)
- [README.md § Troubleshooting](README.md#troubleshooting)
- [TASKS.md § Troubleshooting](TASKS.md#troubleshooting-tasks)

**Migrating from Ant**
- [MIGRATION.md](MIGRATION.md)
- [CONVERSION-SUMMARY.md](CONVERSION-SUMMARY.md)

## 💡 Tips

1. **Start with Quick Reference** - Get up and running in 5 minutes
2. **Use Interactive Mode** - `gradle release` prompts for version selection
3. **Validate First** - Run `gradle validate` before building
4. **Check Documentation Index** - [INDEX.md](INDEX.md) has everything organized
5. **Read Examples** - [USAGE.md](USAGE.md) has real-world workflows

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
