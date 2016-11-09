//
//  BHSelectNV.swift
//  RISYunXiaoKe
//
//  Created by 刘华磊 on 16/9/21.
//  Copyright © 2016年 北京瀚维特科技. All rights reserved.
//

import UIKit

class BHSelectNV: NSObject, UITableViewDelegate, UITableViewDataSource {
    var view: UIView!
    var viewBack : UIView!
    var contentView: UIView!
    lazy var visualEffectView = UIVisualEffectView()
    lazy var window = UIWindow()
    private var tableView : UITableView!
    
    private var commitButton    : UIButton!
    private var cancelButton    : UIButton!
    private var lab    : UILabel!
    //数据
    private var currentItems = [String]()
    private var selectedItemsArray = [String]()
    private var commitButtonTouched: ((Void) -> (Void))?
    var isSingle = false
    
    func sameItemShow() {
        
        let window = UIApplication.sharedApplication().delegate!.window!!
        window.endEditing(true)
        
        let twoTapG = UITapGestureRecognizer.init(target: self, action: #selector(self.hidden))
        
        view = UIView(frame: window.bounds)
        view.backgroundColor = UIColor.clearColor()
        window.addSubview(view)
        
        viewBack = UIView(frame: window.bounds)
        viewBack.backgroundColor = UIColor.blackColor()
        viewBack.alpha = 0
        viewBack.addGestureRecognizer(twoTapG)
        view.addSubview(viewBack)
//            visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
//            visualEffectView.frame = window.bounds
//            view.addSubview(visualEffectView)
        
        contentView = UIView.init(frame: CGRectMake(0, __MainScreenHeight, __MainScreenWidth, __MainScreenHeight * 0.618))
        contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.alpha = 0
        view.addSubview(contentView)
        
        tableView = UITableView(frame: CGRectMake(0, 30, __MainScreenWidth, __MainScreenHeight * 0.618 - 30), style: UITableViewStyle.Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectMake(0,0,100,1))
        tableView.registerNib(UINib(nibName: "CustomerNewMutableSelectedTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerNewMutableSelectedTableViewCell")
        contentView.addSubview(tableView)
        
        commitButton = UIButton(type: .System)
        commitButton.frame = CGRectMake(__MainScreenWidth - 8 - 44, 0, 44, 30)
        commitButton.setTitle("确定", forState: .Normal)
        commitButton.setTitleColor(kNavigationBlue_COLOR, forState: .Normal)
        commitButton.addTarget(self, action: #selector(self.commitButtonAction), forControlEvents: .TouchUpInside)
        contentView.addSubview(commitButton)
        
        cancelButton = UIButton(type: .System)
        cancelButton.frame = CGRectMake(8, 0, 44, 30)
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonAction), forControlEvents: .TouchUpInside)
        contentView.addSubview(cancelButton)
        
        lab = UILabel.init(frame: CGRectMake(__MainScreenWidth/2-20, 5, 40, 16))
        lab.text = isSingle ? "单选" : "多选"
        contentView.addSubview(lab)
    }
    func commitButtonAction() {
        self.commitButtonTouched?()
//        hidesAnimation()
        hidden()
    }
    
    func cancelButtonAction() {
//        hidesAnimation()
        hidden()
    }
    //demo.ris.com.cn:89/app?operation=addcustomer&wyid=XMA0000001&xsyid=ZMA0000770&userName=1&passWord=admin&ISORG=0&yhid=E0013&customerInfo={%22KH_QRXM%22:%22带看测试new111111%22,%22KH_XB%22:%22男%22,%22KH_QRDH%22:%2287787%22,%22KH_KHLY%22:%22渠道%22,%22KH_KHDJ%22:%22首次客户%22,%22KH_XSY%22:%22李想%22,%22KH_XSZB%22:%22公佣%22,%22KH_LFFS%22:%22来电%22,%22KH_LFRQ%22:%222016-09-04%22,%22KH_FYXZ%22:%22地段好%22,%22KH_FYJG%22:%22高楼层%22,%22KH_YXCD%22:%22无%22,%22KH_NATIVE%22:%22中国%22,%22KH_HJ%22:%22本地%22,%22KH_ZW%22:%22董事长%22}}&fwids={%22fwinfo%22:[{%22fwid%22:%22FWP0006859%22,%22fwbh%22:%22A01%22},{%22fwid%22:%22FWP0006860%22,%22fwbh%22:%22A09%22}]}
    //MARK:-KZ
    func singleShow(items: [String], selectedItems: [String]?, ok: ((items: [String], itemsString: String) -> ())) {
        
        self.isSingle = true
        self.selectedItemsArray.removeAll()

        if items.count == 0 {
            YCProgressHUD.show("该条目下还没有选项")
            return
        }
        sameItemShow()
        showAnimation()
        self.currentItems = items
        
        if selectedItems != nil {
            if selectedItems! != [""] {
                self.selectedItemsArray = selectedItems!
            }
        }
        self.tableView.reloadData()

        self.commitButtonTouched = {
            
            ok(items: self.selectedItemsArray, itemsString: self.resultString())
        }
    }
    func multyShow(items: [String], selectedItems: [String]?, ok: ((items: [String], itemsString: String) -> ())) {
        
        self.isSingle = false
        
        if items.count == 0 {
            YCProgressHUD.show("该条目下还没有选项")
            return
        }
        sameItemShow()
        self.selectedItemsArray.removeAll()
 
        showAnimation()
        self.currentItems = items
        if selectedItems != nil {
            if selectedItems! != [""] {
                self.selectedItemsArray = selectedItems!
            }
        }
        
        self.tableView.reloadData()
        self.commitButtonTouched = {
            self.selectedItemsArray.removeAll()
            for idx in 0..<self.currentItems.count {
                let title = self.currentItems[idx]
                let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: idx, inSection: 0)) as! CustomerNewMutableSelectedTableViewCell
                self.tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: idx, inSection: 0), atScrollPosition: .Top, animated: false)
                if cell.flagImageView.image == self.theSelectedImage {
                    self.selectedItemsArray += [title]
                }
            }
            ok(items: self.selectedItemsArray, itemsString: self.resultString())
        }
    }
    func showAnimation() {
        
        UIView.animateWithDuration(0.2) {
            self.contentView.alpha = 1
            self.viewBack.alpha = 0.5
            self.contentView.frame = CGRectMake(0, __MainScreenHeight * 0.382, __MainScreenWidth, __MainScreenHeight * 0.618)
        }
    }
    //MARK:-SJ
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentItems.count
    }
    private let theSelectedImage = UIImage(named: "customerNew-xuanzhong")
    private let theNotSelectedImage = UIImage(named: "customerNew-not_Selected")
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomerNewMutableSelectedTableViewCell", forIndexPath: indexPath) as! CustomerNewMutableSelectedTableViewCell
        let title = currentItems[indexPath.row]
        cell.titleLabel.text = title
        cell.flagImageView.image = self.selectedItemsArray.contains(title) ? theSelectedImage : theNotSelectedImage
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomerNewMutableSelectedTableViewCell
        let title = currentItems[indexPath.row]
        
        if isSingle {
            selectedItemsArray.removeAll()
            self.tableView.reloadData()
            selectedItemsArray += [title]
            
            self.commitButtonAction()
        }else {
            
            if cell.flagImageView.image == theSelectedImage {
                if selectedItemsArray.indexOf(title) != nil {
                    selectedItemsArray.removeAtIndex(selectedItemsArray.indexOf(title)!)
                }
            }else {
                selectedItemsArray += [title]
            }
            self.tableView.reloadData()
        }
        print(selectedItemsArray)
    }
    
    func resultString() -> String {
        let string = (self.selectedItemsArray.map { "\($0)" } as [String]).joinWithSeparator(",")
        return string
    }
    //MARK:-UI
    
    func hidden() {
        UIView.animateWithDuration(0.2) {
            self.view.alpha = 0
        }
    }
}
