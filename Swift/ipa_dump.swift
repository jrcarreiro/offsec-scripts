#!/usr/bin/env swift

import Foundation

let arguments = CommandLine.arguments

guard arguments.count >= 2 else {
    print("Usage: \(arguments[0]) <path_to_ipa_file>")
    exit(1)
}

let ipaPath = arguments[1]

let fileManager = FileManager.default
guard fileManager.fileExists(atPath: ipaPath) else {
    print("[@] Error: IPA file not found!")
    exit(1)
}

let ipaURL = URL(fileURLWithPath: ipaPath)
let appName = ipaURL.deletingPathExtension().lastPathComponent
let resolvedPath = ipaURL.deletingLastPathComponent().standardizedFileURL.path
let outputDir = "\(resolvedPath)/\(appName)"

do {
    try fileManager.createDirectory(atPath: outputDir, withIntermediateDirectories: true)
    print("[*] Output directory created at: \(outputDir)")
} catch {
    print("[@] Failed to create output directory: \(error)")
    exit(1)
}

let unzipDir = "\(outputDir)/_extracted"

do {
    try fileManager.createDirectory(atPath: unzipDir, withIntermediateDirectories: true)
    print("[*] Extraction directory created at: \(unzipDir)")
} catch {
    print("[@] Failed to create extraction directory: \(error)")
    exit(1)
}

let unzipProcess = Process()
unzipProcess.executableURL = URL(fileURLWithPath: "/usr/bin/unzip")
unzipProcess.arguments = ["-q", ipaPath, "-d", unzipDir]

do {
    try unzipProcess.run()
    unzipProcess.waitUntilExit()
    if unzipProcess.terminationStatus != 0 {
        print("[@] Failed to unzip IPA.")
        exit(1)
    }
    print("[*] IPA extracted successfully.")
} catch {
    print("[@] Failed to execute unzip: \(error)")
    exit(1)
}

var appPath: String? = nil
if let enumerator = fileManager.enumerator(atPath: unzipDir) {
    for case let file as String in enumerator {
        if file.hasSuffix(".app") {
            print("[*] .app directory detected: \(file)")
            appPath = "\(unzipDir)/\(file)"
            break
        }
    }
}

guard let appPath = appPath else {
    print("[@] No .app directory found in \(unzipDir). Exiting...")
    exit(1)
}

print("[*] .app found at: \(appPath)")

let binaryName = URL(fileURLWithPath: appPath).deletingPathExtension().lastPathComponent
let binaryPath = "\(appPath)/\(binaryName)"

guard fileManager.fileExists(atPath: binaryPath) else {
    print("[@] Binary not found in \(appPath). Exiting...")
    exit(1)
}

print("[*] Binary found: \(binaryPath)")

let classDumpOutput = "\(outputDir)/class_dump"
let swiftDumpOutput = "\(outputDir)/swift_dump"

do {
    try fileManager.createDirectory(atPath: classDumpOutput, withIntermediateDirectories: true)
    try fileManager.createDirectory(atPath: swiftDumpOutput, withIntermediateDirectories: true)
} catch {
    print("[@] Failed to create output directories for dumps: \(error)")
    exit(1)
}

func runCommand(_ command: String, arguments: [String]) -> Int32 {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: command)
    process.arguments = arguments

    do {
        try process.run()
        process.waitUntilExit()
        return process.terminationStatus
    } catch {
        print("[@] Failed to execute command \(command): \(error)")
        return -1
    }
}

func which(_ command: String) -> String? {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
    process.arguments = [command]
    process.standardOutput = pipe

    do {
        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let path = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)

        return (process.terminationStatus == 0) ? path : nil
    } catch {
        return nil
    }
}

guard let ipswPath = which("ipsw") else {
    print("[@] Could not locate 'ipsw' binary. Is it installed?")
    exit(1)
}

let classDumpStatus = runCommand(ipswPath, arguments: [
    "class-dump", binaryPath, "--headers", "-o", classDumpOutput
])

if classDumpStatus != 0 {
    print("[@] Failed to run class-dump.")
}

print("[*] Dumping Swift classes for \(appName)...")

let mangledPath = "\(swiftDumpOutput)/\(appName)-mangled.txt"
let demangledPath = "\(swiftDumpOutput)/\(appName)-demangled.txt"

do {
    print("[*] Dumping Swift classes (mangled)...")
    FileManager.default.createFile(atPath: mangledPath, contents: nil)

    let swiftDumpMangled = Process()
    swiftDumpMangled.executableURL = URL(fileURLWithPath: ipswPath)
    swiftDumpMangled.arguments = ["swift-dump", binaryPath]

    let mangledFile = URL(fileURLWithPath: mangledPath)
    swiftDumpMangled.standardOutput = try FileHandle(forWritingTo: mangledFile)

    try swiftDumpMangled.run()
    swiftDumpMangled.waitUntilExit()
} catch {
    print("[@] Failed to run swift-dump (mangled): \(error)")
}

do {
    print("[*] Dumping Swift classes (demangled)...")
    FileManager.default.createFile(atPath: demangledPath, contents: nil)

    let swiftDumpDemangled = Process()
    swiftDumpDemangled.executableURL = URL(fileURLWithPath: ipswPath)
    swiftDumpDemangled.arguments = ["swift-dump", binaryPath, "--demangle"]

    let demangledFile = URL(fileURLWithPath: demangledPath)
    swiftDumpDemangled.standardOutput = try FileHandle(forWritingTo: demangledFile)

    try swiftDumpDemangled.run()
    swiftDumpDemangled.waitUntilExit()
} catch {
    print("[@] Failed to run swift-dump (demangled): \(error)")
}
