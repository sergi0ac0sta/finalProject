//
//  InterfaceController.swift
//  FinalProjectWatch Extension
//
//  Created by Sergio Acosta on 11/07/16.
//  Copyright © 2016 Sergio Acosta. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    var session: WCSession? = nil
    
    @IBOutlet var tableView: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if WCSession.isSupported() && session == nil {
            session = WCSession.default()
            session?.delegate = self
            session?.activate()
        }
    }
    
    override func didAppear() {
        if (session!.isReachable) {
            print("is reachable")
            getRoutes(session: self.session!)
        } else {
            print("is not reachable")
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let e = error {
            print(e)
        } else {
            print("WatchKit: Active watch session")
            getRoutes(session: self.session!)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }

    func getRoutes(session: WCSession) {
        session.sendMessage(["message": "getRoutes"], replyHandler:
            {(reply: [String: Any]) -> Void in
                self.setTable(routes: reply["routes"] as! [String])
        }, errorHandler: {
            (error: Error) -> Void in
            print(error)
        })
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        self.pushController(withName: "MapView", context: (table.rowController(at: rowIndex) as! TableRow).text)
    }
    
    func setTable(routes: [String]) {
        tableView.setNumberOfRows(routes.count, withRowType: "TableRow")
        
        for i in 0..<routes.count {
            if let row = tableView.rowController(at: i) as? TableRow {
                row.tag.setText(routes[i])
                row.text = routes[i]
            }
        }
    }
}
