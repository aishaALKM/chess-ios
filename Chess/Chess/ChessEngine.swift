//
//  ChessEngine.swift
//  Chess
//
//  Created by Zhijun Sheng on 2020-06-03.
//  Copyright © 2020 Gold Thumb Inc. All rights reserved.
//

import Foundation

struct ChessEngine {
    var pieces: Set<ChessPiece> = Set<ChessPiece>()
    private(set) var whitesTurn: Bool = true
    var lastMove: ChessMove?
    
    var whiteKingSideRookMoved = false
    var whiteQueenSideRookMoved = false
    var whiteKingMoved = false
    
    var blackKingSideRookMoved = false
    var blackQueenSideRookMoved = false
    var blackKingMoved = false
    
    mutating func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return
        }
        
        if let target = pieceAt(col: toCol, row: toRow) {
            pieces.remove(target)
        }
        
        pieces.remove(movingPiece)
        pieces.insert(ChessPiece(col: toCol, row: toRow, imageName: movingPiece.imageName, isWhite: movingPiece.isWhite, rank: movingPiece.rank))
        
        if fromCol == 4 && fromRow == 7 {
            whiteKingMoved = true
        }
        if fromCol == 7 && fromRow == 7 {
            whiteKingSideRookMoved = true
        }
        if fromCol == 0 && fromRow == 7 {
            whiteQueenSideRookMoved = true
        }
        
        if fromCol == 4 && fromRow == 0 {
            blackKingMoved = true
        }
        if fromCol == 7 && fromRow == 0 {
            blackKingSideRookMoved = true
        }
        if fromCol == 0 && fromRow == 0 {
            blackQueenSideRookMoved = true
        }
        
        if movingPiece.rank == .king && fromCol == 4 {
            let row = movingPiece.isWhite ? 7 : 0
            if toCol == 6 {
                if let rook = pieceAt(col: 7, row: row) {
                    pieces.remove(rook)
                    pieces.insert(ChessPiece(col: 5, row: row, imageName: rook.imageName, isWhite: rook.isWhite, rank: rook.rank))
                }
            } else if toCol == 2 {
                if let rook = pieceAt(col: 0, row: row) {
                    pieces.remove(rook)
                    pieces.insert(ChessPiece(col: 3, row: row, imageName: rook.imageName, isWhite: rook.isWhite, rank: rook.rank))
                }
            }
        }

        if let lastMove = lastMove, let lastMovedPawn = pieceAt(col: lastMove.toCol, row: lastMove.toRow), lastMovedPawn.isWhite != movingPiece.isWhite, movingPiece.rank == .pawn, lastMovedPawn.rank == .pawn, abs(fromCol - toCol) == 1 && abs(fromRow - toRow) == 1 {
            pieces.remove(lastMovedPawn)
        }
        
        lastMove = ChessMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        
        whitesTurn = !whitesTurn
    }
    
    func underThreatAt(col: Int, row: Int, whiteEnemy: Bool) -> Bool {
        for piece in pieces where piece.isWhite == whiteEnemy {
            if canPieceAttack(fromCol: piece.col, fromRow: piece.row, toCol: col, toRow: row) {
                return true
            }
        }
        return false
    }
    
    func canPieceMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int, isWhite: Bool) -> Bool {
        guard
            toCol >= 0 && toCol <= 7 && toRow >= 0 && toRow <= 7,
            (fromCol != toCol || fromRow != toRow),
            let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        
        if let target = pieceAt(col: toCol, row: toRow), target.isWhite == movingPiece.isWhite  {
            return false
        }
        
        switch movingPiece.rank {
        case .knight:
            return canKnightMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .rook:
            return canRookMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .bishop:
            return canBishopMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .queen:
            return canQueenMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .king:
            return canKingMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .pawn:
            return canPawnMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        }
    }
    
    func canPieceAttack(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard let movingPiece = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        
        if let target = pieceAt(col: toCol, row: toRow), target.isWhite == movingPiece.isWhite  {
            return false
        }
        
        switch movingPiece.rank {
        case .knight:
            return canKnightMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .rook:
            return canRookMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .bishop:
            return canBishopMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .queen:
            return canQueenMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        case .king:
            return false // never happens TODO: king can also attack
        case .pawn:
            return canPawnAttack(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        }
    }
    
    func canKnightMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        return abs(fromCol - toCol) == 1 && abs(fromRow - toRow) == 2 || abs(fromRow - toRow) == 1 && abs(fromCol - toCol) == 2
    }
    
    func canRookMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard emptyBetween(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) else {
            return false
        }
        return fromCol == toCol || fromRow == toRow
    }
    
    func canBishopMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard emptyBetween(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) else {
            return false
        }
        return abs(fromCol - toCol) == abs(fromRow - toRow)
    }
    
    func canQueenMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        return canRookMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow) || canBishopMove(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
    }
    
    func canKingMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard !underThreatAt(col: toCol, row: toRow, whiteEnemy: !whitesTurn) else {
            return false
        }
        if canCastle(toCol: toCol, toRow: toRow) {
            return true
        }
        let deltaCol = abs(fromCol - toCol)
        let deltaRow = abs(fromRow - toRow)
        return (deltaCol == 1 || deltaRow == 1) && deltaCol + deltaRow < 3
    }
    
    func canCastle(toCol: Int, toRow: Int) -> Bool {
        guard
            let piece = pieceAt(col: 4, row: toRow),
            piece.rank == .king,
            piece.isWhite == whitesTurn,
            toRow == (piece.isWhite ? 7 : 0) else {
            return false
        }
        
        let kingSide = toCol == 6
        let row = piece.isWhite ? 7 : 0
        let cols = kingSide ? 5...6 : 1...3
        
        guard emptyAndSafe(row: row, cols: cols, whiteEnemy: !whitesTurn), toCol == (kingSide ? 6 : 2) else {
            return false
        }
        
        if piece.isWhite && !whiteKingMoved {
            return kingSide ? !whiteKingSideRookMoved : !whiteQueenSideRookMoved
        } else if !piece.isWhite && !blackKingMoved {
            return kingSide ? !blackKingSideRookMoved : !blackQueenSideRookMoved
        }
        
        return false
    }
    
    func emptyAndSafe(row: Int, cols: ClosedRange<Int>, whiteEnemy: Bool) -> Bool {
        return emptyAt(row: row, cols: cols) && safeAt(row: row, cols: cols, whiteEnemy: whiteEnemy)
    }
    
    func safeAt(row: Int, cols: ClosedRange<Int>, whiteEnemy: Bool) -> Bool {
        for col in cols {
            if underThreatAt(col: col, row: row, whiteEnemy: whiteEnemy) {
                return false
            }
        }
        return true
    }
    
    func emptyAt(row: Int, cols: ClosedRange<Int>) -> Bool {
        for col in cols {
            if pieceAt(col: col, row: row) != nil {
                return false
            }
        }
        return true
    }
    
    func canPawnMove(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard let movingPawn = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        
        if let target = pieceAt(col: toCol, row: toRow), target.isWhite != movingPawn.isWhite {
            return canPawnAttack(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        } else if toCol == fromCol {
            if pieceAt(col: fromCol, row: fromRow + (movingPawn.isWhite ? -1 : 1)) == nil {
                return toRow == fromRow + (movingPawn.isWhite ? -1 : 1) ||
                    toRow == fromRow + (movingPawn.isWhite ? -2 : 2) &&
                    pieceAt(col: fromCol, row: toRow) == nil &&
                    fromRow == (movingPawn.isWhite ? 6 : 1)
            }
        } else if let lastMove = lastMove, let enemyPawn = pieceAt(col: lastMove.toCol, row: lastMove.toRow), enemyPawn.rank == .pawn && enemyPawn.isWhite != movingPawn.isWhite && enemyPawn.row == fromRow && enemyPawn.col == toCol, abs(toCol - fromCol) == 1 {
            if movingPawn.isWhite {
                return fromRow == 3 && toRow == 2 && lastMove.fromRow == 1
            } else {
                return fromRow == 4 && toRow == 5 && lastMove.fromRow == 6
            }
        }

        return false
    }
    
    func canPawnAttack(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        guard let movingPawn = pieceAt(col: fromCol, row: fromRow) else {
            return false
        }
        return toRow == fromRow + (movingPawn.isWhite ? -1 : 1) && abs(toCol - fromCol) == 1
    }
    
    func emptyBetween(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) -> Bool {
        if fromRow == toRow { // horizontal
            let minCol = min(fromCol, toCol)
            let maxCol = max(fromCol, toCol)
            if maxCol - minCol < 2   {
                return true
            }
            for i in minCol + 1 ... maxCol - 1 {
                if pieceAt(col: i, row: fromRow) != nil {
                    return false
                }
            }
            return true
        } else if fromCol == toCol { // vertical
            let minRow = min(fromRow, toRow)
            let maxRow = max(fromRow, toRow)
            if maxRow - minRow < 2   {
                return true
            }
            for i in minRow + 1 ... maxRow - 1 {
                if pieceAt(col: fromCol, row: i) != nil {
                    return false
                }
            }
            return true
        } else if abs(fromCol - toCol) == abs(fromRow - toRow) { // diagonal
            let minCol = min(fromCol, toCol)
            let maxCol = max(fromCol, toCol)
            let minRow = min(fromRow, toRow)
            let maxRow = max(fromRow, toRow)
            
            if fromRow - toRow == fromCol - toCol { // top left to bottom right \
                if maxCol - minCol < 2   {
                    return true
                }
                for i in 1..<abs(fromCol - toCol) {
                    if pieceAt(col: minCol + i, row: minRow + i) != nil {
                        return false
                    }
                }
                return true
            } else { // bottom left to top right /
                if maxCol - minCol < 2   {
                    return true
                }
                for i in 1..<abs(fromCol - toCol) {
                    if pieceAt(col: minCol + i, row: maxRow - i) != nil {
                        return false
                    }
                }
                return true
            }
        }
        
        return false
    }
    
    func emptyBetween(from: Int, to: Int, constant: Int) -> Bool {
        let minCol = min(from, to)
        let maxCol = max(from, to)
        if maxCol - minCol < 2   {
            return true
        }
        for i in minCol + 1 ... maxCol - 1 {
            if pieceAt(col: i, row: constant) != nil {
                return false
            }
        }
        return true
    }
    
    func pieceAt(col: Int, row: Int) -> ChessPiece? {
        for piece in pieces {
            if col == piece.col && row == piece.row {
                return piece
            }
        }
        return nil
    }
    
    mutating func initializeGame() {
        pieces.removeAll()
        whitesTurn = true
        lastMove = nil
        
        whiteKingSideRookMoved = false
        whiteQueenSideRookMoved = false
        whiteKingMoved = false
        
        blackKingSideRookMoved = false
        blackQueenSideRookMoved = false
        blackKingMoved = false
        
        for i in 0..<2 {
            pieces.insert(ChessPiece(col: i * 7, row: 0, imageName: "Rook-black", isWhite: false, rank: .rook))
            pieces.insert(ChessPiece(col: i * 7, row: 7, imageName: "Rook-white", isWhite: true, rank: .rook))
            pieces.insert(ChessPiece(col: 1 + i * 5, row: 0, imageName: "Knight-black", isWhite: false, rank: .knight))
            pieces.insert(ChessPiece(col: 1 + i * 5, row: 7, imageName: "Knight-white", isWhite: true, rank: .knight))
            pieces.insert(ChessPiece(col: 2 + i * 3, row: 0, imageName: "Bishop-black", isWhite: false, rank: .bishop))
            pieces.insert(ChessPiece(col: 2 + i * 3, row: 7, imageName: "Bishop-white", isWhite: true, rank: .bishop))
        }
        
        pieces.insert(ChessPiece(col: 3, row: 0, imageName: "Queen-black", isWhite: false, rank: .queen))
        pieces.insert(ChessPiece(col: 3, row: 7, imageName: "Queen-white", isWhite: true, rank: .queen))
        pieces.insert(ChessPiece(col: 4, row: 0, imageName: "King-black", isWhite: false, rank: .king))
        pieces.insert(ChessPiece(col: 4, row: 7, imageName: "King-white", isWhite: true, rank: .king))
        
        for col in 0..<8 {
            pieces.insert(ChessPiece(col: col, row: 1, imageName: "Pawn-black", isWhite: false, rank: .pawn))
            pieces.insert(ChessPiece(col: col, row: 6, imageName: "Pawn-white", isWhite: true, rank: .pawn))
        }
    }
}

extension ChessEngine: CustomStringConvertible {
    var description: String {
        var desc = ""
        
        desc += "+ 0 1 2 3 4 5 6 7\n"
        for row in 0..<8 {
            desc += "\(row)"
            for col in 0..<8 {
                if let piece = pieceAt(col: col, row: row) {
                    switch piece.rank {
                    case .king:
                        desc += piece.isWhite ? " k" : " K"
                    case .queen:
                        desc += piece.isWhite ? " q" : " Q"
                    case .bishop:
                        desc += piece.isWhite ? " b" : " B"
                    case .knight:
                        desc += piece.isWhite ? " n" : " N"
                    case .rook:
                        desc += piece.isWhite ? " r" : " R"
                    case .pawn:
                        desc += piece.isWhite ? " p" : " P"
                    }
                } else {
                    desc += " ."
                }
            }
            desc += "\n"
        }
        
        return desc
    }
}
