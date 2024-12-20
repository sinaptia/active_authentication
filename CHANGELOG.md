# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [UNRELEASED]

### Added

- Make the registration params and profile params configurable.
- Added `#active_authentication_controller?`. Useful if we want to use `#authenticate_user!` in the application controller but skip the before action if we're in an active_authentication controller.
- The magiclinkable concern.


### Fixed

- The shared links errored out when the magiclinkable concern wasn't included in the user.

## [0.3.0] - 2024-12-11

### Added

- Support for rails 8

## [0.2.0] - 2024-05-02

### Added

- This CHANGELOG.md :P
- The timeoutable concern.
- The omniauthable concern.

### Changed

- The install generator now accepts which concerns are enabled. If no concern is given, all concerns are enabled.
- The timeoutable concern is turned off by default.
- Added `ActiveAuthentication::Controller::Authenticatable` to make it consistent with the other concerns.
- Refactored engine initializers.

### Fixed

- Lockable concern raised `NoMethodError` on `sessions#create` because it didn't check the user existed before calling `#locked?`
- Install generator now makes sure that the adapter is found correctly.
- `ActiveAuthentication::Controller::Lockable`, `ActiveAuthentication::Controller::Timeoutable` and `ActiveAuthentication::Controller::Trackable` had methods defined within the `included` block.
- Omniauthable module autoloading had a typo
