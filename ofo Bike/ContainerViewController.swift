//
//  ContainerViewController.swift
//  ofo Bike
//
//  Created by Yu Wang on 8/24/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

import SidebarOverlay

class ContainerViewController: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuSide = .left
        self.sideMenuWidth = 350
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "topScreen")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "leftScreen")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var isSideViewControllerPresented: Bool {
        didSet {
            let action = isSideViewControllerPresented ? "opened" : "closed"
            let side = self.menuSide == .left ? "left" : "right"
            NSLog("You've \(action) the \(side) view controller.")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
