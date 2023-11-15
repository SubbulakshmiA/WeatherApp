//
//  CustomViewCell.swift
//  WeatherApp
//
//  Created by user248645 on 10/14/23.
//

import Foundation

import UIKit

class CustomViewCell :  UITableViewCell {
    
    @IBOutlet weak var myDateLbl: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    
//    func configCellwith(photo : Photo){
//        myDateLbl.text = photo.earth_date
//        Service.shared.getDataFrom(urlStr: photo.img_src) { result in
//            switch result  {
//            case .failure(let err) : print("err \(err)")
//            case .success(let data):
//                DispatchQueue.main.async {
//                    self.myImgView.image = UIImage(data: data)
//                }
//            }
//        }
  //  }
    
}
