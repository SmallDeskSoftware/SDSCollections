//
//  GenericsRingBufferTests.swift
//
//  Created by : Tomoaki Yagishita on 2021/05/10
//  © 2021  SmallDeskSoftware
//

import XCTest
@testable import SDSCollections

class SDSRingBufferTests: XCTestCase {

    func test_create_createWithoutWrite_shouldBeSuccess() throws {
        let sut = SDSRingBuffer<Int>(capacity: 4)
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.capacity, 4)
        XCTAssertNil(sut[0])
    }
    
    func test_write_writeWithinCapacity_shouldKeepAsIs() throws {
        var sut = SDSRingBuffer<Int>(capacity: 4)
        sut.write(0)
        sut.write(1)
        sut.write(2)

        XCTAssertEqual(sut.count, 3)
        XCTAssertEqual(sut[sut.oldestIndex], 0)
        XCTAssertEqual(sut[sut.oldestIndex+1], 1)
        XCTAssertEqual(sut[sut.oldestIndex+2], 2)

        XCTAssertEqual(sut[sut.latestIndex], 2)
        XCTAssertEqual(sut[sut.latestIndex-1], 1)
        XCTAssertEqual(sut[sut.latestIndex-2], 0)

        XCTAssertNil(sut[5])
    }

    func test_write_writeMoreThanCapacity_shouldKeepOnlyCapacity() throws {
        var sut = SDSRingBuffer<Int>(capacity: 4)
        sut.write(0)
        sut.write(1)
        sut.write(2)
        sut.write(3)
        sut.write(4)

        XCTAssertEqual(sut.count, 4)

        XCTAssertEqual(sut[sut.oldestIndex  ], 1)
        XCTAssertEqual(sut[sut.oldestIndex+1], 2)
        XCTAssertEqual(sut[sut.oldestIndex+2], 3)
        XCTAssertEqual(sut[sut.oldestIndex+3], 4)

        XCTAssertEqual(sut[sut.latestIndex  ], 4)
        XCTAssertEqual(sut[sut.latestIndex-1], 3)
        XCTAssertEqual(sut[sut.latestIndex-2], 2)
        XCTAssertEqual(sut[sut.latestIndex-3], 1)
    }
    
    func test_find_findFromEmptyBuffer_shouldNotCrash() throws {
        let sut = SDSRingBuffer<String>(capacity: 4)
        XCTAssertEqual(sut.count, 0)
        XCTAssertEqual(sut.capacity, 4)
        XCTAssertNil(sut.findIndex(of:"test"))
    }
    
    func test_find_findExistingElement_ShouldBeFound() throws {
        var sut = SDSRingBuffer<String>(capacity: 4)
        sut.write("Hello")
        sut.write(",")
        sut.write("World")
        sut.write("!")
        sut.write(" ")
        
        XCTAssertEqual(try XCTUnwrap(sut.findIndex(of: "World")), 2)
        XCTAssertEqual(sut.findIndex(of: "Aloha"), nil)
    }


//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
