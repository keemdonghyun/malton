# ChatStyleKeyboard iOS (AltStore Ready)

## 빌드 없이 .ipa 받는 법 (맥 없이 가능)
1) 이 폴더를 GitHub 레포로 올립니다.
2) GitHub > Actions > **iOS Unsigned IPA (for AltStore)** 워크플로 실행.
3) 완료되면 **Artifacts**에서 `ChatStyleKeyboard-unsigned.ipa` 다운로드.
4) Windows PC에서 AltStore(AltServer)로 해당 IPA 설치.

## AltStore 설치 요약
- iTunes (공식 사이트 버전) + iCloud 설치
- AltServer 설치 후 iPhone 연결 → **Install AltStore**
- iPhone에서 AltStore 실행 → `+` 눌러 IPA 선택 → 설치
- 7일마다 AltStore가 자동 재서명(같은 네트워크 필요)

## 프로젝트 열기
- macOS가 있다면: `brew install xcodegen && xcodegen generate && open ChatStyleKeyboard.xcodeproj`