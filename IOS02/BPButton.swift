//------------------------------------------------------------------------------
//  BPButton.swift
//------------------------------------------------------------------------------
import UIKit
protocol BPButtonDelegate: class { //プロトコル宣言
    func touchNumber(_ btn:BPButton)
}
class BPButton: UIButton {
    var number: Int //数値
    weak var delegate: BPButtonDelegate?  = nil  //デリゲート変数
    //フォントサイズ
    var fontSize:CGFloat = 12 {
        didSet{
            self.titleLabel?.font =  UIFont.init(name:"Arial", size:fontSize) ??
                UIFont.systemFont(ofSize: fontSize)
        }
    }
    //--------------------------------------------------------------------------
    //イニシャライザ
    //--------------------------------------------------------------------------
    init(rect:CGRect, num:Int, delegate:BPButtonDelegate){
        number = num
        super.init(frame: rect) //指定イニシャライザ
 
        self.delegate = delegate
        self.addTarget(self, action: #selector(self.touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(self.touchUp), for: .touchUpInside)
        //タイトル（数字）のセット
        if self.number == -1{
            self.setTitle("C", for: .normal)
        }else{
            self.setTitle(String(format:"%ld", self.number), for: .normal)
        }
        //外見の設定
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.backgroundColor = UIColor.white.cgColor
        self.setTitleColor(UIColor.black, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--------------------------------------------------------------------------
    //ビューの再表示
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect) //最後に行う
    }
    //--------------------------------------------------------------------------
    // タップした（Down）
    //--------------------------------------------------------------------------
    @objc func touchDown(sender: UIButton) {
        delegate?.touchNumber(self)
        //クリックした数字を入力フィールドに追加する。自オブジェクトを引数とする
        self.layer.backgroundColor = UIColor.yellow.cgColor
    }
    //--------------------------------------------------------------------------
    // タップした（Up）
    //--------------------------------------------------------------------------
    @objc func touchUp(sender: UIButton) {
        //クリックした数字を入力フィールドに追加する。自オブジェクトを引数とする
        self.layer.backgroundColor = UIColor.white.cgColor
    }
}
