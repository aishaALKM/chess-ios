//
//  BoardTests.swift
//  chessTests
//
//  Created by Peter Shi on 2018-10-30.
//  Copyright © 2018 GoldThumb Inc. All rights reserved.
//

import XCTest
@testable import chess

class BoardTests: XCTestCase {
    
    /*
       0 1 2 3 4 5 6 7
     0 . . . . . . . .
     1 . . . . . o . . <= hw: write a func to check if a point is under attack
     2 . . . . . . . .
     3 . . . . . . . .
     4 . . . . . . . .
     5 . . . . . . . .
     6 . . . . . . . .
     7 . . . . . . . .
     */
    
    
    func testPrintBoard() {
        let board = Board()
        print(board)
    }
    
    func testIsBeingAttacked() {
        /*
           0 1 2 3 4 5 6 7
         0 b < . . . . . .
         1 ^ . . . . . . .
         2 . . . . . . . .
         3 . . . . . . . .
         4 . . . . . . . .
         5 . . . . . . . .
         6 . . . . . . . .
         7 . . . . . . . B
         */
        var board = Board()
        board.pieces = [
//            Piece(col: 0, row: 0, imageName: "bb", isWhite: false, rank: .bishop),
            Piece(col: 7, row: 7, imageName: "wb", isWhite: true, rank: .bishop)
        ]
        XCTAssertTrue(board.isBeingAttackedAt(col: 0, row: 0))
        
        /*
           0 1 2 3 4 5 6 7
         0 . . . . . . . .
         1 . . . . N . . .
         2 . . . . 1 . . .
         3 . . . . . 2 . .
         4 . . . . . . . .
         5 . . Q . . . . .
         6 . . . . . . . .
         7 . . . . 3 . R .
         */
        board.pieces = [
            Piece(col: 4, row: 1, imageName: "bn", isWhite: false, rank: .knight),
            Piece(col: 2, row: 5, imageName: "bq", isWhite: false, rank: .queen),
            Piece(col: 6, row: 7, imageName: "br", isWhite: false, rank: .rook)
        ]
        XCTAssertFalse(board.isBeingAttackedAt(col: 4, row: 2))
        XCTAssertTrue(board.isBeingAttackedAt(col: 5, row: 3)) // (4, 1) => (5, 3)
        XCTAssertTrue(board.isBeingAttackedAt(col: 4, row: 7))
    }
    
    func testPiecesBetween() {
        
        
        /*
          0 1 2 3 4 5 6 7
        0 p . . . . . . .
        1 . . . . . . . .
        2 . . . . . . . .
        3 . . . . . . . .
        4 . . . . . . . .
        5 . . . . . . . .
        6 . . . . . . . .
        7 r . . . . . . .
        */
        var anything = Board()
        anything.pieces = [Piece(col: 0, row: 0, imageName: "wr", isWhite: false, rank: .pawn),
                           Piece(col: 0, row: 7, imageName: "wr", isWhite: false, rank: .rook),
        ]
        XCTAssertEqual(anything.numPiecesInBetween(fromRow: 0, fromCol: 0, toCol: 0, toRow: 7), 0)
        
        print(anything)
        
        /*
           0 1 2 3 4 5 6 7
         0 p . . . . . . .
         1 . . . . . . . .
         2 . . . . . . . .
         3 . . . . . . . .
         4 . . . . . . . .
         5 . . . . . . . .
         6 . . . . . . . .
         7 r . . . . . . .
         */
        
        var board = Board()
        
        board.pieces = [Piece(col: 0, row: 0, imageName: "wr", isWhite: false, rank: .pawn),
                        Piece(col: 0, row: 4, imageName: "wr", isWhite: false, rank: .bishop),
                        Piece(col: 0, row: 7, imageName: "wr", isWhite: false, rank: .rook),
        ]
        
        XCTAssertEqual(board.numPiecesInBetween(fromRow: 0, fromCol: 0, toCol: 0, toRow: 7), 1)
        
        XCTAssertEqual(board.numPiecesInBetween(fromRow: 0, fromCol: 0, toCol: 0, toRow: 0), 0)
    }
    
    func testPiecesBetweenD() {
        /*
         + 0 1 2 3 4 5 6 7
         0 b . . . . . . .
         1 . . . . . . . .
         2 . . n . . . . .
         3 . . . . . . . .
         4 . . . . n . . .
         5 . . . . . . . .
         6 . . . . . . . .
         7 r . . . . . . .
         */
        var anything = Board()
        anything.pieces = [Piece(col: 0, row: 0, imageName: "bb", isWhite: false, rank: .bishop),
                           Piece(col: 4, row: 4, imageName: "bn", isWhite: false, rank: .knight),
                           Piece(col: 2, row: 2, imageName: "bn", isWhite: false, rank: .knight)
        ]
        XCTAssertEqual(2, anything.numPiecesInBetween(fromRow: 0, fromCol: 0, toCol: 7, toRow: 7))
        
        print(anything)
        
    }
    
    func testBoardPieces() {
        var anything = Board()
        anything.pieces = [Piece(col: 1, row: 1, imageName: "<#String#>", isWhite: false, rank: .pawn),
                           Piece(col: 0, row: 0, imageName: "<#String#>", isWhite: false, rank: .rook),
                           Piece(col: 2, row: 7, imageName: "<#String#>", isWhite: true, rank: .bishop),
                           Piece(col: 4, row: 0, imageName: "<#String#>", isWhite: false, rank: .queen),
                           Piece(col: 7, row: 1, imageName: "<#String#>", isWhite: false, rank: .pawn),
                           Piece(col: 5, row: 6, imageName: "<#String#>", isWhite: true, rank: .pawn),
        ]
        print(anything)
    }
    
    // FIXME: Swift
    
    /*
    r n b q k b n r
    p p p p p p p p
    . . . . . . . .
    . . . . . . . .
    . . . . . . . .
    . . . . . . . .
    P P P P P P P P
    R N B Q K B N R
    */
    func testInitialBoard() {
        var board = Board()
        
        board.pieces = [
            Piece(col: 0, row: 0, imageName: "<#String#>", isWhite: false, rank: .rook),
            Piece(col: 1, row: 0, imageName: "<#String#>", isWhite: false, rank: .knight),
            Piece(col: 2, row: 0, imageName: "<#String#>", isWhite: false, rank: .bishop),
            Piece(col: 3, row: 0, imageName: "<#String#>", isWhite: false, rank: .queen),
            Piece(col: 4, row: 0, imageName: "<#String#>", isWhite: false, rank: .king),
            Piece(col: 5, row: 0, imageName: "<#String#>", isWhite: false, rank: .bishop),
            Piece(col: 6, row: 0, imageName: "<#String#>", isWhite: false, rank: .knight),
            Piece(col: 7, row: 0, imageName: "<#String#>", isWhite: false, rank: .rook),
            Piece(col: 0, row: 7, imageName: "<#String#>", isWhite: true, rank: .rook),
            Piece(col: 1, row: 7, imageName: "<#String#>", isWhite: true, rank: .knight),
            Piece(col: 2, row: 7, imageName: "<#String#>", isWhite: true, rank: .bishop),
            Piece(col: 3, row: 7, imageName: "<#String#>", isWhite: true, rank: .queen),
            Piece(col: 4, row: 7, imageName: "<#String#>", isWhite: true, rank: .king),
            Piece(col: 5, row: 7, imageName: "<#String#>", isWhite: true, rank: .bishop),
            Piece(col: 6, row: 7, imageName: "<#String#>", isWhite: true, rank: .knight),
            Piece(col: 7, row: 7, imageName: "<#String#>", isWhite: true, rank: .rook),
        ]
        
        for bpawnNo in 0...7 {
            board.pieces.insert(Piece(col: bpawnNo, row: 1, imageName: "<#String#>", isWhite: false, rank: .pawn))
        }
        for wpawnNo in 0...7 {
            board.pieces.insert(Piece(col: wpawnNo, row: 6, imageName: "<#String#>", isWhite: true, rank: .pawn))
        }
        XCTAssertEqual(32, board.pieces.count)
        print(board)
    }
    
    func testK() {
        let board = Board()
        XCTAssertTrue(board.canKingMove(fromCol: 7, fromRow: 7, toCol: 6, toRow: 7))
        XCTAssertTrue(board.canKingMove(fromCol: 7, fromRow: 7, toCol: 6, toRow: 6))
    }
    
    func testQ() {
        let board = Board()
        XCTAssertFalse(board.canQueenMove(fromCol: 0, fromRow: 0, toCol: 1, toRow: 3))
    }
    
    func testB() {
        var board = Board()
        XCTAssertTrue(board.canBishopMove(fromCol: 2, fromRow: 0, toCol: 0, toRow: 2))
        
        /*
           0 1 2 3 4 5 6 7
         0 . . o . . . . .
         1 . n . . . . . .
         2 O . . . . . . .
         3 . . . . . . . .
         4 . . . . . . . .
         5 . . . . . . . .
         6 . . . . . . . .
         7 . . . . . . . .
         */
        board.pieces = [Piece(col: 1, row: 1, imageName: "bn", isWhite: false, rank: .knight)]
        XCTAssertFalse(board.canBishopMove(fromCol: 2, fromRow: 0, toCol: 0, toRow: 2))
        
        /*
           0 1 2 3 4 5 6 7
         0 . . o . . . . .
         1 . . . . . . . .
         2 . . . . . . . .
         3 . . . . . . . .
         4 . . . . . . . .
         5 . . . . . . . o
         6 . . . . . . . .
         7 . . . . . . . .
         */
        board.pieces = [
        ]
        XCTAssertTrue(board.canBishopMove(fromCol: 7, fromRow: 5, toCol: 2, toRow: 0))
        
        /*
           0 1 2 3 4 5 6 7
         0 . . o . . . . .
         1 . . . . . . . .
         2 . . . . n . . .
         3 . . . . . . . .
         4 . . . . . . n .
         5 . . . . . . . o
         6 . . . . . . . .
         7 . . . . . . . .
         */
        board.pieces = [Piece(col: 4, row: 2, imageName: "bn", isWhite: false, rank: .knight),
            Piece(col: 6, row: 4, imageName: "bn", isWhite: false, rank: .knight)
        ]
        XCTAssertFalse(board.canBishopMove(fromCol: 7, fromRow: 5, toCol: 2, toRow: 0))
        
        /*
           0 1 2 3 4 5 6 7
         0 . . . . . . O .
         1 . . . . . . . .
         2 . . . . . . . .
         3 . . . . . . . .
         4 . . . . . . . .
         5 . . . . . . . .
         6 O . . . . . . .
         7 . . . . . . . .
         */
        
        board.pieces = []
        
        XCTAssertTrue(board.canBishopMove(fromCol: 2, fromRow: 7, toCol: 6, toRow: 3))
//        XCTAssertTrue(board.canBishopMove(fromCol: 1, fromRow: 7, toCol: 5, toRow: 3))
    }
    
    func testN() {
        var board = Board()
        board.pieces = [Piece(col: 2, row: 2, imageName: "bn", isWhite: false, rank: .knight)]
        XCTAssertTrue(board.canKnightMove(fromCol: 2, fromRow: 2, toCol: 4, toRow: 3))
        XCTAssertTrue(board.canKnightMove(fromCol: 4, fromRow: 3, toCol: 2, toRow: 2))
    }
    
    func testR0() {
        var board = Board()
        board.pieces = [Piece(col: 7, row: 0, imageName: "br", isWhite: false, rank: .rook)]
        XCTAssertFalse(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 6, toRow: 1))
        XCTAssertTrue(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 7, toRow: 7))
    }
    
    /*
     
       0 1 2 3 4 5 6 7
     0 . . . . . . .|r|
     1 . . . . . . .|.|
     2 . . . . . . .|n|
     3 . . . . . . .|.|
     4 . . . . . . .|.|
     5 . . . . . . .|.|
     6 . . . . . . .|.|
     7 . . . . . . .|✗|
     
     */
    func testR1() {
        var board = Board()
        board.pieces = [Piece(col: 7, row: 0, imageName: "br", isWhite: false, rank: .rook),
                        Piece(col: 7, row: 2, imageName: "bn", isWhite: false, rank: .knight)]
        XCTAssertFalse(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 6, toRow: 1))
        XCTAssertFalse(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 7, toRow: 7))
        XCTAssertTrue(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 7, toRow: 1))
    }
    
    func testR2() {
        /*
         
           0 1 2 3 4 5 6 7
         0 . . . . . . .|r|
         1 . . . . . . .|.|
         2 . . . . . . .|N|
         3 . . . . . . .|.|
         4 . . . . . . .|n|
         5 . . . . . . .|.|
         6 . . . . . . .|.|
         7 . . . . . . .|✗|
         
         */
        var board = Board()
        board.pieces = [Piece(col: 7, row: 0, imageName: "br", isWhite: false, rank: .rook),
                        Piece(col: 7, row: 2, imageName: "wn", isWhite: true, rank: .knight),
                        Piece(col: 7, row: 4, imageName: "bn", isWhite: false, rank: .knight)]
        XCTAssertFalse(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 6, toRow: 1))
        XCTAssertTrue(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 7, toRow: 2))
        XCTAssertFalse(board.canRookMove(fromCol: 7, fromRow: 0, toCol: 7, toRow: 7))
    }
    
    
    
    func testNmove() {
        var board = Board()
        
        // only knight itself
        
        board.pieces = [Piece(col: 1, row: 0, imageName: "bn", isWhite: false, rank: .knight)]
        XCTAssertFalse(board.canKnightMove(fromCol: 1, fromRow: 0, toCol: 7, toRow: 7))
        XCTAssertTrue(board.canKnightMove(fromCol: 1, fromRow: 0, toCol: 2, toRow: 2))
        XCTAssertTrue(board.canKnightMove(fromCol: 1, fromRow: 0, toCol: 3, toRow: 1))
    }//TODO: HW
    
}
