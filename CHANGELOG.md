# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]


<!-- ### Added -->
<!-- ### Changed -->
<!-- ### Removed -->

## [0.2.0] - 2021-01-19

### Added

- Allow using reserved words as attributes.


```ruby
Class.new do
  extend EzAttributes

  # This would break in 0.1.0.
  # Now it works.
  attributes :class, :if
end
```

## [0.1.0] - 2020-11-24

### Added

- Basic module to define class initializers with keyword args.

[unreleased]: https://github.com/MatheusRich/ez_attributes/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/MatheusRich/ez_attributes/releases/tag/v0.1.0