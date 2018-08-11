//
//  FATabButton.swift
//  FATabSwitchView
//
//  Created by lizelu on 2018/7/21.
//  Copyright © 2018年 ludashi. All rights reserved.
//

import UIKit

extension String {
    func size(font: UIFont) -> CGSize {
        let constraintRect = CGSize()
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return boundingBox.size
    }
}


class FATabButton: UIControl {
    
    var title = ""
    
    private var selectFontSize: Float = 30
    private var normalFontSize: Float = 15
    private var tabTitleImageView: UIImageView!
    private var normalTabTextImage: UIImage!
    private var selectTabTextImage: UIImage!
    private var normalTextColor: UIColor = UIColor.black
    private var selectTextColor: UIColor = UIColor.red
    private var animationInterval: TimeInterval = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTabTitleImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setAnimationInterval(interval: TimeInterval) {
        self.animationInterval = interval
    }
    
    public func setNormalTextColor(color: UIColor) {
        self.normalTextColor = color
    }
    
    public func setSelectTextColor(color: UIColor) {
        self.selectTextColor = color
    }
    
    public func setSelectFontFize(fontSize: Float) {
        self.selectFontSize = fontSize;
    }
    
    public func setNormalFontFize(fontSize: Float) {
        self.normalFontSize = fontSize;
        self.tabTitleImageView.snp.updateConstraints { (make) in
            make.height.equalTo(self.normalFontSize + 5)
        }
    }
    
    public func setTitle(title: String) {
        self.title = title
        self.normalTabTextImage = self.txtSwapImage(text: title, textColor: self.normalTextColor)
        self.selectTabTextImage = self.txtSwapImage(text: title, textColor: self.selectTextColor)
        self.tabTitleImageView.image = self.normalTabTextImage;
    }
    
    public func setSelected(selected: Bool) {
        if selected {
            self.updateTabImage(tabImage: self.selectTabTextImage, height: self.selectFontSize, bottom: -10)
        } else {
            self.updateTabImage(tabImage: self.normalTabTextImage, height: self.normalFontSize, bottom: -12)
        }
        if selected != self.isSelected {
            UIView.animate(withDuration: self.animationInterval) {
                self.layoutIfNeeded()
            }
        }
        self.isSelected = selected
    }
    
    private func updateTabImage(tabImage: UIImage, height: Float, bottom: Float) {
        self.tabTitleImageView.image = tabImage;
        self.tabTitleImageView.snp.updateConstraints { (make) in
            make.height.equalTo(height + 5)
            make.bottom.equalTo(bottom)
        }
    }
    
    private func addTabTitleImageView() {
        self.tabTitleImageView = UIImageView()
        self.tabTitleImageView.contentMode = .scaleAspectFit
        self.addSubview(self.tabTitleImageView)
        self.tabTitleImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0);
            make.bottom.equalTo(-12);
            make.height.equalTo(self.normalFontSize + 5);
        }
    }
    
    private func txtSwapImage(text: String, textColor: UIColor) -> UIImage {
        let textFont = UIFont.boldSystemFont(ofSize: CGFloat(self.selectFontSize))
        let textSize = text.size(font: textFont)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        style.lineBreakMode = .byCharWrapping
        style.lineSpacing = 0
        style.paragraphSpacing = 2
        
        let attributes = [NSAttributedStringKey.font : textFont,
            NSAttributedStringKey.foregroundColor : textColor,
            NSAttributedStringKey.backgroundColor : UIColor.clear,
            NSAttributedStringKey.paragraphStyle : style]
        UIGraphicsBeginImageContextWithOptions(textSize, false, 0);
        text.draw(in: CGRect(origin: CGPoint.zero, size: textSize), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!;
    }

}
