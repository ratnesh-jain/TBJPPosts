//
//  File.swift
//  
//
//  Created by Ratnesh Jain on 26/05/24.
//

import Foundation
import UIKit

class AppTableViewDiffableDataSource<Section, Row>: UITableViewDiffableDataSource<Section, Row> 
where Section: Hashable & RawRepresentable, Row: Hashable, Section.RawValue == String {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        self.snapshot().sectionIdentifiers[section].rawValue
    }
    
}
