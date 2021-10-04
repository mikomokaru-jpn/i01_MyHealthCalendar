import UIKit

//------------------------------------------------------------------------------
//  BPDataEntryView.swift
//------------------------------------------------------------------------------
//定数
let upperNormal = 135
let lowerNormal = 85
//プロトコル宣言
protocol BPDataEntryViewDelegate: class  {
    func renewalView()
}
class BPDataEntryView: UIView, BPButtonDelegate, BPValueViewDelegate {
    var thisDate: UACalendarDate?       //対象日
    var dateLabel: UALabel              //日付ラベル
    var btns: [BPButton] = []           //数値ボタン配列
    var upperView: BPValueView          //最高血圧入力エリア
    var lowerView: BPValueView          //最低血圧入力エリア
    var confirmCheck: BPAcceptButton    //確定チェックボックス
    var currentView: BPValueView        //現在ビュー
    var saveLowerValue: Int = 0         //最高血圧（保存）
    var saveUpperValue: Int = 0         //最低血圧（保存）
    var saveConfirmFlg: Bool = false    //確定フラグ（保存）
    weak var delegate: BPDataEntryViewDelegate?  //デリゲート変数
    
    //--------------------------------------------------------------------------
    // イニシャライザ
    //--------------------------------------------------------------------------
    init(){
        dateLabel = UALabel.init(point: CGPoint(x:15, y:15))
        upperView = BPValueView.init(frame: CGRect(x:15, y:100 ,width: 110 ,height:50))
        lowerView = BPValueView.init(frame: CGRect(x:15, y:190 ,width: 110 ,height:50))
        confirmCheck = BPAcceptButton.init(frame: CGRect(x:15, y:255 ,width:20 ,height:20))
        //血圧入力エリア
        currentView = upperView
        upperView.selectedColor()
        lowerView.defaultColor()
        //**** super classオブジェクトの作成 ****
        let myFrame = CGRect(x: 0, y: 0, width: 364 , height: 270)
        super.init(frame: myFrame)
        self.backgroundColor = UIColor.darkGray
        self._init()
    }
    //--------------------------------------------------------------------------
    // 初期処理
    //--------------------------------------------------------------------------
    private func _init(){
        //数値ボタンの作成
        let xPos:CGFloat = 150
        let yPos:CGFloat = 70
        for i in 0..<10{
            let btn = BPButton.init(rect:CGRect(x:0, y:0, width:71, height:71),
                                    num: i, delegate: self)
            btn.fontSize = 48
            btns += [btn]
            self.addSubview(btn)
        }
        //数値ボタンの配置場所
        let span:CGFloat = 70;
        btns[7].frame.origin = CGPoint(x:xPos, y:yPos)
        btns[8].frame.origin = CGPoint(x:xPos+span, y:yPos)
        btns[9].frame.origin = CGPoint(x:xPos+span*2, y:yPos)
        btns[4].frame.origin = CGPoint(x:xPos, y:yPos+span)
        btns[5].frame.origin = CGPoint(x:xPos+span, y:yPos+span)
        btns[6].frame.origin = CGPoint(x:xPos+span*2, y:yPos+span)
        btns[1].frame.origin = CGPoint(x:xPos, y:yPos+span*2)
        btns[2].frame.origin = CGPoint(x:xPos+span, y:yPos+span*2)
        btns[3].frame.origin = CGPoint(x:xPos+span*2, y:yPos+span*2)
        btns[0].frame.origin = CGPoint(x:xPos, y:yPos+span*3)
        //クリアボタンの作成
        let rect = CGRect(x:xPos+span, y:yPos+span*3, width:141, height:71)
        let btnClear = BPButton.init(rect:rect, num: -1, delegate: self)
        btnClear.fontSize = 48
        self.addSubview(btnClear)
        //登録ボタンの作成
        let btnClose = UIButton(type: .roundedRect)
        btnClose.frame = CGRect(x:15, y:290, width:110, height:50)
        btnClose.addTarget(self, action: #selector(self.update), for: .touchUpInside)
        btnClose.setTitle("登録", for: .normal)
        btnClose.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        btnClose.backgroundColor = UIColor.white
        btnClose.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(btnClose)
        //キャンセルボタンの作成
        let btnCancel = UIButton(type: .roundedRect)
        btnCancel.frame = CGRect(x:344, y:15, width:30, height:30)
        btnCancel.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)
        btnCancel.setTitle("X", for: .normal)
        btnCancel.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btnCancel.backgroundColor = UIColor.white
        btnCancel.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(btnCancel)
        //日付ラベルの追加
        dateLabel.fontSize = 32
        dateLabel.backgroundColor = UIColor.darkGray
        dateLabel.color = UIColor.white
        self.addSubview(dateLabel)
        //最高血圧ラベルの追加
        let upperLabel = UALabel.init(point: CGPoint(x:15, y:70))
        upperLabel.text = "最高血圧"
        upperLabel.color = UIColor.white
        upperLabel.fontSize = 24
        upperLabel.backgroundColor = UIColor.darkGray
        self.addSubview(upperLabel)
        //最高血圧入力エリア
        upperView.fontSize = 48
        upperView.delegate = self
        self.addSubview(upperView)
        //最低血圧ラベルの追加
        let lowerLabel = UALabel.init(point: CGPoint(x:15, y:160))
        lowerLabel.text = "最低血圧"
        lowerLabel.color = UIColor.white
        lowerLabel.fontSize = 24
        lowerLabel.backgroundColor = UIColor.darkGray
        self.addSubview(lowerLabel)
        //最高血圧入力エリア
        lowerView.fontSize = 48
        lowerView.delegate = self
        self.addSubview(lowerView)
        //確定フラグ
        self.addSubview(confirmCheck)
        let checkLabel = UALabel.init(point: CGPoint(x:45, y:255))
        checkLabel.text = "確定"
        checkLabel.color = UIColor.white
        checkLabel.fontSize = 24
        checkLabel.backgroundColor = UIColor.darkGray
        self.addSubview(checkLabel)

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--------------------------------------------------------------------------
    // 血圧データの取得：
    //--------------------------------------------------------------------------
    func getData(date:UACalendarDate){
        thisDate = date //対象日
        let cmd = "http://192.168.11.3/doc_health_calendar/php/sql_r20.php"
        let param = String(format:"id=%ld&date=%ld",500 ,date.integerYearMonthDay)
        //DBレコードの取得
        let list = UAServerRequest.postSync(urlString:cmd, param:param)
        //受信データのキャスト  Any -> [[String:Int]]
        guard let records = list as? [[String:Int]] else{
            print("cast error")
            return
        }
        if records.count < 1{
            //レコードなし
            upperView.value = 0
            lowerView.value = 0
            confirmCheck.isChecked = false
        }else{
            //レコードあり・辞書の要素のアンンラップ
            guard let upper = records[0]["upper"],
                let lower = records[0]["lower"],
                let confirm = records[0]["confirm"] else{
                    print("error upper or lower is nill")
                    return
            }
            upperView.value = upper
            lowerView.value = lower
            confirmCheck.isChecked =  confirm.boolValue //confirmはInt
        }
        //変更前の値を保存
        saveLowerValue = lowerView.value
        saveUpperValue = upperView.value
        saveConfirmFlg = confirmCheck.isChecked
        //日付ラベル
        dateLabel.text = String(format:"%ld年%ld月%ld日(%@)",
                                date.year, date.month, date.day, date.strYobi)
        dateLabel.setNeedsDisplay()
        upperView.setNeedsDisplay()
        lowerView.setNeedsDisplay()
    }
    //--------------------------------------------------------------------------
    // DB更新して閉じる
    //--------------------------------------------------------------------------
    @objc func update(sender: UIButton){
        if saveLowerValue == lowerView.value &&
            saveUpperValue == upperView.value &&
            saveConfirmFlg == confirmCheck.isChecked{
            //値の変更がないので何もしない（DB読み込み時と値が同じ）
            self.removeFromSuperview()
        }
        //入力チェック
        if lowerView.value > upperView.value{
            /*
            messageField.text = "値が不正です。最低≧最高"
            messageField.needsDisplay = true
            */
            return
        }
        //DB更新
        let cmd = "http://192.168.11.3/doc_health_calendar/php/sql_w10.php"
        let param = String(format:"id=%ld&date=%ld&lower=%ld&upper=%ld&confirm=%ld",
                           500 ,thisDate!.integerYearMonthDay,
                           lowerView.value, upperView.value, confirmCheck.isChecked.inttValue)
        //DBレコードの取得
        let list = UAServerRequest.postSync(urlString:cmd, param:param)
        //受信データのキャスト  [Int]
        guard let records = list as? [Int] else{
            print("cast error")
            return
        }
        //戻り値のチェック
        if records[0] != 1 {
            print ("DB update error")
            return
        }
        //カレンダービューの再表示
        if delegate != nil{
            delegate?.renewalView()
        }
        self.removeFromSuperview()
    }
    //--------------------------------------------------------------------------
    // 閉じる
    //--------------------------------------------------------------------------
    @objc func cancel(sender: UIButton){
        self.removeFromSuperview()
    }
    //--------------------------------------------------------------------------
    // 数値の入力
    //--------------------------------------------------------------------------
    func touchNumber(_ btn:BPButton){
        if currentView.initialInput == true{
            //カーソルが移った直後に値を入力したときは、初期入力とする。
            currentView.value = 0
            currentView.initialInput = false
        }
        //入力値の判定
        if btn.number == -1{
            //Clearボタン
            currentView.value = 0
        }else{
            //値の追加。最大桁数は3桁
            currentView.value = currentView.value * 10 + btn.number
        }
        currentView.setNeedsDisplay()
        if currentView.value > 99{
            //3桁以上の入力は次の値入力ビューに移る
            self.changeView(from: currentView)
        }
    }
    //--------------------------------------------------------------------------
    // BPValueViewDelegate method
    //--------------------------------------------------------------------------
    func changeView(from: BPValueView){
        if currentView === upperView{
            upperView.defaultColor()
            lowerView.selectedColor()
            currentView = lowerView
        }else{
            upperView.selectedColor()
            lowerView.defaultColor()
            currentView = upperView
        }
        currentView.initialInput = true
    }
}
