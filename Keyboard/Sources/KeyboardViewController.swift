import UIKit
public final class KeyboardViewController: UIInputViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let refreshBtn = UIButton(type: .system)
    let chip1 = UIButton(type: .system)
    let chip2 = UIButton(type: .system)
    let chip3 = UIButton(type: .system)
    let ctxField = UITextField()
    let tonePicker = UIPickerView()
    let tones: [Tone] = [.CASUAL,.POLITE,.FIRM,.SWEET]
    var currentTone: Tone = .CASUAL
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(); refresh()
    }
    func setupUI() {
        view.backgroundColor = .systemBackground
        let row = UIStackView(arrangedSubviews: [refreshBtn, chip1, chip2, chip3])
        row.axis = .horizontal; row.spacing = 8; row.distribution = .fillEqually
        refreshBtn.setTitle("↻", for: .normal)
        [chip1,chip2,chip3].forEach { $0.setTitle("-", for: .normal) }
        chip1.addTarget(self, action: #selector(commit1), for: .touchUpInside)
        chip2.addTarget(self, action: #selector(commit2), for: .touchUpInside)
        chip3.addTarget(self, action: #selector(commit3), for: .touchUpInside)
        refreshBtn.addTarget(self, action: #selector(refreshTap), for: .touchUpInside)
        ctxField.placeholder = "문맥 붙여넣기"; ctxField.borderStyle = .roundedRect
        tonePicker.dataSource = self; tonePicker.delegate = self
        let col = UIStackView(arrangedSubviews: [row, ctxField, tonePicker])
        col.axis = .vertical; col.spacing = 8
        view.addSubview(col); col.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            col.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            col.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            col.topAnchor.constraint(equalTo: view.topAnchor, constant: 6),
            col.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
        ])
    }
    @objc func refreshTap() { refresh() }
    @objc func commit1() { commit(chip1.currentTitle) }
    @objc func commit2() { commit(chip2.currentTitle) }
    @objc func commit3() { commit(chip3.currentTitle) }
    func commit(_ text: String?) { guard let t = text, !t.isEmpty else { return }; textDocumentProxy.insertText(t) }
    func refresh() {
        let threadId = "kakao_demo"
        let ctx = ctxField.text ?? ""
        let sims = RagEngine.topK(threadId: threadId, query: ctx, k: 15)
        let style = StyleProfiler.build(threadIds: [threadId])
        let ranked = Ranker.rank(TemplateGenerator.generate(ctx: ctx, sims: sims, style: style, n: 6, tone: currentTone))
        let top3 = Array(ranked.prefix(3))
        chip1.setTitle(top3.count>0 ? top3[0] : "-", for: .normal)
        chip2.setTitle(top3.count>1 ? top3[1] : "-", for: .normal)
        chip3.setTitle(top3.count>2 ? top3[2] : "-", for: .normal)
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { tones.count }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch tones[row] { case .CASUAL: return "캐주얼"; case .POLITE: return "공손"; case .FIRM: return "단호"; case .SWEET: return "다정" }
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { currentTone = tones[row]; refresh() }
}