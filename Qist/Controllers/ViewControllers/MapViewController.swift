//
//  MapViewController.swift
//  Qist
//
//  Created by GrepRuby on 09/02/16.
//  Copyright © 2016 GrepRuby3. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseController {

    var strLat : String!
    var strLog : String!
    var strAddress : String!

    @IBOutlet var mapView : MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLatLogOnMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -  Overrided Methods of BaseController
    override func leftNavBackButtonTapped(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func setLatLogOnMap(){

        let latitude = Double(strLat!)
        let longitude = Double(strLog!)

        let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)

        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = strAddress
        //annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
    }

    

   

}
