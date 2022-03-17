//
//  AttackTests.swift
//  chessTests
//
//  Created by Peter Shi on 2020-07-12.
//  Copyright © 2020 GoldThumb Inc. All rights reserved.
//

import XCTest
@testable import chess

class AttackTests: XCTestCase {
    func testAtakkingThng() {
        var board = Board()
//        board.pieces = [Piece(col: 0, row: 0, imageName: "void", isWhite: true, rank: .rook),
//                        Piece(col: 5, row: 0, imageName: "jdhv", isWhite: false, rank: .pawn),
//                        Piece(col: 0, row: 5, imageName: " rgx ", isWhite: true, rank: .pawn),
//                        Piece(col: 5, row: 1, imageName: " dj", isWhite: false, rank: .pawn)]
//        XCTAssertTrue(board.isBeingAttackedAt(col: 5, row: 0))
//        XCTAssertFalse(board.isBeingAttackedAt(col: 0, row: 5))
//        XCTAssertFalse(board.isBeingAttackedAt(col: 5, row: 1))
//        print(board)
        board.pieces = [Piece(col: 1, row: 1, imageName: "image_name", isWhite: false, cm: .pawn),
                        Piece(col: 5, row: 5, imageName: "<#image_name#>", isWhite: true, cm: .bishop)]
        XCTAssertTrue(board.isBeingAttackedAt(col: 1, row: 1))
        XCTAssertTrue(board.canBishopMove(fromCol: 5, fromRow: 5, toCol: 1, toRow: 1))
        XCTAssertTrue(board.canCapturePiece(pieceCol: 5, pieceRow: 5, col: 1, row: 1))
        XCTAssertTrue(board.canMove(fromCol: 5, fromRow: 5, toCol: 1, toRow: 1))
        print(board)
    }
}
