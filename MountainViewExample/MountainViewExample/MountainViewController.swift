//
//  MountainViewController.swift
//  MountainViewExample
//
//  Created by Kyohei Ito on 2017/01/04.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import UIKit
import MountainView

class MountainViewController: UIViewController, Storyboard {
    @IBOutlet weak var mountainView: MountainView!
    
    static var storyboardName: String {
        return "Main"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
