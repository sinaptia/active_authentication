# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- CHANGELOG.md :P
- The timeoutable concern.
- The omniauthable concern.

### Changed

- Install generator now accepts which concerns are enabled. If no concern is given, all concerns are enabled.
- The timeoutable concern is turned off by default.
- Added `ActiveAuthentication::Controller::Authenticatable` to make it consistent with the other concerns.
- Refactored engine initializers.

### Fixed

- Lockable concern raised `NoMethodError` on `sessions#create` because it didn't check the user existed before calling `#locked?`
- Install generator now makes sure that the adapter is found correctly.
- `ActiveAuthentication::Controller::Lockable`, `ActiveAuthentication::Controller::Timeoutable` and `ActiveAuthentication::Controller::Trackable` had methods defined within the `included` block.
- Omniauthable module autoloading had a typo
