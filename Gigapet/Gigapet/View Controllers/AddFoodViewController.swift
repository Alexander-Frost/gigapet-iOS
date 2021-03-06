//
//  AddFoodViewController.swift
//  Gigapet
//
//  Created by Alex on 5/22/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class AddFoodViewController: UIViewController {

    // MARK: - Constants
    
    var nc: NetworkController?{
        didSet{
            print("NC passed.")
        }
    }
    var categorySelected: Category?
    
    // MARK: - Outlets
    
    @IBOutlet var foodTextField: UITextField!
    @IBOutlet var caloriesTextField: UITextField!
    
    @IBOutlet var dairyBtn: UIButton!
    @IBOutlet var vegatablesBtn: UIButton!
    @IBOutlet var grainsBtn: UIButton!
    @IBOutlet var fruitsBtn: UIButton!
    @IBOutlet var proteinsBtn: UIButton!
    @IBOutlet var junkBtn: UIButton!
    
    // MARK: - Actions
    
    @IBAction func dairyBtnPressed(_ sender: UIButton) {
        categorySelected = .dairy
    }
    @IBAction func grainsBtnPressed(_ sender: UIButton) {
        categorySelected = .grains
    }
    @IBAction func vegatablesBtnPressed(_ sender: UIButton) {
        categorySelected = .vegatables
    }
    @IBAction func fruitsBtnPressed(_ sender: UIButton) {
        categorySelected = .fruits
    }
    @IBAction func proteinsBtnPressed(_ sender: UIButton) {
        categorySelected = .proteins
    }
    @IBAction func junkBtnPressed(_ sender: UIButton) {
        categorySelected = .junk
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        // Validate required fields are not empty
        if (foodTextField.text?.isEmpty)! ||
            (caloriesTextField.text?.isEmpty)! || (categorySelected != nil) {
            // Display Alert message and return
            displayMessage(userMessage: "All fields are required to be filled in")
            return
        }
        
        nc?.addFood(foodName: foodTextField.text!, foodType: categorySelected!, calories: Int(caloriesTextField.text!)!, date: "2019-05-25", childId: AppPresets.childId ?? 1, completion: { (error) in
            if let error = error {
                print(error)
                return
            }
        
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        })
        
    }
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                // Code in this block will trigger when OK button tapped.
                print("Ok button tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
}
