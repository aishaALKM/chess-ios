//
//  ChessDelegate.swift
//  chess
//
//  Created by Kenneth Wu on 2022-02-16.
//  Copyright © 2022 GoldThumb Inc. All rights reserved.
//

import Foundation

protocol ChessDelegate {
    func pieceAt(col: Int, row: Int) -> ChessPiece?
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int)
}
