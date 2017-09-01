//
//  LeftBarMenuTableViewController.swift
//  ofo Bike
//
//  Created by Yu Wang on 8/23/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

import UIKit

class LeftBarMenuTableViewController: UITableViewController {

    @IBOutlet weak var settingPageAvatarImage: UIImageView!
    @IBOutlet weak var settingPageCertLabel: UILabel!
    @IBOutlet weak var settingPageCreditLabel: UILabel!
    @IBOutlet weak var settingPageMyTrip: UILabel!
    @IBOutlet weak var settingPageMyWallet: UILabel!
    @IBOutlet weak var settingPagePromotionCode: UILabel!
    @IBOutlet weak var settingPageInviteCode: UILabel!
    @IBOutlet weak var settingPageUserGuide: UILabel!
    @IBOutlet weak var settingPageAboutUs: UILabel!
    
    @IBOutlet weak var settingPageBalance: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingPageMyTrip.text = "My Trip"
        settingPageMyWallet.text = "My Wallet"
        settingPagePromotionCode.text = "Promotion Code"
        settingPageInviteCode.text = "Invitation Code"
        settingPageUserGuide.text = "User Guide"
        settingPageAboutUs.text = "About us"
        
        settingPageBalance.text = "100.00"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "topScreen")
        
        DispatchQueue.main.async {
            self.so_containerViewController?.topViewController = vc
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
