//
//  FunFactView.swift
//  Location Demo
//
//  Created by Promit Mukhopadhyay on 2/7/24.
//

import SwiftUI


struct BannerView: View {
    @EnvironmentObject var manager : BannerTextManager
    @State var infoIsShown : Bool = false
    @State var rootData : [String]
    //@State var infoArray = [""]
 
    //var data : EventCalModel
    var body: some View {
        
        
        VStack{
            
            
            Button{
                withAnimation(.easeInOut){
                    infoIsShown.toggle()
                }
            } label: {
                //Text(infoArray.description)
                Marquee(rootData: rootData, font: UIFont(name: "TimesNewRomanPS-BoldMT", size: 16)!)
                    .padding(.vertical, 10)
                    .foregroundStyle(.black)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.white).opacity(0.25))
//                    .overlay( /// apply a rounded border
//                        RoundedRectangle(cornerRadius: 20)
//                            .stroke(.black.opacity(0.3), lineWidth: 5)
//                    )
                    
            }
            
            
            
            if(infoIsShown){
                ScrollView{
                    VStack{
                        ForEach(rootData, id: \.self){root in
                            switch root{
                            case "sports":
                                
                                Text("Sports")
                                    .font(Font(UIFont(name: "TimesNewRomanPS-BoldMT", size: 20)!))
                                    .underline()
                            case "funFact":
                                Text("Fun Facts")
                                    .font(Font(UIFont(name: "TimesNewRomanPS-BoldMT", size: 20)!))
                                    .underline()
                            default:
                                Text("defaultCase")
                                    .font(Font(UIFont(name: "TimesNewRomanPS-BoldMT", size: 20)!))
                                    .underline()
                            }
                                
                            Spacer()
                            ForEach(self.manager.bannerText, id: \.self){info in
                                if(info.type == root){
                                    Text(info.text)
                                        .font(Font(UIFont(name: "TimesNewRomanPS-BoldMT", size: 16)!))
                                }
                            }
                            Spacer()
                        }
                        
                    }
                    .onAppear {
                        print(rootData)
                    }
                    
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(.white).opacity(0.25))
//                .overlay( /// apply a rounded border
//                    RoundedRectangle(cornerRadius: 20)
//                        .stroke(.black.opacity(0.5), lineWidth: 5)
//                )
                
            }
        }
        .padding(20)
       
           
    }
}



struct Marquee: View {
    @EnvironmentObject var manager : BannerTextManager
    @State var rootData:[String] = ["funFact"]
    //@Binding var textArray: [BannerText]
    @State var text : String = ""
    
    var font: UIFont
    
    @State var storedSize: CGSize = .zero
    
    @State var offset : CGFloat = 0
    
    

    var body: some View{
        
        ScrollView(.horizontal, showsIndicators: false){
            Text(text)
                .font(Font(font))
                .offset(x:offset)
        }
        .disabled(true)
        .onReceive(self.manager.$bannerText) { newValue in
            let tempTexts : [BannerText] = newValue
            var i = 0
            var fullText = ""
            for root in rootData{
                print(root)
                switch root{
                    case "sports":
                    fullText.append(" |   Sports:")
                case "funFact":
                    fullText.append(" |   Fun Facts:")
                default:
                    fullText.append(" |   defaultCase")
                }
                
                
                for newText in tempTexts{
                    print("\(newText.type) : \(newText.type == root)")
                    (1...6).forEach{_ in
                        
                        if(newText.type == root){
                            fullText.append(" ")
                        }
                        
                        
                    }
                    if(newText.type == root){
                        fullText.append(newText.text)
                    }
                    if(newText.text != ""){
                        i += 1
                    }
                    
                }
                
            }
            
            print("this the i value:\(i) and the rootData:\(rootData)")
            
            /*if(i == 0 && rootData == "sports"){
                fullText = "No sports events today  . . . . . . . . . . . . . . . . . . . . . . . . "
            }*/
           
            text = fullText
            
            
            //print("text ARRAY from marquee:\(self.manager.bannerText.description)")
            print("text from marquee: \(text)")
            
            storedSize = manager.textSize(textInput:text, font: font)
            
            text.append(fullText)
            
           
            manager.calcTimeFromString(size: storedSize)
        }
        .onAppear(){
            
            text = "Loading Data"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                withAnimation(.linear(duration: manager.marqueeTiming)){
                    offset = -storedSize.width
                    print("Stored Size on appear: \(storedSize.width)")
                }
            }
            
        }
        .onReceive(Timer.publish(every: (manager.marqueeTiming), on: .main, in: .default).autoconnect(), perform: { _ in
            offset = 0
            withAnimation(.linear(duration: (manager.marqueeTiming))){
                offset = -storedSize.width
                print("Stored Size on update: \(storedSize.width)")
            }
        })
      
        
        
        
    }
    
    
}
