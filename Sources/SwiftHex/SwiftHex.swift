public struct Hex {

    @usableFromInline
    var storage: Storage

    @usableFromInline
    final class Storage {
        @usableFromInline var value: UInt64
        init(_ value: UInt64) { self.value = value }
    }

    public init(_ string: String) throws {
        guard let value = UInt64(string, radix: 16) else { throw HexError.invalidFormat }
        self.storage = Storage(value)
    }

    public init(_ value: UInt64) {
        self.storage = Storage(value)
    }

    public init<T: BinaryInteger>(_ value: T) {
        self.storage = Storage(UInt64(value))
    }

    @inlinable
    public func toUInt8() throws -> UInt8 {
        guard storage.value <= UInt64(UInt8.max) else { throw HexError.overflow }
        return UInt8(storage.value)
    }

    @inlinable
    public func toUInt64() -> UInt64 {
        return storage.value
    }
}

extension Hex: CustomStringConvertible {
    public var description: String {
        return String(storage.value, radix: 16, uppercase: true)
    }

    public func description(_ count: Int) -> String {
        let string = self.description
        guard count > string.count else { return string }
        let formats = String(repeating: "0", count: count - string.count)
        return formats + string
    }
}

extension Hex: Equatable, Hashable {
    public static func == (lhs: Hex, rhs: Hex) -> Bool {
        return lhs.storage.value == rhs.storage.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(storage.value)
    }
}

extension Hex: Comparable {
    public static func < (lhs: Hex, rhs: Hex) -> Bool {
        return lhs.storage.value < rhs.storage.value
    }
    
    public static func > (lhs: Hex, rhs: Hex) -> Bool {
        return lhs.storage.value > rhs.storage.value
    }
}

extension Hex {
    public enum HexError: Error {
        case overflow
        case invalidFormat
    }
}
