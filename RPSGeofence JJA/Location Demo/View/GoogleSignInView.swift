//import SwiftUI
//import FirebaseCore
//import FirebaseAuth
//import GoogleSignIn
//
//struct GoogleSignIn: View {
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            Text("Welcome")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .padding(.bottom, 20)
//            
//            Text("Sign in to continue")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .padding(.bottom, 40)
//            
//            Button(action: {
//                signInWithGoogle()
//            }) {
//                HStack {
//                    Image("google_logo")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                    Text("Sign in with Google")
//                        .fontWeight(.medium)
//                        .foregroundColor(.white)
//                }
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//            }
//            .padding(.horizontal, 40)
//            
//            Spacer()
//        }
//        .background(Color(UIColor.systemGroupedBackground))
//        .edgesIgnoringSafeArea(.all)
//    }
//
//    func signInWithGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        // Start the sign-in flow!
//        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
//            print("No root view controller")
//            return
//        }
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
//            guard error == nil else {
//                print("Error signing in: \(error!.localizedDescription)")
//                return
//            }
//
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString else {
//                print("Failed to get ID token")
//                return
//            }
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: user.accessToken.tokenString)
//
//            // Authenticate with Firebase
//            Auth.auth().signIn(with: credential) { authResult, error in
//                if let error = error {
//                    print("Error authenticating: \(error)")
//                    return
//                }
//                // User is signed in
//                if let user = authResult?.user {
//                    print("User signed in: \(user.displayName ?? "No Name")")
//                    print("User email: \(user.email ?? "No Email")")
//                    print("User ID: \(user.uid)")
//                    print("User photo URL: \(user.photoURL?.absoluteString ?? "No Photo URL")")
//                }
//            }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct GoogleSignIn: View {
    @Binding var isSignedIn: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Welcome")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 40)
            
            Button(action: {
                signInWithGoogle()
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Sign in with Google")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign-in flow!
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else {
            print("No root view controller")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            guard error == nil else {
                print("Error signing in: \(error!.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Failed to get ID token")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)

            // Authenticate with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error authenticating: \(error)")
                    return
                }
                // User is signed in
                if let user = authResult?.user {
                    print("User signed in: \(user.displayName ?? "No Name")")
                    print("User email: \(user.email ?? "No Email")")
                    print("User ID: \(user.uid)")
                    print("User photo URL: \(user.photoURL?.absoluteString ?? "No Photo URL")")
                }
                // Set isSignedIn to true to navigate to the Main view
                isSignedIn = true
            }
        }
    }
}
