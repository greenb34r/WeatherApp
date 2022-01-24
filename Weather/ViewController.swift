//
//  ViewController.swift
//  Weather
//
//  Created by Алексей Матвеев on 09.01.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }

}

extension ViewController: UISearchBarDelegate {
    
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            searchBar.resignFirstResponder()
            let encodedString  = "\(searchBar.text!)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let urlString = "http://api.weatherstack.com/current?access_key=737be9f22cf099d909aa3c6eed678889&query=\(encodedString!))"
            let url = URL(string: urlString)
            
            var locationName: String?
            var temperature: Double?
            var errorHasOccured: Bool = false
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
               
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    if let _ = json["error"] {
                        errorHasOccured = true
                    }
                    
                    if let location = json["location"] {
                        locationName = location["name"] as? String
                    }
                    
                    if let current = json["current"] {
                        temperature = current["temperature"] as? Double
                    }
                    DispatchQueue.main.async {
                        if errorHasOccured { 
                            self.cityLabel.text = "Такого города не существует"
                            self.temperatureLabel.text = "ERROR"
                            self.temperatureLabel.isHidden = true
                        } else {
                            self.cityLabel.text = locationName
    //                        if let temp = temperature {
                            self.temperatureLabel.text = "\(temperature!)"
                            self.temperatureLabel.isHidden = false
    //                        }
                        }

                    }
                }
                catch let jsonError {
                    print(jsonError)
                }
            }
            task.resume()
        }
    }

