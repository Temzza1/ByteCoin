//
//  ViewController.swift
//  ByteCoin
//
//  Created by Artem Mazur on 15.07.2020.
//  Copyright © 2020 Artem Mazur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
        
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
        var coinManager = CoinManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            coinManager.delegate = self
            currencyPicker.delegate = self
            currencyPicker.dataSource = self
        }
        
        func didUpdatePrice(price : String, currency : String) {
            DispatchQueue.main.async {
                self.currencyLabel.text = price
                self.bitcoinLabel.text = currency
                
            }
        }
        
        func didFailWithError(error: Error) {
            print(error)
        }
        
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return coinManager.currencyArray.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            return coinManager.currencyArray[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectCurrency = coinManager.currencyArray[row]
            coinManager.getCoinPrice(for: selectCurrency)
    //        print(coinManager.currencyArray[row])
        }

}


