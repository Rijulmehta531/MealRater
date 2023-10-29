//
//  RatingController.swift
//  MealRater
//
//  Created by Rijul Mehta on 10/28/23.
//

import UIKit
protocol RatingControllerDelegate: AnyObject {
    func didRateMeal(_ rating: Int)
}

class RatingController: UIViewController {

    @IBOutlet weak var chooser: UISegmentedControl!
    weak var delegate: RatingControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveButtonPressed(_ sender: Any) {
        let selectedValue = chooser.selectedSegmentIndex + 1
        delegate?.didRateMeal(selectedValue)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedValue = sender.selectedSegmentIndex + 1
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
