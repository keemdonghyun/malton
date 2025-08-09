import SwiftUI
import UIKit

struct OnboardingView: View {
    @State private var didOpen = false
    @State private var copied = false
    private let steps = [
        "설정 → 일반 → 키보드 → 키보드",
        "새 키보드 추가… → 말톤 키보드",
        "말톤 키보드 들어가서 ‘전체 접근 허용’ 켜기",
        "카톡 등에서 지구본 길게 눌러 ‘말톤’ 선택"
    ]
    private let testMsg = "내일 8시 괜찮을까? 일정 공유해줘!"

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("말톤 키보드 활성화").font(.title).bold()
                    Text("아래 순서대로 진행해주세요. 버튼을 누르면 설정이 열리거나, 열리지 않으면 안내대로 따라가면 됩니다.")

                    // 단계 카드
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(steps.enumerated()), id:\.0) { i, s in
                            HStack(alignment: .top, spacing: 10) {
                                Text("\(i+1)").font(.headline).frame(width: 24, height: 24)
                                    .background(Color.primary.opacity(0.1)).clipShape(Circle())
                                Text(s)
                            }
                        }
                    }
                    .padding().background(Color.primary.opacity(0.06)).cornerRadius(12)

                    // 설정 열기 버튼들
                    VStack(spacing: 10) {
                        Button(action: openKeyboardSettings) {
                            Text("🔧 ‘새 키보드 추가’ 화면 열기 시도")
                                .frame(maxWidth: .infinity).padding()
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: openAppSettings) {
                            Text("⚙️ 앱 설정 열기(대안)")
                                .frame(maxWidth: .infinity).padding()
                        }
                        .buttonStyle(.bordered)
                        Text("일부 iOS에서 ‘새 키보드 추가’ 화면은 보안상 바로 못 열 수 있어요. 그 경우 위 안내 순서를 따라가면 됩니다.")
                            .font(.footnote).foregroundColor(.secondary)
                    }

                    Divider().padding(.vertical, 6)

                    // 테스트 입력 영역
                    Text("테스트 메시지").font(.headline)
                    TextEditor(text: .constant(testMsg))
                        .frame(minHeight: 80).padding(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.primary.opacity(0.15)))
                    Button {
                        UIPasteboard.general.string = testMsg
                        copied = true
                    } label: {
                        Text(copied ? "복사됨 ✅" : "복사하기")
                            .frame(maxWidth: .infinity).padding()
                    }
                    .buttonStyle(.bordered)

                    Text("복사 후, 말톤 키보드 상단 문맥칸에 붙여넣고 ↻ 누르면 추천 3개가 뜹니다.")
                        .font(.footnote).foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // 시도 1: 비공식(동작하면 바로 새 키보드 추가 화면)
    private func openKeyboardSettings() {
        let candidates = [
            URL(string: "App-Prefs:root=General&path=Keyboard/KEYBOARDS"),
            URL(string: "Prefs:root=General&path=Keyboard/KEYBOARDS")
        ].compactMap { $0 }
        for url in candidates {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
        }
        // 실패 시 대안
        openAppSettings()
    }

    // 시도 2: 공식(앱 설정 → 사용자가 안내 따라가기)
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
