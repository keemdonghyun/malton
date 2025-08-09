import UIKit
import UniformTypeIdentifiers

public final class ShareViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        if let item = (extensionContext?.inputItems.first as? NSExtensionItem),
           let provider = item.attachments?.first {
            if provider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, _) in
                    DispatchQueue.main.async {
                        if let s = data as? String {
                            let cleaned = TextClean.clean(s)
                            let threadId = "kakao_\(abs(cleaned.hashValue))"
                            let role = cleaned.hasPrefix("나:") ? "me" : "partner"
                            SharedStore.shared.append(Message(threadId: threadId, role: role, text: cleaned, ts: Date().timeIntervalSince1970))
                        }
                        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                    }
                }
            } else {
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            }
        }
    }
}