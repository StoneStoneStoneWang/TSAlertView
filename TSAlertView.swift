//
//  TSAlertView.swift
//  ThreeStone
//
//  Created by 王磊 on 1/16/17.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit

class TSAlertView: UIAlertView {
    private var block: TSAlertBlock?
    
    private var buttonCount: Int = 0
    
    required init(title: String, message: String) {
        super.init(frame: CGRect.zero)
        
        self.title = title
        
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func addBtnWithTitle(title: String?) {
        
        buttonCount += 1
        
        addButtonWithTitle(title)
    }
    
    internal func showAlert(alertBlock: TSAlertBlock) {
        
        self.delegate = self
        
        block = alertBlock
        
        show()
    }
    
    
    deinit {
        clearActionBlock()
    }
    
    internal func clearActionBlock() {
        if delegate != nil {
            delegate = nil
            block = nil
        }
    }
}
extension TSAlertView: UIAlertViewDelegate {
    
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        guard let _ = block else {
            
            return
        }
        
        if buttonCount == 1 {
            
            block!(.Confirm)
            
        } else {
            
            if buttonIndex == 1 {
                block!(.Confirm)
            } else if buttonIndex == 0 {
                
                block!(.Cancle)
            }
        }
        clearActionBlock()
    }
}
