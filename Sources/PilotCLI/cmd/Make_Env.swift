//
//  Make_Env.swift
//  Commander
//
//  Created by LXF on 2018/7/20.
//

import Foundation
import Commander
import XcodeEdit
import PilotCLICore
import RswiftCore
import Stencil
import PathKit
import INI

struct Make_Env {
    
    static let CMD = command(
        CommanderOptions.rootDir,
        CommanderOptions.sourceRoot,
        CommanderOptions.envDir,
        CommanderOptions.templateDir,
        CommanderOptions.lauchTemplateFile,
        { (rootDir:String,sourceRoot:String,envDirOpt:String,templateDirOpt:String,lauchTemplateFileOpt:String)  in
            
            
            
            var envDir = Pilot.path(dir: rootDir, sub: ConfigKeys.appEnvDirPath)
            
            /// envDir 参数化
            if envDirOpt.count > 0{
                envDir = Path(envDirOpt).absolute().description
            }
            
            let lauchModeName:String = try Make_Env.lauchModeName(envDir: envDir)
            var lauchModeFileName:String = lauchModeName
            
            if !lauchModeName.hasSuffix(".ini") {
                lauchModeFileName = lauchModeName + ".ini"
            }
            
            let lauchConfigFile:String = Pilot.path(dir: envDir, sub: lauchModeFileName)
            
            let conf = try Pilot.parse(INIPath: lauchConfigFile)
            
            let def = conf["DEFAULT"]
            
            var otherSection:[KVSection] = []
            
            for index in 0..<conf.sections.count{
                let se:Section = conf.sections[index]
                if se.name != "DEFAULT" {
                    var kvs = KVSection.init(name: se.name, kvList: Pilot.toKV(list: se.settings))
                    otherSection.append(kvs)
                }
            }
            
            let context:[String : Any] = [
                "lauchModeFileName":lauchModeFileName,
                "conf": conf,
                "DEFAULT":Pilot.toKV(list: ((def?.settings) ?? [:])),
                "otherSection":otherSection
                
            ]
            
            var templateDir = Pilot.templateDirPath(rootDir: rootDir)
            var templateFile = ConfigKeys.template_envFileName
            
            /// 参数化
            if templateDirOpt.count > 0{
                templateDir = Path(templateDirOpt).absolute().description
            }
            if lauchTemplateFileOpt.count > 0{
                templateFile = Path(lauchTemplateFileOpt).absolute().description
            }
            
            let environment = Environment(loader: FileSystemLoader(paths: [Path(templateDir)]))
            let rendered = try environment.renderTemplate(name: templateFile, context: context)
            try Path(Pilot.path(dir: envDir, sub: templateFile)).write(rendered)

//            fputs("Error:\n", stderr)
//            exit(EXIT_FAILURE)
    })
    
    fileprivate static func lauchModeName(envDir:String)throws ->String{
        
        if Pilot.isRelease() {
            return ConfigKeys.Release
        }
        
        /// 读取 启动文件
        let lauchModePath = Pilot.path(dir: envDir, sub: ConfigKeys.appEnvLauchFile)
        let lauchModeContent = try Path(lauchModePath).read(String.Encoding.utf8)
        let lauchMode = try parseINI(string: lauchModeContent.RemoveAnnotation())
        
        guard let sourceFileName = lauchMode["LauchMode"]?["mode"]else {
            fputs("启动模式文件格式不正确. \(lauchModePath)", stderr)
            exit(EXIT_FAILURE)
        }
    
        return sourceFileName
    }
}




