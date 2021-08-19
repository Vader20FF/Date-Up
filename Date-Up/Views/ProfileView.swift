//
//  SettingsView.swift
//  Date-Up
//
//  Created by Łukasz Janiszewski on 16/08/2021.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var profileViewModel: ProfileViewModel
    @State private var switchToContentView = false
    private let textFieldColor = Color("TextFieldsColor")
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var bio = ""
    @State private var preference = ""
    private var preferenceValues = ["Men", "Women", "Both"]
    @State private var editMode = false
    
    init(profile: ProfileViewModel) {
        self.profileViewModel = profile
        self.firstName = profile.profile!.firstName
        self.lastName = profile.profile!.lastName
        self.bio = profile.profile!.bio
        self.preference = profile.profile!.preference
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        profileViewModel.session.signOut()
                    }, label: {
                        Image(systemName: "person.badge.minus")
                    })
                    .padding(.trailing, screenWidth * 0.1)
                    .padding(.top, screenHeight * 0.03)
                }
                .foregroundColor(.black)
                .font(.system(size: screenHeight * 0.03))
                
                VStack {
                    Image("blank-profile-hi")
                        .resizable()
                        .frame(width: screenWidth * 0.6, height: screenHeight * 0.3)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    
                    Button(action: {
                        withAnimation {
                            if changeWasMade() {
                                profileViewModel.session.editUserInfoInDatabase(firstName: firstName, lastName: lastName, bio: bio, preference: preference)
                            }
                            
                            profileViewModel.getUserInfo()
                            editMode.toggle()
                        }
                    }, label: {
                        Image(systemName: editMode ? "pencil.circle.fill" : "pencil.circle")
                    })
                    .padding(.top, screenHeight * 0.03)
                    .foregroundColor(.black)
                    .font(.system(size: screenHeight * 0.03))
                    
                    Spacer()
                    
                    if profileViewModel.profile != nil {
                        Group {
                            TextField(profileViewModel.profile!.firstName, text: $firstName)
                            
                            TextField(profileViewModel.profile!.lastName, text: $lastName)
                            
                            TextField(profileViewModel.profile!.firstName, text: $bio)
                                .padding(.bottom, screenHeight * 0.1)
                        }
                        .padding()
                        .background(textFieldColor)
                        .cornerRadius(5.0)
                        .lineLimit(0)
                        .disabled(editMode ? false : true)
                        
                        Text("Preference:")
                            .padding(.trailing, screenWidth * 0.65)
                            .padding(.top, screenHeight * 0.05)
                        Picker("preference", selection: $preference) {
                            ForEach(preferenceValues, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.bottom, screenHeight * 0.05)
                        .disabled(editMode ? false : true)
                        
                    } else {
                        Text("ProfileView: The profile is nil!")
                    }
                }
            }
        }
    }
    
    private func changeWasMade() -> Bool {
        if profileViewModel.profile != nil {
            if profileViewModel.profile!.firstName != firstName || profileViewModel.profile!.lastName != lastName || profileViewModel.profile!.firstName != firstName {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let profileViewModel = ProfileViewModel()
        ProfileView(profile: profileViewModel)
    }
}