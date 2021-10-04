//------------------------------------------------------------------------------
//  UAItemView.swift
//------------------------------------------------------------------------------
import UIKit
//プロトコル宣言
protocol UAItemViewDelegate: class  {
    func dateSelect(index: Int)
}
class UAItemView: UIView {
    var index: NSInteger = 0                                //インデックス
    var aString: NSAttributedString?                        //表示文字列
    weak var delegate: UAItemViewDelegate?  = nil           //デリゲート
    var upper: Int = 0;                                     //最高血圧
    var lower: Int = 0;                                     //最低血圧
    var confirm: Bool = false                               //確定フラグ
    //イニシャライザ
    override init(frame: CGRect) {
        super.init(frame: frame)
        //2タップ
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapped(_:)))
        tapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGesture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--------------------------------------------------------------------------
    //2タップ；データ入力ビューを表示する
    //--------------------------------------------------------------------------
    @objc func tapped(_ sender: UITapGestureRecognizer){
        delegate?.dateSelect(index: index)
    }
    //--------------------------------------------------------------------------
    //ビューの再表示
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
        if (index < 0){
            //月末一週間を非表示
            self.isHidden = true;
            return;
        }
        //初期値
        let path1 = UIBezierPath.init(
            rect: CGRect(x:0, y:0,width:self.frame.size.width,
                         height:self.frame.size.height))
        UIColor.white.set()
        path1.stroke()
        //日付の表示
        self.isHidden = false;
        let x = (self.frame.size.width/2)-(aString!.size().width/2)
        let y = (self.frame.size.height/2)-(aString!.size().height/2)
        aString?.draw(at: CGPoint(x: x, y: y))
        //血圧入力済みの印
        if confirm{
            let rect = CGRect(x: 3, y: 3,
                              width: self.frame.size.width - 6,
                              height: self.frame.size.height - 6)
            let path = UIBezierPath.init(ovalIn: rect)
            path.lineWidth = 2.0
            UIColor.init(red: 1.0, green: 0, blue: 0, alpha: 0.5).set()
            path.stroke()
        }
    }
    //--------------------------------------------------------------------------
    // 日付の選択
    //--------------------------------------------------------------------------
    func selectOn(){
        self.layer.borderWidth = 2.5
        self.layer.borderColor = UIColor.blue.cgColor
        self.setNeedsDisplay()
    }
    //--------------------------------------------------------------------------
    // 日付の選択を外す
    //--------------------------------------------------------------------------
    func selectOff(){
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setNeedsDisplay()
    }
}
