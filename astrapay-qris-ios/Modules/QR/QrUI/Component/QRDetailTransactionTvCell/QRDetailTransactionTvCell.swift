

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
    @IBOutlet weak var lblValueJumlahTransaksi: QRUILabelInterRegular!
    @IBOutlet weak var lblValuePercentageTips: QRUILabelInterMedium!
    @IBOutlet weak var lblValueTips: QRUILabelInterRegular!
    @IBOutlet weak var lblValueTotalPayment: QRUILabelInterSemiBold!
    @IBOutlet weak var viewBtnEditTips: QRAPButtonAtom!


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
        lblValueJumlahTransaksi.text = payloadView.jumlahTransaksi.toIDRQR(withSymbol: true)
        setTips(tipsPercentage: payloadView.tipsPercentage, tips: payloadView.tips, tipType: payloadView.tipType)

        //ini total payment dari hasil tambah jumlah transaksi dan tips
        lblValueTotalPayment.text = payloadView.totalPayment.toIDRQR(withSymbol: true)

    }



    func setupAction(){
        viewBtnEditTips.coreButton.addTapGestureRecognizerQR{
            self.delegate?.didPressTipsButton()
        }
    }
}

extension QRDetailTransactionTvCell {
    func setTips(tipsPercentage: String, tips:Int,tipType : QRISNewTipType){
        //5% = 05.00%
        //
//        var stringPercentage : String = ""
//        if tipsPercentage < 10 {
//            stringPercentage = "0\(String(Int(tipsPercentage)))." + "00%"
//        }else {
//            stringPercentage = "\(String(Int(tipsPercentage)))." + "00%"
//        }
//


    //MARK: ini hanya percobaan
//    var tipeTip = QRISNewTipType.any
        switch tipType {
        case .fixed :
            lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips
            viewBtnEditTips.isHidden = true
            if tips != 0 {
                lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips
                lblValueTips.text = tips.toIDRQR()
            }else {
                lblValueTips.text = "FREE"
            }
        case .any :
            lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips
            viewBtnEditTips.isHidden = false
            lblValueTips.text = tips.toIDRQR()
        case .percentage :
            viewBtnEditTips.isHidden = true
            if Double(tipsPercentage) != 0 {
                lblValuePercentageTips.text = QRDetailTransactionTvCell.titleTips + " (\(tipsPercentage)%)"
                lblValueTips.text = tips.toIDRQR()//"\(tips) %"
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
