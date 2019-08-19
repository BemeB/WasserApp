//
//  ViewController.swift
//  WasserApp
//
//  Created by Benedict Baldus on 18.08.19.
//  Copyright © 2019 Benedict Baldus. All rights reserved.
//

import UIKit
import HealthKit

class ViewController:UIViewController {
    
        
    var wassertag = 0
    var tagesziel = ""
    var finalZiel = 0
    var finalZielseg = ""
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        enablehealth()
        save()
        
        
        
    }
    @IBOutlet weak var label: UILabel!
    
    lazy var healthStore = HKHealthStore()
    func enablehealth(){
        var shareTypes = Set<HKSampleType>()
        shareTypes.insert(HKSampleType.quantityType(forIdentifier: .dietaryWater)!)

        var readTypes = Set<HKSampleType>()
        readTypes.insert(HKSampleType.quantityType(forIdentifier: .dietaryWater)!)

        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) -> Void in
            if success {
                print("success")
            } else {
                print("failure")
            }

            if let error = error { print(error) }
        }
        
    }
    
    func save(){
        finalZiel = UserDefaults.standard.integer(forKey: "Tagesziel")
        label.text = String(finalZiel)+" ml"
    }
    
    
    @IBOutlet weak var waterLabel: UILabel!
    @IBAction func stepper(_ sender: UIStepper) {
        if sender.value == Double(1){
            sender.value = 50
        }
        sender.stepValue = 50
        sender.minimumValue = 0
        sender.maximumValue = 2000
        waterLabel.text = String(Int(sender.value))
        if sender.value > 950{
            sender.stepValue = 100
        }else {
            sender.stepValue = 50
        }
        save()

        
    }
    
    @IBAction func buttonadd(_ sender: UIButton) {
        wassertag = Int(waterLabel.text!)!
        if let waterType=HKSampleType.quantityType(forIdentifier: .dietaryWater){
            
            let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: Double(wassertag))
            let today = Date()
            let waterQuantitySample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: today, end: today)
            
            HKHealthStore().save(waterQuantitySample) { (success, error) in
                print(self.wassertag)
            }
        }else {
            print("Sample type not available")
            return
            
        }
        
        if (wassertag >= finalZiel) {
            let tag : String = String(finalZiel)
        print("Tagesziel von " + tag + "wurde erreicht")
            
        }
}
}
