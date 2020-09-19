import UIKit

class RecycleTableViewCell: UITableViewCell {
    
    @IBOutlet var recycleBatchImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var recycleProgress: UIProgressView!
    
    @IBOutlet var waterCountLabel: UILabel!
    
    var progressBarTimer: Timer!
    
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
        self.waterCountLabel.text = "\(model.Water)"
        self.dateLabel.text = "Orders Recieved at: \(model.ScanDate)"
        handleProgressBar()
    }
    
    func handleProgressBar() {
        recycleProgress.layer.cornerRadius = 4
        recycleProgress.progressTintColor = UIColor.darkGray
        recycleProgress.clipsToBounds = true
        recycleProgress.subviews[1].clipsToBounds = true
        self.progressBarTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateProgressView() {
        recycleProgress.progress += 0.1
        recycleProgress.setProgress(recycleProgress.progress, animated: true)
        if(recycleProgress.progress == 1.0) {
            progressBarTimer.invalidate()
        }
    }
    
}
