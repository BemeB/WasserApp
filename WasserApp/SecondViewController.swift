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
    var ZielText = ""
    var wassertag = 0
    var Tagesziel = ""
    
    override func viewDidLoad() {
        wochend()
        monatsd()
        //monatsdurschnitt()
    }
   

    
    
    @IBOutlet weak var Ziellbl: UILabel!
    @IBOutlet weak var wochendurch: UILabel!
    @IBOutlet weak var monatsdurch: UILabel!
    @IBAction func überg(_ sender: Any) {
        ZielText = Ziellbl.text!
       performSegue(withIdentifier: "segue", sender: self)
        print(ZielText)
      /*  let zieltag = Int(ZielText)
        UserDefaults.standard.set(zieltag, forKey: "Tagesziel")
        UserDefaults.standard.synchronize()*/
    }
    
    @IBAction func slide(_ sender: UISlider) {
        let Ziel = sender.value
        let zielrnd = Ziel.rounded()
        Ziellbl.text = String(zielrnd)
    
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let firstViewController = segue.destination as! ViewController
        firstViewController.finalZielseg = Ziellbl.text!
        }
    
  //Funktion Monatsdurschnitt
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
        print("Something went wrong: \(String(describing: error))")
            return
        }
                                            
    let total = quantitySamples.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.literUnit(with: .milli)) }
            print("Wassermenge gesamt: \(total)")
            DispatchQueue.main.async {
                let durch = Int(total)/30
        self.monatsdurch.text = String(durch)
                }
            }
            HKHealthStore().execute(waterQuery)
        }
    
    
    // Funktion Wochendurschnitt
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
        print("Something went wrong: \(String(describing: error))")
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
