//
//  ContentView.swift
//  LoginApp
//
//  Created by Lazar Avramov on 20.10.22.
//

import SwiftUI


struct ShakeEffect:GeometryEffect{
    var TravelDistance:CGFloat=6
    var numOfShakes:CGFloat=4
    var animatableData:CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
                                                TravelDistance * sin(animatableData * .pi *  numOfShakes), y: 0))
    }
}
struct ContentView: View {
    @State var     Username:String
    @State var Password:String=""
    @State var isNotLogged:Bool=true
    @State var isSecured:Bool=true
    @State var invalidAttempts=0
    @State var loginButtonDisabled:Bool=false;
    var body: some View{
        if isNotLogged{
            HStack{
                Text("Username:")
                TextField("",text:$Username,prompt: Text("your@email"))
                    .disableAutocorrection(true)
            }
            HStack{
                Text("Password:")
                if isSecured{
                    SecureField("",text:
                                    $Password,prompt: Text("your password")).disableAutocorrection(true)
                }
                else{
                    TextField("",text:
                                    $Password,prompt: Text("your password")).disableAutocorrection(true)
                }
            }.overlay(alignment: .trailing){
                Image(systemName: isSecured ? "eye.slash": "eye")
                               .onTapGesture {
                                   isSecured.toggle()
                               }
            }.modifier(ShakeEffect(animatableData:CGFloat( invalidAttempts)))
            Button("Login"){
                
                if Username == "Test" && Password == "test" {
                    isNotLogged=false
                }
                else{
                    withAnimation(.default){
                        self.invalidAttempts+=1
                        if invalidAttempts>=3{
                            loginButtonDisabled=true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                invalidAttempts=0
                                loginButtonDisabled = false
                                        }
                            
                        }
                    }
                }
            }
            .disabled((Username.isEmpty || Password.isEmpty) || loginButtonDisabled)
            
        }
        else {
            Color.green.ignoresSafeArea()
            Button{
                isNotLogged=true
            }label:{
                Text("Log out").padding(20)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(Username:"")
            ContentView(Username:"")
        }
    }
}

