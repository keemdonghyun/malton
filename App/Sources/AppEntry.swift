import SwiftUI

struct AppEntry: View {
    @AppStorage("maltone.onboarded") private var onboarded = false

    var body: some View {
        Group {
            if onboarded {
                HomeView()
            } else {
                OnboardingView()
                    .onAppear { onboarded = true } // 최초 1회만 표시
            }
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("말톤").font(.largeTitle).bold()
            Text("설정 → 일반 → 키보드에서 활성화 후 사용하세요.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
