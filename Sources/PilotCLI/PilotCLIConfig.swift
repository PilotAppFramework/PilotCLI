//
//  PilotCLIConfig.swift
//  PilotCLI
//
//  Created by LXF on 2018/7/19.
//

import Foundation
import PathKit
import INI

struct PilotCLIConfig {
    static let version = "1.0.0"
    static let envFileName = "Env.generated.swift"
}


/// 相对于 框架根目录的配置
struct ConfigKeys {
    /// 模板目录名称
    static let templateDirPath = "Template"
    
    /// app env 的默认目录
    static let appEnvDirPath = "App/App/Env"
    
    /// app env 的 启动 模式 配置文件
    static let appEnvLauchFile = "LauchMode.ini"

    static let Release = "Release"
    
    static let template_envFileName = "Env.generated.swift"
}


struct Pilot{
    
    static func isXcode()->Bool{
        if let xcodeVersion = ProcessInfo.processInfo.environment["XCODE_VERSION_MINOR"] ,xcodeVersion.count > 0{
            return true
        }
        return false
    }
    
    /// 构建 子节点
    static func path(dir:String,sub:String)->String{
        return Path(dir+Path.separator+sub).absolute().description
    }
    
    /// rootDir
    static func rootDir()->String{
        
        if let rootDir = ProcessInfo.processInfo.environment["PILOT_ROOT_DIR"] ,rootDir.count > 0{
            return rootDir
        }
        
        if isXcode() {
            return Path("..").absolute().description
        }
        
        if Path("").parent().absolute().components.last == "Tools" {
            return Path("../..").absolute().description
        }
        
        return Path("").absolute().description
    }
    
    /// 构建 模板目录
    static func templateDirPath(rootDir:String)->String{
        return path(dir: rootDir,sub: ConfigKeys.templateDirPath)
    }

    /// app env 路径
    static func appEnvDirPath(rootDir:String)->String{
        return path(dir: rootDir,sub: ConfigKeys.appEnvDirPath)
    }
    
    static func isRelease()->Bool{
        let con = ProcessInfo.processInfo.environment["SWIFT_ACTIVE_COMPILATION_CONDITIONS"]
        return isXcode() && (con == nil || con?.count == 0)
    }
    
    static func isDebug()->Bool{
        return isXcode() && ProcessInfo.processInfo.environment["SWIFT_ACTIVE_COMPILATION_CONDITIONS"] == "Debug"
    }
    
    static func parse(INIPath: String) throws -> Config {
        let lauchConfigContent = try Path(INIPath).read(String.Encoding.utf8)
        let lauchConfig = try parseINI(string: lauchConfigContent.RemoveAnnotation())
        return lauchConfig
    }
    
    static func toKV(list: [String:Any])-> [KV] {
        var listKV:[KV] = []
        for item in list {
            listKV.append(KV.init(k: item.key, v_value: item.value))
        }
        
        listKV.sort { (_1, _2) -> Bool in
            return _1.k.compare(_2.k) == ComparisonResult.orderedAscending
        }
        
        return listKV
    }
}

//class KV:NSObject {
struct KV {
    var k:String
    var v:String
    var v_value:Any
    
    init(k:String,
    v_value:Any) {
        self.k = k
        self.v_value = v_value
        self.v = String.init(describing: v_value).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if let b = Bool.init(self.v){
            self.v = String.init(describing: b)
            return
        }
        
        if let b = Int.init(self.v){
            self.v = String.init(describing: b)
            return
        }
        
        if let b = Double.init(self.v){
            self.v = String.init(describing: b)
            return
        }
        
        self.v = self.v.trimmingCharacters(in: CharacterSet.init(charactersIn: "\""))
        
        self.v = "\""+String.init(describing: self.v)+"\""
        
    }
}



struct KVSection {
    
    var name:String
    var kvList:[KV]
    
    init(name:String,
         kvList:[KV]) {
        self.name = name
        self.kvList = kvList
    }
}



