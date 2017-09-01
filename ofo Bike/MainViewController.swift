//
//  ViewController.swift
//  ofo Bike
//
//  Created by Yu Wang on 8/17/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

import UIKit
import SidebarOverlay

class MainViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate{
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    @IBOutlet weak var panelView: UIView!
    
    // MARK: - UI stack
    @IBAction func locateTap(_ sender: Any) {
        searchBikeNearBy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // display MA map
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        // display user location and tracking mode
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.zoomLevel = 17
        
        // display panel view at upper layer
        view.bringSubview(toFront: panelView)
        
        // create search api instance
        search = AMapSearchAPI()
        search.delegate = self
        
        
        // add left bar button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftTopImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showSettingPage))
        
        // add right bar button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "rightTopImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showActivityPage))
        
        // add navigation title
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "ofoLogo"))
        
    }
    
    @objc func showActivityPage() {
        print("navigate to Activity page")
        
        // Perform segue to activity controller
        performSegue(withIdentifier: "ActivitySegue", sender: self)
        //If you want pass data while segue you can use prepare segue method
    }
    
    fileprivate func searchBikeNearBy() {
        //searchCustomLocation(mapView.centerCoordinate)
        searchCustomLocation(mapView.userLocation.coordinate)
    }
    
    func searchCustomLocation(_ center: CLLocationCoordinate2D) {
        
        // setup around search parameter
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "Restaurant"
        request.requireExtension = true
        request.radius = 500
        
        // invoke search
        search.aMapPOIAroundSearch(request)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        searchBikeNearBy()
//    }
    
    
    
    
//    @objc func showSettingPage() {
//        print("Setting page Displayed")
//
//        // Perform segue to activity controller
//        performSegue(withIdentifier: "SettingPageSegue", sender: self)
//        //If you want pass data while segue you can use prepare segue method
//    }
    
    // MARK: - Setting stack
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSettingPage() {
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
        }
    }
    
    // MARK: - Map Search Delegate
    // call back function - deal with search result
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count > 0 else {
            return
        }
        
        for poi in response.pois {
            print(poi.name)
        }
        
        // convert POI to PointAnnotation
        var pointAnnotations: [MAPointAnnotation] = []
        pointAnnotations = response.pois.map {
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if ($0.distance < 200) {
                annotation.title = "Red Pocket Bike"
                annotation.subtitle = "Ride 20 mins for free"
            } else {
                annotation.title = "Normal Bike"
            }
            return annotation
        }
        
        mapView.addAnnotations(pointAnnotations)
        mapView.showAnnotations(pointAnnotations, animated: true)
    }
    
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView? {
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
//
//            if annotation == nil {
//                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            }
//
//            if (annotation.title == "Red Pocket Bike") {
//                annotationView?.image = UIImage(named: "homepage_nearbyBikeRedPacket")
//            } else {
//                annotationView?.image = UIImage(named: "homepage_nearbyBike")
//            }
//
//            annotationView?.canShowCallout = true
//            annotationView?.animatesDrop = true
//            annotationView?.isDraggable = true
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
////            guard annotationView != nil else {
////                return nil
////            }
//            return annotationView
//        }
//        return nil
//    }
}

