//
//  ViewController.swift
//  HWS: Project 7
//
//  Created by Deonte on 6/13/19.
//  Copyright © 2019 Deonte. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Challenge 1: Add Credits button to the top right
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .done, target: self, action: #selector(handleCreditsButtonPressed))
        
        // Challenge 2: Let users filter the petitions they see.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterResults))
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json"
        }
        
        // Bad Practice but will be adressed later
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // We are ok to parse
                parse(json: data)
                return
            }
        }
        handleAlert(title: "Error Loading Page", message: "We are having trouble loading the Petition Data. Please ensure your internet connection is working.")
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.reloadData()
        }
    }
    
    @objc func handleAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(ac, animated: true)
    }
    
    @objc func handleCreditsButtonPressed() {
        if navigationController?.tabBarItem.tag == 0 {
            handleAlert(title: "Sample Data Provided by.", message: "www.hackingwithswift.com")
        } else {
            handleAlert(title: "Live Data Provided by.", message: "We the people API of the WhiteHouse.")
        }
        
    }
    
    @objc func filterResults() {
        let ac = UIAlertController(title: "Search Petitions", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let filteringPetitions = UIAlertAction(title: "Search", style: .default) { [weak self, weak ac] _ in
            guard let searchText = ac?.textFields?[0].text else {return}
            self?.search(searchText)
        }
        
        ac.addAction(filteringPetitions)
        present(ac, animated: true)
    }
    
    func search(_ search: String) {
        
        // Challenge 2: Incomplete but will return later to finish.
    }
    
}



extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
