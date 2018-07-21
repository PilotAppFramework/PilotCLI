import Foundation
import Commander
import XcodeEdit
import PilotCLICore
import RswiftCore
import Stencil
import PathKit
import INI



// Argument convertibles
extension AccessLevel : ArgumentConvertible, CustomStringConvertible {
    public init(parser: ArgumentParser) throws {
        guard let value = parser.shift() else { throw ArgumentError.missingValue(argument: nil) }
        guard let level = AccessLevel(rawValue: value) else { throw ArgumentError.invalidType(value: value, type: "AccessLevel", argument: nil) }
        
        self = level
    }
    
    public var description: String {
        return rawValue
    }
}

extension ProcessInfo {
    func value(from current: String, name: String, key: String) throws -> String {
        if current != key { return current }
        guard let value = self.environment[key] else { throw ArgumentError.missingValue(argument: name) }
        
        return value
    }
}

// Flags grouped in struct for readability
struct CommanderFlags {
    static let version = Flag("version", description: "Prints version information about this release.")
}

// Default values for non-optional Commander Options
struct EnvironmentKeys {
    static let xcodeproj = "PROJECT_FILE_PATH"
    static let target = "TARGET_NAME"
    static let bundleIdentifier = "PRODUCT_BUNDLE_IDENTIFIER"
    static let productModuleName = "PRODUCT_MODULE_NAME"
    static let buildProductsDir = SourceTreeFolder.buildProductsDir.rawValue
    static let developerDir = SourceTreeFolder.developerDir.rawValue
    static let sourceRoot = SourceTreeFolder.sourceRoot.rawValue
    static let sdkRoot = SourceTreeFolder.sdkRoot.rawValue
    
    /// 框架 根目录
    static let rootDir = Pilot.rootDir()
    
}

// Options grouped in struct for readability
public struct CommanderOptions {
    static let importModules = Option("import", default: "", description: "Add extra modules as import in the generated file, comma seperated.")
    static let accessLevel = Option("accessLevel", default: AccessLevel.internalLevel, description: "The access level [public|internal] to use for the generated R-file.")
    static let rswiftIgnore = Option("rswiftignore", default: ".rswiftignore", description: "Path to pattern file that describes files that should be ignored.")
    
    static let xcodeproj = Option("xcodeproj", default: EnvironmentKeys.xcodeproj, flag: "p", description: "Path to the xcodeproj file.")
    static let target = Option("target", default: EnvironmentKeys.target, flag: "t", description: "Target the R-file should be generated for.")
    
    static let bundleIdentifier = Option("bundleIdentifier", default: EnvironmentKeys.bundleIdentifier, description: "Bundle identifier the R-file is be generated for.")
    static let productModuleName = Option("productModuleName", default: EnvironmentKeys.productModuleName, description: "Product module name the R-file is generated for.")
    static let buildProductsDir = Option("buildProductsDir", default: EnvironmentKeys.buildProductsDir, description: "Build products folder that Xcode uses during build.")
    static let developerDir = Option("developerDir", default: EnvironmentKeys.developerDir, description: "Developer folder that Xcode uses during build.")
    static let sourceRoot = Option("sourceRoot", default: EnvironmentKeys.sourceRoot, description: "Source root folder that Xcode uses during build.")
    static let sdkRoot = Option("sdkRoot", default: EnvironmentKeys.sdkRoot, description: "SDK root folder that Xcode uses during build.")
    
    static let rootDir = Option("rootDir", default: EnvironmentKeys.rootDir, description: "pilot框架 根目录.")
    static let envDir = Option("envDir", default: "", description: "Env 目录.")
    static let templateDir = Option("templateDir", default: "", description: "模板文件目录.")
    static let lauchTemplateFile = Option("LauchTemplateFile", default: ConfigKeys.template_envFileName, description: "启动文件模板文件名.")
}


// Options grouped in struct for readability
struct CommanderArguments {
    static let outputDir = Argument<String>("outputDir", description: "Output directory for the generated file.")
}

// Temporary warning message during migration to R.swift 4
let parser = ArgumentParser(arguments: CommandLine.arguments)
_ = parser.shift()
let exception = parser.hasOption("version") || parser.hasOption("help")

//if !exception && parser.shift() != "generate" {
//    var arguments = CommandLine.arguments
//    arguments.insert("generate", at: 1)
//    let command = arguments
//        .map { $0.contains(" ") ? "\"\($0)\"" : $0 }
//        .joined(separator: " ")
//
//    let message = "error: R.swift 4 requires \"generate\" command as first argument to the executable.\n"
//        + "Change your call to something similar to this:\n\n"
//        + "\(command)"
//        + "\n"
//
//    fputs("\(message)\n", stderr)
//    exit(EXIT_FAILURE)
//}

Group {

    $0.addCommand("make:env", "构建 env.generate.swift", Make_Env.CMD)
    
}.run(PilotCLIConfig.version)


