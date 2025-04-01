# MSTG Automation – iOS Focused

This directory contains automated checks for the OWASP Mobile Security Testing Guide (MSTG), starting with the MASVS-STORAGE category.

## 🧠 Structure

```
mstg/
├── static/
│   └── masvs-storage/
│       ├── mstg-storage-1.rb       # Static check for MSTG-STORAGE-1
│       ├── keywords.txt            # Regex and keyword patterns used by the scripts
├── dynamic/
│   └── masvs-storage/              # Future dynamic runtime checks
├── common/
│   └── ios_utils.rb                # Shared utility methods for iOS analysis
├── reports/
│   ├── report-*.json               # Individual test JSON reports
│   ├── report-*.md                 # Individual test Markdown reports
│   ├── logs/                       # Timestamped logs from the runner
│   └── combined-report-*.json     # Merged report from multiple runs
├── mstg_runner.rb                 # CLI runner to execute all static tests
```

## 🎯 Goals

- Automate validation of MSTG controls for iOS apps (starting with static analysis)
- Designed for both real devices and simulators
- Works with extracted IPA files or already-installed apps
- CLI-first with future Web UI potential
- Written in Ruby, because elegance matters

## ✅ Current Checks

**`MSTG-STORAGE-1:`** _Verify that no sensitive data is stored unprotected_
→ See: `static/masvs-storage/mstg-storage-1.rb`

## 🚀 Usage

### Run individual check manually:
```bash
ruby mstg/static/masvs-storage/mstg-storage-1.rb /path/to/Payload/AppName.app
```

### Run all tests using the runner:
```bash
ruby mstg/mstg_runner.rb /path/to/Payload/AppName.app
```

### Run from Rake task:
```bash
rake mstg:run[/path/to/Payload/AppName.app]
```

### Combine all previous JSON reports:
```bash
rake mstg:combine_reports
```

---

> This project is built piece by piece, one test at a time. Because real security takes real care. ☕⚔️

