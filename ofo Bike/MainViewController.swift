//
//  ViewController.swift
//  ofo Bike
//
//  Created by Yu Wang on 8/17/17.
//  Copyright © 2017 Yu Wang. All rights reserved.
//

import UIKit
import SidebarOverlay

class MainViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate{
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var customPin: CustomPinAnnotation!
    var customPinView: MAAnnotationView!
    var nearSearch: Bool = true
    var walkManager: AMapNaviWalkManager!
    
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
        
        // init Walk Manager
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
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
    
    // after Map view is initilized
    func mapInitComplete(_ mapView: MAMapView!) {
        
        // init custom pin
        customPin = CustomPinAnnotation()
        customPin.coordinate = mapView.centerCoordinate
        customPin.lockedScreenPoint = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        customPin.isLockedToScreen = true
        
        // show custom pin
        mapView.addAnnotation(customPin)
        mapView.showAnnotations([customPin], animated: true)
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
    
    // MARK: - Pin Animation
    func PinAmination() {
        let endPin = customPinView?.frame
        customPinView?.frame = (endPin?.offsetBy(dx: 0, dy: -15))!
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
            self.customPinView?.frame = endPin!
        }, completion: nil)
    }
    
    
    // MARK: - Map Search Delegate
    
    /// 用户地图交互
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - wasUserAction: 是否用户行为
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            customPin.isLockedToScreen = true
            PinAmination()
            searchCustomLocation(mapView.centerCoordinate)
        }
    }
    
    
    // retrieve search result, configure annotation and add annotation into mapView
    ///
    /// - Parameters:
    ///   - request: search request
    ///   - response: search response
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
        
        // add annotations into mapView
        mapView.addAnnotations(pointAnnotations)
        if nearSearch {
            mapView.showAnnotations(pointAnnotations, animated: true)
            nearSearch = !nearSearch
        }
    }
    
    
    // MARK: - Map View Delegate
    /// configure and display annotation view
    ///
    /// - Parameters:
    ///   - mapView: mapView
    ///   - annotation: annotation
    /// - Returns: annotationView
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        // ignore user location annotation view
        if annotation.isKind(of: MAUserLocation.self) {
            return nil
        }
        
        // display custom annotation view
        if annotation.isKind(of: CustomPinAnnotation.self) {
            let pointReuseIndetifier = "custompointReuseIndetifier"
            var cpv: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if cpv == nil {
                cpv = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            cpv?.image = UIImage(named: "homePage_wholeAnchor")
            customPinView = cpv
            return cpv!
        }
        
        // display bike annotation view
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
                as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            if (annotation.title == "Red Pocket Bike") {
                annotationView?.image = UIImage(named: "HomePage_nearbyBikeRedPacket")
            } else {
                annotationView?.image = UIImage(named: "HomePage_nearbyBike")
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return annotationView!
        }
        return nil
    }
    
    // Add Annotation Animation - zoom up annotation view
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aView in aViews {
            if aView.isKind(of: MAPinAnnotationView.self) {
                aView.transform = CGAffineTransform(scaleX: 0, y: 0)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                    aView.transform = .identity
                }, completion: nil)
            }
        }
    }
    
    // select annotation View
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
        let start = customPin.coordinate
        let end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(start.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        
        walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
    }
    
    // MARK: - AMap Navi Walk Manager Delegate 导航代理
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("start navigation")
        
        //显示路径或开启导航
    }
    
}

