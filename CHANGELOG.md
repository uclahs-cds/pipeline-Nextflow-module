# Changelog
All notable changes to pipeline-Nextflow-module.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]
### Added
- Add `indexFile` module to return index file path
- Add intermediate file/directory removal module
- Add genome interval extraction module
- Add PipeVal validation module
- Add index file module
- Add standardized filename generation module
- Add exposed string sanitization function
- Add options to handle compressed files with VCF indexing workflow
- Add `bgzip` to `index_VCF_tabix` module
- Add PipeVal generate-checksum module
- Add SAMtools convert CRAM to BAM

### Changed
- Use `ghcr.io/uclahs-cds` as default registry
- Initial pipeline set up
- Update log output directory for intermediate file removal
- File deletion module: add disk usage monitoring before and after deletion
- PipeVal module: nested log directories
- Update PipeVal to v4.0.0-rc.2
