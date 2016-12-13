/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

@IBDesignable open class DateChooser: UIView {
    
    // MARK: - IB Inspectable properties
    
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable open var titleColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var neutralColor: UIColor = .darkGray {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var destructiveColor: UIColor = .red {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable open var titleFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            title.font = titleFont
        }
    }
    
    @IBInspectable open var buttonFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            removeDateButton.titleLabel?.font = buttonFont
            setToCurrentButton.titleLabel?.font = buttonFont
            saveButton.titleLabel?.font = buttonFont
        }
    }
    
    @IBInspectable open var capabilities: Int = DateChooserCapabilities.standard.rawValue {
        didSet {
            updateCapabilities()
        }
    }
    
    @IBInspectable open var minuteInterval: Int = 5 {
        didSet {
            datePicker.minuteInterval = minuteInterval
        }
    }
    
    
    // MARK: - Computed properties
    
    var computedCapabilities: DateChooserCapabilities {
        return DateChooserCapabilities(rawValue: capabilities)
    }
    
    
    // MARK: - Internal properties
    
    var title = UILabel()
    var segmentedControl = UISegmentedControl()
    var datePicker = UIDatePicker()
    var removeDateButton = UIButton(type: .system)
    var setToCurrentButton = UIButton(type: .system)
    var saveButton = UIButton(type: .system)
    
    
    // MARK: - Overrides
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    open override func tintColorDidChange() {
        updateColors()
    }
    
}


// MARK: - Private functions

private extension DateChooser {
    
    func setupViews() {
        let temp = 2
    }
    
    func updateColors() {
        let temp = 3
    }
    
    func updateCapabilities() {
        let temp = 1
    }
    
}
