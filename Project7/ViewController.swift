//
//  ViewController.swift
//  Project7
//
//  Created by iMac on 01/07/2021.
//

import UIKit

class ViewController: UITableViewController, UISearchResultsUpdating {
    var petitions = [Petition]()
    var petitionsFilter = [Petition]()
    let searchController = UISearchController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(infoActualList))
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        // Pour l'instant on fait tout dans le viewcontroller mais cela est fortement déconseillé, notamment par rapport au fait de charger des données directement dans le viewDidLoad
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json" // la redirection !
        }
        else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
            
        }
        
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Erreur de chargement", message: "Il y a eu un problème de chargement, veuillez réessayer !", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK Tant pis :(", style: .default))
        present(ac, animated: true)
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            petitionsFilter = petitions
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionsFilter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitionsFilter[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController() // notre page !
        vc.detailItem = petitionsFilter[indexPath.row]
        navigationController?.pushViewController(vc, animated: true) // la redirection !
    }
    
    @objc func infoActualList() {
        let ac = UIAlertController(title: "Source", message: navigationController?.tabBarItem.tag == 0 ? "Petition 1 de HWS" : "Petition 2 de HWS", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
        
        if(text.isEmpty) {
            petitionsFilter = petitions
        } else {
            petitionsFilter = petitions.filter{$0.title.contains(text) || $0.body.contains(text)}
        }
        
        tableView.reloadData()
        
    }
}

