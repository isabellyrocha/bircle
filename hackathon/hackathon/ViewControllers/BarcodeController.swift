import ScanditBarcodeCapture
import UIKit
import RealmSwift

let EAN_API_KEY = "17b59ae07e623a422907dd947fd251"
let EAN_BASE_URL = "https://api.ean-search.org/api/"

extension DataCaptureContext {
    private static let licenseKey = "AVv/AAOBHGkQAdCRciFd3gwoDDvyJ7LjBGmAqOhR1AjsaCxMV2nspcNAswDidvg4W2orwfRKno4BbHgnrU4Hsml97yo+Vtm+6SXmm0RU0c8yGPj041H6d3pSj4/YWTIiCFR/IXxvvVHTTd7r6GPxFa5hehwvTaqOfna2DC1PPqR3XtTZZVYWt+9YTXJESEZoP2O49oxvM3hfVX6rfWVBZ4J5j6HkQACselYNWEdehU2wdWzjumReNZt4C/3gf9VM6UjHEz5jG1KjTB8mAXrjpfx+ywD/WXCCKFLX6R1ayqfiRshy2FPVaSVhi8xnYZesjl48DosleVj9e2Gc8W4c3uMWFZpbXXB+WCjArjRT02QCUsKsWG3mAxFQsMd5SjIyVVOvEEV/if1Gb8ul+mpeZY1Y+tAlY6yek1D1hVcWFL4YLJ0uWlvgnr9zS4yNIKCofxKpui5WBVECEjvy0nVUlG1LUYmSCJ/NGnI+tHpEwBe1VTi9vn/aY7oW6maQaDWLKwMrnJQsBLzkKiUEpDPkNgJmlbY8iHcdaMSZo0nrEg3oGcZdQjS5uYBJHvB309pd+MeYdqw7VRPyPKstqTlcNxsPxLHJ6In7occdlpijG+CSzZJQHDTjT5ghowRTdlI3cPj9PvBwYX+IfHTJBIxSKyWUxcLDOFw7YLpcFFS7Ch1YDZMq4+pmqNi1+YQHcksFtGHf7xPwh+kuQFJ9pBuoMa51N82LXzPwhJLlbaT+MURQn0YTfrQA6qIqRDyDF1IpXdAZqV2xTrZU6l/McAtbngm9DXG9HcMtk4Clfr3JdI/FmUdYQhBIEjajZ/i/PnQNADlPLj+3mmnHHhjzZ3LrYGIwWD3DVR61953Ow7fEC3INQ5r89sKfuC+EZszHVbnE8P7JV02r6gIa3lve5nEbMWqxGvdV8AfLvm+vgR2+rLTpBTgG+fZfhDe2PFY/xEGbUa0k0sjgVaKIgW/js2QMuLt2wD/h41OR3dik4en6TjprMXTw9t/HGje5raNkLRRydi5fjpTRBe/AeE19exdlb4IHKLkVY2JT1wW5xZkd0zaCKnYB0BWIEjoc/8c3yZ8/UpNH19wceRx6FW/ykfsX1r9eQK0L3S7lTtqIFj5DTMTh0kKTrxZ3C4yGLHpAWy1cGbSOC5ESxPZIFPSntvRh2+dHVq0WNnjC1Y7pKgr21UG3cBgVjr/VW7PD7zq1fTU="
    
    static var licensed: DataCaptureContext {
        return DataCaptureContext(licenseKey: licenseKey)
    }
}

class BarcodeController: UIViewController, BarcodeCaptureListener {
    
    private var context: DataCaptureContext!
    private var camera: Camera?
    private var barcodeCapture: BarcodeCapture!
    private var captureView: DataCaptureView!
    private var overlay: BarcodeCaptureOverlay!
    private var products: [Ean]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecognition()
        setupNavigation()
        
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        swipeLeft.addTarget(self, action: #selector(popToLeftBarButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        barcodeCapture.isEnabled = true
        camera?.switch(toDesiredState: .on)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
    }
    
    func setupRecognition() {
        context = DataCaptureContext.licensed
        
        camera = Camera.default
        context.setFrameSource(camera, completionHandler: nil)
        
        let recommenededCameraSettings = BarcodeCapture.recommendedCameraSettings
        camera?.apply(recommenededCameraSettings)
        
        let settings = BarcodeCaptureSettings()
        
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
        settings.set(symbology: .qr, enabled: true)
        settings.set(symbology: .dataMatrix, enabled: true)
        settings.set(symbology: .code39, enabled: true)
        settings.set(symbology: .code128, enabled: true)
        settings.set(symbology: .interleavedTwoOfFive, enabled: true)
        
        let symbologySettings = settings.settings(for: .code39)
        symbologySettings.activeSymbolCounts = Set(7...20) as Set<NSNumber>
        
        barcodeCapture = BarcodeCapture(context: context, settings: settings)
        barcodeCapture.addListener(self)
        
        captureView = DataCaptureView(context: context, frame: view.bounds)
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(captureView)
        
        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        overlay.viewfinder = RectangularViewfinder()
        captureView.addOverlay(overlay)
    }
    
    private func showResult(_ result: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Article added!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion() }))
            self.present(alert, animated: true, completion: nil)
            print(result)
            guard let user = app.currentUser() else {
                fatalError("User must be logged.")
            }

            // Block bellow needed if the remote scheme changes
            //let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
            //Leave the block empty
            //}
            //Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: migrationBlock)

            // GetProductByEAN(ean: result, completionHandler: <#T##([Article]) -> Void#>)

            
            self.getProductByEAN(ean: result, completionHandler:{ [weak self] (products) in
                self?.products = products
                DispatchQueue.main.async {
                    // Database Setup
                    
                    print(products[0].name)
                    
                    let realm = try! Realm(configuration: user.configuration(partitionValue: "test"))

                    let articles = realm.objects(Article.self).filter("ean = %@", result)
                    if let article = articles.first {
                        try! realm.write {
                            let newCount = Int(article.count!)!+1
                            article.count = String(newCount)
                        }
                    } else {
                        try! realm.write {
                            realm.add(Article(ean: result, name: products[0].name, date: "test_date", realm_id: "test", categoryId: products[0].categoryId, categoryName: products[0].categoryName))
                        }
                    }
                    
                    
                    }
                    
                })
            }
    }
    
    func getProductByEAN(ean: String, completionHandler: @escaping ([Ean]) -> Void) {
      let query = "?op=barcode-lookup&format=json"
      let token = "&token=" + EAN_API_KEY
      let param = "&ean=" + ean
      let url = URL(string: EAN_BASE_URL + query + token + param)!

      let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        if let error = error {
          print("Error with fetching films: \(error)")
          return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
          return
        }

        if let data = data,
          let model = try? JSONDecoder().decode([Ean].self, from: data) {
            completionHandler(model)
        }
      })
      task.resume()
    }
    
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        guard let barcode = session.newlyRecognizedBarcodes.first else {
            return
        }
        
        barcodeCapture.isEnabled = false
        var result = ""
        if let data = barcode.data {
            result += "\(data)"
        }
        
        showResult(result) { [weak self] in
            self?.barcodeCapture.isEnabled = true
        }
    }
    
    lazy var popToLeftBarButtonItem = UIBarButtonItem(
        title: "Re-Bottle",
        style: .done,
        target: self,
        action: #selector(popToLeftBarButtonTapped)
    )
    
    fileprivate func setupNavigation() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.setRightBarButton(popToLeftBarButtonItem, animated: false)
    }
    
    @objc fileprivate func popToLeftBarButtonTapped() {
        navigationController?.popViewControllerToLeft()
    }
    
}
