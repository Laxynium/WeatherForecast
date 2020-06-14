//
//  UIImageViewExtension.swift
//  WeatherForecast
//
//  Created by GG on 12/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL, onFinish: @escaping ()->Void = {}) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        onFinish()
                    }
                }
            }
        }
    }
}
