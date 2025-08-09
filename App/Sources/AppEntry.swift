import SwiftUI

@main
struct ChatStyleKeyboardApp: App {
    @AppStorage("maltone.onboarded") private var onboarded = false
    var body: some Scene {
        WindowGroup {
            Group {
                if onboarded {
                    HomeView()
                } else {
                    OnboardingView()
                        .onAppear { onboarded = true } // 최초 1회만 노출
                }
            }
        }
    }
}

// 기존 화면이 없을 수 있어 간단한 플레이스홀더
struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("말톤").font(.largeTitle).bold()
            Text("설치가 완료됐습니다. ‘설정 → 일반 → 키보드’에서 활성화 후 사용하세요.")
                .multilineTextAlignment(.center).foregroundColor(.secondary)
        }.padding()
    }
}
