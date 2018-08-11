//
//  ViewController.swift
//  FATabSwitchView
//
//  Created by lizelu on 2018/7/21.
//  Copyright © 2018年 ludashi. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var tabView: FATabSwitchView!
    var selectFontValue: Float = 0

    @IBOutlet weak var nomalFontSlider: UISlider!
    @IBOutlet weak var selectFontSlider: UISlider!
    @IBOutlet weak var logLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectFontValue = self.selectFontSlider.value - self.selectFontSlider.minimumValue
        self.addSelectTabView()
    }
    
    func addSelectTabView() {
        self.tabView = FATabSwitchView()
        self.tabView.backgroundColor = UIColor.white
        self.view.addSubview(self.tabView)
        self.tabView.snp.makeConstraints { (make) in
            make.top.equalTo(50)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(80)
        }
        
        let titles = ["乐库", "推荐", "趴间", "我的榜单","看点", "乐库", "推荐", "趴间", "我的榜单","看点"]
        self.tabView.setTitleArray(titles: titles)
        self.tabView.setSelectFontFize(fontSize: 40)
        self.tabView.setSelectTextColor(color: UIColor.orange)
        weak var weak_self = self
        self.tabView.setSelectBlock { (index) in
            weak_self?.logLabel.text = "\(index):\(titles[index])"
        }
        self.logLabel.text = titles.first
    }
    
    @IBAction func tapNormalColor(_ sender: UIButton) {
        self.tabView.setNormalTextColor(color: sender.backgroundColor!)
    }
    
    @IBAction func tapSelectColor(_ sender: UIButton) {
        self.tabView.setSelectTextColor(color: sender.backgroundColor!)
    }
    
    @IBAction func sliderSelectTextFontSize(_ sender: UISlider) {
        if sender.tag == 0 {
            self.selectFontValue = sender.value - sender.minimumValue
            self.tabView.setSelectFontFize(fontSize: sender.value)
        }
        
        if sender.tag == 1 {
            self.tabView.setNormalFontFize(fontSize: sender.value)
            self.selectFontSlider.minimumValue = sender.value + 10
            self.selectFontSlider.maximumValue = sender.value + 50
            self.selectFontSlider.value = self.selectFontSlider.minimumValue + selectFontValue
            self.tabView.setSelectFontFize(fontSize: self.selectFontSlider.value)
            NSLog("%lf", selectFontSlider.value)
        }
    }
}

