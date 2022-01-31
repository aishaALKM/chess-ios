import Foundation

struct ChessBrain: CustomStringConvertible {
    var conditionWQueenS: Bool = true
    var conditionWKing: Bool = true
    var conditionWKingS: Bool = true
    var conditionBQueenS: Bool = true
    var conditionBKing: Bool = true
    var conditionBKingS: Bool = true
    var isWhiteTurn: Bool = true
    var piecesBox = Set<ChessPiece>()
    var lastMovedPiece: ChessPiece? = nil
    
    mutating func promote(rank: ChessRank) {
        
        guard let movingPawn = lastMovedPiece else {
            return
        }
        
        var imageName = ""
        
        
        if movingPawn.isWhite {
            switch rank {
            case .queen:
                imageName = "Queen-white"
            case .knight:
                imageName = "Knight-white"
            case .rook:
                imageName = "Rook-white"
            case .bishop:
                imageName = "Bishop-white"
            default:
                break
            }
            
        } else {
            switch rank {
            case .queen:
                imageName = "Queen-black"
            case .knight:
                imageName = "Knight-black"
            case .rook:
                imageName = "Rook-black"
            case .bishop:
                imageName = "Bishop-black"
            default:
                break
            }
        }
        
        piecesBox.remove(movingPawn)
        let newPiece = ChessPiece(x: movingPawn.x, y: movingPawn.y, isWhite: movingPawn.isWhite, rank: rank, imageName: imageName)
        piecesBox.insert(newPiece)
    }
    
    func pieceAt(x: Int, y: Int) -> ChessPiece? {
        for piece in piecesBox {
            if piece.x == x && piece.y == y {
                return piece
            }
        }
        
        return nil
    }
    
    func winOrLose() {
        let boardview = BoardView()
        var a = 0
        var b = 0
        for c in 0..<8 {
            for d in 0..<8 {
                if pieceAt(x: c, y: d) == nil {
                    continue
                }
                if pieceAt(x: c, y: d)!.rank == .king && pieceAt(x: c, y: d)!.isWhite {
                    a += 1
                }
                if pieceAt(x: c, y: d)!.rank == .king && pieceAt(x: c, y: d)!.isWhite == false {
                    b += 1
                }
            }
        }
        
        if a == 0 || b == 0 {
            boardview.isUserInteractionEnabled = true
        }
    }
    
    mutating func reset() {
        piecesBox.removeAll()
        
        for i in 0..<2 {
            piecesBox.insert(ChessPiece(x: 0 + i * 7, y: 7, isWhite: true, rank: .rook, imageName: "Rook-white"))
            piecesBox.insert(ChessPiece(x: 0 + i * 7, y: 0, isWhite: false, rank: .rook, imageName: "Rook-black"))
        }
        
        for i in 0..<2 {
            piecesBox.insert(ChessPiece(x: 1 + i * 5, y: 7, isWhite: true, rank: .knight, imageName: "Knight-white"))
            piecesBox.insert(ChessPiece(x: 1 + i * 5, y: 0, isWhite: false, rank: .knight, imageName: "Knight-black"))
        }
        
        for i in 0..<2 {
            piecesBox.insert(ChessPiece(x: 2 + i * 3, y: 7, isWhite: true, rank: .bishop, imageName: "Bishop-white"))
            piecesBox.insert(ChessPiece(x: 2 + i * 3, y: 0, isWhite: false, rank: .bishop, imageName: "Bishop-black"))
        }
        
        piecesBox.insert(ChessPiece(x: 3, y: 7, isWhite: true, rank: .queen, imageName: "Queen-white"))
        piecesBox.insert(ChessPiece(x: 3, y: 0, isWhite: false, rank: .queen, imageName: "Queen-black"))

        piecesBox.insert(ChessPiece(x: 4, y: 7, isWhite: true, rank: .king, imageName: "King-white"))
        piecesBox.insert(ChessPiece(x: 4, y: 0, isWhite: false, rank: .king, imageName: "King-black"))
        
        for i in 0..<8 {
            piecesBox.insert(ChessPiece(x: i, y: 6, isWhite: true, rank: .pawn, imageName: "Pawn-white"))
            piecesBox.insert(ChessPiece(x: i, y: 1, isWhite: false, rank: .pawn, imageName: "Pawn-black"))
        }
    }
    
    func canPieceMove(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        guard let movingPiece = pieceAt(x: frX, y: frY) else {
            return false
        }
        
        if isWhiteTurn && movingPiece.isWhite == false || !isWhiteTurn && movingPiece.isWhite {
            return false
        }
        
        switch movingPiece.rank {
        case .rook:
            if !isValidRook(frX: frX, frY: frY, toX: toX, toY: toY) {
                return false
            }
        case .knight:
            if !isValidKnight(frX: frX, frY: frY, toX: toX, toY: toY) {
                return false
            }
        case .bishop:
            if !isValidBishop(frX: frX, frY: frY, toX: toX, toY: toY) {
                return false
            }
        case .king:
            if !isValidKing(frX: frX, frY: frY, toX: toX, toY: toY) {
                return false
            }
        case .pawn:
            if !isValidPawn(frX: frX, frY: frY, toX: toX, toY: toY) {
                return false
            }
        case .queen:
            if !isValidQueen(frX: frX, frY: frY, toX: toX, toY: toY) {
                return false
            }
        }
        
        return true
        
    }
    
    mutating func movePiece(frX: Int, frY: Int, toX: Int, toY: Int) {
//        bwturn()
        if toX > 7 || toX < 0 || toY > 7 || toY < 0 {
            return
        }
        
        let beCapturedPiece = pieceAt(x: toX, y: toY)
        guard let movingPiece = pieceAt(x: frX, y: frY) else {
            return
        }
        
        if beCapturedPiece?.isWhite == movingPiece.isWhite {
            return
        }
        
        switch movingPiece.rank {
        case .rook:
            if !isValidRook(frX: frX, frY: frY, toX: toX, toY: toY) {
                return
            }
            
        case .knight:
            if !isValidKnight(frX: frX, frY: frY, toX: toX, toY: toY) {
                return
            }
            
        case .bishop:
            if !isValidBishop(frX: frX, frY: frY, toX: toX, toY: toY) {
                return
            }
            
        case .king:
            if !isValidKing(frX: frX, frY: frY, toX: toX, toY: toY) {
                return
            } else {
                if isCastling(frX: frX, frY: frY, toX: toX, toY: toY) {
                    if toX == 6, let castlingRook = pieceAt(x: 7, y: toY) {
                        piecesBox.remove(castlingRook)
                        piecesBox.insert(ChessPiece(x: 5, y: toY, isWhite: castlingRook.isWhite, rank: .rook, imageName: castlingRook.imageName))
                    }
                    
                    if toX == 2, let castlingRook = pieceAt(x: 0, y: toY) {
                        piecesBox.remove(castlingRook)
                        piecesBox.insert(ChessPiece(x: 3, y: toY, isWhite: castlingRook.isWhite, rank: .rook, imageName: castlingRook.imageName))
                    }
                }
            }
        case .pawn:
            if !isValidPawn(frX: frX, frY: frY, toX: toX, toY: toY) {
                return
            } else {
                if let lastMovedPiece = lastMovedPiece {
                    if isEnPassant(frX: frX, frY: frY, toX: toX, toY: toY) {
                        piecesBox.remove(lastMovedPiece)
                    }
                }
            }
        case .queen:
            if !isValidQueen(frX: frX, frY: frY, toX: toX, toY: toY) {
                return
            }
        }
        
        if let actualBeCapturedPiece = beCapturedPiece {
            piecesBox.remove(actualBeCapturedPiece)
        }
             
        if movingPiece.rank == .rook && movingPiece.isWhite == false && movingPiece.x == 0 && movingPiece.y == 0 {
            conditionBQueenS = false
        }
        
        if movingPiece.rank == .rook && movingPiece.isWhite == false && movingPiece.x == 7 && movingPiece.y == 0 {
            conditionBKingS = false
        }
        
        if movingPiece.rank == .king && movingPiece.isWhite == false && movingPiece.x == 4 && movingPiece.y == 0 {
            conditionBKing = false
        }
        
        if movingPiece.rank == .rook && movingPiece.isWhite == true && movingPiece.x == 0 && movingPiece.y == 7 {
            conditionWQueenS = false
        }
        
        if movingPiece.rank == .rook && movingPiece.isWhite == true && movingPiece.x == 7 && movingPiece.y == 7 {
            conditionWKingS = false
        }
        
        if movingPiece.rank == .king && movingPiece.isWhite == true && movingPiece.x == 4 && movingPiece.y == 7 {
            conditionWKing = false
        }
        
        piecesBox.remove(movingPiece)
        let movedPiece = ChessPiece(x: toX, y: toY, isWhite: movingPiece.isWhite, rank: movingPiece.rank, imageName: movingPiece.imageName)
        
        piecesBox.insert(movedPiece)
        
       
        if movedPiece.rank == .pawn && movedPiece.y == 7 || movedPiece.rank == .pawn && movedPiece.y == 0 {
 //           promote(rank: <#T##ChessRank#>, movingPawn: <#T##ChessPiece#>)
            // we'll show a selection dialog window ...
        }
        
        lastMovedPiece = movedPiece
        isWhiteTurn.toggle()
        print(isWhiteTurn)
    }
    
    func needsPromotion() -> Bool {
        if let lastMovedPiece = lastMovedPiece, lastMovedPiece.rank == .pawn {
            if lastMovedPiece.isWhite {
                return lastMovedPiece.y == 0
            } else {
                return lastMovedPiece.y == 7
            }
        }
        
        return false
    }
    
    func isValidRook(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        
        return emptyBetween(frX: frX, frY: frY, toX: toX, toY: toY) &&
              (frX == toX && frY != toY ||
               frX != toX && frY == toY)
    }
    
    func isValidKnight(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        let dx = abs(frX - toX)
        let dy = abs(frY - toY)
        return dx == 1 && dy == 2 || dy == 1 && dx == 2        
    }
    
    func isValidBishop(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        return emptyBetween(frX: frX, frY: frY, toX: toX, toY: toY) && abs(frX - toX) == abs(frY - toY)
    }
    
    func isValidQueen(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        return isValidRook(frX: frX, frY: frY, toX: toX, toY: toY) ||
               isValidBishop(frX: frX, frY: frY, toX: toX, toY: toY)
    }
    
    func isValidPawn(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        guard let movingPiece = pieceAt(x: frX, y: frY) else {
            return false
        }
        
        if isEnPassant(frX: frX, frY: frY, toX: toX, toY: toY) {
            return true
        }
        
        switch movingPiece.isWhite {
        case true:
            
            
            if let target = pieceAt(x: toX, y: toY) {
                // capture
                if target.x == movingPiece.x + 1 {
                    return frX + 1 == toX && frY - 1 == toY
                } else if target.x == movingPiece.x - 1 {
                    return frX - 1 == toX && frY - 1 == toY
                } else {
                    return false
                }
            } else {
                // normal move
                if frY == 6 {
                    return frX == toX && frY - 1 == toY ||
                           frX == toX && frY - 2 == toY
                } else {
                    return frX == toX && frY - 1 == toY
                }
            }
            
        case false:
            if let target = pieceAt(x: toX, y: toY) {
                if target.x == movingPiece.x + 1 {
                    return frX + 1 == toX && frY + 1 == toY
                } else if target.x == movingPiece.x - 1 {
                    return frX - 1 == toX && frY + 1 == toY
                } else {
                    return false
                }
            } else {
                
                if frY == 1 {
                    return frX == toX && frY + 1 == toY ||
                           frX == toX && frY + 2 == toY
                } else {
                    return frX == toX && frY + 1 == toY
                }
            }
        }
    }
    
    func isEnPassant(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        guard let movingPiece = pieceAt(x: frX, y: frY) else {
            return false
        }
        
        switch movingPiece.isWhite {
        case true:
            if let deadPiece = pieceAt(x: toX, y: 3), frY == 3, toY == 2, deadPiece.rank == .pawn, lastMovedPiece == deadPiece {
                return abs(frX - toX) == 1
            }
        
        case false:
            if let deadPiece = pieceAt(x: toX, y: 4), frY == 4, toY == 5, deadPiece.rank == .pawn, lastMovedPiece == deadPiece {
                
                return abs(frX - toX) == 1
            }
        }
        
        return false
    }
    
    func isValidKing(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        return canKingAttack(frX: frX, frY: frY, toX: toX, toY: toY) ||
            isCastling(frX: frX, frY: frY, toX: toX, toY: toY)
    }
    
    
    func canKingAttack(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        return isValidQueen(frX: frX, frY: frY, toX: toX, toY: toY) && (abs(frX - toX) == 1 || abs(frY - toY) == 1)
    }
    
    func isCastling(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        guard let movingPiece = pieceAt(x: frX, y: frY) else {
            return false
        }
        
        guard abs(frX - toX) == 2,
              pieceAt(x: toX, y: toY) == nil,
              pieceAt(x: toX - 1, y: toY) == nil else {
            return false
        }
        
        if toX == 2 {
            if pieceAt(x: 3, y: toY) != nil {
                return false
            }
        }
        
        if movingPiece.isWhite {
            if !conditionWQueenS && toX == 2 {
                return false
            } else if !conditionWKingS && toX == 6 {
                return false
            } else if !conditionWKing {
                return false
            }
        } else {
            if !conditionBQueenS && toX == 2 {
                return false
            } else if !conditionBKingS && toX == 6 {
                return false
            } else if !conditionBKing {
                return false
            }
        }
    
        if isThreateningCastling(frX: frX, frY: frY, toX: toX, toY: toY) {
            return false
        }
        
        
        return true
    }
    
    func isThreateningCastling(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        guard let movPiece = pieceAt(x: frX, y: frY) else {
            return false
        }
        
        if checkIsThreatenedSquare(x: movPiece.x, y: movPiece.y, isWhiteMoving: movPiece.isWhite) ||
            checkIsThreatenedSquare(x: (frX + toX) / 2, y: frY, isWhiteMoving: movPiece.isWhite) ||
            checkIsThreatenedSquare(x: toX, y: toY, isWhiteMoving: movPiece.isWhite) {
            return true
        }
        
        return false
    }
    
    func checkIsThreatenedSquare(x: Int, y: Int, isWhiteMoving: Bool) -> Bool {
        for piece in piecesBox where piece.isWhite != isWhiteMoving {
            if piece.rank == .king {
                if canKingAttack(frX: piece.x, frY: piece.y, toX: x, toY: y) {
                    return true
                }
            } else {
                if canPieceMove(frX: piece.x, frY: piece.y, toX: x, toY: y) {
                    return true
                }
            }
            
        }
        
        return false
    }
    
    func emptyBetween(frX: Int, frY: Int, toX: Int, toY: Int) -> Bool {
        if frX == toX && frY == toY {
            return false
        }
        let deltaX = abs(frX - toX)
        if frX == toX && frY != toY  { // |
            if toY > frY { // going ⬇️
                if frY + 1 <= toY - 1 {
                    for y in frY + 1 ... toY - 1 {
                        if pieceAt(x: frX, y: y) != nil {
                            return false
                        }
                    }
                }
            } else { // going ⬆️
                if toY + 1 <= frY - 1 {
                    for y in toY + 1 ... frY - 1 {
                        if pieceAt(x: frX, y: y) != nil {
                            return false
                        }
                    }
                }
            }
        } else if frY == toY && frX != toX { // -
            if toX > frX { // going ➡️
                if frX + 1 <= toX - 1 {
                    for x in frX + 1 ... toX - 1 {
                        if pieceAt(x: x, y: frY) != nil {
                            return false
                        }
                    }
                }
            } else { // going ⬅️
                if toX + 1 <= frX - 1 {
                    for x in toX + 1 ... frX - 1 {
                        if pieceAt(x: x, y: frY) != nil {
                            return false
                        }
                    }
                }
            }
        } else if frX + deltaX == toX && frY + deltaX == toY { // \
            for i in 1..<deltaX {
                if pieceAt(x: frX + i, y: frY + i) != nil {
                    return false
                }
            }
        } else if frX - deltaX == toX && frY + deltaX == toY { // /
            for i in 1..<deltaX {
                if pieceAt(x: frX - i, y: frY + i) != nil {
                    return false
                }
            }
        } else if frX + deltaX == toX && frY - deltaX == toY {
            for i in 1..<deltaX {
                if pieceAt(x: frX + i, y: frY - i) != nil {
                    return false
                }
            }
        } else if frX - deltaX == toX && frY - deltaX == toY {
            for i in 1..<deltaX {
                if pieceAt(x: frX - i, y: frY - i) != nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    var description: String {
        var desc = ""
        
        desc += "  0 1 2 3 4 5 6 7 \n"
        
        for row in 0..<8 {
            desc += "\(row) "
            for col in 0..<8 {
                if let piece = pieceAt(x: col, y: row) {
                    switch piece.rank {
                    case .rook:
                        desc += piece.isWhite ? "R " : "r "
                    case .knight:
                        desc += piece.isWhite ? "N " : "n "
                    case .bishop:
                        desc += piece.isWhite ? "B " : "b "
                    case .king:
                        desc += piece.isWhite ? "K " : "k "
                    case .pawn:
                        desc += piece.isWhite ? "P " : "p "
                    case .queen:
                        desc += piece.isWhite ? "Q " : "q "
                    }
                } else {
                    desc += ". "
                }
            }
            
            desc += "\n"
        }

        return desc
    }
}