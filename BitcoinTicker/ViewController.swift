

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","TRY"]
    let currenySymbolArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "₺"]
    var currencySelected = ""
    var finalURL = ""
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return   currencyArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
  
        finalURL = baseURL + currencyArray[row]
        currencySelected = currenySymbolArray[row]
        getBitcoinData(url: finalURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }
    
    //MARK: - Networking
        /***************************************************************/
    
        func getBitcoinData(url: String) {
    
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.result.isSuccess {
    
                        print("Sucess! Got the bitcoin data")
                        let bitcoinJSON : JSON = JSON(response.result.value!)
    
                        self.updateBitcoinData(json: bitcoinJSON)
    
                    } else {
                        print("Error: \(response.result.error)")
                        self.bitcoinPriceLabel.text = "Connection Issues"
                    }
            }
    
        }
    
    
    
    
    
        //MARK: - JSON Parsing
        /***************************************************************/
    
        func updateBitcoinData(json : JSON) {
    
            if  let bitcoinResult = json["ask"].double {
                
                bitcoinPriceLabel.text = String(bitcoinResult) + " " + currencySelected
            }
            else {
                bitcoinPriceLabel.text = "Price Unavailable"
            }
    
            
           
        }
        
    
    
    
    
}

