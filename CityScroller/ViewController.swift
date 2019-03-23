//
//  ViewController.swift
//  CityScroller
//
//  Created by Karol Struniawski on 20/03/2019.
//  Copyright © 2019 Karol Struniawski. All rights reserved.
//

import UIKit

/*
 let height = CGFloat.random(min: 350, max: maxBuildingHeight)
 let width = CGFloat.random(min: 120, max: 200)
 class var maxBuildingHeight: CGFloat {
 return UIScreen.main.bounds.height + 50.0
 }
 */

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var buildings = [BuildingView]()
    var buildingsLeftCorner = CGFloat()
    var buildingsRightCorner = CGFloat()
    var moon = UIView()
    var setup = true

    func loadBuildings(){
        var moveBy = 400.0
        while moveBy <= 400 + Double(self.view.bounds.maxX){
            let building = BuildingView.randomBuilding()
            building.center = CGPoint(x: CGFloat(moveBy) + (building.frame.width/2), y: scrollView.bounds.height - (building.frame.height/2) + 50)
            moveBy = moveBy + Double(building.frame.width)
            buildingsRightCorner = building.frame.maxX
            buildings.append(building)
            scrollView.addSubview(building)
        }
    }

    func spawnMoon(){
        let moonRect = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        let moon = UIView(frame: moonRect)
        moon.center = CGPoint(x: 50, y: 100)
        moon.backgroundColor = .yellow
        moon.layer.cornerRadius = moon.frame.width / 2
        self.moon = moon
        scrollView.addSubview(moon)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: self.view.bounds.width + 800, height: UIScreen.main.bounds.height + 50.0)
        scrollView.backgroundColor = .darkGray

        scrollView.contentOffset.y = 50.0
        scrollView.contentOffset.x = 400.0
        buildingsLeftCorner = 400.0
        scrollView.isDirectionalLockEnabled = true
    }

    override func viewWillLayoutSubviews() {

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup = true
        spawnMoon()
        loadBuildings()
        setup = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        moon.frame.origin.x = scrollView.contentOffset.x + 10.0
        print(buildings.count)

        if scrollView.contentOffset.x + self.view.bounds.width >= buildingsRightCorner && !setup{
            spawnBuildingRight()
        }

        if scrollView.contentOffset.x <= buildingsRightCorner && !setup{
            spawnBuildingLeft()
        }

        if let firstBuildingWidth = buildings.first?.frame.width{
            if scrollView.contentOffset.x >= buildingsLeftCorner + firstBuildingWidth{
                let width = buildings.first?.frame.width
                buildings.first?.removeFromSuperview()
                buildings.removeFirst()
                buildings.forEach { (bld) in
                    bld.center.x -= width!
                }
                buildingsLeftCorner = (buildings.first?.frame.minX)!
                buildingsRightCorner = (buildings.last?.frame.maxX)!
                scrollView.contentOffset.x = buildingsLeftCorner
            }
        }
    }

    func spawnBuildingRight(){
        let building = BuildingView.randomBuilding()
        building.center = CGPoint(x: buildingsRightCorner + (building.frame.width/2), y: scrollView.bounds.height - (building.frame.height/2) + 50)
        buildingsRightCorner = building.frame.maxX
        buildings.append(building)
        scrollView.addSubview(building)
    }

    func spawnBuildingLeft(){
        
    }
}

