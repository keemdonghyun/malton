import SwiftUI

struct ContentView: View {
    @State private var agree1 = true
    @State private var agree2 = true
    @State private var agree3 = true

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("말톤 Maltone").font(.title)
            Text("공유로 넘긴 텍스트만 학습하고, 로컬(App Group)에서만 처리합니다.")
            Toggle("공유 텍스트만 학습", isOn: $agree1)
            Toggle("외부 전송 안 함", isOn: $agree2)
            Toggle("민감정보 자동 마스킹", isOn: $agree3)
            Spacer()
            Button("확인") {}
                .buttonStyle(.borderedProminent)
                .disabled(!(agree1 && agree2 && agree3))
        }.padding(20)
    }
}