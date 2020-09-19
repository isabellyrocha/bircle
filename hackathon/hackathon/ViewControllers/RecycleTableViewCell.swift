import UIKit

class RecycleTableViewCell: UITableViewCell {
    
    @IBOutlet var recycleBatchImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var recycleRequest: UIButton!
    
    @IBOutlet var beerStepper: UIStepper!
    @IBOutlet var waterStepper: UIStepper!
    @IBOutlet var colaStepper: UIStepper!
    
    @IBOutlet var waterCountLabel: UILabel!
    @IBOutlet var beerCountLabel: UILabel!
    @IBOutlet var colaCountLabel: UILabel!
    
    @IBOutlet var waterView: UIImageView!
    @IBOutlet var beerView: UIImageView!
    @IBOutlet var colaView: UIImageView!
    
    static let identifier = "RecycleTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RecycleTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: FeedItem){
        self.colaCountLabel.text = "\(model.Cola)"
        self.beerCountLabel.text = "\(model.Beer)"
        self.waterCountLabel.text = "\(model.Water)"
        self.dateLabel.text = "\(model.ScanDate)"
    }
    
}
