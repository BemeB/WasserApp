//
//  SecondViewController.swift
//  WasserApp
//
//  Created by Benedict Baldus on 19.08.19.
//  Copyright © 2019 Benedict Baldus. All rights reserved.
//

import UIKit
import HealthKit

class SecondViewController: UIViewController{
    
    
    
    var tageszielo = ""
    var  ZielText = ""
    var wassertag = 0
    
    override func viewDidLoad() {
        wochend()
        monatsd()
        //monatsdurschnitt()
    }
   /*
    @IBOutlet weak var picker: UIPickerView!
    let ziel = ["1000", "1500","2000"]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ziel[row]
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ziel.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tageszielo = ziel[row]
        print(tageszielo)
        
    }*/

    @IBOutlet weak var text: UITextField!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
       print(self.ZielText)
        vc.finalZielseg = self.ZielText
    }
    
    @IBOutlet weak var wochendurch: UILabel!
    @IBOutlet weak var monatsdurch: UILabel!
    @IBAction func überg(_ sender: Any) {
        self.ZielText = text.text!
      // performSegue(withIdentifier: "name", sender: self)
        
        UserDefaults.standard.set(ZielText, forKey: "Tagesziel")
        UserDefaults.standard.synchronize()
        
        
    }
  /*  func monatsdurschnitt(){
       if let waterType=HKSampleType.quantityType(forIdentifier: .dietaryWater){
            
            let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: Double(wassertag))
            let today = Date()
            let waterQuantitySample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: today, end: today)
            
            HKHealthStore().read(waterQuantitySample) { (success, error) in
                print(self.wassertag)
                HKHealthStore.load()
            }
        }else {
            print("Sample type not available")
            return
            
        }
    }*/
     func monatsd() {
            guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
                print("Sample type not available")
                return
            }
            
        let last30DPredicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-2592000), end: Date(), options: .strictEndDate)
            
            let waterQuery = HKSampleQuery(sampleType: waterType,
                                           predicate: last30DPredicate,
                                           limit: HKObjectQueryNoLimit,
                                           sortDescriptors: nil) {
                                            (query, samples, error) in
                                            
    guard error == nil, let quantitySamples = samples as? [HKQuantitySample] else {
            print("Something went wrong: \(error)")
            return
        }
                                            
    let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) }
            print("Wassergesamt Menge: \(total)")
            DispatchQueue.main.async {
                let durch = Int(total)/30
        self.monatsdurch.text = String(durch)
                }
            }
            HKHealthStore().execute(waterQuery)
        }
    func wochend() {
            guard let waterType = HKSampleType.quantityType(forIdentifier: .dietaryWater) else {
                print("Sample type not available")
                return
            }
            
        let last7DPredicate = HKQuery.predicateForSamples(withStart: Date().addingTimeInterval(-604800), end: Date(), options: .strictEndDate)
            
            let waterQuery = HKSampleQuery(sampleType: waterType,
                                           predicate: last7DPredicate,
                                           limit: HKObjectQueryNoLimit,
                                           sortDescriptors: nil) {
                                            (query, samples, error) in
                                            
    guard error == nil, let quantitySamples = samples as? [HKQuantitySample] else {
            print("Something went wrong: \(error)")
            return
        }
                                            
    let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) }
            print("Wassergesamt Menge: \(total)")
            DispatchQueue.main.async {
                let durch = Int(total)/7
        self.wochendurch.text = String(durch)
                }
            }
            HKHealthStore().execute(waterQuery)
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


