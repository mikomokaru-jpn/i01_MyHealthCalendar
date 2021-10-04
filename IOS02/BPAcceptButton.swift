//------------------------------------------------------------------------------
//  BPAcceptButton.swift：確定フラグ
//------------------------------------------------------------------------------
import UIKit
class BPAcceptButton: UIButton {
    private var isChecked_: Bool = false
    let checkedImage = UIImage(named: "icon_check")! as UIImage
    //チェックフラグ
    var isChecked: Bool {
        get{
            return isChecked_
        }
        set{
            isChecked_ = newValue
            if isChecked_ == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(nil, for: UIControl.State.normal)
            }
        }
    }
    //--------------------------------------------------------------------------
    //イニシャライザ
    //--------------------------------------------------------------------------
    override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.isChecked = false
        //タップアクションの登録
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(tapGesture)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    
    //--------------------------------------------------------------------------
    // フラグの変更
    //--------------------------------------------------------------------------
    @objc func tapped(_ sender: UITapGestureRecognizer){
        isChecked = !isChecked
    }
}

