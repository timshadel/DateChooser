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
    
    // MARK: - Enums
    
    public enum DateMode: Int {
        case date
        case time
    }
    
    
    // MARK: - IB Inspectable properties
    
    @IBInspectable open var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable open var background: UIColor = .white {
        didSet {
            updateColors()
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
            let date = startingDate ?? Date()
            let adjustedDate = date.rounded(minutes: minuteInterval)
            self.date = adjustedDate
            datePicker.date = adjustedDate
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
    
    @IBInspectable open var blurEffectStyle: UIBlurEffectStyle = .extraLight {
        didSet {
            updateBlur()
        }
    }
    
    
    // MARK: - Public properties
    
    open var chosenDate: Date?
    public weak var delegate: DateChooserDelegate?
    public var programmaticCapabilities: DateChooserCapabilities {
        get {
            return DateChooserCapabilities(rawValue: capabilities)
        }
        set {
            capabilities = newValue.rawValue
        }
    }
    
    
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
    fileprivate let backgroundView = UIView()
    fileprivate let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    fileprivate var date: Date?
    
    
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
    
    
    // MARK: - Public functions
    
    public func change(to dateMode: DateMode) {
        segmentedControl.selectedSegmentIndex = dateMode.rawValue
        updateDatePicker()
    }
    
    
    // MARK: - Internal functions
    
    func updateDatePicker() {
        guard computedCapabilities.contains(.dateAndTimeSeparate) else { return }
        datePicker.datePickerMode = segmentedControl.selectedSegmentIndex == 0 ? .date : .time
        datePicker.minuteInterval = minuteInterval
    }
    
    func dateChanged() {
        date = datePicker.date
        updateDate()
        delegate?.countdownDurationChanged(to: datePicker.countDownDuration)
    }
    
    func removeDate() {
        date = nil
        datePicker.date = Date().rounded(minutes: minuteInterval)
        updateDate()
    }
    
    func setDateToCurrent() {
        let now = Date().rounded(minutes: minuteInterval)
        date = now
        datePicker.date = now
        updateDate()
    }
    
    func cancelChanges() {
        delegate?.dateChooserCancelled()
    }
    
    func saveChanges() {
        delegate?.dateChooserSaved(with: date, duration: datePicker.countDownDuration)
    }
    
    func toggleMinuteInterval() {
        if datePicker.minuteInterval == minuteInterval {
            datePicker.minuteInterval = 1
        } else {
            datePicker.minuteInterval = minuteInterval
            datePicker.date = datePicker.date.rounded(minutes: minuteInterval)
            updateDate()
            delegate?.dateChanged(to: datePicker.date)
        }
    }
    
    func buttonTouchBegan(_ button: UIButton) {
        button.backgroundColor = .clear
    }
    
    func buttonTouchEnded(_ button: UIButton) {
        button.backgroundColor = background
    }
    
}


// MARK: - Private functions

private extension DateChooser {
    
    func setupViews() {
        clipsToBounds = true
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
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
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.7
        title.allowsDefaultTighteningForTruncation = true
        title.accessibilityIdentifier = "DateChooser.title"

        segmentedContainer.addSubview(segmentedControl)
        constrainFullWidth(segmentedControl, leading: DateChooser.innerMargin * 2, top: DateChooser.innerMargin, trailing: DateChooser.innerMargin * 2, bottom: DateChooser.innerMargin)
        stackView.addArrangedSubview(segmentedContainer)
        segmentedControl.addTarget(self, action: #selector(updateDatePicker), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.accessibilityIdentifier = "DateChooser.segmentedControl"

        stackView.addArrangedSubview(datePicker)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(toggleMinuteInterval))
        doubleTap.numberOfTapsRequired = 2
        datePicker.addGestureRecognizer(doubleTap)
        datePicker.accessibilityIdentifier = "DateChooser.datePicker"
        backgroundView.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true

        stackView.addArrangedSubview(removeDateBorder)
        let removeDateBorderHeight = removeDateBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight)
        removeDateBorderHeight.priority = 999
        removeDateBorderHeight.isActive = true
        stackView.addArrangedSubview(removeDateButton)
        removeDateButton.addTarget(self, action: #selector(removeDate), for: .touchUpInside)
        addTouchHandlers(to: removeDateButton)
        let removeDateButtonHeight = removeDateButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight)
        removeDateButtonHeight.priority = 999
        removeDateButtonHeight.isActive = true
        removeDateButton.setTitle(NSLocalizedString("Remove date", comment: "Button title to remove date"), for: .normal)
        removeDateButton.accessibilityIdentifier = "DateChooser.removeDateButton"

        stackView.addArrangedSubview(currentBorder)
        let currentBorderHeight = currentBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight)
        currentBorderHeight.priority = 999
        currentBorderHeight.isActive = true
        stackView.addArrangedSubview(setToCurrentButton)
        setToCurrentButton.addTarget(self, action: #selector(setDateToCurrent), for: .touchUpInside)
        addTouchHandlers(to: setToCurrentButton)
        let currentButtonHeight = setToCurrentButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight)
        currentButtonHeight.priority = 999
        currentButtonHeight.isActive = true
        setToCurrentButton.accessibilityIdentifier = "DateChooser.currentButton"

        stackView.addArrangedSubview(saveBorder)
        saveBorder.heightAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true
        
        let saveCancelContainer = UIStackView()
        stackView.addArrangedSubview(saveCancelContainer)
        saveCancelContainer.axis = .horizontal
        saveCancelContainer.addArrangedSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
        addTouchHandlers(to: cancelButton)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel button title"), for: .normal)
        cancelButton.accessibilityIdentifier = "DateChooser.cancelButton"
        saveCancelContainer.addArrangedSubview(cancelBorder)
        cancelBorder.widthAnchor.constraint(equalToConstant: DateChooser.innerRuleHeight).isActive = true

        saveCancelContainer.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        addTouchHandlers(to: saveButton)
        saveButton.heightAnchor.constraint(equalToConstant: DateChooser.buttonHeight).isActive = true
        saveButton.setTitle(NSLocalizedString("Save", comment: "Save button title"), for: .normal)
        saveButton.accessibilityIdentifier = "DateChooser.saveButton"
        let buttonWidth = cancelButton.widthAnchor.constraint(equalTo: saveButton.widthAnchor)
        buttonWidth.priority = 999
        buttonWidth.isActive = true

        updateColors()
        updateCapabilities()
    }
    
    func updateColors() {
        backgroundView.backgroundColor = background
        title.textColor = titleColor
        datePicker.setValue(titleColor, forKey: "textColor")
        segmentedControl.tintColor = tintColor
        removeDateButton.tintColor = destructiveColor
        removeDateButton.backgroundColor = background
        setToCurrentButton.tintColor = neutralColor
        setToCurrentButton.backgroundColor = background
        saveButton.tintColor = tintColor
        saveButton.backgroundColor = background
        cancelButton.backgroundColor = background
        removeDateBorder.backgroundColor = innerBorderColor
        currentBorder.backgroundColor = innerBorderColor
        saveBorder.backgroundColor = innerBorderColor
        cancelBorder.backgroundColor = innerBorderColor
    }
    
    func updateBlur() {
        blurView.effect = UIBlurEffect(style: blurEffectStyle)
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
        if let date = date {
            title.text = dateFormatter.string(from: date)
        } else {
            title.text = nil
        }
        delegate?.dateChanged(to: date)
    }
    
    func constrainFullWidth(_ view: UIView, leading: CGFloat = 0, top: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        guard let superview = view.superview else { fatalError("\(view) has no superview") }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailing).isActive = true
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottom).isActive = true
    }
    
    func addTouchHandlers(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTouchBegan(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchEnded(_:)), for: .touchDragExit)
        button.addTarget(self, action: #selector(buttonTouchEnded(_:)), for: .touchUpInside)
    }
    
}
