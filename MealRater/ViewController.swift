//
//  ViewController.swift
//  MealRater
//
//  Created by Rijul Mehta on 10/28/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, RatingControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var dishTF: UITextField!
    @IBOutlet weak var restTF: UITextField!
    @IBOutlet weak var restName: UITextField!
    var selectedValue: Int = 1
    
    var managedObjectContext: NSManagedObjectContext {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.persistentContainer.viewContext
            }
            fatalError("Unable to access managed object context")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restName.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func button(_ sender: UIButton) {
        
        // Check if restaurant name and dish name are not empty
        guard let restaurantName = restName.text, !restaurantName.isEmpty,
              let dishName = dishTF.text, !dishName.isEmpty else {
            // Show an alert if either field is empty
            showValidationError(message: "Please enter both restaurant name and dish name.")
            return
        }
        
        restName.resignFirstResponder()
        let ratingController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "rating_vc") as! RatingController
        ratingController.delegate = self
        ratingController.modalPresentationStyle = .fullScreen
                present(ratingController, animated: true, completion: nil)
    }
    func didRateMeal(_ rating: Int) {
        selectedValue = rating
        ratingLabel.text = "\(selectedValue)"
    }
    
    @IBAction func dataSaveBtnPressed(_ sender: UIButton) {
        let newDish = Dish(context: managedObjectContext)
        newDish.dishName = dishTF.text
        newDish.restaurantName = restTF.text
        if let ratingText = ratingLabel.text, let rating = Int(ratingText){
            newDish.rating = Int32(rating)
        }
        do{
            try managedObjectContext.save()
            print("Dish saved to Core Data")
            showSuccessAlert(message: "Data saved successfully")
        }
        catch {
            print("Error saving dish to Core Data: \(error)")
            showErrorAlert(message: "Failed to save data")
                }
    }
    func showSuccessAlert(message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
//    @IBAction func fetchData(_ sender: UIButton) {
////        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
////
////                do {
////                    let dishes = try managedObjectContext.fetch(fetchRequest)
////                    for dish in dishes {
////                        print("Dish Name: \(dish.dishName ?? "N/A")")
////                        print("Restaurant Name: \(dish.restaurantName ?? "N/A")")
////                        print("Rating: \(dish.rating)")
////                    }
////                } catch {
////                    print("Error fetching data: \(error)")
////                }
//    }
    func showValidationError(message: String) {
        let alertController = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

