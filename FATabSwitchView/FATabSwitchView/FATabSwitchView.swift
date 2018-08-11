//
//  FATabSwitchView.swift
//  FATabSwitchView
//
//  Created by lizelu on 2018/7/21.
//  Copyright © 2018年 ludashi. All rights reserved.
//

import UIKit
import SnapKit

typealias FATabSelectBlockType = (Int)->Void

class FATabSwitchView: UIView {
    
    //MARK: private priority
    
    private var contentView: UIView!
    private var tabButtonsArray: Array<FATabButton> = []
    private var titleArray: Array<String> = []
    private var currentSelectIndex: Int = 0
    private var selectBlock: FATabSelectBlockType!
    private var normalFontSize: Float = 15
    private var selectFontSize: Float = 30
    private var normalTextColor: UIColor = UIColor.black
    private var selectTextColor: UIColor = UIColor.red
    private var animationInterval: TimeInterval = 0.3
    
    //MARK: override method
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addScrollView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addTabButtons()
        self.addConstraintForSubTabs()
        
        self.testAddBottomLine()
    }
    
    func testAddBottomLine() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.black
        self.contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.height.equalTo(2)
            make.width.left.equalTo(self.contentView)
            make.top.equalTo(self.contentView.snp.bottom).offset(-10)
        }
    }
    
    //MARK: public config method
    
    /// 设置动画时间
    ///
    /// - Parameter interval: 时间间隔
    public func setAnimationInterval(interval: TimeInterval) {
        self.animationInterval = interval
        self.layoutSubviews()
    }
    
    /// 设置未选中状态下的颜色
    ///
    /// - Parameter color: 色值
    public func setNormalTextColor(color: UIColor) {
        self.normalTextColor = color
        self.layoutSubviews()
    }
    
    /// 设置选中状态下的颜色
    ///
    /// - Parameter color
    public func setSelectTextColor(color: UIColor) {
        self.selectTextColor = color
        self.layoutSubviews()
    }
    
    /// 设置选中字号
    ///
    /// - Parameter fontSize
    public func setSelectFontFize(fontSize: Float) {
        self.selectFontSize = fontSize;
        self.layoutSubviews()
    }
    
    /// 设置常规字号
    ///
    /// - Parameter fontSize
    public func setNormalFontFize(fontSize: Float) {
        self.normalFontSize = fontSize
        self.layoutSubviews()
    }
    
    /// 设置Tab标题
    ///
    /// - Parameter titles
    public func setTitleArray(titles:  Array<String>) {
        self.titleArray = titles
        self.layoutSubviews()
    }
    
    /// 设置点击Block
    ///
    /// - Parameter block
    public func setSelectBlock(block: @escaping FATabSelectBlockType) {
        self.selectBlock = block
    }
    
    
    //MARK: private add subviews method
    
    private func addScrollView() {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = false;
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.contentView = UIView()
        self.contentView.clipsToBounds = false
        scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
    }
    
    private func addTabButtons() {
        self.tabButtonsArray.removeAll()
        for index in 0..<self.titleArray.count {
            let tab = FATabButton()
            tab.setSelectFontFize(fontSize: self.selectFontSize)
            tab.setNormalFontFize(fontSize: self.normalFontSize)
            tab.setSelectTextColor(color: self.selectTextColor)
            tab.setNormalTextColor(color: self.normalTextColor)
            tab.setAnimationInterval(interval: self.animationInterval)
            tab.tag = index;
            tab.setTitle(title: self.titleArray[index])
            tab.addTarget(self, action: #selector(self.tapButton(sender:)), for: .touchUpInside)
            self.tabButtonsArray.append(tab)
        }
    }
    
    private func addConstraintForSubTabs() {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        var leftConstraint = self.contentView.snp.left
        for index in 0..<self.tabButtonsArray.count {
            let tabButton = self.tabButtonsArray[index]
            self.contentView.addSubview(tabButton)
            self.addConstraintForButton(button: tabButton, leftSlibling: leftConstraint)
            leftConstraint = tabButton.snp.right
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.right.equalTo(leftConstraint)
        }
    }
    
    private func addConstraintForButton(button: FATabButton, leftSlibling:ConstraintItem) {
        let leftOffset = (button.tag == 0) ? 0 : 10
        var font = UIFont.boldSystemFont(ofSize: CGFloat(self.normalFontSize))
        if self.currentSelectIndex == button.tag {
            button.isSelected = true
            button.setSelected(selected: true)
            font = UIFont.boldSystemFont(ofSize: CGFloat(self.selectFontSize))
        }
        let size = button.title.size(font: font)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(leftSlibling).offset(leftOffset)
            make.bottom.equalTo(0);
            make.width.equalTo(size.width);
            make.height.equalTo(self.contentView.snp.height);
        }
    }
    
    private func updateUI(index: Int) {
        if index == self.currentSelectIndex {
            return;
        }
        let currentButton = self.tabButtonsArray[index]
        let lastSelectButton = self.tabButtonsArray[self.currentSelectIndex]
        currentButton.setSelected(selected: true)
        lastSelectButton.setSelected(selected: false)
        currentButton.snp.updateConstraints { (make) in
            make.width.equalTo(currentButton.title.size(font: UIFont.boldSystemFont(ofSize: CGFloat(self.selectFontSize))).width)
        }
        
        lastSelectButton.snp.updateConstraints { (make) in
            make.width.equalTo(lastSelectButton.title.size(font: UIFont.boldSystemFont(ofSize: CGFloat(self.normalFontSize))).width)
        }
        UIView.animate(withDuration: self.animationInterval) {
            self.layoutIfNeeded()
        }
        self.currentSelectIndex = index
    }
    
    //MARK: event method
    
    @objc private func tapButton(sender:FATabButton) {
        if self.selectBlock != nil {
            self.selectBlock(sender.tag)
        }
        self.updateUI(index: sender.tag)
    }
    
}
