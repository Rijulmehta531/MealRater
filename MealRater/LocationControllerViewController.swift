//
//  LocationControllerViewController.swift
//  MealRater
//
//  Created by Rijul Mehta on 10/29/23.
//


import UIKit
import CoreLocation
import CoreData


class LocationControllerViewController: UIViewController , CLLocationManagerDelegate{
    var textToDisplay: String?
    
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var resNameDisplay: UILabel!
    
    @IBOutlet weak var lat: UILabel!
    
    @IBOutlet weak var long: UILabel!
    
    @IBOutlet weak var btnFind: UIButton!
    var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!
    var managedObjectContext: NSManagedObjectContext {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate.persistentContainer.viewContext
            }
            fatalError("Unable to access managed object context")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resNameDisplay.text=textToDisplay
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("Permission granted")
//            locationManager.startUpdatingLocation() // Start location updates when permission is granted
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            lat.text = String(format: "%g\u{00B0}", latitude)
            long.text = String(format: "%g\u{00B0}", longitude)
        }
    }
    @IBAction func lookUpClicked(_ sender: Any) {
        street.isHidden = false
        city.isHidden = false
        state.isHidden = false
        btnFind.isHidden = false
    }
    
    
    @IBAction func fromLocClicked(_ sender: Any) {
        street.isHidden = true
        city.isHidden = true
        state.isHidden = true
        btnFind.isHidden = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    @IBAction func FindClicked(_ sender: Any) {
        let address = "\(street.text!), \(city.text!), \(state.text!)"
        geoCoder.geocodeAddressString(address){
            (placemarks, error) in self.processAddressResponse(withPlacemarks: placemarks, error: error)
        }
    }
    private func processAddressResponse(withPlacemarks placemarks: [CLPlacemark]?, error:Error?){
        if let error = error{
            print("Geocode error: \(error)")
        }
        else{
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                bestMatch = placemarks.first?.location
            }
            if let coordinate = bestMatch?.coordinate{
                lat.text = String(format: "%g\u{00B0}", coordinate.latitude)
                long.text = String(format: "%g\u{00B0}", coordinate.longitude)
            }
            else{
                print("Didn't find any matching locations.")
            }
        }
    }
    
    @IBAction func saveLocation(_ sender: Any) {
        let newDish = Dish(context: managedObjectContext)
        newDish.restaurantName = resNameDisplay.text
        newDish.latitude = lat.text
        newDish.longitude = long.text
        do {
                try managedObjectContext.save()
                // Data saved successfully, display a success message
                showSuccessAlert(message: "Location Saved Successfully")
            } catch {
                // Handle the error, e.g., display an error message
                showErrorAlert(message: "Failed to save location")
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
