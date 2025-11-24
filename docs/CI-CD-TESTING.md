# MariaDB Module CI/CD Testing

## Overview

This document describes the automated testing workflow for the Bearsampp MariaDB module. The CI/CD pipeline ensures that MariaDB builds are properly packaged, can be extracted, and that all executables are functional.

## Workflow Triggers

The MariaDB testing workflow is triggered automatically on:

- **Pull Request Events**: When a PR is opened, synchronized (new commits pushed), reopened, or edited
  - Target branches: `main`
- **Manual Workflow Dispatch**: Can be triggered manually with options to test specific versions

## Test Scope

The workflow intelligently determines which versions to test based on the context using a **2-tier smart detection system**:

### Pull Request Testing - Smart Detection

The workflow uses a cascading detection strategy to identify which versions to test:

#### 🔍 PRIMARY METHOD: /bin Directory Detection
- **Automatically detects** which MariaDB versions are included in the PR from changed files in `/bin` directory
- **Extracts version numbers** from directory names (e.g., `bin/mariadb11.8.3/` → `11.8.3`)
- **Validates versions** against `releases.properties` for consistency
- **Includes new versions** even if not yet in `releases.properties` (if directory exists in `/bin`)
- **Most efficient**: Tests only the versions you're actually adding/modifying

#### 📋 FALLBACK METHOD: PR Title Extraction
- **Activates when**: No changes detected in `/bin` directory
- **Extracts version numbers** from PR title (e.g., "Update MariaDB 11.4.8")
- **Supports formats**: `11.4.8`, `10.11.14`, `11.1.1-RC`
- **Validates versions** exist in `releases.properties`
- **Useful for**: Documentation updates or non-code changes that reference specific versions

#### 🔄 FINAL FALLBACK: Latest 5 Versions
- **Activates when**: No versions detected by either of the above methods
- **Tests latest 5 versions** from `releases.properties`
- **Ensures coverage**: Prevents PRs from skipping tests entirely
- **Safety net**: Catches potential regressions in recent versions

### Manual Testing
- **Latest 5 Versions**: Tests the 5 most recent versions from `releases.properties`
- **Specific Version**: Tests a single version provided as input parameter
- **Flexibility**: Useful for re-testing or validating specific versions

### Example Scenarios

#### Scenario 1: Pre-release Workflow (Most Common)
```
1. New versions created and added to pre-release (tagged with date, e.g., "2025.11.23")
2. Version directories created in /bin (e.g., bin/mariadb11.8.3/, bin/mariadb12.0.2/)
3. releases.properties updated via workflow
4. PR created from release branch (e.g., "November") to main
5. ✅ Workflow detects: bin/mariadb11.8.3/ and bin/mariadb12.0.2/
6. Tests run against: 11.8.3 and 12.0.2 only
```

#### Scenario 2: Documentation Update with Version Reference
```
1. Update README.md mentioning "MariaDB 11.4.8"
2. Create PR with title: "Update docs for MariaDB 11.4.8"
3. ✅ Workflow detects: Version 11.4.8 in PR title
4. Tests run against: 11.4.8 only
```

#### Scenario 3: General Changes (Fallback)
```
1. Update build scripts or CI configuration
2. Create PR to main
3. ✅ Workflow detects: No specific versions
4. Tests run against: Latest 5 versions (safety check)
```

### Detection Method Reporting

The workflow reports which detection method was used in PR comments:
- 📦 **Detected from `/bin` directory changes** - Primary method
- 📋 **Extracted from PR title** - Fallback method
- 🔄 **Testing latest 5 versions (fallback)** - Final fallback
- 🖱️ **Manual workflow dispatch** - Manual trigger

## Test Phases

### Phase 1: Installation Validation

**Purpose**: Verify the MariaDB package can be downloaded and extracted correctly.

**Steps**:
1. **Download MariaDB** (Phase 1.1)
   - Reads the download URL from `releases.properties`
   - Downloads the `.7z` archive from GitHub releases
   - Reports download size and success status
   - Validates file size (must be > 0.1 MB)

2. **Extract Archive** (Phase 1.1)
   - Extracts the `.7z` file using 7-Zip
   - Locates the `mariadb*` subfolder
   - Validates the directory structure
   - Verifies `bin` directory exists

3. **Verify Executables** (Phase 1.2)
   - Checks for required MariaDB executables:
     - `mariadbd.exe` - MariaDB server daemon
     - `mariadb.exe` - MariaDB command-line client
     - `mariadb-admin.exe` - MariaDB administration utility
     - `mariadb-dump.exe` - MariaDB backup utility
   - Retrieves and displays MariaDB version
   - Saves verification results to JSON

### Phase 2: Basic Functionality

**Purpose**: Verify MariaDB executables can run and display version information.

**Steps**:
1. **Test Executable Versions** (Phase 2)
   - Runs `mariadbd.exe --version` to verify server executable
   - Runs `mariadb.exe --version` to verify client executable
   - Runs `mariadb-admin.exe --version` to verify admin utility
   - Validates all executables return successfully
   - Displays version output for verification

## Test Results

### Artifacts

The workflow generates and uploads the following artifacts:

1. **Test Results** (`test-results-mariadb-VERSION`)
   - `verify.json` - Executable verification results
   - `summary.md` - Human-readable test summary
   - Retention: 30 days

### PR Comments

For pull requests, the workflow automatically posts a comment with:
- Test date and time (UTC)
- Summary for each tested version
- Pass/fail status for each phase
- Overall test status
- Troubleshooting tips for failures
- Links to detailed artifacts

The comment is updated if it already exists (no duplicate comments).

### Test Summary Format

Each version's summary includes:

```
### MariaDB X.Y.Z

**Phase 1: Installation Validation**
- Download & Extract: ✅ PASS / ❌ FAIL
- Verify Executables: ✅ PASS / ❌ FAIL

**Phase 2: Basic Functionality**
- Test Executables: ✅ PASS / ❌ FAIL

**Overall Status:** ✅ ALL TESTS PASSED / ❌ SOME TESTS FAILED
```

If tests fail, additional troubleshooting information is provided:
- Specific error messages
- Collapsible troubleshooting tips
- Links to workflow logs
- References to test artifacts

## Error Handling

The workflow provides comprehensive error reporting at multiple levels:

### Detailed Error Messages

Each phase captures and reports specific error information:

- **Download failures**: 
  - HTTP status codes and error messages
  - Attempted URLs
  - File size validation errors
  
- **Extraction failures**: 
  - 7-Zip exit codes and output logs
  - Directory listings showing actual structure
  - Expected vs. actual directory patterns
  
- **Missing files**: 
  - List of expected executables
  - Actual directory contents
  - Specific missing files highlighted
  
- **Execution failures**: 
  - Command output and error messages
  - Exit codes
  - Version information (if available)

### Error Propagation

- Each phase uses `continue-on-error: true` to allow subsequent phases to run
- Failed phases are clearly marked in the summary with ❌ indicators
- Error messages are included inline in test summaries
- All test results are uploaded regardless of success/failure
- Overall workflow status reflects any failures

### Troubleshooting Assistance

When tests fail, the summary includes:
- Specific error messages for each failed phase
- Collapsible troubleshooting tips section with:
  - Links to detailed workflow logs
  - Instructions to download test artifacts
  - Common issues and solutions
  - Archive structure validation tips
  - DLL dependency checks

## Platform

- **Runner**: `windows-latest`
- **Reason**: MariaDB builds are Windows executables (.exe)
- **Tools**: Native Windows PowerShell, 7-Zip (pre-installed)
- **OS**: Windows Server (latest GitHub Actions runner)

## Matrix Strategy

- **Parallel Execution**: Tests run in parallel for different versions
- **Fail-Fast**: Disabled (`fail-fast: false`) to test all versions even if one fails
- **Dynamic Matrix**: Version list is generated dynamically based on trigger context
- **Resource Efficiency**: Only tests relevant versions to minimize CI time

## Workflow File Location

`.github/workflows/mariadb-test.yml`

## Maintenance

### Adding New Test Cases

To add new functionality tests:

1. Add a new step after Phase 2
2. Use `continue-on-error: true` to prevent blocking other tests
3. Check previous phase success with `if: steps.PREVIOUS_STEP.outputs.success == 'true'`
4. Set output variable: `echo "success=true/false" >> $env:GITHUB_OUTPUT`
5. Update the test summary generation to include the new phase
6. Document the new phase in this file

### Modifying Version Selection

To change which versions are tested, edit the `Get MariaDB Versions` step:

```bash
# Current: Latest 5 versions
VERSIONS=$(... | head -5 | ...)

# Example: Latest 3 versions
VERSIONS=$(... | head -3 | ...)

# Example: Latest 10 versions
VERSIONS=$(... | head -10 | ...)
```

### Adjusting Test Parameters

Key parameters that can be adjusted:

- **Download timeout**: `TimeoutSec 300` (5 minutes) in Phase 1.1
- **Minimum file size**: `0.1 MB` validation in Phase 1.1
- **Artifact retention**: `retention-days: 30` in Upload Test Results step

### Adding New Executables to Verify

To verify additional MariaDB executables:

1. Edit Phase 1.2 in the workflow file
2. Add the executable name to the `$requiredExes` array:
   ```powershell
   $requiredExes = @("mariadbd.exe", "mariadb.exe", "mariadb-admin.exe", "mariadb-dump.exe", "NEW_EXE.exe")
   ```
3. Optionally add version test in Phase 2

## Troubleshooting

### Common Issues

1. **Download Failures**
   - **Symptom**: Phase 1.1 fails with download error
   - **Causes**:
     - Invalid URL in `releases.properties`
     - GitHub release not published or deleted
     - Network connectivity issues
     - Rate limiting from GitHub
   - **Solutions**:
     - Verify the release URL is accessible in a browser
     - Check GitHub releases page for the module
     - Ensure the version number matches exactly
     - Wait and retry if rate limited

2. **Extraction Failures**
   - **Symptom**: Phase 1.1 fails after successful download
   - **Causes**:
     - Corrupted `.7z` file
     - Incorrect archive structure
     - Insufficient disk space
   - **Solutions**:
     - Re-download and re-upload the release
     - Verify archive structure locally before uploading
     - Check that archive contains `mariadb*` directory with `bin` subdirectory

3. **Missing Executables**
   - **Symptom**: Phase 1.2 fails with missing files
   - **Causes**:
     - Incomplete MariaDB build
     - Wrong directory structure in archive
     - Missing DLL dependencies
   - **Solutions**:
     - Verify all required executables are in the `bin` directory
     - Check that the build is complete and not a partial package
     - Ensure all dependencies are included in the archive

4. **Version Command Failures**
   - **Symptom**: Phase 2 fails when running version commands
   - **Causes**:
     - Missing DLL dependencies
     - Corrupted executables
     - Incompatible Windows version
   - **Solutions**:
     - Include all required DLLs in the archive
     - Test the build locally on Windows
     - Check for Visual C++ runtime dependencies

### Debugging Steps

To debug a specific version failure:

1. **Check Workflow Logs**
   - Navigate to the failed workflow run in GitHub Actions
   - Expand the failed step to see detailed output
   - Look for specific error messages

2. **Download Artifacts**
   - Download the `test-results-mariadb-VERSION` artifact
   - Review `verify.json` for executable validation details
   - Check `summary.md` for formatted results

3. **Local Testing**
   - Download the same `.7z` file from releases
   - Extract it locally on Windows
   - Try running the executables manually
   - Check for missing DLL errors

4. **Compare with Working Versions**
   - Compare directory structure with a passing version
   - Check file sizes and contents
   - Verify all dependencies are present

### Manual Workflow Testing

To manually test a specific version:

1. Go to the Actions tab in GitHub
2. Select "MariaDB Module Tests" workflow
3. Click "Run workflow"
4. Choose "Specific version" from the dropdown
5. Enter the version number (e.g., "11.4.8")
6. Click "Run workflow"
7. Monitor the test results

## Best Practices

1. **Always test before merging**: The workflow runs on PRs to catch issues early
2. **Review test summaries**: Check PR comments for test results before merging
3. **Investigate failures**: Don't merge if tests fail without understanding why
4. **Keep versions updated**: Regularly update `releases.properties` with new MariaDB versions
5. **Monitor artifact storage**: Old artifacts are automatically cleaned up after retention period
6. **Test locally first**: Before creating a PR, test the MariaDB build locally on Windows
7. **Document changes**: Update this documentation when modifying the workflow
8. **Version consistency**: Ensure version numbers in filenames match `releases.properties`

## Version Naming Conventions

MariaDB versions in `releases.properties` should follow these patterns:

- **Major.Minor.Patch**: `11.4.8`, `10.11.14`, `10.6.23`
- **Release Candidates**: `11.1.1-RC`, `11.2.1-RC`
- **Legacy versions**: `10.3.37`, `10.4.27`

The workflow supports all version formats and will test them accordingly.

## Workflow Outputs

### Success Indicators

When all tests pass, you'll see:
- ✅ Green checkmark on the PR
- "All tests passed" status in PR comment
- All phases marked with ✅ PASS
- Artifacts uploaded successfully

### Failure Indicators

When tests fail, you'll see:
- ❌ Red X on the PR
- "Some tests failed" status in PR comment
- Failed phases marked with ❌ FAIL
- Error messages in the summary
- Troubleshooting tips displayed

## Related Documentation

- [MariaDB Official Documentation](https://mariadb.com/kb/en/documentation/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Bearsampp Project](https://github.com/Bearsampp)
- [Module MariaDB Repository](https://github.com/Bearsampp/module-mariadb)

## Changelog

### Version History

- **Initial Release**: Basic download and extraction testing
- **Current**: Two-phase testing with executable verification and version checks

### Future Enhancements

Potential improvements for future versions:

1. **Database Initialization Testing**: Add tests for `mariadbd --initialize`
2. **Server Startup Testing**: Test starting and stopping MariaDB server
3. **Connection Testing**: Verify client can connect to server
4. **Basic SQL Testing**: Execute simple SQL commands
5. **Performance Benchmarks**: Add basic performance metrics
6. **Security Checks**: Verify default security settings
7. **Compatibility Testing**: Test with different Windows versions

## Contributing to Tests

To contribute improvements to the testing workflow:

1. Fork the repository
2. Create a feature branch
3. Modify `.github/workflows/mariadb-test.yml`
4. Update this documentation
5. Test your changes with manual workflow dispatch
6. Submit a pull request with:
   - Description of changes
   - Rationale for improvements
   - Test results showing the changes work

## Support and Contact

For questions or issues with the CI/CD workflow:

- **GitHub Issues**: [Open an issue](https://github.com/Bearsampp/module-mariadb/issues)
- **Discussions**: Use GitHub Discussions for questions
- **Pull Requests**: Submit improvements via PR

When reporting issues, please include:
- Version number being tested
- Link to failed workflow run
- Error messages from logs
- Steps to reproduce (if applicable)

## MariaDB-Specific Notes

### Executable Naming

MariaDB uses different executable names compared to MySQL:
- `mariadbd.exe` (MariaDB daemon) vs `mysqld.exe` (MySQL daemon)
- `mariadb.exe` (MariaDB client) vs `mysql.exe` (MySQL client)
- `mariadb-admin.exe` vs `mysqladmin.exe`
- `mariadb-dump.exe` vs `mysqldump.exe`

The workflow is configured to check for MariaDB-specific executables.

### Version Compatibility

MariaDB maintains compatibility with MySQL protocols but has its own versioning:
- **10.x series**: Long-term support versions (10.3, 10.4, 10.5, 10.6, 10.11)
- **11.x series**: Current stable versions (11.0, 11.1, 11.2, 11.4, 11.5, 11.6, 11.8)
- **12.x series**: Latest development versions

### Release Candidates

MariaDB releases include RC (Release Candidate) versions for testing:
- Format: `11.1.1-RC`, `11.2.1-RC`, `11.5.1-RC`
- These are pre-release versions for testing purposes
- The workflow handles RC versions correctly

## Testing Strategy

### Version Coverage

The workflow ensures comprehensive testing coverage:
- **Latest versions**: Always tested to catch regressions
- **LTS versions**: Long-term support versions are prioritized
- **RC versions**: Release candidates are tested for early feedback
- **Legacy versions**: Older versions are maintained for compatibility

### Test Reliability

The workflow is designed for reliability:
- **Retry logic**: Downloads can be retried on transient failures
- **Detailed logging**: Every step is logged for debugging
- **Artifact preservation**: Test results are kept for 30 days
- **Parallel execution**: Tests run in parallel for speed
- **Fail-safe**: One version failure doesn't block others

## Performance Considerations

### CI/CD Optimization

The workflow is optimized for performance:
- **Smart version detection**: Only tests changed versions
- **Parallel matrix**: Multiple versions tested simultaneously
- **Efficient downloads**: Uses direct GitHub release URLs
- **Minimal dependencies**: Uses pre-installed tools (7-Zip)
- **Artifact cleanup**: Automatic cleanup after retention period

### Resource Usage

Typical resource usage per test:
- **Download size**: 50-150 MB per version
- **Extraction space**: 200-500 MB per version
- **Test duration**: 2-5 minutes per version
- **Parallel jobs**: Up to 5 versions simultaneously
- **Total workflow time**: 5-10 minutes for typical PRs
