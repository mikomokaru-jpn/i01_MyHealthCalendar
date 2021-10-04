//------------------------------------------------------------------------------
//  BPValueView.swift：血圧の入力フィールド
//------------------------------------------------------------------------------

import UIKit
//プロトコル宣言
protocol BPValueViewDelegate: class {
    func changeView(from: BPValueView)
}
class BPValueView: UIView{
    var fontSize: CGFloat = 12                      //フォントサイズ
    var initialInput:Bool = true                    //初期入力フラグ
    weak var delegate: BPValueViewDelegate?  = nil  //デリゲート変数
    private var _value:Int = 0                      //値
    private var _preValue:Int = 0                   //更新前の値
    private var aString = NSMutableAttributedString(string:"") //値（文字列）
    //--------------------------------------------------------------------------
    //イニシャライザ
    //--------------------------------------------------------------------------
    override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        self.backgroundColor = UIColor.white
        //タップアクションの登録
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--------------------------------------------------------------------------
    //ビューの再表示
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
        //血圧値の表示
        let x = (dirtyRect.size.width - aString.size().width) -
                (dirtyRect.size.width * 0.12)
        let y = (dirtyRect.size.height / 2) - (aString.size().height / 2)
        aString.draw(at: CGPoint(x:x, y:y))
        
    }
    //--------------------------------------------------------------------------
    //タップアクション
    //--------------------------------------------------------------------------
    @objc func tapped(_ sender: UITapGestureRecognizer){
        print("tapped")
        delegate?.changeView(from: self)
    }
    //--------------------------------------------------------------------------
    //アクセッサー
    //--------------------------------------------------------------------------
    var value:Int{
        get{
            return _value
        }
        set(inValue){
            _value = inValue
            let strValue = String(format:"%ld",inValue)
            aString = UATextAttribute.makeAttributedString(string: strValue, size: self.fontSize)
        }
    }
    //--------------------------------------------------------------------------
    //選択中の色にする
    //--------------------------------------------------------------------------
    func selectedColor(){
        self.backgroundColor = UIColor.yellow
        self.setNeedsDisplay()
    }
    //--------------------------------------------------------------------------
    //非選択中の色にする
    //--------------------------------------------------------------------------
    func defaultColor(){
        self.backgroundColor = UIColor.white
        self.setNeedsDisplay()
    }
}
