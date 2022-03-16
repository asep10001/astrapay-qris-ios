//
// Created by Gilbert on 01/01/22.
// Copyright (c) 2022 Astra Digital Arta. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct QRPaylaterResponseDto: Codable {
    let content: [Content]?
    let number, size, totalElements: Int?
    let pageable: Pageable?
    let last: Bool?
    let totalPages: Int?
    let sort: Sort?
    let first: Bool?
    let numberOfElements: Int?
    let empty: Bool?
}

// MARK: - Content
struct Content: Codable {
    let partnerName: String?
    let limit: Int?
    let status: String?
}

// MARK: - Pageable
struct Pageable: Codable {
    let sort: Sort?
    let offset, pageNumber, pageSize: Int?
    let paged, unpaged: Bool?
}

// MARK: - Sort
struct Sort: Codable {
    let sorted, unsorted, empty: Bool?
}