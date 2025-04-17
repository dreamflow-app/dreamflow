import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userStats: UserStatsViewModel
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("storedUsername") private var storedUsername = ""
    @AppStorage("storedPassword") private var storedPassword = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showSignUp = false
    @AppStorage("profileImageData") private var profileImageData: Data?
    @State private var showImagePicker = false
    @State private var loginErrorMessage: String? = nil
    @State private var signUpErrorMessage: String? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    if let profileImageData = profileImageData,
                       let uiImage = UIImage(data: profileImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .onTapGesture { showImagePicker = true }
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text("Add Photo")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            )
                            .onTapGesture { showImagePicker = true }
                    }
                    
                    Spacer()
                }
                
                Text(storedUsername.isEmpty ? "Guest" : storedUsername)
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                
                if isLoggedIn {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            statView(title: "Exercises Completed", value: "\(userStats.exercisesCompleted)")
                        }
                    }
                    .padding()
                } else {
                    if showSignUp {
                        SignUpView(username: $username, password: $password, signUpErrorMessage: $signUpErrorMessage)
                    } else {
                        LoginView(username: $username,
                                password: $password,
                                loginErrorMessage: $loginErrorMessage,
                                storedUsername: storedUsername,
                                storedPassword: storedPassword,
                                isLoggedIn: $isLoggedIn)
                    }
                    
                    Button {
                        showSignUp.toggle()
                    } label: {
                        Text(showSignUp ? "Switch to Login" : "Switch to Sign Up")
                            .foregroundColor(.primary)
                    }
                    .padding()
                }
                
                if isLoggedIn {
                    Button("Log Out") {
                        isLoggedIn = false
                        username = ""
                        password = ""
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.label))
                    .foregroundColor(Color(UIColor.systemBackground))
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Profile")
        .background(Color(UIColor.systemBackground))
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(imageData: $profileImageData)
        }
    }
    
    func statView(title: String, value: String) -> some View {
        VStack {
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(UIColor.tertiarySystemBackground))
        .cornerRadius(10)
    }
}

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var loginErrorMessage: String?
    var storedUsername: String
    var storedPassword: String
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if let error = loginErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Log In") {
                if username == storedUsername && password == storedPassword {
                    isLoggedIn = true
                    loginErrorMessage = nil
                } else {
                    loginErrorMessage = "Incorrect username or password."
                }
            }
            .padding()
            .background(Color(UIColor.label))
            .foregroundColor(Color(UIColor.systemBackground))
            .cornerRadius(10)
        }
    }
}

struct SignUpView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var signUpErrorMessage: String?
    @AppStorage("storedUsername") private var storedUsername: String = ""
    @AppStorage("storedPassword") private var storedPassword: String = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            if let error = signUpErrorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
            
            Button("Sign Up") {
                if username.isEmpty || password.isEmpty {
                    signUpErrorMessage = "Fields cannot be empty."
                } else if username == storedUsername {
                    signUpErrorMessage = "Username already taken."
                } else {
                    storedUsername = username
                    storedPassword = password
                    signUpErrorMessage = nil
                }
            }
            .padding()
            .background(Color(UIColor.label))
            .foregroundColor(Color(UIColor.systemBackground))
            .cornerRadius(10)
        }
    }
}
