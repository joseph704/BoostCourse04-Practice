//
//  Friend.swift
//  boostcourse03-ios
//
//  Created by 차요셉 on 13/01/2020.
//  Copyright © 2020 차요셉. All rights reserved.
//
import Foundation


/*
 {
 "name":"하나",
 "age":22,
 "address_info": {
     "country":"대한민국",
     "city":"울산"
 }
 */

struct Friend: Codable {
    
    
    struct Address: Codable {
        let country:String
        let city:String
    }
    
    let name:String
    let age:Int
    let addressInfo:Address
    
    var nameAndAge: String {
        return self.name + "(\(self.age))"
    }
    
    var fullAddress: String {
        return self.addressInfo.city + ", " + self.addressInfo.country
    }
    
     enum CodingKeys: String, CodingKey{
      case name, age
      case addressInfo = "address_info"
     }
}



