@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Gradle Conversion Verification
echo ========================================
echo.

set ERROR_COUNT=0

echo Checking build files...
echo.

REM Check Gradle build files
call :check_file "build.gradle.kts" "Main Gradle build script"
call :check_file "settings.gradle.kts" "Gradle settings"
call :check_file "gradlew" "Gradle wrapper (Unix)"
call :check_file "gradlew.bat" "Gradle wrapper (Windows)"
call :check_file "gradle\wrapper\gradle-wrapper.properties" "Gradle wrapper properties"

echo.
echo Checking documentation files...
echo.

REM Check documentation
call :check_file ".gradle-docs\README.md" "Main documentation"
call :check_file ".gradle-docs\TASKS.md" "Task reference"
call :check_file ".gradle-docs\CONFIGURATION.md" "Configuration guide"
call :check_file ".gradle-docs\MIGRATION.md" "Migration guide"
call :check_file ".gradle-docs\SUMMARY.md" "Conversion summary"
call :check_file ".gradle-docs\QUICK-REFERENCE.md" "Quick reference"
call :check_file ".gradle-docs\INDEX.md" "Documentation index"
call :check_file "CHANGELOG.md" "Changelog"
call :check_file "CONTRIBUTING.md" "Contributing guide"

echo.
echo Checking CI/CD files...
echo.

REM Check CI/CD
call :check_file ".github\workflows\build.yml" "GitHub Actions workflow"
call :check_file ".github\markdown-link-check-config.json" "Link checker config"

echo.
echo Checking preserved files...
echo.

REM Check preserved files
call :check_file "build.properties" "Build properties"
call :check_file "releases.properties" "Release properties"
call :check_file "README.md" "Main README"
call :check_file "LICENSE" "License file"
call :check_file ".editorconfig" "Editor config"
call :check_file ".gitignore" "Git ignore"

echo.
echo Checking for old Ant files...
echo.

REM Check for Ant files (should not exist)
if exist "build.xml" (
    echo [WARNING] build.xml found - should be removed
    set /a ERROR_COUNT+=1
) else (
    echo [OK] build.xml not found ^(good^)
)

if exist "build-commons.xml" (
    echo [WARNING] build-commons.xml found - should be removed
    set /a ERROR_COUNT+=1
) else (
    echo [OK] build-commons.xml not found ^(good^)
)

if exist "build-properties.xml" (
    echo [WARNING] build-properties.xml found - should be removed
    set /a ERROR_COUNT+=1
) else (
    echo [OK] build-properties.xml not found ^(good^)
)

echo.
echo Checking Gradle wrapper JAR...
echo.

if exist "gradle\wrapper\gradle-wrapper.jar" (
    echo [OK] gradle-wrapper.jar found
) else (
    echo [WARNING] gradle-wrapper.jar not found
    echo          Run: gradle wrapper --gradle-version 8.5
    echo          Or download from: https://github.com/gradle/gradle/raw/master/gradle/wrapper/gradle-wrapper.jar
    set /a ERROR_COUNT+=1
)

echo.
echo Checking Java installation...
echo.

java -version >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Java found
    java -version 2>&1 | findstr /C:"version"
) else (
    echo [ERROR] Java not found
    echo         Install Java 17+ and set JAVA_HOME
    set /a ERROR_COUNT+=1
)

echo.
echo Checking 7-Zip installation...
echo.

7z --help >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] 7-Zip found
) else (
    echo [WARNING] 7-Zip not found in PATH
    echo           Install 7-Zip and add to PATH
    set /a ERROR_COUNT+=1
)

echo.
echo ========================================
echo Verification Summary
echo ========================================
echo.

if %ERROR_COUNT% EQU 0 (
    echo [SUCCESS] All checks passed!
    echo.
    echo Next steps:
    echo   1. Initialize Gradle wrapper JAR ^(if needed^):
    echo      gradle wrapper --gradle-version 8.5
    echo.
    echo   2. Remove Ant files ^(if they exist^):
    echo      del build.xml
    echo      del build-commons.xml
    echo      del build-properties.xml
    echo.
    echo   3. Test build:
    echo      gradlew validate
    echo      gradlew clean build
    echo.
    echo   4. Commit changes:
    echo      git add .
    echo      git commit -m "Convert to Gradle build system"
    echo.
    exit /b 0
) else (
    echo [FAILED] %ERROR_COUNT% issue^(s^) found
    echo.
    echo Please fix the issues above and run this script again.
    echo.
    exit /b 1
)

:check_file
if exist "%~1" (
    echo [OK] %~2
) else (
    echo [ERROR] %~2 not found: %~1
    set /a ERROR_COUNT+=1
)
goto :eof
