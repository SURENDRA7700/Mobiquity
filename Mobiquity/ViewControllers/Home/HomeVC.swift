//
//  HomeVC.swift
//  Mobiquity
//
//  Created by surendra on 14/05/21.
//

import UIKit
import MapKit

class HomeVC: UIViewController {
    
    
    @IBOutlet weak var locationEmptyLbl: UILabel!
    @IBOutlet weak var locationTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var orgArray : [CLPlacemark] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        let nibNameobj = UINib(nibName: "AddressCell", bundle:nil)
        locationTable.register(nibNameobj, forCellReuseIdentifier: "AddressCell")
        locationTable.separatorStyle = .none
        locationTable.delegate = self
        locationTable.dataSource = self
        locationTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)

        searchBar.delegate = self
        searchBar.placeholder = "Search address"
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.showsCancelButton = true;
        searchBar.tintColor = UIColor.ketoGenik.DarkBlue
        searchBar.autocapitalizationType = .none

        self.locationTable.isHidden = true
        searchBar.isHidden = true
        if (ApiService.sharedManager.locationArray.count != 0) {
            self.locationTable.isHidden = false
            searchBar.isHidden = false
            self.orgArray = ApiService.sharedManager.locationArray
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationTable.reloadData()
    }
    
    
    @IBAction func addLocations(_ sender: Any) {
        let vc = MapVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func rotated() {
        self.locationTable.reloadData()
    }


}


extension HomeVC : UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ApiService.sharedManager.locationArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell") as? AddressCell else { return AddressCell() }
        let eachBlog = ApiService.sharedManager.locationArray[indexPath.row]
        let address = "\(eachBlog.name ?? "") \(eachBlog.subLocality ?? "")"
        cell.topLabelAddres.text = address
        cell.secLabelAddrInfo.text = "\(eachBlog.location?.coordinate.latitude ?? 0)"
        cell.thirdLabel.text = "\(eachBlog.location?.coordinate.longitude ?? 0)"
        cell.selectionStyle = .none
        cell.sselectBtn.tag = indexPath.row
        cell.sselectBtn.addTarget(self, action: #selector(updateAddressWithIndex(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func updateAddressWithIndex(sender:UIButton){
        let alert = UIAlertController(title: "", message: "Are you sure want to delete Address", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { [self] (action) in
            
            let eachBlog = ApiService.sharedManager.locationArray[sender.tag]
            if let index = ApiService.sharedManager.locationArray.firstIndex(where: {$0.name == eachBlog.name}){
                    ApiService.sharedManager.locationArray.remove(at: index)
            }
            locationTable.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)


    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eachBlog = ApiService.sharedManager.locationArray[indexPath.row]
        let cityVC = CityVC()
        cityVC.locationObj = eachBlog
        cityVC.modalPresentationStyle = .fullScreen
        self.present(cityVC, animated: true, completion: nil)
    }
    
    
}


extension HomeVC : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString(searchBar)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            searchBar.resignFirstResponder()
            self.locationTable.reloadData()
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchString(searchBar)
        self.searchBar.resignFirstResponder()
        self.locationTable.reloadData()
    }
    
    //filter search results
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchString(searchBar)
    }
    
    func searchString(_ searchBar: UISearchBar)
    {
        ApiService.sharedManager.locationArray.removeAll()
        if (((searchBar.text?.utf8.count)!) > 0) {
            do {
                let searchString = self.searchBar.text?.trimWhiteSpace()
                if searchString != "", searchString!.count > 0 {
                    if let text = self.searchBar.text {
                        ApiService.sharedManager.locationArray = self.orgArray.filter {
                            ($0.name?.lowercased().contains(text.lowercased()))!
                        }
                    }
                }
                self.locationTable.reloadData()
                self.searchBar.resignFirstResponder()
            } catch let error {
            }
            
        }else{
            ApiService.sharedManager.locationArray = orgArray
            self.locationTable.reloadData()
            self.searchBar.resignFirstResponder()
        }
    }
    
    
}

extension String {
    func trimWhiteSpace() -> String {
        let string = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return string
    }
}

