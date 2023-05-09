import UIKit

class HomeVC: UIViewController {
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case metricMeasurements
    }
    
    private var convertionK: Float = 1.0 {
        didSet {
            viewModel?.convertionK = convertionK
            historyTable.reloadData()
        }
    }
    private var viewModel: WeightsViewModel?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let pageContentView: UIView = {
        let pageContentView = UIView(frame: .zero)
        pageContentView.translatesAutoresizingMaskIntoConstraints = false
        return pageContentView
    }()
    
    private let titleLabel = UILabel().customStyle(style: .title, text: "Монитор веса")
    
    private let widget: UIView = {
        let view = UIViewAutoLayout()
        view.backgroundColor = UIColor().getProjectUIColor(color: .wchngWidget)// UIColor(named: "WCHNGWidget")
        view.layer.cornerRadius = 12
        
        let imageView = UIImageView(image: UIImage(named: "widgetImage"))
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner]
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let widgetContentView = UIViewAutoLayout()
    private let widgetTitleView = UIViewAutoLayout()
    private let widgetTitle = UILabel().customStyle(style: .widgetTitle, text: "Текущий вес")
    private let weightValueView = UIViewAutoLayout()
    private let weightValue = UILabel().customStyle(style: .weightValue, text: "")
    private let weightDifference = UILabel().customStyle(style: .weightDifference, text: "")
    private let measurementSystemLabel = UILabel().customStyle(style: .measurementSystemLabel, text: "Метрическая система")
    private let measurementSystemSwitch: UISwitch = {
        let measurementSystemSwitch = UISwitch()
        measurementSystemSwitch.layer.cornerRadius = 16.0
        measurementSystemSwitch.onTintColor = UIColor().getProjectUIColor(color: .wchngPurple)
        measurementSystemSwitch.isOn = true
        measurementSystemSwitch.translatesAutoresizingMaskIntoConstraints = false
        return measurementSystemSwitch
    }()
    private let historySectionView = UIViewAutoLayout()
    private let historySectionLabel = UILabel().customStyle(style: .title, text: "История")
    private let historyTable = ContentSizedTableView()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTable()
        setupConstraints()
    }
    
    func initialize(viewModel: WeightsViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.onWeightsUpdate = { [weak self] in
            guard let self = self else { return }
            self.historyTable.reloadData()
            self.weightValue.text = String(format: "%.1f", viewModel.lastWeight?.weight ?? 0) + " \(viewModel.units)"
            self.weightDifference.text = (viewModel.lastWeight?.difference.weightDifferenceFormatted ?? "0") + " \(viewModel.units)"
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(pageContentView)
        
        pageContentView.addSubview(widget)
        
        widget.addSubview(widgetContentView)
        widgetContentView.addSubview(widgetTitleView)
        widgetTitleView.addSubview(widgetTitle)
        
        widgetContentView.addSubview(weightValueView)
        weightValueView.addSubview(weightValue)
        weightValueView.addSubview(weightDifference)
        widgetContentView.addSubview(measurementSystemSwitch)
        measurementSystemSwitch.setOn(userDefaults.bool(forKey: Keys.metricMeasurements.rawValue), animated: false)
        
        if measurementSystemSwitch.isOn {
            convertionK = 1.0
        } else {
            convertionK = Const.kgToFt
        }
        
        measurementSystemSwitch.addTarget(self, action: #selector(toggleMeasurementSystem), for: .valueChanged)
        widgetContentView.addSubview(measurementSystemLabel)
            
        NSLayoutConstraint.activate([
            widgetContentView.topAnchor.constraint(equalTo: widget.topAnchor, constant: 16),
            widgetContentView.leadingAnchor.constraint(equalTo: widget.leadingAnchor, constant: 16),
            widgetContentView.trailingAnchor.constraint(equalTo: widget.trailingAnchor, constant: -16),
            widgetContentView.bottomAnchor.constraint(equalTo: widget.bottomAnchor, constant: -16),
            
            widgetTitleView.topAnchor.constraint(equalTo: widgetContentView.topAnchor),
            widgetTitleView.leadingAnchor.constraint(equalTo: widgetContentView.leadingAnchor),
            widgetTitleView.trailingAnchor.constraint(equalTo: widgetTitle.trailingAnchor),
            widgetTitleView.heightAnchor.constraint(equalToConstant: 18),
            
            widgetTitle.centerYAnchor.constraint(equalTo: widgetTitleView.centerYAnchor),
            widgetTitle.leadingAnchor.constraint(equalTo: widgetTitleView.leadingAnchor),
            
            weightValueView.topAnchor.constraint(equalTo: widgetTitleView.bottomAnchor, constant: 6),
            weightValueView.leadingAnchor.constraint(equalTo: widgetContentView.leadingAnchor),
            weightValueView.trailingAnchor.constraint(equalTo: weightValue.trailingAnchor),
            weightValueView.heightAnchor.constraint(equalToConstant: 26),
            
            weightValue.centerYAnchor.constraint(equalTo: weightValueView.centerYAnchor),
            weightValue.leadingAnchor.constraint(equalTo: weightValueView.leadingAnchor),
            
            weightDifference.leadingAnchor.constraint(equalTo: weightValue.trailingAnchor, constant: 8),
            weightDifference.bottomAnchor.constraint(equalTo: weightValue.bottomAnchor),
            
            measurementSystemSwitch.topAnchor.constraint(equalTo: weightValueView.bottomAnchor, constant: 16),
            measurementSystemSwitch.leadingAnchor.constraint(equalTo: widgetContentView.leadingAnchor),
            
            measurementSystemLabel.centerYAnchor.constraint(equalTo: measurementSystemSwitch.centerYAnchor),
            measurementSystemLabel.leadingAnchor.constraint(equalTo: measurementSystemSwitch.trailingAnchor, constant: 16),
        ])
        
        pageContentView.addSubview(historySectionView)
        historySectionView.addSubview(historySectionLabel)
        
        pageContentView.addSubview(historyTable)
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(showAddWeightVC), for: .touchUpInside)
    }
    
    private func showToast(message : String) {
        let toastLabelView = UIViewAutoLayout()
        let toastLabel = UILabel().customStyle(style: .toast, text: message)
        
        toastLabelView.backgroundColor = UIColor().getProjectUIColor(color: .wchngBlack)
        toastLabelView.layer.cornerRadius = 12;
        
        toastLabelView.addSubview(toastLabel)
        self.view.addSubview(toastLabelView)
        
        NSLayoutConstraint.activate([
            toastLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            toastLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            toastLabelView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            toastLabelView.heightAnchor.constraint(equalToConstant: 52),
            
            toastLabel.leadingAnchor.constraint(equalTo: toastLabelView.leadingAnchor, constant: 16),
            toastLabel.trailingAnchor.constraint(equalTo: toastLabelView.trailingAnchor, constant: -16),
            toastLabel.centerYAnchor.constraint(equalTo: toastLabelView.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 4.0, delay: 1, options: .curveEaseOut, animations: {
             toastLabelView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabelView.removeFromSuperview()
        })
    }
    
    @objc private func showAddWeightVC() {
        guard let viewModel = viewModel else { return }
        let vc = WeightVC(viewModel: viewModel)
        vc.completion = { [weak self] in
            self?.viewModel?.updateWeights()
            self?.view.layoutIfNeeded()
            self?.showToast(message: "Добавлено новое измерение")
            self?.dismiss(animated: true)
        }
        present(vc, animated: true)
    }
    
    @objc private func toggleMeasurementSystem() {
        if measurementSystemSwitch.isOn {
            userDefaults.set(true, forKey: Keys.metricMeasurements.rawValue)
            convertionK = 1.0
        } else {
            userDefaults.set(false, forKey: Keys.metricMeasurements.rawValue)
            convertionK = Const.kgToFt
        }
    }
    
    private func configureTable() {
        historyTable.translatesAutoresizingMaskIntoConstraints = false
        historyTable.register(HistoryTableCell.self, forCellReuseIdentifier: HistoryTableCell.reuseIdentifier)
        historyTable.separatorInset = UIEdgeInsets.zero
        historyTable.layoutMargins = UIEdgeInsets.zero
        historyTable.dataSource = self
        historyTable.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor),
            
            
            pageContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            pageContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            pageContentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            widget.topAnchor.constraint(equalTo: pageContentView.topAnchor),
            widget.leadingAnchor.constraint(equalTo: pageContentView.leadingAnchor),
            widget.trailingAnchor.constraint(equalTo: pageContentView.trailingAnchor),
            widget.heightAnchor.constraint(equalToConstant: 129),
            
            historySectionView.topAnchor.constraint(equalTo: widget.bottomAnchor, constant: 16),
            historySectionView.leadingAnchor.constraint(equalTo: pageContentView.leadingAnchor),
            historySectionView.trailingAnchor.constraint(equalTo: pageContentView.trailingAnchor),
            historySectionView.heightAnchor.constraint(equalToConstant: 24),
            
            historyTable.topAnchor.constraint(equalTo: historySectionView.bottomAnchor, constant: 16),
            historyTable.leadingAnchor.constraint(equalTo: pageContentView.leadingAnchor),
            historyTable.trailingAnchor.constraint(equalTo: pageContentView.trailingAnchor),
            historyTable.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -149),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 4),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 80),
            addButton.widthAnchor.constraint(equalToConstant: 80),
            
            pageContentView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor),
            
        ])
    }
    
    private func deleteWeight(indexPath: IndexPath) {
        viewModel?.deleteWeight(indexPath: indexPath)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.weightsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableCell.reuseIdentifier, for: indexPath) as? HistoryTableCell,
              let viewModel = viewModel        
        else { return HistoryTableCell() }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        cell.viewModel = cellViewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIViewAutoLayout()
                
        let column1and2widthRatio = 35.47
        let column1and2width = (tableView.frame.width / 100.0) * column1and2widthRatio
        let column3Width = tableView.frame.width - column1and2width
        
        let headerFirstCellLabel = UILabel().customStyle(style: .widgetTitle, text: "Вес")
        let headerSecondCellLabel = UILabel().customStyle(style: .widgetTitle, text: "Изменения")
        let headerThirdCellLabel = UILabel().customStyle(style: .widgetTitle, text: "Дата")
        
        let headerFirstCellView = UIViewAutoLayout()
        let headerSecondCellView = UIViewAutoLayout()
        let headerThirdCellView = UIViewAutoLayout()
        
        let separator = UIViewAutoLayout()
        separator.backgroundColor = UIColor().getProjectUIColor(color: .tableHeaderSeparator)
        
        headerFirstCellView.addSubview(headerFirstCellLabel)
        headerSecondCellView.addSubview(headerSecondCellLabel)
        headerThirdCellView.addSubview(headerThirdCellLabel)
        headerView.addSubview(headerFirstCellView)
        headerView.addSubview(headerSecondCellView)
        headerView.addSubview(headerThirdCellView)
        headerView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            headerView.widthAnchor.constraint(equalToConstant: tableView.frame.width),
            headerView.heightAnchor.constraint(equalToConstant: 27),
            
            headerFirstCellView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerFirstCellView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerFirstCellView.widthAnchor.constraint(equalToConstant: column1and2width),
            headerFirstCellView.heightAnchor.constraint(equalToConstant: 18),
            
            headerSecondCellView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerSecondCellView.leadingAnchor.constraint(equalTo: headerFirstCellView.trailingAnchor, constant: 0),
            headerSecondCellView.widthAnchor.constraint(equalToConstant: column1and2width),
            headerSecondCellView.heightAnchor.constraint(equalToConstant: 18),
            
            headerThirdCellView.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerThirdCellView.leadingAnchor.constraint(equalTo: headerSecondCellView.trailingAnchor, constant: 0),
            headerThirdCellView.widthAnchor.constraint(equalToConstant: column3Width),
            headerThirdCellView.heightAnchor.constraint(equalToConstant: 18),
            
            headerFirstCellLabel.centerYAnchor.constraint(equalTo: headerFirstCellView.centerYAnchor),
            headerFirstCellLabel.leadingAnchor.constraint(equalTo: headerFirstCellView.leadingAnchor),
            
            headerSecondCellLabel.centerYAnchor.constraint(equalTo: headerSecondCellView.centerYAnchor),
            headerSecondCellLabel.leadingAnchor.constraint(equalTo: headerSecondCellView.leadingAnchor),
            
            headerThirdCellLabel.centerYAnchor.constraint(equalTo: headerThirdCellView.centerYAnchor),
            headerThirdCellLabel.leadingAnchor.constraint(equalTo: headerThirdCellView.leadingAnchor),
            
            separator.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Ред.") { [weak self] (action, view, completionHandler) in
            guard let viewModel = self?.viewModel else { completionHandler(false); return }
            let vc = WeightVC(viewModel: viewModel)
            vc.editWeightIndexPath = indexPath
            vc.completion = { [weak self] in
                viewModel.updateWeights()
                self?.showToast(message: "Изменения сохранены")
                self?.dismiss(animated: true)
            }
            self?.present(vc, animated: true)
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            self?.deleteWeight(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}
