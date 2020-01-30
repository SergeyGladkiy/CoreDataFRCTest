//
//  Source.swift
//  JuniorExercize
//
//  Created by Serg on 05.01.2020.
//  Copyright © 2020 Sergey Gladkiy. All rights reserved.
//

import Foundation

protocol InterfaceSourceInfo {
    var sectionName: String { get }
    var labelNameOfRows: [String]! { get }
}

struct FieldsOfCourse: InterfaceSourceInfo {
    var sectionName: String
    var labelNameOfRows: [String]!
}

struct StudentsOfCourse: InterfaceSourceInfo {
    var sectionName: String
    var labelNameOfRows: [String]!
}
