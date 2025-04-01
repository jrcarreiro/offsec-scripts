
# offsec-scripts

[![Made with Ruby](https://img.shields.io/badge/made%20with-ruby-red?style=flat-square&logo=ruby)](https://www.ruby-lang.org)
[![macOS Compatible](https://img.shields.io/badge/macOS-compatible-brightgreen?style=flat-square&logo=apple)](https://www.apple.com/macos)
[![MIT License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Hacker Friendly](https://img.shields.io/badge/hacker-friendly-black?style=flat-square&logo=protonmail)](https://github.com/jrcarreiro)

---

### 💻 About this repository

Welcome to `offsec-scripts`, a personal collection of Ruby-powered scripts designed to streamline my daily workflow as an offensive security professional.

Here you'll find tools, automations, and utilities that help me solve real-world problems, speed up repetitive tasks, and avoid the rabbit holes of manual setup. These scripts range from plugin installers and system tweaks to mobile tooling and reverse engineering helpers — all crafted with care, clarity, and just the right amount of 🔥.

This repo isn't meant to be a polished product — it's a living toolbox that grows as I break, fix, and automate things.

### 📂 Structure

Scripts will be organized into two main folders:

```
.
├── Rakefile                 # Entry point for rake tasks
├── tasks/                   # Rake-based automations
│   └── radare2.rake         # Example: install r2lldb plugin via rake
├── scripts/                 # Pure Ruby CLI tools and utilities
│   └── install_r2lldb.rb    # Standalone Ruby script version
└── README.md
```

### 🧠 Highlights
- 💎 Pure Ruby (no Python here, sorry 😅)
- 🎯 Focused on practical, day-to-day use in red teaming & mobile hacking
- 🧰 Built to be reused, extended and improved

### 🚀 Quick start
```bash
# Run a task (example)
rake radare2:r2lldb:install

# Run a pure Ruby script
ruby scripts/install_r2lldb.rb
```

### 🤝 Contributions
This is a personal repo, but PRs, ideas, or improvements are always welcome — especially if you speak the language of elegant scripts and useful hacks 😄

### 🧨 License
MIT — because good tools should be free to use and share.

---

Crafted with focus, caffeine, and a little bit of controlled chaos ☕⚔️

> "Automate the boring. Script the chaos. Hack the planet."
