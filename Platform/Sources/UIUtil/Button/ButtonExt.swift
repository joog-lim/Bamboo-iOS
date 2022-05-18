import UIKit

public extension UIButton{
    convenience init(title : String, font: UIFont, titleColor : UIColor){
        self.init()
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(titleColor, for: .normal)
    }
}