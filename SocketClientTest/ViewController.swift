//
//  ViewController.swift
//  SocketClientTest
//
//  Created by Jarrod Parkes on 5/17/17.
//  Copyright © 2017 huntsvilleswiftusers. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

    /*
     
     dateFormatter.dateFormat = "HH:mm:ss "
     
     if let dateString = data[0] as? String, let date = self.dateFormatter.date(from: dateString) {
     print(date)
     } else {
     print("date conversion failed")
     }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let socket = SocketIOClient(socketURL: URL(string: "https://mysterious-fjord-75568.herokuapp.com")!, config: [.log(false), .forcePolling(true)])
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
        socket.on("time") { data, ack in
            if let cur = data[0] as? String {
                
                DispatchQueue.main.async {
                    print(cur)
                }
                
                socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    socket.emit("update", ["amount": 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()
    }
}

