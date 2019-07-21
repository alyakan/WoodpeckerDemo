//
//  MainView.swift
//  Woodpecker
//
//  Created by Aly Yakan on 7/22/19.
//  Copyright © 2019 Aly. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationButton(destination: LogsList(), isDetail: true) {
                    Text("View Logs")
                }
            }
            .navigationBarTitle(Text("Woodpecker"))
        }
    }
}

struct LogsList: View {
    let logs = LogStore().fetchAll()
    var body: some View {
        List(logs) { log in
            Text(verbatim: log.message).lineLimit(nil).padding()
        }.listStyle(.grouped).navigationBarTitle(Text("Logs"))
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone XS Max"].identified(by: \.self)) { deviceName in
            MainView()
        }
    }
}
#endif
