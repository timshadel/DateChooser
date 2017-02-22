/*
 |  _   ____   ____   _
 | | |‾|  ⚈ |-| ⚈  |‾| |
 | | |  ‾‾‾‾| |‾‾‾‾  | |
 |  ‾        ‾        ‾
 */

import UIKit

public protocol DateChooserDelegate: class {
    func dateChanged(to date: Date?)
    func countdownDurationChanged(to duration: TimeInterval)
    func dateChooserSaved(with date: Date?, duration: TimeInterval)
    func dateChooserCancelled()
}

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
    
    @IBInspectable open var startingDate: Date? {
        didSet {
            var date = startingDate ?? Date()
            datePicker.date = date.rounded(minutes: minuteInterval)
            updateDate()
        }
    }
    
    @IBInspectable open var startingCountdownDuration: TimeInterval = 0.0 {
        didSet {
            datePicker.countDownDuration = startingCountdownDuration
        }
    }
    
    @IBInspectable open var removeButtonTitle: String = NSLocalizedString("Remove date", comment: "Button title to remove date") {
        didSet {
            removeDateButton.setTitle(removeButtonTitle, for: .normal)
        }
    }
    
    
    // MARK: - Public properties
    
    open var chosenDate: Date?
    public weak var delegate: DateChooserDelegate?
    
    
    // MARK: - Computed properties
    
    var computedCapabilities: DateChooserCapabilities {
        return DateChooserCapabilities(rawValue: capabilities)
    }
    
    
    // MARK: - Internal properties
    
    let title = UILabel()
    let segmentedContainer = UIView()
    let segmentedControl = UISegmentedControl(items: [NSLocalizedString("Date", comment: "Title for date in segmented control"), NSLocalizedString("Time", comment: "Title for time in segmented control")])
    let datePicker = UIDatePicker()
    let removeDateBorder = UIView()
    let removeDateButton = UIButton(type: .system)
    let currentBorder = UIView()
    let setToCurrentButton = UIButton(type: .system)
    let cancelBorder = UIView()
    let cancelButton = UIButton(type: .system)
    let saveBorder = UIView()
    let saveButton = UIButton(type: .system)
    let stackView = UIStackView()
    
    
    // MARK: - Private properties
    
    fileprivate lazy var dateFormatter = DateFormatter()
    
    
    // MARK: - Constants
    
    static fileprivate let innerMargin: CGFloat = 8.0
    static fileprivate let innerRuleHeight: CGFloat = 1.0
    static fileprivate let buttonHeight: CGFloat = 44.0
    
    
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
        guard computedCapabilities.contains(.dateAndTimeSeparate) else { return }
        datePicker.datePickerMode = segmentedControl.selectedSegmentIndex == 0 ? .date : .time
        datePicker.minuteInterval = minuteInterval
    }
    
    func dateChanged() {
        updateDate()
        delegate?.dateChanged(to: datePicker.date)
        delegate?.countdownDurationChanged(to: datePicker.countDownDuration)
    }
    
    func removeDate() {
        datePicker.date = Date().rounded(minutes: minuteInterval)
        title.text = nil
        delegate?.dateChanged(to: nil)
    }
    
    func setDateToCurrent() {
        let now = Date().rounded(minutes: minuteInterval)
        datePicker.date = now
        updateDate()
        delegate?.dateChanged(to: now)
    }
    
    func cancelChanges() {
        delegate?.dateChooserCancelled()
    }
    
    func saveChanges() {
        delegate?.dateChooserSaved(with: datePicker.date, duration: datePicker.countDownDuration)
    }
    
}


// MARK: - Private functions

private extension DateChooser {
    
    func setupViews() {
        addSubview(stackView)
        constrainFullWidth(stackView, top: DateChooser.innerMargin)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        let titleContainer = UIView()
        titleContainer.addSubview(title)
        constrainFullWidth(title, leading: DateChooser.innerMargin, top: DateChooser.innerMargin, trailing: DateChooser.innerMargin, bottom: DateChooser.innerMargin)
        stackView.addArrangedSubview(titleContainer)
        title.font = titleFont
        title.textAlignment = .center
        title.setContentCompressionResistancePriority(800, for: .horizontal)
        
        segmentedContainer.addSubview(segmentedControl)
        constrainFullWidth(segmentedControl, leading: DateChooser.innerMargin * 2, top: DateChooser.innerMargin, trailing: DateChooser.innerMargin * 2, bottom: DateChooser.innerMargin)
        stackView.addArrangedSubview(segmentedContainer)
        segmentedControl.addTarget(self, action: #selector(updateDatePicker), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        
        stackView.addArrangedSubview(datePicker)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        stackView.addArrangedSubview(removeDateBorder)
        removeDateBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(removeDateButton)
        removeDateButton.addTarget(self, action: #selector(removeDate), for: .touchUpInside)
        removeDateButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        removeDateButton.setTitle(NSLocalizedString("Remove date", comment: "Button title to remove date"), for: .normal)

        stackView.addArrangedSubview(currentBorder)
        currentBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(setToCurrentButton)
        setToCurrentButton.addTarget(self, action: #selector(setDateToCurrent), for: .touchUpInside)
        setToCurrentButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        
        stackView.addArrangedSubview(cancelBorder)
        cancelBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
        cancelButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button title"), for: .normal)

        stackView.addArrangedSubview(saveBorder)
        saveBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        stackView.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        saveButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        saveButton.setTitle(NSLocalizedString("Save", comment: "Save button title"), for: .normal)

        updateColors()
        updateCapabilities()
    }
    
    func updateColors() {
        title.textColor = titleColor
        segmentedControl.tintColor = tintColor
        removeDateButton.tintColor = destructiveColor
        setToCurrentButton.tintColor = neutralColor
        saveButton.tintColor = tintColor
        removeDateBorder.backgroundColor = innerBorderColor
        currentBorder.backgroundColor = innerBorderColor
        saveBorder.backgroundColor = innerBorderColor
    }
    
    func updateCapabilities() {
        let includeRemoveDate = computedCapabilities.contains(.removeDate)
        removeDateBorder.isHidden = !includeRemoveDate
        removeDateButton.isHidden = !includeRemoveDate
        let includeCancel = computedCapabilities.contains(.cancel)
        cancelBorder.isHidden = !includeCancel
        cancelButton.isHidden = !includeCancel
        let includeCurrent = computedCapabilities.contains(.setToCurrent)
        currentBorder.isHidden = !includeCurrent
        setToCurrentButton.isHidden = !includeCurrent
        let dateAndTimeSeparate = computedCapabilities.contains(.dateAndTimeSeparate)
        segmentedControl.isHidden = !dateAndTimeSeparate
        segmentedContainer.isHidden = !dateAndTimeSeparate
        title.isHidden = computedCapabilities.contains(.countdown)
        let currentButtonTitle: String
        if dateAndTimeSeparate {
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .full
            currentButtonTitle = NSLocalizedString("Set to current date/time", comment: "Button title to set date to current date and time")
        } else if computedCapabilities.contains(.timeOnly) {
            datePicker.datePickerMode = .time
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
            currentButtonTitle = NSLocalizedString("Set to current time", comment: "Button title to set date to current time")
        } else if computedCapabilities.contains(.dateAndTimeCombined) {
            datePicker.datePickerMode = .dateAndTime
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .full
            currentButtonTitle = NSLocalizedString("Set to current date/time", comment: "Button title to set date to current date and time")
        } else if computedCapabilities.contains(.countdown) {
            datePicker.datePickerMode = .countDownTimer
            currentButtonTitle = ""
        } else {
            datePicker.datePickerMode = .date
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .full
            currentButtonTitle = NSLocalizedString("Set to current date", comment: "Button title to set date to current date")
        }
        setToCurrentButton.setTitle(currentButtonTitle, for: .normal)
        updateDate()
    }
    
    func updateDate() {
        title.text = dateFormatter.string(from: datePicker.date)
    }
    
    func constrainFullWidth(_ view: UIView, leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = view.superview else { fatalError("\(view) has no superview") }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing).isActive = true
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
    }
    
}
