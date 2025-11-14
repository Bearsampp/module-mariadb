# Contributing to MariaDB Module

Thank you for your interest in contributing to the Bearsampp MariaDB module! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Coding Standards](#coding-standards)
- [Adding New MariaDB Versions](#adding-new-mariadb-versions)

## Code of Conduct

This project follows the [Bearsampp Code of Conduct](https://github.com/bearsampp/bearsampp/blob/main/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

Before you begin, ensure you have:

- **Java JDK 17+**: Required for Gradle
- **7-Zip**: Required for creating archives
- **Git**: For version control
- **Text Editor/IDE**: VS Code, IntelliJ IDEA, or similar

### Fork and Clone

1. **Fork the repository** on GitHub
2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/module-mariadb.git
   cd module-mariadb
   ```
3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/bearsampp/module-mariadb.git
   ```

## Development Setup

### 1. Verify Prerequisites

```bash
# Check Java version (should be 17+)
java -version

# Check 7-Zip
7z --help

# Check Git
git --version
```

### 2. Build the Project

```bash
# First build (downloads Gradle if needed)
./gradlew build

# Validate configuration
./gradlew validate

# List available versions
./gradlew listVersions
```

### 3. IDE Setup

#### IntelliJ IDEA

1. Open IntelliJ IDEA
2. File → Open → Select `module-mariadb` directory
3. IDEA will automatically detect Gradle project
4. Wait for indexing to complete

#### VS Code

1. Install "Gradle for Java" extension
2. Open `module-mariadb` directory
3. VS Code will detect Gradle project
4. Use Gradle tasks panel for builds

#### Eclipse

1. Install Buildship plugin
2. File → Import → Gradle → Existing Gradle Project
3. Select `module-mariadb` directory
4. Finish import

## Making Changes

### 1. Create a Branch

```bash
# Update your fork
git fetch upstream
git checkout main
git merge upstream/main

# Create feature branch
git checkout -b feature/my-feature
```

**Branch naming conventions**:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Test additions/changes

### 2. Make Your Changes

Edit files as needed. Common changes:

- **Add MariaDB version**: See [Adding New MariaDB Versions](#adding-new-mariadb-versions)
- **Update documentation**: Edit files in `.gradle-docs/`
- **Fix bugs**: Modify `build.gradle.kts` or configuration files
- **Improve build**: Enhance Gradle tasks

### 3. Test Your Changes

```bash
# Validate configuration
./gradlew validate

# Clean build
./gradlew clean build

# Check output
ls C:/Bearsampp-build/bearsampp-mariadb-*.7z
```

### 4. Commit Your Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "Add: Support for MariaDB 12.1.0"
```

**Commit message format**:
```
<type>: <description>

[optional body]

[optional footer]
```

**Types**:
- `Add:` - New feature or version
- `Fix:` - Bug fix
- `Update:` - Update existing feature
- `Docs:` - Documentation changes
- `Refactor:` - Code refactoring
- `Test:` - Test changes
- `Chore:` - Maintenance tasks

**Examples**:
```
Add: Support for MariaDB 12.1.0

- Added bin/mariadb12.1.0/ directory
- Created bearsampp.conf configuration
- Updated releases.properties

Closes #123
```

```
Fix: Incorrect path handling on Windows

- Fixed backslash escaping in build.gradle.kts
- Updated path normalization logic
```

```
Docs: Update configuration guide

- Added examples for custom build paths
- Clarified environment variable usage
```

## Testing

### Validation Tests

```bash
# Validate all configuration files
./gradlew validate

# Should output:
# ✓ All configuration files are valid
```

### Build Tests

```bash
# Clean build
./gradlew clean build

# Verify output exists
ls C:/Bearsampp-build/bearsampp-mariadb-*.7z

# Check archive contents
7z l C:/Bearsampp-build/bearsampp-mariadb-*.7z
```

### Manual Testing

1. **Extract archive**:
   ```bash
   7z x C:/Bearsampp-build/bearsampp-mariadb-*.7z -otest-extract
   ```

2. **Verify structure**:
   ```bash
   cd test-extract/module-mariadb
   ls bin/
   ```

3. **Check configuration**:
   ```bash
   cat bin/mariadb12.0.2/bearsampp.conf
   # Verify bundleRelease is set correctly (not @RELEASE_VERSION@)
   ```

### Test Checklist

Before submitting:

- [ ] `./gradlew validate` passes
- [ ] `./gradlew clean build` succeeds
- [ ] Archive is created in build directory
- [ ] Archive size is reasonable (~200-300 MB)
- [ ] Configuration files have correct release version
- [ ] No `@RELEASE_VERSION@` placeholders remain
- [ ] Documentation is updated
- [ ] Commit messages are clear

## Submitting Changes

### 1. Push to Your Fork

```bash
git push origin feature/my-feature
```

### 2. Create Pull Request

1. Go to your fork on GitHub
2. Click "Pull Request" button
3. Select base: `bearsampp/module-mariadb` `main`
4. Select compare: `YOUR_USERNAME/module-mariadb` `feature/my-feature`
5. Fill in PR template:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New MariaDB version
- [ ] Bug fix
- [ ] Documentation update
- [ ] Build improvement

## Testing
- [ ] Validated configuration
- [ ] Built successfully
- [ ] Tested archive extraction

## Checklist
- [ ] Code follows project style
- [ ] Documentation updated
- [ ] Tests pass
- [ ] Commit messages are clear
```

6. Click "Create Pull Request"

### 3. Code Review

- Maintainers will review your PR
- Address any feedback
- Make requested changes
- Push updates to your branch

### 4. Merge

Once approved:
- PR will be merged by maintainers
- Your changes will be in the next release
- You'll be credited in release notes

## Coding Standards

### Kotlin DSL (build.gradle.kts)

```kotlin
// Use descriptive variable names
val bundleName: String = props.getProperty("bundle.name")

// Add comments for complex logic
// Process bearsampp.conf files and replace version placeholders
fileTree("${buildPath}/module-${bundleName}/bin").matching {
    include("**/bearsampp.conf")
}.forEach { confFile ->
    // ...
}

// Use consistent formatting
tasks {
    val clean by registering(Delete::class) {
        delete(file("${buildPath}/module-${bundleName}"))
    }
}
```

### Configuration Files

**bearsampp.conf**:
```ini
# Use consistent formatting
mariadbVersion = "12.0.2"
mariadbExe = "bin/mysqld.exe"

# Always use forward slashes
mariadbCliExe = "bin/mysql.exe"  # ✓ Good
mariadbCliExe = "bin\mysql.exe"  # ✗ Bad

# Keep placeholder for bundleRelease
bundleRelease = "@RELEASE_VERSION@"  # ✓ Good
bundleRelease = "2025.8.21"          # ✗ Bad (will be replaced during build)
```

**build.properties**:
```properties
# Use consistent naming
bundle.name = mariadb
bundle.release = 2025.8.21

# Comment optional properties
#build.path = C:/Bearsampp-build
```

### Documentation

- Use Markdown for all documentation
- Keep lines under 100 characters
- Use tables for structured data
- Include code examples
- Add links to related docs

**Example**:
```markdown
## Task Name

**Description**: Brief description

**Usage**:
\`\`\`bash
./gradlew taskName
\`\`\`

**What it does**:
1. Step one
2. Step two

**Output**:
\`\`\`
Expected output
\`\`\`
```

## Adding New MariaDB Versions

### Step-by-Step Guide

#### 1. Prepare Binary Files

Download MariaDB binaries from official source:
```bash
# Example: MariaDB 12.1.0
# Download from https://mariadb.org/download/
```

#### 2. Create Version Directory

```bash
mkdir -p bin/mariadb12.1.0
```

#### 3. Add Binary Files

Copy MariaDB files to `bin/mariadb12.1.0/`:
```
bin/mariadb12.1.0/
├── bin/
│   ├── mysqld.exe
│   ├── mysql.exe
│   ├── mysqladmin.exe
│   └── ...
├── lib/
├── share/
└── ...
```

#### 4. Create bearsampp.conf

Create `bin/mariadb12.1.0/bearsampp.conf`:
```ini
mariadbVersion = "12.1.0"
mariadbExe = "bin/mysqld.exe"
mariadbCliExe = "bin/mysql.exe"
mariadbAdmin = "bin/mysqladmin.exe"
mariadbConf = "my.ini"
mariadbPort = "3307"
mariadbRootUser = "root"
mariadbRootPwd = ""

bundleRelease = "@RELEASE_VERSION@"
```

#### 5. Update releases.properties

Add entry to `releases.properties`:
```properties
12.1.0 = https://github.com/Bearsampp/module-mariadb/releases/download/2025.9.1/bearsampp-mariadb-12.1.0-2025.9.1.7z
```

#### 6. Update build.properties

Update release version:
```properties
bundle.release = 2025.9.1
```

#### 7. Validate and Build

```bash
# Validate configuration
./gradlew validate

# List versions (should include 12.1.0)
./gradlew listVersions

# Build
./gradlew clean build
```

#### 8. Test

```bash
# Extract and verify
7z x C:/Bearsampp-build/bearsampp-mariadb-2025.9.1.7z -otest
cd test/module-mariadb/bin/mariadb12.1.0

# Check configuration
cat bearsampp.conf
# Verify bundleRelease = "2025.9.1" (not @RELEASE_VERSION@)
```

#### 9. Commit

```bash
git add bin/mariadb12.1.0/
git add releases.properties
git add build.properties
git commit -m "Add: Support for MariaDB 12.1.0"
```

#### 10. Create Pull Request

Follow [Submitting Changes](#submitting-changes) section.

## Questions?

- **Documentation**: Check `.gradle-docs/` directory
- **Issues**: Search [existing issues](https://github.com/bearsampp/bearsampp/issues)
- **Discussion**: Open a [discussion](https://github.com/bearsampp/bearsampp/discussions)
- **Email**: Contact maintainers (see README)

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to Bearsampp! 🐻
