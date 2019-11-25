//
//  ViewController.swift
//  chess
//
//  Created by Donald Sheng on 2018-01-23.
//  Copyright © 2018 GoldThumb Inc. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, ChessDelegate {
    
    var chessBoard = ChessBoard()
    

    @IBOutlet weak var boardView: BoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chessBoard.reset()
        boardView.pieceBoxShadow = chessBoard.pieceBox
        
        boardView.chessDelegate = self
    }
    
    func movePiece(fromCol: Int, fromRow: Int, toCol: Int, toRow: Int) {
        chessBoard.movePiece(fromCol: fromCol, fromRow: fromRow, toCol: toCol, toRow: toRow)
        boardView.pieceBoxShadow = chessBoard.pieceBox
        boardView.setNeedsDisplay()
    }
}
    
