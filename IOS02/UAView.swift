import UIKit
//------------------------------------------------------------------------------
// Int拡張：0->false 0以外->true を返す
//------------------------------------------------------------------------------
extension Int {
    var boolValue: Bool { return self != 0 } //比較演算
}
//------------------------------------------------------------------------------
// Bool拡張：false->0 true->1 を返す
//------------------------------------------------------------------------------
extension Bool {
    var inttValue: Int { return self == true ? 1 : 0 }
}
//------------------------------------------------------------------------------
//  UAView.swift
//------------------------------------------------------------------------------
class UAView: UIView, UAItemViewDelegate, BPDataEntryViewDelegate {
    //定数
    var WIDTH:CGFloat = 0                           //カレンダーの幅
    var HEIGHT:CGFloat = 0;                         //カレンダーの高さ
    let DIFF:CGFloat = 40.0;                        //カレンダーの高さの差
    let CELL_WIDTH: CGFloat = 52.0                  //日付の幅
    let CELL_HEIGHT: CGFloat = 52.0                 //日付の高さ
    let FONT_NORMAL: CGFloat = 34.0                 //数字の大きさ（普通）
    let FONT_SMALL: CGFloat = 26.0                  //数字の大きさ（小さい）
    //プロパティ
    var currentDate:Date                            //現在日
    var thisFirstDate:Date                          //当月初日
    var dtUtil:UADateUtil                           //日付操作ユーティリティオブジェクト
    var itemViewList = [UAItemView]()               //日付ビューリスト
    var calendar: UACalendar =  UACalendar.init()   //カレンダーオブジェクト
    var headerView: UALabel                         //年月見出し
    var heightOfMidashi: CGFloat = 0                //見出し部の高さ
    var dataEntryView: BPDataEntryView                //データ入力ビュー
    //選択中の日付ビュー
    var selectedItemIndex:Int = 0 {
        didSet{
            itemViewList[oldValue].selectOff()
            itemViewList[selectedItemIndex].selectOn()
        }
    }
    //--------------------------------------------------------------------------
    //イニシャライザ
    //--------------------------------------------------------------------------
    init(){
        //プロパティの初期化
        dtUtil = UADateUtil.dateManager
        currentDate = Date() //現在日
        thisFirstDate = dtUtil.firstDate(date: currentDate) //当月初日
        //見出し
        headerView = UALabel.init(point: CGPoint(x: 0, y: 0));
        headerView.backgroundColor = UIColor.lightGray
        //データ入力ビューの作成
        dataEntryView = BPDataEntryView.init()
        //**** super classオブジェクトの作成 ****
        let myFrame = CGRect(x: 0, y: 0, width: 0 , height: 0)
        super.init(frame: myFrame)
        //当月カレンダーの作成（現在日を元に）
        calendar = UACalendar()
        //サブビュー（コントロール、日付ビュー）の作成と配置
        self.arrangeControlViews()
        //日付ビューに日付をセットする＆フレームの大きさを決める
        self.putDateToIemView()
        //スワイプの取得（右へ）
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.addGestureRecognizer(swipeRight)
        //スワイプの取得（左へ）
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        self.addGestureRecognizer(swipeLeft)
        //データ入力ビューのdelegate
        dataEntryView.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented");
    }
    //--------------------------------------------------------------------------
    // カレンダービューの再描画
    //--------------------------------------------------------------------------
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
    }
    //--------------------------------------------------------------------------
    //前月へボタン
    //--------------------------------------------------------------------------
    @objc func clickPreButton(){
        calendar.createCalender(addMonth: -1)
        self.putDateToIemView()
        self.setNeedsDisplay()
    }
    //--------------------------------------------------------------------------
    //翌月へボタン
    //--------------------------------------------------------------------------
    @objc func clickNextButton(){
        calendar.createCalender(addMonth: 1)
        self.putDateToIemView()
        self.setNeedsDisplay()
    }
    //--------------------------------------------------------------------------
    //サブビュー（コントロール、日付ビュー）の作成と配置
    //--------------------------------------------------------------------------
    func arrangeControlViews(){
        WIDTH = CELL_WIDTH * 7 + 20 //カレンダーの幅
        //super classのプロパティの参照はここか
        self.backgroundColor = UIColor.lightGray
        //年月見出し
        self.addSubview(headerView)
        //前月へボタン
        let preButton = UIButton(type: .roundedRect)
        preButton.backgroundColor = UIColor.gray
        preButton.setTitleColor(UIColor.white, for: .normal)
        preButton.frame = CGRect(x: 10,y: 8,width: 30, height: 30)
        preButton.setTitle("<", for: .normal)
        preButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        preButton.addTarget(self, action: #selector(self.clickPreButton), for: .touchUpInside)
        self.addSubview(preButton)
        //翌月へボタン
        let nextButton = UIButton(type: .roundedRect)
        nextButton.backgroundColor = UIColor.gray
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.frame = CGRect(x: WIDTH - 40,y: 8,width: 30, height: 30)
        nextButton.setTitle(">", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        nextButton.addTarget(self, action: #selector(self.clickNextButton), for: .touchUpInside)
        self.addSubview(nextButton)
        //曜日見出し
        let youbis = ["月","火","水","木","金","土","日"]
        heightOfMidashi = 8 + (headerView.frame.height > 30 ? headerView.frame.height:30) + 10
        for i in 0..<youbis.count {
            let youbiView = UALabel.init(point:CGPoint(x: CGFloat(21+(CELL_WIDTH * CGFloat(i))),
                                                       y: heightOfMidashi))
            youbiView.fontSize = 20
            youbiView.text = youbis[i]
            youbiView.backgroundColor = UIColor.lightGray
            self.addSubview(youbiView)
            if i == (youbis.count - 1){ heightOfMidashi += youbiView.frame.size.height + 5 }
        }
        //日付ビューのグリッド(6行×7列)を作成してカレンダービューへ追加する
        var index = 0
        for i in 1...6{
            for j in 1...7{
                let x = CGFloat((j-1) % 7) * CELL_WIDTH + 10
                let y = heightOfMidashi + (CGFloat(i-1) * CELL_HEIGHT)
                let rect = CGRect(x: x, y: y, width: CELL_WIDTH, height: CELL_HEIGHT)
                let item = UAItemView.init(frame: rect)
                item.delegate = self
                item.backgroundColor = UIColor.white
                itemViewList.append(item)
                self.addSubview(item)
                index += 1
            }
        }
    }
    //--------------------------------------------------------------------------
    //日付ビューに日付をセットする（イニシャライザ、または前月/翌月の移動処理から呼ばれる）
    //--------------------------------------------------------------------------
    func putDateToIemView(){
        let currentDaycolor:UIColor =
            UIColor.init(red: 200/255, green: 220/255, blue: 240/255, alpha: 1)
        //年月見出し
        let wareki:Array = calendar.yearOfWareki
        headerView.text = String(format: "%ld年%ld月(%@%@)",
                          calendar.year, calendar.month, wareki[0], wareki[1])
        headerView.fontSize = 30
        let sp =  (WIDTH / 2) - (headerView.frame.width / 2)
        headerView.frame.origin = CGPoint(x: sp, y: 10)
        headerView.setNeedsDisplay()
        //血圧データの取得
        let cmd = "http://192.168.11.3/doc_health_calendar/php/sql_r10.php"
        let param = String(format:"id=%ld&from_date=%ld&to_date=%ld",
                           500, calendar.startOfCalendar, calendar.endOfCalendar)
        let list = UAServerRequest.postSync(urlString:cmd, param:param)
        //受信データのキャスト  Any -> [[String:Int]]
        guard let bloodPressureList = list as? [[String:Int]] else{
            print("cast error")
            return
        }
        //日付のセット
        for i in 0..<itemViewList.count{
            let item = itemViewList[i]; //日付ビュー
            item.backgroundColor = UIColor.white
            if i < calendar.daysOfCalender{
                item.index = i
                item.aString = self.attributedDay(index: i)
                //当日の判定
                if i == calendar.currentDateIndex{
                    item.backgroundColor = currentDaycolor
                }else{
                    item.selectOff()
                }
                //血圧入力済みの印
                item.upper = 0
                item.lower = 0
                item.confirm = false
                for record in bloodPressureList {
                    if calendar.dateList[i].integerYearMonthDay == record["date"]{
                        //辞書の要素のアンンラップ
                        guard let upper = record["upper"],
                            let lower = record["lower"],
                            let confirm = record["confirm"] else{
                                print("error upper or lower is nill")
                                return
                        }
                        item.upper = upper
                        item.lower = lower
                        item.confirm = confirm.boolValue
                        break
                    }
                }
            }else{
                item.index = -1 //hidden
            }
            item.setNeedsDisplay()
        }
        //ビューの大きさを変える
        let weeks = calendar.daysOfCalender > 35 ? 6 : 5 //週数
        HEIGHT = heightOfMidashi + CELL_HEIGHT * CGFloat(weeks) + 30
        self.frame.size = CGSize(width: WIDTH, height: HEIGHT)
    }
    //--------------------------------------------------------------------------
    //文字列・日の作成
    //--------------------------------------------------------------------------
    private func attributedDay(index: Int)->NSAttributedString{
        let fontName = "Arial"
        //let fontName = "HiraginoSans-W3"
        var size: CGFloat = 0
        let attributes: [NSAttributedString.Key : Any]
        if calendar.thisMonthFlag(index: index){
            size = FONT_NORMAL
        }else{
            size = FONT_SMALL
        }
        if calendar.weekday(index: index) == 1 ||
            calendar.holidayFlag(index: index){
            //日曜日・休日
            attributes = UATextAttribute.makeAttributes(name: fontName,
                                                        size: size, color: UIColor.red)
        }else if calendar.weekday(index: index) == 7{
            //土曜日
            attributes = UATextAttribute.makeAttributes(name: fontName,
                                                        size: size, color: UIColor.blue)
        }else{
            //平日
            attributes = UATextAttribute.makeAttributes(name: fontName,
                                                            size: size, color: UIColor.black)
        }
        //属性付き文字列の作成
        let day = String(format:"%ld", calendar.day(index: index))
        let atrDay = NSAttributedString.init(string: day, attributes: attributes)
        return atrDay
    }
    //--------------------------------------------------------------------------
    //スワイプ
    //--------------------------------------------------------------------------
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                clickNextButton()
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                clickPreButton()
            default:
                break
            }
        }
    }
    //--------------------------------------------------------------------------
    // データ入力ビューの表示：UAItemViewDelegate delegate
    //--------------------------------------------------------------------------
    func dateSelect(index: Int){
        self.selectedItemIndex = index
        dataEntryView.getData(date:calendar.dateList[selectedItemIndex])
        dataEntryView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        self.addSubview(dataEntryView)
    }
    //--------------------------------------------------------------------------
    // データ入力ビューの表示： delegate
    //--------------------------------------------------------------------------
    func renewalView(){
        self.putDateToIemView()
        //selectedItemIndexのdidSetを起動するための策（変だよな）
        let tmp = self.selectedItemIndex
        self.selectedItemIndex = tmp
    }
}
