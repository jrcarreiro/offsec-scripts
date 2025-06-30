# offsec-scripts

[![Made with Ruby](https://img.shields.io/badge/made%20with-ruby-red?style=flat-square&logo=ruby)](https://www.ruby-lang.org)
[![Made with Swift](https://img.shields.io/badge/made%20with-swift-orange?style=flat-square&logo=swift)](https://developer.apple.com/swift/)
[![macOS Compatible](https://img.shields.io/badge/macOS-compatible-brightgreen?style=flat-square&logo=apple)](https://www.apple.com/macos)
[![MIT License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Hacker Friendly](https://img.shields.io/badge/hacker-friendly-black?style=flat-square&logo=protonmail)](https://github.com/jrcarreiro)

---

### 💻 About this repository

Welcome to `offsec-scripts`, a personal collection of Ruby and Swift-powered scripts designed to streamline my daily workflow as an offensive security professional.

Here you'll find tools, automations, and utilities that help me solve real-world problems, speed up repetitive tasks, and avoid the rabbit holes of manual setup. These scripts range from plugin installers and system tweaks to mobile tooling and reverse engineering helpers — all crafted with care, clarity, and just the right amount of 🔥.

This repo isn't meant to be a polished product — it's a living toolbox that grows as I break, fix, and automate things.

---

## New Script Added: APKEnum (Ruby Version)

**APKEnum.rb** is a refactored and improved version of the original APKEnum tool, now written in Ruby to fit this repository’s language focus. This script automates APK reconnaissance and reverse engineering, extracting URLs, S3 buckets, public IPs, and Google Maps API keys from decompiled APK files.

**Key Features:**
- Modular, object-oriented Ruby design
- Robust error handling
- Skips binary files to avoid encoding errors
- Scope filtering support
- JSON output for easy integration

**Usage:**
```bash
ruby Ruby/APKEnum.rb -p /path/to/app.apk [-s keyword1,keyword2]
```

**What it does:**  
- Decompiles APKs using apktool
- Scans only text-based files in the decompiled output
- Extracts reconnaissance data relevant to mobile security assessments

### 📂 Structure

Scripts are now organized by language for clarity and maintainability:

```
├── Ruby/
│   ├── APKEnum.rb           # APK reconnaissance and enumeration tool (NEW)
│   ├── Gemfile
│   ├── Gemfile.lock
│   ├── Rakefile
│   ├── tasks/
│   │   └── radare2.rake
│   └── install_r2lldb.rb
├── Swift/
│   └── ipa_dump.swift
└── README.md
```

### 🚀 Quick start

**Ruby:**
```bash
# Run the APKEnum script
ruby Ruby/APKEnum.rb -p /path/to/app.apk [-s keyword1,keyword2]

# Or run other Ruby scripts/tasks as before
bundle install
bundle exec rake radare2:r2lldb:install
ruby Ruby/install_r2lldb.rb
```

**Swift:**
```bash
chmod +x Swift/ipa_dump.swift
./Swift/ipa_dump.swift /path/to/App.ipa
```

Feel free to further adjust the README to match your voice or add more technical details as needed!

Sources
[1] GitHub - jrcarreiro/offsec-scripts https://github.com/jrcarreiro/offsec-scripts


---

### 🤝 Contributions

This is a personal repo, but PRs, ideas, or improvements are always welcome — especially if you speak the language of elegant scripts and useful hacks 😄

---

### 🧨 License

MIT — because good tools should be free to use and share.

---

Crafted with focus, caffeine, and a little bit of controlled chaos ☕⚔️

> "Automate the boring. Script the chaos. Hack the planet."
