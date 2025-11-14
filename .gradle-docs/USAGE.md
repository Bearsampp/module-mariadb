# Gradle Build Usage Guide

## Available Tasks

### 1. List Versions
```bash
gradle listVersions
```

**Output:**
```
Available MariaDB versions in bin/:

  • MariaDB 10.11.13 (bin/mariadb10.11.13/)
  • MariaDB 10.11.14 (bin/mariadb10.11.14/)
  • MariaDB 10.6.22 (bin/mariadb10.6.22/)
  • MariaDB 10.6.23 (bin/mariadb10.6.23/)
  • MariaDB 11.4.7 (bin/mariadb11.4.7/)
  • MariaDB 11.4.8 (bin/mariadb11.4.8/)
  • MariaDB 11.8.2 (bin/mariadb11.8.2/)
  • MariaDB 11.8.3 (bin/mariadb11.8.3/)
  • MariaDB 12.0.2 (bin/mariadb12.0.2/)

Total: 9 version(s)
```

### 2. Release (Interactive)
```bash
gradle release
```

**Interactive Prompt:**
```
╔════════════════════════════════════════════════════════════════════════════╗
║                    MariaDB Module Release Builder                          ║
║                         Release: 2025.8.21                                 ║
╚════════════════════════════════════════════════════════════════════════════╝

Available MariaDB versions:

  1. MariaDB 10.11.13 (bin/mariadb10.11.13/)
  2. MariaDB 10.11.14 (bin/mariadb10.11.14/)
  3. MariaDB 10.6.22 (bin/mariadb10.6.22/)
  4. MariaDB 10.6.23 (bin/mariadb10.6.23/)
  5. MariaDB 11.4.7 (bin/mariadb11.4.7/)
  6. MariaDB 11.4.8 (bin/mariadb11.4.8/)
  7. MariaDB 11.8.2 (bin/mariadb11.8.2/)
  8. MariaDB 11.8.3 (bin/mariadb11.8.3/)
  9. MariaDB 12.0.2 (bin/mariadb12.0.2/)

  0. All versions

Select version(s) (comma-separated numbers, e.g., 1,3,5 or 0 for all): _
```

**Examples:**
- Select single version: Enter `9` (for MariaDB 12.0.2)
- Select multiple versions: Enter `8,9` (for MariaDB 11.8.3 and 12.0.2)
- Select all versions: Enter `0`

**Output for each version:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Processing MariaDB 12.0.2
━━━━━━━━���━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Source: bin/mariadb12.0.2/
  Copying files...
  ✓ Processed: bearsampp.conf
  Creating archive...
  ✓ Created: bearsampp-mariadb-12.0.2-2025.8.21.7z
  ✓ Size: 245.32 MB
  ✓ Location: C:/Bearsampp-build/bearsampp-mariadb-12.0.2-2025.8.21.7z
```

**Final Summary:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Release Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Successful: 1
  Output directory: C:/Bearsampp-build
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 3. Build All (Non-Interactive)
```bash
gradle build
```

Builds **all** MariaDB versions without prompting. Use with caution if you have many versions.

**Output:**
```
╔════════════════════════════════════════════════════════════════════════════╗
║                    MariaDB Module Build All Versions                       ║
║                         Release: 2025.8.21                                 ║
╚════════════════════════════════════════════════════════════════════════════╝

Building 9 version(s): 10.11.13, 10.11.14, 10.6.22, 10.6.23, 11.4.7, 11.4.8, 11.8.2, 11.8.3, 12.0.2

[Processes each version...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Build Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ✓ Successful: 9
  Output directory: C:/Bearsampp-build
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. Validate
```bash
gradle validate
```

Validates all MariaDB configuration files.

**Output:**
```
Validating MariaDB module configuration...

  ✓ Found 9 MariaDB version(s)
  ✓ bin/mariadb10.11.13/bearsampp.conf
  ✓ bin/mariadb10.11.14/bearsampp.conf
  ✓ bin/mariadb10.6.22/bearsampp.conf
  ✓ bin/mariadb10.6.23/bearsampp.conf
  ✓ bin/mariadb11.4.7/bearsampp.conf
  ✓ bin/mariadb11.4.8/bearsampp.conf
  ✓ bin/mariadb11.8.2/bearsampp.conf
  ✓ bin/mariadb11.8.3/bearsampp.conf
  ✓ bin/mariadb12.0.2/bearsampp.conf

✓ All configuration files are valid
```

### 5. Clean
```bash
gradle clean
```

Removes the build directory.

## Task Comparison

| Task            | Interactive | Builds          | Use Case                           |
|-----------------|-------------|-----------------|-------------------------------------|
| `listVersions`  | No          | Nothing         | View available versions             |
| `release`       | **Yes**     | Selected        | Build specific version(s)           |
| `build`         | No          | All versions    | Build everything (CI/CD)            |
| `validate`      | No          | Nothing         | Check configuration files           |
| `clean`         | No          | Nothing         | Clean build directory               |

## Workflow Examples

### Example 1: Build Latest Version
```bash
# List versions to see what's available
gradle listVersions

# Run interactive release
gradle release

# Select the latest version (e.g., 9 for 12.0.2)
# Enter: 9
```

### Example 2: Build Multiple Specific Versions
```bash
# Run interactive release
gradle release

# Select multiple versions
# Enter: 8,9
# This builds MariaDB 11.8.3 and 12.0.2
```

### Example 3: Build All Versions for Release
```bash
# Validate first
gradle validate

# Build all
gradle build
```

### Example 4: Clean and Rebuild
```bash
# Clean previous builds
gradle clean

# Build specific version
gradle release
# Select version when prompted
```

## Output Files

Archives are created in the build directory (default: `C:/Bearsampp-build/`):

```
C:/Bearsampp-build/
├── bearsampp-mariadb-10.11.13-2025.8.21.7z
├── bearsampp-mariadb-10.11.14-2025.8.21.7z
├── bearsampp-mariadb-10.6.22-2025.8.21.7z
├── bearsampp-mariadb-10.6.23-2025.8.21.7z
├── bearsampp-mariadb-11.4.7-2025.8.21.7z
├── bearsampp-mariadb-11.4.8-2025.8.21.7z
├── bearsampp-mariadb-11.8.2-2025.8.21.7z
├── bearsampp-mariadb-11.8.3-2025.8.21.7z
└── bearsampp-mariadb-12.0.2-2025.8.21.7z
```

## Configuration

### Change Build Directory

**Option 1: Environment Variable**
```bash
set BEARSAMPP_BUILD_PATH=D:/MyBuilds
gradle release
```

**Option 2: Edit build.properties**
```properties
build.path = D:/MyBuilds
```

### Change Archive Format

Edit `build.properties`:
```properties
bundle.format = zip  # or 7z
```

## Troubleshooting

### Issue: No versions listed
**Cause**: No `mariadbX.X.X` directories in `bin/`

**Solution**: Ensure MariaDB versions are in `bin/mariadb{version}/` format

### Issue: Interactive prompt not working
**Cause**: Running in non-interactive environment (CI/CD)

**Solution**: Use `gradle build` instead (builds all versions)

### Issue: 7z command not found
**Cause**: 7-Zip not in PATH

**Solution**: 
- Install 7-Zip
- Add to PATH: `C:\Program Files\7-Zip`

### Issue: Archive creation fails
**Cause**: Insufficient disk space or permissions

**Solution**:
- Check disk space
- Run as Administrator
- Change build path to writable location

## Key Features

✓ **Interactive version selection** - Choose which versions to build
✓ **Shows directory paths** - Clear indication of source directories
✓ **Progress indicators** - Visual feedback during build
✓ **Detailed output** - File sizes, locations, and status
✓ **Error handling** - Clear error messages
✓ **Multiple selection** - Build several versions at once
✓ **Build all option** - Quick way to build everything
✓ **Validation** - Check configurations before building

## Comparison with Other Modules

This build system follows the same pattern as:
- `module-apache`
- `module-bruno`
- `module-git`

All use:
- Interactive `gradle release` task
- Non-interactive `gradle build` task
- Same output format and structure
- Same directory naming conventions
