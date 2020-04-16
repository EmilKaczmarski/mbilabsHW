//
//  WeeklyWeatherCollectionDataSource.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 07/04/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import Foundation
import UIKit

class WeeklyWeatherCollectionDataSource: NSObject, UICollectionViewDataSource {
    var days: [List] = []

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.id, for: indexPath) as? DailyWeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.model = days[indexPath.row]

        return cell
    }
}
