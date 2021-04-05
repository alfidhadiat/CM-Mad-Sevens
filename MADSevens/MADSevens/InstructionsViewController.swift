//
//  InstructionsViewController.swift
//  MADSevens
//
//  Created by david  on 04/04/2021.
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var InstructionView: UIScrollView!

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        self.InstructionView.contentSize.height = 3000;
    }
    
    
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

