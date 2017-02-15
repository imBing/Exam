//
//  ExtentionTableView+refresh.swift
//  FeedbackStar
//
//  Created by James Xu on 16/9/23.
//  Copyright © 2016年 Daimler. All rights reserved.
//

import UIKit
import MJRefresh

extension UITableView {
    open func addRefresh(_ headerHandle: @escaping () -> (), _ footerHandle: @escaping () -> ()) {
        self.addHeaderRefresh {
            headerHandle()
        }
        
        self.addFooterRefresh {
            footerHandle()
        }
    }
    
    open func addHeaderRefresh(_ headerHandle: @escaping () -> ()) {
        let header = MJRefreshNormalHeader {
            headerHandle()
        }
        
        self.mj_header = header
        self.setHeaderTitles()
    }
    
    open func addFooterRefresh(_ footerHandle: @escaping () -> ()) {
        let footer = MJRefreshAutoNormalFooter {
            footerHandle()
        }
        
        self.mj_footer = footer
        self.setFooterTitles()
    }
    
    private func setHeaderTitles() {
        self.setHeaderTitle(title: LS("DMLRefreshHeaderIdleText"), state:.idle)
        self.setHeaderTitle(title: LS("DMLRefreshHeaderPullingText"), state:.pulling)
        self.setHeaderTitle(title: LS("DMLRefreshHeaderRefreshingText"), state:.refreshing)
    }
    
    private func setFooterTitles() {
        self.setFooterTitle(title: LS("DMLRefreshAutoFooterIdleText"), state:.idle)
        self.setFooterTitle(title: LS("DMLRefreshAutoFooterRefreshingText"), state:.refreshing)
        self.setFooterTitle(title: LS("DMLRefreshAutoFooterNoMoreDataText"), state:.noMoreData)
    }

    
    open func setHeaderTitle(title: String, state: MJRefreshState) {
        let header = self.mj_header as! MJRefreshNormalHeader
        header.setTitle(title, for: state)
    }
    
    open func setFooterTitle(title: String, state: MJRefreshState) {
        let footer = self.mj_footer as! MJRefreshAutoNormalFooter
        footer.setTitle(title, for: state)
    }
    
    open func endWithNoMoreData() {
        let footer = self.mj_footer as? MJRefreshAutoNormalFooter
        footer?.endRefreshingWithNoMoreData()
    }
    
    open func resetNoMoreData() {
        let footer = self.mj_footer as? MJRefreshAutoNormalFooter
        footer?.resetNoMoreData()
    }
    
    open func endRefreshing() {
        self.endHeaderRefreshing()
        self.endFooterRefreshing()
    }
    
    open func endHeaderRefreshing() {
        if let header = self.mj_header {
            header.endRefreshing()
        }
    }
    
    open func endFooterRefreshing() {
        if let footer = self.mj_footer {
            footer.endRefreshing()
        }
    }
}
