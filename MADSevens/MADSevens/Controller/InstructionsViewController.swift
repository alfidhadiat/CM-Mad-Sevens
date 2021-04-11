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
        self.InstructionView.contentSize.height = 2100;
    }
  }
