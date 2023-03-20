import UIKit
import WebKit

public final class DWebViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Properties
    private let urlString: String
    private let wkWebView: WKWebView

    // MARK: - Init
    public init(urlString: String, tokenDTO: LocalStorageTokenDTO) {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preferences

        let wkWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        self.wkWebView = wkWebView
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        setAccessToken(tokenDTO: tokenDTO, configuration: wkWebView.configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        wkWebView.navigationDelegate = self
        wkWebView.allowsBackForwardNavigationGestures = true
        wkWebView.allowsLinkPreview = true
        DispatchQueue.main.async {
            guard let url = URL(string: self.urlString) else { return }
            let request = URLRequest(url: url)
            self.wkWebView.load(request)
        }
    }
}

private extension DWebViewController {
    func setAccessToken(tokenDTO: LocalStorageTokenDTO, configuration: WKWebViewConfiguration) {
        let dataStore = WKWebsiteDataStore.nonPersistent()
        let accessCookie = makeCookie(
            key: "Authorization",
            value: tokenDTO.accessToken,
            age: "10800"
        )
        dataStore.httpCookieStore.setCookie(accessCookie)
        let refreshCookie = makeCookie(
            key: "RefreshToken",
            value: tokenDTO.refreshToken,
            age: "604800"
        )
        dataStore.httpCookieStore.setCookie(refreshCookie)
        configuration.websiteDataStore = dataStore
    }

    func makeCookie(key: String, value: String, age: String) -> HTTPCookie {
        HTTPCookie(properties: [
            .domain: ".",
            .path: "/",
            .name: key,
            .value: value,
            .secure: "TRUE",
            .maximumAge: age
        ]) ?? .init()
    }
}
