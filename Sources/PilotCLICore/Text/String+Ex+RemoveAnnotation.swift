//
//  String+Ex+RemoveAnnotation.swift
//  Commander
//
//  Created by LXF on 2018/7/20.
//

import Foundation

extension String{
//    # 启动模式  其实就是填个文件名
    public func RemoveAnnotation()->String{
        var str = ""
        
        var startAnnotation = false
        
        for item in self.enumerated() {
            if item.element == "#"{
                startAnnotation = true
                continue
            }
            
            if item.element == "\n"{
                startAnnotation = false
            }
            
            if !startAnnotation{
                str.append(item.element)
            }
        }
        
        return str
    }
}
