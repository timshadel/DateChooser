/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import Foundation

public struct DateChooserCapabilities: OptionSet {
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let setToCurrent = DateChooserCapabilities(rawValue: 1)
    public static let removeDate = DateChooserCapabilities(rawValue: 2)
    public static let dateAndTimeSeparate = DateChooserCapabilities(rawValue: 4)
    public static let dateAndTimeCombined = DateChooserCapabilities(rawValue: 8)
    public static let dateOnly = DateChooserCapabilities(rawValue: 16)
    public static let timeOnly = DateChooserCapabilities(rawValue: 32)
    
    public static let standard: DateChooserCapabilities = [.setToCurrent, .removeDate, .dateAndTimeSeparate]
    
}
