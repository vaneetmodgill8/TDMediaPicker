//
//  TDMediaPreviewViewController.swift
//  ImagePicker
//
//  Created by Abhimanu Jindal on 28/06/17.
//  Copyright © 2017 Abhimanu Jindal. All rights reserved.
//

import UIKit

protocol TDMediaPreviewViewControllerDelegate: class {
    func previewControllerDidTapClose(_ controller: TDMediaPreviewViewController)
    func previewControllerDidTapAddOption(_ controller: TDMediaPreviewViewController)
    func previewControllerDidTapDone(_ controller: TDMediaPreviewViewController)
}

class TDMediaPreviewViewController: UIViewController, TDMediaPreviewViewDelegate, TDMediaPreviewServiceManagerDelegate{
    
    // MARK: - Variable(s)
    
    weak var delegate: TDMediaPreviewViewControllerDelegate?

    lazy private var serviceManager: TDMediaPreviewServiceManager = TDMediaPreviewServiceManager()

    // MARK: - Init
    
    public required init() {
        super.init(nibName: "TDMediaPreview", bundle: TDMediaUtil.xibBundle())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2. View Setup
        
        let previewView = self.view as! TDMediaPreviewView
        previewView.delegate = self
        
        // 3. Service Manager Setup
        
        serviceManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        serviceManager.fetchMediaItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        serviceManager.purgeData()
        
        let previewView = self.view as! TDMediaPreviewView
        previewView.purgeData()
    }
    
    
    // MARK: - View Delegate Method(s)
    
    func previewViewDidTapClose(_ view: TDMediaPreviewView) {
        self.delegate?.previewControllerDidTapClose(self)
    }
    
    func previewViewDidTapAddMore(_ view: TDMediaPreviewView) {
        self.delegate?.previewControllerDidTapAddOption(self)
    }
    
    func previewViewDidTapDone(_ view: TDMediaPreviewView){
        self.delegate?.previewControllerDidTapDone(self)
    }
    
    // MARK: - Service Manager Deleage Method(s)
    
    func mediaPreviewServiceManager(_ manager: TDMediaPreviewServiceManager, didUpdateCart media: [TDMedia], updateType: TDCart.UpdateType, shouldDisplayAddMoreOption: Bool) {
        let previewView = self.view as! TDMediaPreviewView
        previewView.reload(cartItems: media, updateType: updateType, shouldDisplayAddMoreOption: shouldDisplayAddMoreOption)
    }
    
    
}
