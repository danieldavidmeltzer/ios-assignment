//
//  HorizontalTableView.swift
//  paykey-ios-interview
//
//  Created by daniel meltzer on 08/08/2018.
//  Copyright © 2018 ishay weinstock. All rights reserved.
//

import UIKit

/// horizontal table view to use
@objc public class HorizontalTableView: UIScrollView ,UIScrollViewDelegate{
    
    // MARK: constants
    let tagKey = 43786
    
    // MARK: variables
    var reusableCells:Set<UIView> = []
    var dataSource:HorizontalTableViewDataSource?
    var cellWidth = 100
    
    // MARK: implementation
    
    
    /// get cell if can be reloaded, otherwise return nil
    ///
    /// - Returns: recycled cell if can, nil if can't
    func dequeueCell()->UIView?{
        if reusableCells.isEmpty{
            return nil
        }
        else{
        return self.reusableCells.removeFirst()
        }
    }
    
    /// recycle a view that is not used
    /// remove it and add to reusable cells for further use
    /// - Parameter view: the view to recycle
    func recycleCell(view:UIView){
        self.reusableCells.insert(view)
        view.removeFromSuperview()
    }
    func reloadData(){
        reusableCells = []
        self.reloadView()
    }
    
    
    /// get existing cell if not recycled
    ///
    /// - Parameter row: row of cell
    /// - Returns: the cell
    func cell(forRow row:Int)->UIView?{
        let topEdgeRow = row * self.cellWidth;
        for view in self.subviews.filter({$0.tag==tagKey}){
            if (Int(view.frame.origin.x) == topEdgeRow){
                return view
                
            };
        }
        return nil
    }
    
    /// add cell to view
    ///
    /// - Parameters:
    ///   - indexOfCell: the index of cells to add
    ///   - rowWidth: the width of row
    fileprivate func addCellToTableView(_ indexOfCell: Int, _ rowWidth: CGFloat) {
        let cell = self.cell(forRow: indexOfCell) ?? self.dataSource?.horizontalTableView(tableView: self, cellForIndex: indexOfCell)
        
        cell?.tag = tagKey
        cell!.frame = CGRect(x: CGFloat(indexOfCell)*rowWidth, y: 0, width: CGFloat(self.cellWidth), height: CGFloat(self.frame.height))
        self.insertSubview(cell!, at: 0)
       
    }
    
    /// recycle unused views
    fileprivate func recycleUnusedViews() {
        for cell:UIView in self.subviews.filter({$0.tag==tagKey}){
            if(cell.frame.origin.x + cell.frame.size.width < self.contentOffset.x || cell.frame.origin.x > self.contentOffset.x + self.frame.size.width){
                self.recycleCell(view: cell)
            }
        }
    }
    
    /// create the cells to show
    ///
    /// - Parameter rowWidth: width of row
    fileprivate func createCellsToShow(_ rowWidth: CGFloat) {
        let fVisibleIndex = Int(max(0, floor(self.contentOffset.x/rowWidth)));
        let lVisibleIndex = min((self.dataSource?.horizontalTableViewNumberOfCells(tableView: self))!,Int(fVisibleIndex + 1 + Int(ceil(self.frame.size.width/rowWidth))))
        for i in stride(from: fVisibleIndex, to: lVisibleIndex, by: 1){
            addCellToTableView(i, rowWidth)
        }
    }
    
    /// reload the view of the tableview
    func reloadView(){
        if(!self.frame.isNull){
            let rowWidth:CGFloat = CGFloat(cellWidth)
            self.contentSize = CGSize(width: rowWidth*CGFloat((self.dataSource?.horizontalTableViewNumberOfCells(tableView: self))!), height: self.frame.size.height)
            recycleUnusedViews()
            createCellsToShow(rowWidth)
            
        }
    }
    
    /// implement scrolling
    ///
    /// - Parameter scrollView: scrollview that scrolled(needed by delegate of scrollview, we know it's self)
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reloadView()
    }
    
    /// called when need to layoutsubviews, good for post ios 5.1, reloadData
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.delegate = self
        self.reloadData()
    }
    
    
}

/// protocol of the horizontal table view data source
@objc protocol HorizontalTableViewDataSource{
    func horizontalTableView(tableView:HorizontalTableView!, cellForIndex index:Int)->UIView!;
    func horizontalTableViewNumberOfCells(tableView:HorizontalTableView!)->Int;
}
