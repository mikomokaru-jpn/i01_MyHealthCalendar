//------------------------------------------------------------------------------
//  ViewController.swift
//------------------------------------------------------------------------------
import UIKit
class ViewController: UIViewController {
    var uaView: UAView? = nil                   //カレンダービュー
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        //カレンダービューの作成と表示
        uaView = UAView.init()
        guard let uaView = self.uaView else {
            return
        }
        //表示位置の決定
        let mid = self.view.frame.size.width / 2
        let x = mid - (uaView.frame.width / 2)
        uaView.frame.origin = CGPoint(x: x, y: 50)
        self.view.addSubview(uaView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
