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
- Add `run_validate_PipeVal_with_metadata` method
- Add SAMtools module to create index files from alignment files

### Changed
- Use `ghcr.io/uclahs-cds` as default registry
- Initial pipeline set up
- Update log output directory for intermediate file removal
- File deletion module: add disk usage monitoring before and after deletion
- PipeVal module: nested log directories
- Update PipeVal to v4.0.0-rc.2
- Set `ext.capture_logs` to false for all processes to disable new `setup_process_afterscript()` behavior.
- Change PipeVal command since the interface was changed.
- Change indexFile to support cram format type
- Set `ext.capture_logs` to false for `index_VCF_tabix` processes

### Fixed
- Fix default log_output_dir in `run_index_SAMtools`
