//
//  HashTagButtons.swift
//  Prography
//
//  Created by 김민성 on 2023/02/04.
//

import SwiftUI

struct HashTagViews: View {
    let firstStrings: [String]
    let secondStrings: [String]
    
    init(strings: [String]) {
        //해쉬태그가 5개 이상이면 두 줄로 나눠서 보여주기 위해 배열을 두개 만듬
        //TODO: 배열 하나를 사용해 잘리지 않고 여러줄 표현하기 (horizontal scroll view를 이용해도 됨)
        if strings.count < 5 {
            self.firstStrings = strings
            self.secondStrings = []
        } else {
            self.firstStrings = Array<String>(strings[..<4])
            self.secondStrings = Array<String>(strings[4...])
        }
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                ForEach(firstStrings, id: \.self){ string in
                    Text("#" + string)
                        .bold()
                        .padding(5)
                        .lineLimit(1)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                }
            }
            HStack {
                ForEach(secondStrings, id: \.self){ string in
                    Text("#" + string)
                        .bold()
                        .padding(5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .shadow(radius: 5)
                
                }
            }
        }
    }
}

struct HashTagViews_Previews: PreviewProvider {
    static let strings: [String] = ["Action", "Mystery", "Adventure"]
    static var previews: some View {
        HashTagViews(strings: strings)
    }
}
