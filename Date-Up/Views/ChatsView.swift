//
//  ChatsView.swift
//  Date-Up
//
//  Created by Łukasz Janiszewski on 16/08/2021.
//

import SwiftUI

struct ChatsView: View {
    @ObservedObject private var profileViewModel: ProfileViewModel
    
    init(profile: ProfileViewModel) {
        self.profileViewModel = profile
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            NavigationView {
                Text("ChatView")
            }
        }
        .onAppear {
            self.profileViewModel.fetchData()
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        let profileViewModel = ProfileViewModel(forPreviews: true)
        ForEach(ColorScheme.allCases, id: \.self) {
            ChatsView(profile: profileViewModel).preferredColorScheme($0)
        }
    }
}
