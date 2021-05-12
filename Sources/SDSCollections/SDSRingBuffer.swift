//
//  SDSRingBuffer.swift
//
//  Created by : Tomoaki Yagishita on 2021/05/10
//  © 2021  SmallDeskSoftware
//

import Foundation

public struct SDSRingBuffer<T> {
    let capacity: Int
    private var buffer:[T?]
    private(set) public var latestIndex: Int = -1
    private(set) public var oldestIndex: Int = 0
    
    public var count: Int {
        return (latestIndex - oldestIndex + 1)
    }
    
    public init(capacity: Int) {
        self.capacity = capacity
        self.buffer = Array<T?>(repeating: nil, count: capacity)
    }
    
    public mutating func write(_ value: T) {
        latestIndex += 1
        buffer[latestIndex % capacity] = value
        
        if capacity < count {
            oldestIndex += 1
        }
    }
    
    subscript(index: Int) -> T? {
        get {
            guard (oldestIndex <= index && index <= latestIndex) else { return nil }
            guard let value = buffer[index % capacity] else { return nil }
            return value
        }
    }
    
    func findIndex(of valueToFind:T) -> Int? where T:Equatable {
        if count == 0 { return nil }
        for index in oldestIndex...latestIndex {
            guard let value = self[index] else { continue }
            if value == valueToFind {
                return index
            }
        }
        return nil
    }
}
