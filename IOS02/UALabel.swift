//------------------------------------------------------------------------------
//  UALabel.swift
//------------------------------------------------------------------------------
import UIKit
class UALabel: UIView {
    var atrStr = NSMutableAttributedString.init(string: "")     //表示テキスト
    private var str_ : String = ""                              //テキスト文字列
    private var fontSize_: CGFloat = 12.0                       //フォントサイズ
    private var color_:UIColor = UIColor.black                  //文字の色

    //--------------------------------------------------------------------------
    //イニシャライザ
    //--------------------------------------------------------------------------
    init(point: CGPoint) {
        let frame = CGRect(x:point.x, y:point.y, width:0, height:0)
        super.init(frame: frame)
        self.fontSize_ = 12
        self.color_ = UIColor.black
        self.text = "あ" //初期値
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--------------------------------------------------------------------------
    //アクセッサー：テキスト文字列
    //--------------------------------------------------------------------------
    var text:String{
        get{
            return str_
        }
        set{
            str_ = newValue
            self.setting()
        }
    }
    //--------------------------------------------------------------------------
    //アクセッサー：フォントサイズ
    //--------------------------------------------------------------------------
    var fontSize:CGFloat{
        get{
            return fontSize_
        }
        set{
            fontSize_ = newValue
            self.setting()
        }
    }
    //--------------------------------------------------------------------------
    //アクセッサー：文字の色
    //--------------------------------------------------------------------------
    var color: UIColor{
        get{
            return color_
        }
        set{
            color_ = newValue
            self.setting()
        }
    }
    //--------------------------------------------------------------------------
    //属性付き文字列の作成
    //--------------------------------------------------------------------------
    private func setting(){
        atrStr = UATextAttribute.makeAttributedString(
            string:str_, size:fontSize_, color:color_)
        //テキストの長さに合わせてフレームの大きさを変える
        self.frame.size.width = atrStr.size().width
        self.frame.size.height = atrStr.size().height
    }
    //--------------------------------------------------------------------------
    //ビューの再描画（左揃え）
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
        atrStr.draw(at: CGPoint(x: 0, y: 0))
    }
}
