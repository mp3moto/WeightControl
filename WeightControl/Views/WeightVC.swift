import UIKit

class WeightVC: UIViewController {
    var viewModel: WeightsViewModel
    var completion: (() -> Void)?
    var editWeightIndexPath: IndexPath?
    var weight: Weight?
    
    private var keyboardSize = 0.0 {
        didSet {
            NSLayoutConstraint.deactivate([
                contentViewConstraint,
                buttonConstraint,
                datePickerConstraint
            ])
            var constant1 = 0.0
            var constant2 = -16.0
            if keyboardSize > 0 {
                constant1 = CGFloat(0.0 - ((keyboardSize - 32) / 2))
                constant2 = CGFloat(0.0 - (keyboardSize - 18))
            }
            contentViewConstraint = contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: constant1)
            buttonConstraint = addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: constant2)
            datePickerConstraint = datePickerView.heightAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([
                contentViewConstraint,
                buttonConstraint,
                datePickerConstraint
            ])
        }
    }
    private let handle = UIViewAutoLayout()
    private let titleLabelView = UIViewAutoLayout()
    private let titleLabel = UILabel().customStyle(style: .title, text: "Добавить вес")
    private let dateRowLabel = UILabel().customStyle(style: .measurementSystemLabel, text: "Дата")
    private let dateRowValue: UIButton = {
        let button = UIButton()
        button.setTitle("Сегодня", for: .normal)
        button.titleLabel?.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 17)
        button.setTitleColor(UIColor().getProjectUIColor(color: .wchngPurple), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private let arrowRightView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "arrowright"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let separator1 = UIViewAutoLayout()
    private let separator2 = UIViewAutoLayout()
    private let separator3 = UIViewAutoLayout()
    private let contentView = UIViewAutoLayout()
    private let dateRowView = UIViewAutoLayout()
    private let datePickerView = UIViewAutoLayout()
    private let datePicker = UIDatePicker()
    private let weightRowView = UIViewAutoLayout()
    private let weightValue: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "0", attributes: [NSAttributedString.Key.foregroundColor: UIColor().getProjectUIColor(color: .wchngGray)])
        field.font = UIFont().getCustomFont(font: .SFProDisplayBold, size: 34)
        field.textColor = UIColor().getProjectUIColor(color: .wchngBlack)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardType = .decimalPad
        return field
    }()
    private let weightRowLabel = UILabel().customStyle(style: .weightUnits, text: "")
    private let addButton: UIButton = {
        let button = WCHNGButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 17)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var contentViewConstraint = NSLayoutConstraint()
    private var buttonConstraint = NSLayoutConstraint()
    private var datePickerConstraint = NSLayoutConstraint()
    
    init(viewModel: WeightsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupUI()
        setupConstraints()
        initializeHideKeyboard()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        if let editWeightIndexPath = editWeightIndexPath {
            weight = viewModel.getWeight(indexPath: editWeightIndexPath)
        }
        
        view.addSubview(handle)
        handle.backgroundColor = UIColor().getProjectUIColor(color: .wchngGray)
        handle.layer.cornerRadius = 3
        
        view.addSubview(titleLabelView)
        titleLabelView.addSubview(titleLabel)
        
        view.addSubview(contentView)
        contentView.addSubview(dateRowView)
        dateRowView.addSubview(dateRowLabel)
        dateRowView.addSubview(dateRowValue)
        dateRowView.addSubview(arrowRightView)
        dateRowView.addSubview(separator1)
        separator1.backgroundColor = UIColor().getProjectUIColor(color: .separator)
        dateRowValue.setTitle(weight?.date.displayDate() ?? "Сегодня", for: .normal)
        
        view.addSubview(datePickerView)
        datePickerView.addSubview(separator2)
        separator2.backgroundColor = UIColor().getProjectUIColor(color: .separator)
        datePickerView.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        datePicker.locale = .current
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.date = weight?.date ?? Date()
        
        contentView.addSubview(weightRowView)
        weightRowView.addSubview(weightValue)
        weightRowView.addSubview(weightRowLabel)
        weightRowLabel.text = viewModel.units
        weightRowView.addSubview(separator3)
        separator3.backgroundColor = UIColor().getProjectUIColor(color: .separator)
        if let weight = weight {
            weightValue.text = "\(weight.value * (viewModel.convertionK ?? 1.0))"
        }
        
        view.addSubview(addButton)
        if let _ = weight {
            addButton.setTitle("Сохранить", for: .normal)
        } else {
            addButton.setTitle("Добавить", for: .normal)
        }
        
        if let _ = editWeightIndexPath {
            setAddButton(enabled: true)
        } else {
            setAddButton(enabled: false)
        }
        
        addButton.addTarget(self, action: #selector(addWeight), for: .touchUpInside)
        dateRowValue.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(updateDateRowValue), for: .allEvents)
        weightValue.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        viewModel.onInputValidStateChange = { [weak self] isInputValid in
            self?.setAddButton(enabled: isInputValid)
        }
    }
    
    private func setupConstraints() {
        contentViewConstraint = contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        buttonConstraint = addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        datePickerConstraint = datePickerView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            handle.widthAnchor.constraint(equalToConstant: 36),
            handle.heightAnchor.constraint(equalToConstant: 5),
            handle.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            titleLabelView.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 19),
            titleLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            titleLabelView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerXAnchor.constraint(equalTo: titleLabelView.centerXAnchor),
            titleLabelView.centerYAnchor.constraint(equalTo: titleLabelView.centerYAnchor),
            
            contentViewConstraint,
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            dateRowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateRowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateRowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateRowView.heightAnchor.constraint(equalToConstant: 54),
            
            dateRowLabel.centerYAnchor.constraint(equalTo: dateRowView.centerYAnchor),
            dateRowLabel.leadingAnchor.constraint(equalTo: dateRowView.leadingAnchor, constant: 15.5),
            dateRowLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateRowView.trailingAnchor),
            
            arrowRightView.centerYAnchor.constraint(equalTo: dateRowView.centerYAnchor, constant: 1),
            arrowRightView.trailingAnchor.constraint(equalTo: dateRowView.trailingAnchor, constant: -17.5),
            arrowRightView.leadingAnchor.constraint(greaterThanOrEqualTo: dateRowView.leadingAnchor),
            
            dateRowValue.centerYAnchor.constraint(equalTo: dateRowView.centerYAnchor),
            dateRowValue.trailingAnchor.constraint(equalTo: arrowRightView.leadingAnchor, constant: -8),
            dateRowValue.leadingAnchor.constraint(greaterThanOrEqualTo: dateRowView.leadingAnchor),
            
            separator1.bottomAnchor.constraint(equalTo: dateRowView.bottomAnchor),
            separator1.leadingAnchor.constraint(equalTo: dateRowView.leadingAnchor),
            separator1.trailingAnchor.constraint(equalTo: dateRowView.trailingAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            
            datePickerView.topAnchor.constraint(equalTo: dateRowView.bottomAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            datePickerConstraint,
            
            datePicker.topAnchor.constraint(equalTo: datePickerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor),
            
            separator2.bottomAnchor.constraint(equalTo: datePickerView.bottomAnchor),
            separator2.leadingAnchor.constraint(equalTo: datePickerView.leadingAnchor),
            separator2.trailingAnchor.constraint(equalTo: datePickerView.trailingAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1),
            
            weightRowView.topAnchor.constraint(equalTo: datePickerView.bottomAnchor),
            weightRowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weightRowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weightRowView.heightAnchor.constraint(equalToConstant: 72),
            
            weightValue.centerYAnchor.constraint(equalTo: weightRowView.centerYAnchor),
            weightValue.leadingAnchor.constraint(equalTo: weightRowView.leadingAnchor, constant: 15),
            weightValue.trailingAnchor.constraint(equalTo: weightRowLabel.leadingAnchor, constant: -4),
            
            weightRowLabel.centerYAnchor.constraint(equalTo: weightRowView.centerYAnchor),
            weightRowLabel.trailingAnchor.constraint(equalTo: weightRowView.trailingAnchor, constant: -15),
            weightRowLabel.leadingAnchor.constraint(greaterThanOrEqualTo: weightRowView.leadingAnchor),
            
            separator3.bottomAnchor.constraint(equalTo: weightRowView.bottomAnchor),
            separator3.leadingAnchor.constraint(equalTo: weightRowView.leadingAnchor),
            separator3.trailingAnchor.constraint(equalTo: weightRowView.trailingAnchor),
            separator3.heightAnchor.constraint(equalToConstant: 1),
            
            contentView.bottomAnchor.constraint(equalTo: weightRowView.bottomAnchor),
            
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15.5),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.5),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            buttonConstraint
        ])
    }
    
    private func setAddButton(enabled: Bool) {
        addButton.isUserInteractionEnabled = enabled
        addButton.isEnabled = enabled
    }
    
    @objc private func keyboardWillShow(_ notification : Notification?) -> Void {
        var _kbSize:CGSize!
        if let info = notification?.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                let screenSize = UIScreen.main.bounds
                let intersectRect = kbFrame.intersection(screenSize)
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                
                keyboardSize = _kbSize.height
            }
        }
    }
    
    @objc private func addWeight() {
        guard let weight = weightValue.text?.floatValue else { return }
        if let editWeightIndexPath = editWeightIndexPath {
            viewModel.editWeight(indexPath: editWeightIndexPath, weight: weight, date: datePicker.date)
        } else {
            viewModel.addWeight(weight: weight, date: datePicker.date)
        }
        completion?()
    }
    
    @objc private func showDatePicker() {
        dismissMyKeyboard()
        NSLayoutConstraint.deactivate([
            datePickerConstraint
        ])
        datePickerConstraint = datePickerView.heightAnchor.constraint(equalToConstant: 216)
        NSLayoutConstraint.activate([
            datePickerConstraint
        ])
    }
    
    @objc private func updateDateRowValue() {
        dateRowValue.setTitle(datePicker.date.displayDate(), for: .normal)
    }
    
    @objc
    private func textFieldDidChange() {
        guard let text = weightValue.text else { return }
        viewModel.didEnter(text)
    }
}

extension WeightVC {
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        keyboardSize = 0
        view.endEditing(true)
    }
}
