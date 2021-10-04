//------------------------------------------------------------------------------
//  UATextAttribute.swift
//------------------------------------------------------------------------------
import UIKit

class UATextAttribute: NSObject {
    //--------------------------------------------------------------------------
    //属性付き文字列の属性
    //--------------------------------------------------------------------------
    class func makeAttributes(name:String, size:CGFloat, color:UIColor)
    ->[NSAttributedString.Key:Any]{
        //属性
        var attributes:[NSAttributedString.Key:Any] = [:]
        //フォント名
        var fontName:String = name
        if name == "" {
            fontName = "Arial"
        }
        //フォント
        let font:UIFont = UIFont.init(name:fontName, size:size)
            ?? UIFont.systemFont(ofSize: 12)
        attributes[.font] = font
        //文字色
        attributes[.foregroundColor] = color
        return attributes
    }
    //文字列装飾属性（デフォルト）
    class func makeAttributes()->[NSAttributedString.Key:Any]{
        return self.makeAttributes(name: "", size: 12, color: UIColor.black)
    }
    //文字列装飾属性（フォントサイズ指定）
    class func makeAttributes(size:CGFloat)->[NSAttributedString.Key:Any]{
        return self.makeAttributes(name: "", size: size, color: UIColor.black)
    }
    //文字列装飾属性（文字色指定）
    class func makeAttributes(color:UIColor?)->[NSAttributedString.Key:Any]{
        return self.makeAttributes(name: "", size: 12, color: UIColor.black)
    }
    //文字列装飾属性（フォントサイズ、文字色指定）
    class func makeAttributes(size:CGFloat, color:UIColor?)->[NSAttributedString.Key:Any]{
        return self.makeAttributes(name: "", size: size, color: UIColor.black)
    }
    //--------------------------------------------------------------------------
    //属性付き文字列
    //--------------------------------------------------------------------------
    class func makeAttributedString(_ string:String, name:String,
                                    size:CGFloat, color:UIColor)->NSMutableAttributedString{
        //文字列
        let atrString = NSMutableAttributedString(string: string)
        //フォント名
        var fontName:String = name
        if name == "" {
            fontName = "Arial"
        }
        let font = UIFont.init(name:fontName, size:size)
            ??  UIFont.systemFont(ofSize: 12)
        atrString.addAttributes([.font:font], range:NSMakeRange(0, atrString.length))
        //文字色
        atrString.addAttributes([.foregroundColor:color],
                                range:NSMakeRange(0, atrString.length))
        return atrString
    }
    //修飾文字列（フォントサイズ、文字色指定）
    class func makeAttributedString(string:String, size:CGFloat,
                                    color:UIColor)->NSMutableAttributedString{
        return self.makeAttributedString(string, name: "",
                                         size: size, color: color)
    }
    //修飾文字列（フォントサイズ）
    class func makeAttributedString(string:String,
                                    size:CGFloat)->NSMutableAttributedString{
        return self.makeAttributedString(string, name: "",
                                         size: size, color: UIColor.black)
    }
    //--------------------------------------------------------------------------
    //修飾文字列を中央揃えにする
    //--------------------------------------------------------------------------
    class func centered(atrString:NSMutableAttributedString)->NSMutableAttributedString{
        let pStyle = NSMutableParagraphStyle()
        pStyle.alignment = NSTextAlignment.center
        atrString.addAttributes([.paragraphStyle:pStyle],
                                range:NSMakeRange(0, atrString.length))
        return atrString
    }
}
