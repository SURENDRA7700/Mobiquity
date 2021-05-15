//
//  CityVC.swift
//  Mobiquity
//
//  Created by surendra on 14/05/21.
//

import UIKit
import MapKit

//http://api.openweathermap.org/data/2.5/weather?lat=29.93&lon=79.93&appid=fae7190d7e6433ec3a45285ffcf55c86


let baseUrl = "http://api.openweathermap.org/data/2.5/weather?"

class CityVC: UIViewController {
    var locationObj : CLPlacemark? = nil
    private var weatherData : WeatherModel? = nil
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var layout = UICollectionViewFlowLayout()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        self.navigationController?.navigationBar.isHidden = true
        self.configureLayout()
    }
    
    func configureLayout()
    {
        collectionView.register(UINib.init(nibName: "CustomCollViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCollViewCell")
        layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (self.view.frame.size.width - 20) //some width
        layout.itemSize = CGSize(width: width, height: 125)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWeatherData()
    }
    
    func getWeatherData()
    {
        guard let wwatherObj =  locationObj else { return }
        let lat = "lat=\(wwatherObj.location?.coordinate.latitude ?? 0)"
        let lon = "&lon=\(wwatherObj.location?.coordinate.longitude ?? 0)"
        let appid = "&appid=fae7190d7e6433ec3a45285ffcf55c86"
        let url : String? = "\(baseUrl)"+lat+lon+appid
        WebServices.shared.getServiceCall(type: WeatherModel.self, urlString: url!, requiredToken: false, view: self.view, animateIndicator: true)
        {  (response) in
            do {
                DispatchQueue.main.async {
                    self.weatherData = response
                    self.tempLabel.text = "\(response?.main.tempMax ?? 0) 'c"
                    self.collectionView.reloadData()
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }

        
    }
    
    @objc func rotated() {
        layout.scrollDirection = .horizontal
        self.collectionView.reloadData()
    }



    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
        


}


extension CityVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollViewCell", for: indexPath) as! CustomCollViewCell
        cell.configureLayout(weatherData: self.weatherData, index: indexPath.item)
        self.tempLabel.text = "\(self.weatherData?.main.tempMax ?? 0) 'c"

        return cell
    }
}
