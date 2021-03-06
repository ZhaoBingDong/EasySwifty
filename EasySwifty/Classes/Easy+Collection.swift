//
//  Easy+Collection.swift
//  EaseSwifty
//
//  Created by 董招兵 on 2017/8/6.
//  Copyright © 2017年 大兵布莱恩特. All rights reserved.
//

import Foundation

// MARK: - Dictionary
public extension Dictionary {

    var jsonValue : String? {
        get {
            if let data = Data.dataWithObject(self) {
                var string = data.stringValue()
                if string?.contains("\\") ?? false {
                    string = string?.replacingOccurrences(of: "\\", with: "")
                }
                if string?.contains("\\/") ?? false {
                    string = string?.replacingOccurrences(of: "\\/", with: "/")
                }
                return string
            } else {
                return nil
            }
        }
    }

    mutating func set(object : Value?,forKey key :Key) {
        guard object != nil else { return }
        self[key]    = object
    }

    @discardableResult
    mutating func object(forKey key : Key) -> Value? {
        return self[key]
    }

    mutating func remove(forKey key : Key) {
        self.removeValue(forKey: key)
    }
    
    @discardableResult
    mutating func contains(_ key : Key) -> Bool {
        return object(forKey: key) != nil
    }

}

//MARK: Array

public extension Array {

    var jsonValue : String? {
        get {
            if let data     = Data.dataWithObject(self) {
                return data.stringValue()
            } else {
                return nil
            }
        }
    }

}

// MARK: - Safe Retrieve 读取数据
public extension Array where Element : Equatable {

    /// 安全获取数组中的元素
    @discardableResult
    func object(at index : Int) -> Element? {
        guard !isEmpty else { return nil }
        guard (index <= self.count - 1) else { return nil }
        return  self[index]
    }


}

// MARK: - Safe Delete 移除数据
public extension Array where Element : Equatable {

    /// 移除数组下标的元素 安全判断不可越界
    mutating func remove(at index: Int) {
        guard !isEmpty else { return }
        guard (index <= self.count - 1) else { return }
        remove(at: index)
    }

    /// 移除某个范围的数组元素
    mutating func remove(in range: FoundationRange) {
        if let  subRange  = rangeIndex(from: range) {
            removeSubrange(subRange)
        }
    }

}

//MARK: Array
public extension Array where Element : Equatable {

    /// 在数组某个位置插入一个元素
    mutating func insert(object : Element ,at index:Int) {
        guard !isEmpty else { return }
        guard index <= self.count else { return }
        insert(object, at: index)
    }
    /// 替换数组某个下标的元素
    mutating func replace(object : Element , at index : Int) {
        guard !isEmpty else { return }
        guard (index <= self.count - 1) else { return }
        self[index] = object
    }

    /// 在数组中间任意位置插入一个数组
    mutating func insert(objects : [Element], at index : Int) {
        var i = index+1
        for obj in objects {
            self.insert(object : obj, at: i)
            i+=1
        }
    }
    /// 在当前数组末尾追加元素
    mutating func insertObjects(from array : [Element]) {
        for obj in array {
            self.append(obj)
        }
    }
 
    fileprivate func rangeIndex(from range : FoundationRange) -> Range<Index>? {
        guard !isEmpty else { return nil }
        let location = range.location
        let length = range.length
        guard location <= self.count else  {
            NJLog("\nlocation 越界\n")
            return nil
        }
        guard (range.sum <= self.count) else {
            NJLog("\nlocation + length 越界\n")
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy:location)
        let endIndex = self.index(startIndex, offsetBy:length)
        let range = Range.init(NSRange(location: startIndex, length: endIndex))
        return range
    }

    /// 随机从数组中取出一个元素
    func randomObject() -> Element? {
        guard !isEmpty else { return nil }
        let index = arc4random_uniform(UInt32(self.count))
        return self[Int(index)]
    }


}

public extension Set where Element : Equatable {
    
    var allObjects : [Element] {
        get {
            if self.isEmpty {
                return [Element]()
            } else {
                var objects = [Element]()
                for obj in self {
                    objects.append(obj)
                }
                return objects
            }
            
        }
    }
}
