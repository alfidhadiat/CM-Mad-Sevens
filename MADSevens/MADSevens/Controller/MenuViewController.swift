//
//  MenuViewController.swift
//  MADSevens
//
//  Created by D.L. Kovacs on 18/03/2021.
//

import UIKit

class MenuViewController: UIViewController {

    lazy var viewController = MADSevensViewController()
//    lazy var game = MADSevens()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /**
     Initiates a new game
     */
    @IBAction func newGame(_ sender: UIButton) {
        viewController.game.newGame()
        viewController.game.printGame()
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
