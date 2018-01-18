//
//  MineSweeperModel.swift
//  MineSweeper
//
//  Created by AAK on 2/12/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit

enum TileType {
    case NumberTile
    case FlagTile
    case CoverTile
    case MineTile
}

struct TileAttributes {
    let row: Int
    let column: Int
    var tiles: [TileType]
    
    var value: Int
}

private var percentageOfMines: UInt32 = 20

class MineSweeperModel: NSObject {

    private var rows = 0
    private var columns = 0
    private var numMines = 0
    var isRevealed = false
    private var tilesToWin = 0
    private var uncovered = 0
    
    private var tiles = [[TileAttributes]]()
    
    func startGameWith(rows: Int, columns: Int) -> [[TileAttributes]]{
        self.rows = rows
        self.columns = columns
        
        for row in 0..<rows {
            var tileRow = [TileAttributes]() // Create a one-dimensional array
            for column in 0..<columns {
                
          
                tileRow.append(createTile(row: row, column: column)) // Create either a NumberTile or a MineTile.
      //          tileRow[column].tiles.append(.CoverTile)             // Cover it with a CoverTile.
            }
            self.tilesToWin = rows*columns - self.numMines
            tiles.append(tileRow)  // add the one-dimensional array into another array as an element.
        }

 
        return tiles
    }
    
    
    //Gets a specific tile given its row and column
    func getTile(row: Int, col: Int) -> TileAttributes{
    
        return tiles[row][col]
    }
    
    func isAMine(row: Int, col: Int) -> Bool{
        return tiles[row][col].tiles[0] == TileType.MineTile
    }
    
    //Checks whether win conditions have been satisfied or not
    //Returns 1 for win, 0 for no change and -1 for losing.
    func winLose(row: Int, col: Int) -> Int {
        uncovered += 1
        
        if isAMine(row: row, col: col) {
            return -1
        }
        else if uncovered >= tilesToWin {
            return 1
        }
        
        return 0
    }
    
    func isCover(row: Int, col: Int) -> Bool {
        
        return tiles[row][col].tiles[0] == TileType.CoverTile
    }

    
    
    //creates the tiles that go on the lowest level of the game
    func createTile(row: Int, column: Int) -> TileAttributes {
        let aMine = arc4random_uniform(99) + 1
        if aMine <= percentageOfMines { // how often do we create a mine?
            self.numMines += 1
            return TileAttributes(row: row, column: column, tiles: [.MineTile], value: 0)
        }
            
        else {
            return TileAttributes(row: row, column: column, tiles: [.NumberTile], value:0)
        }
        
    }
    
    //Counts the mines surrounding a tile
    func countMines(tile: TileAttributes, rows: Int, cols: Int) -> Int {

   
    
        
        var count = 0
        let r = tile.row
        let c = tile.column
        
        //Tile is a mine, don't count
        if isAMine(row: r,col: c) {
            return 0;
        }
        
        //Top
        if r - 1 >= 0 && isAMine(row: r - 1,col: c) {
            count += 1
        }
        
        //Left
        if c - 1 >= 0 && isAMine(row: r,col: c - 1) {
            count += 1
        }
        
        //Right
        if c + 1 < cols && isAMine(row: r,col: c + 1) {
            count += 1
        }
        
        //Bottom
        if r + 1 < rows && isAMine(row: r + 1,col: c) {
            count += 1
        }
        
        //Topleft Corner
        if r - 1 >= 0 && c - 1 >= 0 && isAMine(row: r - 1,col: c - 1) {
            count += 1
        }
        
        //Topright Corner
        if r - 1 >= 0 && c + 1 < cols && isAMine(row: r - 1,col: c + 1) {
            count += 1
        }
        
        //Bottomleft Corner
        if r + 1 < rows && c - 1 >= 0 && isAMine(row: r + 1,col: c - 1) {
            count += 1
        }
        
        //Bottomright Corner
        if r + 1 < rows && c + 1 < cols && isAMine(row: r + 1,col: c + 1) {
            count += 1
        }
        
       return count;
       // tiles[r][c].value = count
    }
    
    
    
    func actionTiles() -> [[TileAttributes]] {
        return tiles
    }
    
}











