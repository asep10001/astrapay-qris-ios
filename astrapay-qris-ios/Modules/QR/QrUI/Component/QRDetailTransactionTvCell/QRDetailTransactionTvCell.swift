

import UIKit


struct QRDetailTransactionCellPayload{
    var jumlahTransaksi : Int
    var totalPayment  : Int
    var isUseTips : Bool = false
    var tips : Int
    var tipsPercentage : String
    var tipType : QRISNewTipType
}

protocol QRDetailTransactionTvCellProtocol : class {
    func didPressTipsButton()
}

class QRDetailTransactionTvCell: UITableViewCell {
    @IBOutlet weak var lblValueJumlahTransaksi: UILabelInterRegular!
    @IBOutlet weak var lblValuePercentageTips: UILabelInterMedium!
    @IBOutlet weak var lblValueTips: UILabelInterRegular!
    @IBOutlet weak var lblValueTotalPayment: UILabelInterSemiBold!
    @IBOutlet weak var viewBtnEditTips: APButtonAtom!


    static let identifier = "qRDetailTransactionTvCellIdentifier"
    static let nibName = "QRDetailTransactionTvCell"
    static let heightOfCell : CGFloat = 147
    private static let titleTips = "Uang Tip"
    var delegate : QRDetailTransactionTvCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    //MARK: Setup view
    func setupView(payloadView : QRDetailTransactionCellPayload){

        //ini hasil dari input amount
        lblValueJumlahTransaksi.text = payloadView.jumlahTransaksi.toIDR(withSymbol: true)
        setTips(tipsPercentage: payloadView.tipsPercentage, tips: payloadView.tips, tipType: payloadView.tipType)

        //ini total payment dari hasil tambah jumlah transaksi dan tips
        lblValueTotalPayment.text = payloadView.totalPayment.toIDR(withSymbol: true)

    }



    func setupAction(){
        viewBtnEditTips.coreButton.addTapGestureRecognizer{
            self.delegate?.didPressTipsButton()
        }
    }
}

extension QRDetailTransactionTvCell {
    func setTips(tipsPercentage: String, tips:Int,tipType : QRISNewTipType){


    //MARK: ini hanya percobaan
//    var tipeTip = QRISNewTipType.any
        switch tipType {
        case .fixed :
            lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips
            viewBtnEditTips.isHidden = true
            if tips != 0 {
                lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips
                lblValueTips.text = tips.toIDR()
            }else {
                lblValueTips.text = "FREE"
            }
        case .any :
            lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips
            viewBtnEditTips.isHidden = false
            lblValueTips.text = tips.toIDR()
        case .percentage :
            viewBtnEditTips.isHidden = true
            if Double(tipsPercentage) != 0 {
                lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips + " (\(tipsPercentage)%)"
                lblValueTips.text = tips.toIDR()//"\(tips) %"
            }else {
                lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips + " (\(tipsPercentage)%)"
                lblValueTips.text = "Rp. 0"
            }
        default:
            lblValueTips.text = "FREE"
            viewBtnEditTips.isHidden = true
        }

    }
}
