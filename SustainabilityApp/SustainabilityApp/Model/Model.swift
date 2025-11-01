//
//  Model.swift
//  SustainabilityApp
//
//  Created by Utkarsh Upadhyay on 31/10/25.
//

import Foundation

struct Activity: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let xp: Int
    let showDot: Bool
    let buttonTitle: String? // "ACTIVATE"
}
