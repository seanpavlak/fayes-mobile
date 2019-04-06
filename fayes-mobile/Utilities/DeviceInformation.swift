//
//  DeviceInformation.swift
//  rdn-mobile
//
//  Created by Sean Pavlak on 10/10/18.
//  Copyright © 2018 Reliability Data Network. All rights reserved.
//

import Foundation
import Device

func getAppInfo() -> String {
    let dictionary = Bundle.main.infoDictionary!
    let version = dictionary["CFBundleShortVersionString"] as! String
    return version
}

func getOSInfo() -> String {
    let os = ProcessInfo().operatingSystemVersion
    return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
}

func getDeviceType() -> String {
    switch Device.type() {
    case .iPod:
        return "iPod"
    case .iPhone:
        return "iPhone"
    case .iPad:
        return "iPad"
    default:
        return "Unknown"
    }
}

func getDeviceSize() -> String {
    switch Device.size() {
    case .screen3_5Inch:
        return "3.5 inch"
    case .screen4Inch:
        return "4.0 inch"
    case .screen4_7Inch:
        return "4.7 inch"
    case .screen5_5Inch:
        return "5.5 inch"
    case .screen5_8Inch:
        return "5.8 inch"
    case .screen6_1Inch:
        return "6.1 inch"
    case .screen6_5Inch:
        return "6.8 inch"
    case .screen7_9Inch:
        return "7.9 inch"
    case .screen9_7Inch:
        return "9.7 inch"
    case .screen10_5Inch:
        return "10.5 inch"
    case .screen12_9Inch:
        return "12.9 inch"
    default:
        return "Unknown"
    }
}
