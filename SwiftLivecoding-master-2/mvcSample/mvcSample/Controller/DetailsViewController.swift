//
//  DetailsViewController.swift
//  mvcSample
//
//  Created by Eugene Hyrol on 12/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func popTapped(_ sender: Any) {

//    Go back to the previous page in the navigation stack of the navigation conrtoller
//        self.navigationController?.popViewController(animated: true)
//    Hide this view controller when it was presented modally
//        self.dismiss(animated: true, completion: nil)
        
    }
    
//    Called before each segue is triggered
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
}
