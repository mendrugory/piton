# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0] - 2025-11-08

### Added
- Support for Elixir 1.19.x
- Support for Erlang/OTP 27
- GitHub Actions workflow for automatic publishing to Hex.pm on release
- `.tool-versions` file for asdf version management
- CHANGELOG.md file

### Changed
- Updated minimum Elixir version requirement to ~> 1.7 (now supports up to 1.19)
- Updated dependency versions:
  - `earmark` to ~> 1.4
  - `ex_doc` to ~> 0.31
  - `poison` to ~> 5.0
- Updated README with requirements section

### Fixed
- Compatibility with modern Elixir versions

## [0.4.0] - Previous Release

### Initial Release
- Basic Piton.Port functionality
- Piton.Pool for parallel Python execution
- Mix tasks for Python environment management

