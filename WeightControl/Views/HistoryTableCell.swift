import UIKit

class HistoryTableCell: UITableViewCell {
    static let reuseIdentifier = "HistoryTableCell"
    
    var viewModel: WeightViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            
            weightValue.text = "\(viewModel.weight.weightFormatted)"
            differenceValue.text = "\(viewModel.difference.weightDifferenceFormatted)"
            if let units = viewModel.units,
               let text = differenceValue.text {
                differenceValue.text = text + " " + units
            }
            dateValue.text = viewModel.date.displayDate()
        }
    }
    
    private let containerView = UIViewAutoLayout()
    private let weightValue = UILabel().customStyle(style: .measurementSystemLabel, text: "")
    private let differenceValue = UILabel().customStyle(style: .weightDifference, text: "")
    private let dateValue = UILabel().customStyle(style: .dateLabel, text: "")
    private let arrowRight = UIImageView(image: UIImage(named: "arrowright"))
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configCell()
    }
    
    func configCell() {
        contentView.addSubview(containerView)
        containerView.addSubview(weightValue)
        containerView.addSubview(differenceValue)
        containerView.addSubview(dateValue)
        containerView.addSubview(arrowRight)
        arrowRight.translatesAutoresizingMaskIntoConstraints = false
        
        let column1and2widthRatio = 35.47
        let column1and2width = ((contentView.bounds.width + 16.0) / 100.0) * column1and2widthRatio
        let column3Width = (contentView.bounds.width + 16.0) - column1and2width
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 22),
            
            weightValue.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            weightValue.widthAnchor.constraint(equalToConstant: column1and2width),
            weightValue.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            differenceValue.leadingAnchor.constraint(equalTo: weightValue.trailingAnchor, constant: 8),
            differenceValue.widthAnchor.constraint(equalToConstant: column1and2width),
            differenceValue.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            dateValue.leadingAnchor.constraint(equalTo: differenceValue.trailingAnchor, constant: 8),
            dateValue.widthAnchor.constraint(equalToConstant: column3Width),
            dateValue.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            arrowRight.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            arrowRight.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            arrowRight.widthAnchor.constraint(equalToConstant: 20),
            arrowRight.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for view in subviews where view != contentView {
            view.removeFromSuperview()
        }
    }
}
