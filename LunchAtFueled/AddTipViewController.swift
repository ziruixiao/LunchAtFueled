//
//  AddTipViewController.swift
//  LunchAtFueled
//
//  Created by Felix Xiao on 11/6/15.
//  Copyright © 2015 Felix Xiao. All rights reserved.
//

import UIKit
import AERecord
import CoreData

class AddTipViewController: UIViewController {

    var venue: Venue!
    
    @IBOutlet weak var tipTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Done", style: .Done, target: self, action: "addTip")
        tipTextView.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    func addTip() {
        //validate fields
        let allText = tipTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if (allText != "") {
            //add tip to CoreData and publish notification
            let newTip = Tip.create()
            newTip.createdAt = NSDate()
            newTip.venueId = venue.id
            newTip.text = allText
            AERecord.saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName("TipsLoaded", object: nil)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please write some content for the tip.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
