//
//  ViewController.swift
//  MountainViewExample
//
//  Created by Kyohei Ito on 2017/01/04.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import UIKit
import Mountain

class ViewController: UIViewController, Storyboard {
    let mountain = Mountain()

    static var storyboardName: String {
        return "Main"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            UIApplication.appDelegate?.climb()
        }, completion: nil)
    }

    func climbMountain() {
        transitionCoordinator?.animate(alongsideTransition: { _ in
            UIApplication.appDelegate?.climb()
        }, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}

extension ViewController {
    @IBAction func push() {
        let controller = ViewController.makeFromStoryboard()
        navigationController?.pushViewController(controller, animated: true)
        climbMountain()
    }
    
    @IBAction func pop() {
        _ = navigationController?.popViewController(animated: true)
        climbMountain()
    }
    
    @IBAction func present() {
        let controller = NavigationController.makeFromStoryboard()
        present(controller, animated: true, completion: nil)
        climbMountain()
    }
    
    @IBAction func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
        climbMountain()
    }

    @IBAction func curveLinear() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.mountain.climb()
                .situation {
                    print($0)
                }
            UIApplication.appDelegate?.climb()
        }, completion: nil)
    }

    @IBAction func curveEaseIn() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseIn], animations: {
            self.mountain.climb()
                .situation {
                    print($0)
                }
            UIApplication.appDelegate?.climb()
        }, completion: nil)
    }

    @IBAction func curveEaseOut() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.mountain.climb()
                .situation {
                    print($0)
                }
            UIApplication.appDelegate?.climb()
        }, completion: nil)
    }
}
