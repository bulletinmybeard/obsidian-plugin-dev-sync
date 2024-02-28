# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-02-28

### Added
- Bash script for synchronizing Obsidian plugin development projects with Obsidian vaults, facilitating real-time testing and development across different devices.
- Support for Linux and macOS, including compatibility with iCloud vaults for mobile device testing.
- Automatic detection and synchronization of essential plugin files (`main.js`, `manifest.json`) and other specified files and directories (`styles.css`, `data.json`, `assets`, `cache`) using `rsync` and `fswatch`.
- Script functionality to resolve absolute paths, check file existence, and create necessary directories for plugin synchronization.
- Continuous monitoring of specified files and directories for changes, with immediate synchronization to the target directory for seamless development experience.
- Initial setup instructions and usage guidelines in README to assist users in starting with the script.
- Implemented checks to ensure that essential plugin files exist before attempting synchronization to prevent potential sync issues.
