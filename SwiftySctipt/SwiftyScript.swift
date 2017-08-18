//
//  SwiftyScript.swift
//  SwiftySctipt
//
//  Created by Hank on 18/08/2017.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

// MARK: - Shell Command
public struct Shell {

    @discardableResult static func command(_ args: String...) -> Int32 {
        let task = Process()
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }

}

// MARK: - String Extensions
extension String {

    func open() -> String? {
        return (try? String(contentsOfFile: self, encoding: .utf8)) ?? nil
    }

    func matchedSubstrings(of regularExpression: NSRegularExpression) -> [String] {
        return regularExpression.matches(in: self, range: NSMakeRange(0, characters.count)).map { result in
            let start = index(startIndex, offsetBy: result.range.location)
            let end = index(startIndex, offsetBy: result.range.location + result.range.length)
            let range = start..<end
            return substring(with: range)
        }
    }

}

// MARK: - Array Extensions
extension Array {

    func assertNoneEmpty(with name: String, errorMessage: String) {
        guard !isEmpty else {
            print(errorMessage)
            exit(1)
        }
        print("\(count) of \(name) found.")
    }

}

// MARK: - FileManager Extensions
extension FileManager {

    func paths(of types: [String], in path: String, searchPath: [String]? = nil) -> [String] {
        guard let subpaths = try? subpathsOfDirectory(atPath: path) else {
            return []
        }
        return subpaths
            .filter { path in
                guard let type = path.components(separatedBy: ".").last else {
                    return false
                }
                let isMatchedType = types.contains(type)
                guard let searchPath = searchPath else {
                    return isMatchedType
                }
                return isMatchedType && searchPath.contains { path.contains($0) }
            }
            .map { path + $0 }
    }

}
