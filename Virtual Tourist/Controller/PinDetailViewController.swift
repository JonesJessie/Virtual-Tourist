//
//  PinDetailViewController.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/21/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PinDetailViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    var pinAnnotation: PinAnnotation?
    let spinner = SpinnerViewController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let pinAnnotation = pinAnnotation {
            mapView.addAnnotation(pinAnnotation)
            let region = MKCoordinateRegion(center: pinAnnotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func getNewCollection(_ sender: Any) {
        guard let pinAnnotation = pinAnnotation else { return }
        showSpinner()
        NetworkClient.searchPhotosFor(latitude: pinAnnotation.coordinate.latitude, longitude: pinAnnotation.coordinate.longitude) { (response, error) in
            if response.count > 0 {
                if let currentImages = pinAnnotation.pin.images {
                    pinAnnotation.pin.removeFromImages(currentImages)
                    try? DataController.shared.viewContext.save()
                }
                
                for imageUrl in response {
                    let photo = Photo(context: DataController.shared.viewContext)
                    photo.imageUrl = imageUrl
                    
                    
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        photo.image = imageData
                        pinAnnotation.pin.addToImages(photo)
                        try? DataController.shared.viewContext.save()
                    }
                }
                
                self.pinAnnotation = pinAnnotation
                
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.collectionView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.showAlert(title: "Sorry", message: "No images were found for this location or something went wrong.")
                }
            }
        }
    }
    
    func showSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension PinDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView {
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView.canShowCallout = false
            pinView.animatesDrop = true
            return pinView
        }
    }
}

extension PinDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pinAnnotation?.pin.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell, let pinAnnotation = pinAnnotation else {
            fatalError("Unable to dequeue PhotoCollectionViewCell.")
        }
        
        guard let images = pinAnnotation.pin.images else { return cell }
        
        if let photo = images.allObjects[indexPath.row] as? Photo,
            let imageData = photo.image {
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(data: imageData as Data)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let images = pinAnnotation?.pin.images else {return}
        if let imageToDelete = images.allObjects[indexPath.item] as? Photo {
            pinAnnotation?.pin.removeFromImages(imageToDelete)
            try? DataController.shared.viewContext.save()
            collectionView.deleteItems(at: [indexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (view.bounds.width - 12) / 2
        return CGSize (width: cellSize, height: cellSize)
    }
}
