//
//  ParamViewController.swift
//  cast
//
//  Created by Mohamed dennoun on 16/03/2020.
//  Copyright © 2020 DENNOUN Mohamed. All rights reserved.
//

import UIKit

class ParamViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var link: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
            self.link.delegate = self
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }

    @IBAction func validate(_ sender: Any) {
        let vc = AppNagatorViewController.newInstance(link: link.text ?? "")
        navigationController?.pushViewController(vc, animated: true)
        
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
