//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Artem Mazur on 15.07.2020.
//  Copyright © 2020 Artem Mazur. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "FCB73A6F-8582-487E-B784-9DFBA92C2BEF"
    let currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","INR","JPY","MXN","NZD","PLN","RUB","SGD","USD","ZAR"]

    func getCoinPrice(for currencyName: String)  {
        let urlString = "\(baseURL)\(currencyName)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {

                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let bitCoinPrice = self.parseJSON(safeData) {
                        let cryptoString = String(format: "%.2f", bitCoinPrice)
                        self.delegate?.didUpdatePrice(price: cryptoString, currency: currencyName)
                        }

                    }
                }
                 task.resume()
            }
    }
    func parseJSON(_ exhangeData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinModel.self, from: exhangeData)
            let coinPrice = decodedData.rate
            print(String(format: "%.2f", coinPrice))
            
            return coinPrice
        } catch  {
            delegate?.didFailWithError ( error: error)
            return nil
        }

    }

}
