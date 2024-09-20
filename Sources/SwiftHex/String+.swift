//
//  String+.swift
//  SwiftHex
//
//  Created by HALQME on 2024/09/20.
//

extension String {
    public func isHexable() -> Bool {
        let value = self
        var result: Bool = false
        let splitValue = splitString(value, every: 16)
        splitValue.forEach {
            do {
                try _ = Hex($0)
            } catch {
                result = false
            }
            result = true
        }
        return result
    }
    
    public func splitString(_ str:String?, every: Int) -> [String] {
        let str = str ?? self
        return stride(from: 0, to: str.count, by: every).map {
            let start = str.index(str.startIndex, offsetBy: $0)
            let end = str.index(start, offsetBy: every, limitedBy: str.endIndex) ?? str.endIndex
            return String(str[start..<end])
        }
    }
}
