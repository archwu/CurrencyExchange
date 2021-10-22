//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by AW on 10/21/21.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let symbolsURL = "http://api.exchangeratesapi.io/v1/symbols"
    let apiKey = "1a9032170ccf7939dc20b9f441a458e9"
    private var symbols = [String]()
    
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    @IBOutlet weak var outLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAvailableSymbol(symbols: symbols)
        fromPicker.delegate = self
        fromPicker.dataSource = self
        toPicker.delegate = self
        toPicker.dataSource = self
        
    }

//    func getAvailableSymbols() -> Promise <JSON> {
//        return Promise<JSON> {
//            seal -> Void in
//            let url = symbolsURL + "?apikey=" + apiKey
//
//            AF.request(url).responseJSON { response in
//                if response.error != nil {
//                    seal.reject(response.error!)
//                }
//                seal.fulfill(response.data)
//            }
//        }
//    }
    
    func getAvailableSymbol(symbols : [String]) {
        let url = symbolsURL + "?access_key=" + apiKey
        var symbols:[String] = []
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                let responseSucceed = value as! [String:Any]
                let error = responseSucceed["error"]
                let success = responseSucceed["success"]
                if error != nil {
                    print(error)
                    return
                }
                if success != nil {
                    let symbolsDict = responseSucceed["symbols"] as! [String:String]
                    symbols = Array(symbolsDict.keys)
                    print(symbols)
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return symbols.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return symbols[row]
    }
}

