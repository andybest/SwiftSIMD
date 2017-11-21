/*
 MIT License
 
 Copyright (c) 2017 Andy Best
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import Commander
import Stencil
import StencilSwiftKit
import PathKit

struct VectorType {
    let numElements: Int
    let typeName: String
    let scalarType: String
    let crossTypeName: String?
}

let vectorTypes: [VectorType] = [
    VectorType(numElements: 2, typeName: "float2", scalarType: "Float", crossTypeName: "float3"),
    VectorType(numElements: 3, typeName: "float3", scalarType: "Float", crossTypeName: "float3"),
    VectorType(numElements: 4, typeName: "float4", scalarType: "Float", crossTypeName: nil),
    VectorType(numElements: 2, typeName: "double2", scalarType: "Double", crossTypeName: "double3"),
    VectorType(numElements: 3, typeName: "double3", scalarType: "Double", crossTypeName: "double3"),
    VectorType(numElements: 4, typeName: "double4", scalarType: "Double", crossTypeName: nil),
]

func generateVectors(toDir outputDir:String, vectorTemplatePath: String) {
    
    let templatePath = (vectorTemplatePath as NSString).deletingLastPathComponent
    let templateName = (vectorTemplatePath as NSString).lastPathComponent
    
    for vType in vectorTypes {
        let outputPath = outputDir + "/\(vType.typeName)+SIMDExtensions.swift"
        
        var environment = stencilSwiftEnvironment()
        environment.loader = FileSystemLoader(paths: [Path(templatePath)])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        let context: [String: Any] = [
            "vectorType": vType.typeName,
            "scalarType": vType.scalarType,
            "numElements": vType.numElements,
            "crossTypeName": vType.crossTypeName ?? "",
            "date": dateFormatter.string(from: Date()),
            "year": Calendar.current.component(.year, from: Date())
        ]
        
        do {
            let rendered = try environment.renderTemplate(name: templateName, context: context)
            print(rendered)
            try rendered.write(toFile: outputPath, atomically: true, encoding: .utf8)
        } catch {
            generatorError(error.localizedDescription)
        }
    }
}

func generateFiles(toDir outputDir: String, vectorTemplatePath: String) {
    generateVectors(toDir: outputDir, vectorTemplatePath: vectorTemplatePath)
}

func generatorError(_ msg: String) -> Never {
    print(msg)
    exit(1)
}

let main = command ( Argument<String>("outputDir", description: "The output directory"),
                     Argument<String>("vectorTemplatePath", description: "The path for vector templates")) { outputDir, vectorTemplatePath in
    
                        generateFiles(toDir: outputDir, vectorTemplatePath: vectorTemplatePath)
}

main.run()
//generateVectors(toDir: "./", vectorTemplatePath: "./templates/vectorTemplate.stencil")
