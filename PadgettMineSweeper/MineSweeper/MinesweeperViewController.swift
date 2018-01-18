//
//  ViewController.swift
//  MineSweeper
//
//  Created by AAK on 2/11/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit


class MinesweeperViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var inputErrorMessageLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var numRowsTextField: UITextField!
    @IBOutlet weak var numColumnsTextField: UITextField!

    var numberOfRows = 0
    var numberOfColumns = 0
    let maxNumberOfRows = 15
    let maxNumberOfColumns = 10
    let gapBetweenTiles = 2.0
    var mineModel = MineSweeperModel()
    var widthOfATile = 0.0

    private var coverTiles = [[UIButton]]()
    
    func makeButton(x: Double, y: Double, widthHeight: Double) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5.0

        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    
    func makeCoverButton(x: Double, y: Double, widthHeight: Double) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.alpha = 0
        numRowsTextField.delegate = self
        numColumnsTextField.delegate = self
        inputErrorMessageLabel.textColor = UIColor.orange

        
//        view.backgroundColor = UIColor.gray
        let mineView = MineView(frame: CGRect(x: 100, y: 100, width: 140, height: 140))
        mineView.backgroundColor = UIColor.white
        
        
        
        let flagView = FlagView(frame: CGRect(x: 100, y: 100, width: 140, height: 140))
        flagView.backgroundColor = UIColor.white
//        view.addSubview(mineView)

//        let tiles = mineModel.startGameWith(rows: 10, columns: 10)
//        updateTiles(tiles: tiles)
 
        
/*
        
        for i in  0 ..< 10 {
            let button = makeButton(x: 15 + Double(i) * 27.0, y: 50.0, widthHeight: widthOfATile)
            button.setTitle("\(i)", for: UIControlState.normal)
            button.tag = i
            view.addSubview(button)

        }
*/
        
    }

    
    func updateTiles(tiles: [[TileAttributes]]) {
        
        let frame = view.frame
        widthOfATile = (Double(frame.size.width) - 2 * gapBetweenTiles) / (Double(numberOfColumns) + gapBetweenTiles)
        print("width of a tile \(widthOfATile)")
        
   //     var y = gapBetweenTiles + 40.0
        var v = 0
        
        
        for row in tiles {
            var buttonRow = [UIButton]()
            let y = (widthOfATile + gapBetweenTiles) * Double(row[0].row) + 40.0
            var x = gapBetweenTiles
            for column in row {
                
           //     v += 1
                x = (widthOfATile + gapBetweenTiles) * Double(column.column) + gapBetweenTiles
                if column.tiles[0] == TileType.MineTile {
                    let mineView = MineView(frame: CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                

                    mineView.backgroundColor = UIColor.orange
                    mineView.layer.cornerRadius = 5.0
            
                    mineView.layer.shadowColor = UIColor.black.cgColor
                    mineView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                    mineView.layer.shadowRadius = 5
               //     mineView.layer.shadowOpacity = 1.0
                    view.addSubview(mineView)
                }
        
                 else {
                    let button = makeButton(x: x, y: y, widthHeight: widthOfATile)
                    button.backgroundColor = UIColor.orange
                    button.layer.shadowColor = UIColor.black.cgColor
                   button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                   button.layer.shadowRadius = 5
                //   button.layer.shadowOpacity = 1.0
                    let current = mineModel.getTile(row: column.row, col: column.column)
                    let count = mineModel.countMines(tile: current, rows: numberOfRows, cols: numberOfColumns)
               
                 
                    button.tag =  count
                    button.setTitle("\(count)", for: .normal)
            
                        
                    buttonRow.append(button)
                    view.addSubview(button)
 
                }
                
                let coverView = makeCoverButton(x: x, y: y, widthHeight: widthOfATile);
                coverView.backgroundColor = UIColor.darkGray
                view.addSubview(coverView)
            
                coverView.tag = v
                v += 1
            
            
 
            }  // end column loop
            coverTiles.append(buttonRow)
        }
    }
    

    
    @IBAction func didTapStartButton(_ sender: UIButton) {
        print("Did tap the start button.")
        sender.isEnabled = false
        let tiles = mineModel.startGameWith(rows: numberOfRows, columns: numberOfColumns)
    
        updateTiles(tiles: tiles)
        
    }
    
 
    func clearNeighbors(row: Int, col: Int ) {
        for i in -1...2{
            for j in -1...2 {
                if i == 0 && j == 0{
                    continue
                }
                if (row + i < 0) || col + j < 0 || row + i >= numberOfRows || col + j >= numberOfColumns {
                    continue
                }
             
                let current = mineModel.getTile(row: row, col: col)
                // clear current
               let currentbutton = coverTiles[row][col]
                currentbutton.backgroundColor = UIColor.clear
             //  currentbutton.tag = 10
                if mineModel.isCover(row: row, col: col){
                    currentbutton.tag = 10
                }
                
                
                
       
                   print("rowin clear:", row, "col in clear:", col, currentbutton.tag)
                //   let count = mineModel.countMines(tile: current, rows: numberOfRows, cols: numberOfColumns)
               // button.tag = count
               // button.backgroundColor.UIClear
                
                if current.value == 0 && currentbutton.tag != 10{
               // if current.value == 0 && covered == false/*  and not uncovered */ {
                    // recursive call
                    currentbutton.tag = 10
                    clearNeighbors(row: row + i, col: col + j)
                }
            }
        }

    }
 

    
    func didTapButton(_ button: UIButton) {
        let row = button.tag / numberOfRows
        let col = button.tag % numberOfColumns
        print("row: \(row)")
        print("col: \(col)")
 //       button.tag = 10
        
    

        button.backgroundColor = UIColor.clear
        if mineModel.winLose(row: row, col: col) == 1 {
            self.showGameWonAlert(button)
        }
        
        if mineModel.isAMine(row: row, col: col){
            button.tag = -1
        }
        

        if button.tag == 10{
//           clearNeighbors(row: row, col: col)
        }
        
 
        if button.tag == 0 {
            
            //expose all neighbors that have a zero
           
        }
        
        if button.tag == -1 {
            print("didTapMine with tag: \(button.tag)")
            self.showAlertButtonTapped(button)

        }
        if button.tag == 2{
            button.backgroundColor = UIColor.clear
            
        }

    }
    
  func didTapCover(_ coverView: UIButton) {
        print("didTapCover with tag: \(coverView.tag)")
      }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    //Shows 'Game Over' message when a mine is tapped
    @IBAction func showAlertButtonTapped(_ sender: UIButton) {
        
        // create the Game Over alert
        let alert = UIAlertController(title: "Game Over", message: "You hit a mine!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: { action in
            exit(0)
        }))
        
        
        // Exit the app when the 'Exit' button is tapped
        alert.addAction(UIAlertAction(title: "Restart", style: UIAlertActionStyle.destructive, handler: { action in
            let newtiles = self.mineModel.startGameWith(rows: self.numberOfRows, columns: self.numberOfColumns)
            
            self.updateTiles(tiles: newtiles)
        }))
        
        
        // display the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    //Shows 'You Won' message when a mine is tapped
    @IBAction func showGameWonAlert(_ sender: UIButton) {
        
        // create the Game Over alert
        let alert = UIAlertController(title: "You Win!", message: "Good Job", preferredStyle: UIAlertControllerStyle.alert)
        
  
        
        // Exit the app when the 'Exit' button is tapped
        alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.destructive, handler: { action in
            exit(0)
        }))
        
        
        // display the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    

    
    
// TextField delegates
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        inputErrorMessageLabel.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputErrorMessageLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if let text = numRowsTextField.text, let value = Int(text) {
            if value > maxNumberOfRows {
                inputErrorMessageLabel.text = "Rows should be less than \(maxNumberOfRows). Try again."
                return false
            }
            numberOfRows = value
        }
        
        if let text = numColumnsTextField.text, let value = Int(text) {
            if value > maxNumberOfColumns {
                inputErrorMessageLabel.text = "Columns should be less than \(maxNumberOfColumns). Try again."
                return false
            }
            numberOfColumns = value
        }

        textField.resignFirstResponder()
        print("Rows = \(numberOfRows) columns = \(numberOfColumns)")
        if numberOfRows > 0 && numberOfColumns > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.numRowsTextField.alpha = 0.0
                self.numColumnsTextField.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.startButton.alpha = 1.0
                }, completion: { _ in })
            })
        }
        numRowsTextField.isEnabled = false
        numColumnsTextField.isEnabled = false
        return true
    }


}

