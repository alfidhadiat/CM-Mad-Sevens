//
//  MenuViewController.swift
//  MADSevens
//
//  Created by D.L. Kovacs on 18/03/2021.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    /**
     Initiates a new game
     */
    @IBAction func newGame(_ sender: UIButton) {
        print("Button start game was pressed, starting a new game on viewController.game instance")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
