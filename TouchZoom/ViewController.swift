//
//  ViewController.swift
//  TouchZoom
//
//  Created by IrvingHuang on 2020/5/1.
//  Copyright © 2020 Irving Huang. All rights reserved.
//

import UIKit

// MARK: - Base View Controller
class ViewController: UIViewController {
    
    lazy var imageView: TouchZoomImageView = {
        let v = TouchZoomImageView(frame: .zero)
        view.addSubview(v)
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    private func setup() {
        let views = [ "img": imageView]
        var constraints = [NSLayoutConstraint]()
        // 水平
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"H:|-(0)-[img]",options: [], metrics: nil, views: views)
        // 垂直
        constraints += NSLayoutConstraint.constraints(withVisualFormat:"V:|-(100)-[img]",options: [], metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - Touch Zoom Up ImageView
class TouchZoomImageView: UIImageView {
    
    private lazy var viewZoom: UIImageView = {
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        v.contentMode = .center
        v.layer.cornerRadius = 80
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.masksToBounds = true
        addSubview(v)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        image = .sampleImage
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        print(bounds)
        print(frame)
    }
}

// MARK: Touch Event
extension TouchZoomImageView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        viewZoom.isHidden = false
        viewZoom.center = point

        viewZoom.image = self.cutWithFrame(frame: viewZoom.frame)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        viewZoom.isHidden = true
    }
}


// MARK: - Image announce
extension UIImage {
    static let sampleImage: UIImage = UIImage(named: "Lenna")!
    
    func reSizeImage(reSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage
    }
    
    func scaleImage(scaleSize: CGFloat) -> UIImage {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}

// MARK: - extension UIImageView
extension UIImageView {
    func cutWithFrame(frame: CGRect) -> UIImage? {
        guard let cutImage = self.image?.cgImage?.cropping(to: frame) else { return nil }
        return UIImage(cgImage: cutImage).scaleImage(scaleSize: 1.2)
    }
}
