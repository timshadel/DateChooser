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
    
    @IBInspectable open var innerBorderColor: UIColor = .lightGray {
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
    
    let title = UILabel()
    let segmentedControl = UISegmentedControl()
    let datePicker = UIDatePicker()
    let removeDateBorder = UIView()
    let removeDateButton = UIButton(type: .system)
    let currentBorder = UIView()
    let setToCurrentButton = UIButton(type: .system)
    let saveBorder = UIView()
    let saveButton = UIButton(type: .system)
    let stackView = UIStackView()
    
    
    // MARK: - Constants
    
    static fileprivate let innerMargin: CGFloat = 8.0
    
    
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
    
    
    // MARK: - Internal functions
    
    func updateDatePicker() {
        let temp = 4
    }
    
    func dateChanged() {
        let temp = 3
    }
    
    func removeDate() {
        let temp = 4
    }
    
    func setDateToCurrent() {
        let temp = 2
    }
    
    func saveChanges() {
        let temp = 3
    }
    
}


// MARK: - Private functions

private extension DateChooser {
    
    func setupViews() {
        updateCapabilities()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        constrainFullWidth(stackView, top: DateChooser.innerMargin)
        stackView.axis = .vertical
        
        let titleContainer = UIView()
        titleContainer.addSubview(title)
        constrainFullWidth(title, leading: DateChooser.innerMargin, trailing: DateChooser.innerMargin)
        stackView.addArrangedSubview(titleContainer)
        title.font = titleFont
        
        let segmentedContainer = UIView()
        segmentedContainer.addSubview(segmentedControl)
        constrainFullWidth(segmentedControl, leading: DateChooser.innerMargin * 2, top: DateChooser.innerMargin, trailing: DateChooser.innerMargin * 2, bottom: DateChooser.innerMargin)
        stackView.addArrangedSubview(segmentedContainer)
        segmentedControl.addTarget(self, action: #selector(updateDatePicker), for: .valueChanged)
        
        stackView.addArrangedSubview(datePicker)
        updateDatePicker()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        stackView.addArrangedSubview(removeDateBorder)
        stackView.addArrangedSubview(removeDateButton)
        removeDateButton.addTarget(self, action: #selector(removeDate), for: .touchUpInside)
        
        stackView.addArrangedSubview(currentBorder)
        stackView.addArrangedSubview(setToCurrentButton)
        setToCurrentButton.addTarget(self, action: #selector(setDateToCurrent), for: .touchUpInside)
        
        stackView.addArrangedSubview(saveBorder)
        stackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        updateColors()
    }
    
    func updateColors() {
        let temp = 3
    }
    
    func updateCapabilities() {
        let temp = 1
    }
    
    func constrainFullWidth(_ view: UIView, leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = view.superview else { fatalError("\(view) has no superview") }
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing).isActive = true
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
    }
    
}
