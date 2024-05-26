//
//  ABIDecoderTests.swift
//  localTests
//
//  Created by geoffrey on 25.05.2024
//

import Foundation
import Web3Core
import XCTest
import BigInt
@testable import web3swift

final class ABIDecoderTests: XCTestCase {
    func testDecodeTuple() throws {
        // cast abi-encode "tuple((uint256))" "(0x55)"
        let data = Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000055")
        let tuple = try XCTUnwrap(ABIDecoder.decode(types: [.tuple(types: [.uint(bits: 256)])], data: data))
        let result = try XCTUnwrap(tuple[0] as? [Any])
        XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
    }

    func testDecodeTwoTuple() throws {
        // cast abi-encode "tuple((uint256,uint256))" "(0x55,0x22)"
        let data = Data(hex: "0x00000000000000000000000000000000000000000000000000000000000000550000000000000000000000000000000000000000000000000000000000000022")
        let tuple = try XCTUnwrap(ABIDecoder.decode(types: [.tuple(types: [.uint(bits: 256), .uint(bits: 256)])], data: data))
        let result = try XCTUnwrap(tuple[0] as? [Any])
        XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
        XCTAssertEqual(BigUInt(0x22), result[1] as? BigUInt)
    }

    func testDecodeTwoTupleString() throws {
        // cast abi-encode "tuple((uint256,string,uint256))" "(0x55,hello,0x22)"
        let data = Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000568656c6c6f000000000000000000000000000000000000000000000000000000")
        let tuple = try XCTUnwrap(
            ABIDecoder.decode(types: [
                .tuple(types: [
                    .uint(bits: 256),
                    .string,
                    .uint(bits: 256)
                ])], data: data))
        let result = try XCTUnwrap(tuple[0] as? [Any])
        XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
        XCTAssertEqual("hello", result[1] as? String)
        XCTAssertEqual(BigUInt(0x22), result[2] as? BigUInt)
    }

    func testDecodeTwoTupleStringString() throws {
        // cast abi-encode "tuple((uint256,string,string,uint256))" "(0x55,hello,goodbye,0x22)"
        let data = Data(hex: "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000568656c6c6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007676f6f6462796500000000000000000000000000000000000000000000000000")
        let tuple = try XCTUnwrap(
            ABIDecoder.decode(types: [
                .tuple(types: [
                    .uint(bits: 256),
                    .string,
                    .string,
                    .uint(bits: 256)
                ])], data: data))
        let result = try XCTUnwrap(tuple[0] as? [Any])
        XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
        XCTAssertEqual("hello", result[1] as? String)
        XCTAssertEqual("goodbye", result[2] as? String)
        XCTAssertEqual(BigUInt(0x22), result[3] as? BigUInt)
    }

    func testDecodeTwoTupleStringArray() throws {
        // cast abi-encode 'tuple((uint256,string,string[],string,uint256))' '(0x55,hello,[hee,haw,hah,hoo],goodbye,0x22)'
        // cast abi-decode --input 'tuple((uint256,string,string[],string,uint256))' '0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002800000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000568656c6c6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000003686565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036861770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000368616800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003686f6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007676f6f6462796500000000000000000000000000000000000000000000000000'
        let data = Data(hex: "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000005500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000002800000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000568656c6c6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001400000000000000000000000000000000000000000000000000000000000000003686565000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036861770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000368616800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003686f6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007676f6f6462796500000000000000000000000000000000000000000000000000")
        let tuple = try XCTUnwrap(
            ABIDecoder.decode(types: [
                .tuple(types: [
                    .uint(bits: 256),
                    .string,
                    .array(type: .string, length: 0),
                    .string,
                    .uint(bits: 256)
                ])], data: data))
        let result = try XCTUnwrap(tuple[0] as? [Any])
        XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
        XCTAssertEqual("hello", result[1] as? String)
        let arr = try XCTUnwrap(result[2] as? [Any])
        XCTAssertEqual("hee", arr[0] as? String)
        XCTAssertEqual("haw", arr[1] as? String)
        XCTAssertEqual("hah", arr[2] as? String)
        XCTAssertEqual("hoo", arr[3] as? String)
        XCTAssertEqual("goodbye", result[3] as? String)
        XCTAssertEqual(BigUInt(0x22), result[4] as? BigUInt)
    }

     func testDecodeTwoTupleStringBytes() throws {
         // cast abi-encode 'tuple((uint256,string,bytes,uint256))' '(0x55,hello,0x1122,0x22)'
         // cast abi-decode --input 'tuple((uint256,string,bytes,uint256))' '0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000568656c6c6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021122000000000000000000000000000000000000000000000000000000000000'
         let data = Data(hex: "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000022000000000000000000000000000000000000000000000000000000000000000568656c6c6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021122000000000000000000000000000000000000000000000000000000000000")
         let tuple = try XCTUnwrap(
             ABIDecoder.decode(types: [
                 .tuple(types: [
                     .uint(bits: 256),
                     .string,
                     .dynamicBytes,
                     .uint(bits: 256)
                 ])], data: data))
         let result = try XCTUnwrap(tuple[0] as? [Any])
         XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
         XCTAssertEqual("hello", result[1] as? String)
         XCTAssertEqual(Data(hex: "0x1122"), result[2] as? Data)
         XCTAssertEqual(BigUInt(0x22), result[3] as? BigUInt)
     }
    
    func testDecodeTwoTupleStringBytesStructArray() throws {
        // cast abi-encode 'tuple((uint256,string,bytes,(uint256,bytes,bytes)[]))' '(0x55,hello,0x1122,[(1,0xaa,0xbb)])'
        // cast abi-decode --input 'tuple((uint256,string,bytes,(uint256,bytes,bytes)[]))' '0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000568656c6c6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000001aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001bb00000000000000000000000000000000000000000000000000000000000000'
        let data = Data(hex: "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000568656c6c6f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021122000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000001aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001bb00000000000000000000000000000000000000000000000000000000000000")
        let tuple = try XCTUnwrap(
            ABIDecoder.decode(types: [
                .tuple(types: [
                    .uint(bits: 256),
                    .string,
                    .dynamicBytes,
                    .array(type: .tuple(types: [
                        .uint(bits: 256),
                        .dynamicBytes,
                        .dynamicBytes
                    ]), length: 0)
                ])], data: data))
        let result = try XCTUnwrap(tuple[0] as? [Any])
        XCTAssertEqual(BigUInt(0x55), result[0] as? BigUInt)
        XCTAssertEqual("hello", result[1] as? String)
        XCTAssertEqual(Data(hex: "0x1122"), result[2] as? Data)
        let arr = try XCTUnwrap(result[3] as? [Any])
        let str = try XCTUnwrap(arr[0] as? [Any])
        XCTAssertEqual(BigUInt(1), str[0] as? BigUInt)
        XCTAssertEqual(Data(hex: "0xaa"), str[1] as? Data)
        XCTAssertEqual(Data(hex: "0xbb"), str[2] as? Data)
    }
}
