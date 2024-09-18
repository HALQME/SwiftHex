import Testing
@testable import SwiftHex

@Suite("Initialize")
struct InitTests {
    @Test("with hex string")
    func initializeWithHexString() {
        #expect(try! Hex("00000").storage.value == .zero)
        #expect(try! Hex("F").storage.value == UInt64(15))
    }

    @Test("returns nil if invalid hex string")
    func initializeNilr() {
        #expect(throws: Hex.HexError.invalidFormat, performing: { try Hex.init("G") })
    }

    @Test("with UInt64")
    func initializeWithUInt64() {
        #expect(Hex(.zero).storage.value == .zero)
        #expect(Hex(UInt64(15)).storage.value == UInt64(15))
    }

    @Test("with BinaryInteger")
    func initializeWithBinaryInteger() {
        #expect(Hex(0b01).storage.value == UInt64(1))
        #expect(Hex(0b1111).storage.value == UInt64(15))
    }
}

@Suite("Convert")
struct ConvertTests {
    @Test("Description")
    func convertToHexString() {
        #expect(Hex(UInt64(15)).description == String("F"))
        #expect(Hex(UInt64(255)).description == String("FF"))
    }

    @Test("String with fix length")
    func convertToHexStringWithFixLength() {
        #expect(Hex(UInt64(15)).description(2) == String("0F"))
        #expect(Hex(UInt64(24)).description(3) == String("018"))
        #expect(Hex(UInt64(255)).description(6) == String("0000FF"))
    }

    @Test("UInts convert")
    func convertToUInt() {
        #expect(Hex(UInt64(15)).toUInt64() == UInt64(15))
        #expect(try! Hex(UInt64(16)).toUInt8() == UInt8(16))
    }

    func convertToUInt8Error() {
        #expect(throws: Hex.HexError.overflow, performing: { try Hex(UInt64(256)).toUInt8() })
    }
}

@Suite("Equatable, Hashable")
struct Equatable_Hashable_Tests {
    @Test("Equatable")
    func equal() {
        #expect(try! Hex(UInt64(15)) == Hex(String("F")))
        #expect(Hex(UInt8(15)) == Hex(UInt64(15)))
        #expect(Hex(UInt64(15)) != Hex(UInt64(255)))
    }
    @Test("Hashable")
    func hash() {
        #expect(try! Hex(UInt64(15)).hashValue == Hex(String("F")).hashValue)
        #expect(Hex(UInt8(15)).hashValue == Hex(UInt64(15)).hashValue)
    }
}

@Suite("Comparabke")
struct Comparable_Tests {
    @Test("Comparable")
    func lessThan() {
        #expect(Hex(UInt64(15)) < Hex(UInt64(255)))
        #expect(Hex(UInt8(15)) <= Hex(UInt64(15)))
        #expect(try! Hex(String("F")) > Hex(UInt64(13)))
        #expect(try! Hex(String("FF")) >= Hex(UInt8.max))
    }
}
