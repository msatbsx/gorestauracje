//
//  InnAppPurchaseViewController.swift
//  GoOut Restauracje
//
//  Created by Michal Szymaniak on 20/08/16.
//  Copyright © 2016 Codelabs. All rights reserved.
//

import UIKit
import PKHUD

class InnAppPurchaseViewController: RootViewController, UITextFieldDelegate {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var pasteCodeTextField: UITextField!
    @IBOutlet weak var buyInfoTextView: UITextView!
    @IBOutlet weak var OpenShopButton: UIButton!
 
    
    var isFirstCheckBoxOn = false
    var isSecondCheckBoxOn = false
    var hideKeyboardTap:UITapGestureRecognizer?
    var packageARRAY:NSArray?
    var shopUrl : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupButtonViewLabels()
        shouldAddBackButton = true
        pasteCodeTextField.layer.borderWidth = 1
        pasteCodeTextField.layer.borderColor = UIColor.gray.cgColor;
        hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(InnAppPurchaseViewController.dismissKeyboard))
        view.addGestureRecognizer(hideKeyboardTap!)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        addBottomShadow()
        HUD.show(.progress)
        RestClient.sharedInstance.getInfoHowToBuyCoupons { (infotext, shopLink, success) in
            DispatchQueue.main.async {
                if success
                {
                    self.buyInfoTextView.text = infotext!
                    if shopLink != nil{
                        self.shopUrl = shopLink!
                    }
                    HUD.hide()
                }
                else
                {
                    HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                    HUD.hide(afterDelay: 2.0)
                }
            }
        }
    }
    
    @IBAction func openShop(_ sender: Any) {
        if (self.shopUrl.characters.count) > 0
        {
            let linkText = self.shopUrl as String
            let callAllertController = UIAlertController(title:"" , message: "Otworzyć w przeglądarce?", preferredStyle: .alert)
            let cancellAction = UIAlertAction(title: "Nie", style: .cancel, handler: nil)
            let callAction = UIAlertAction(title: "Tak", style: .default, handler: { (self) in
                UIApplication.shared.openURL(URL(string: linkText)!)
            })
            callAllertController.addAction(callAction)
            callAllertController.addAction(cancellAction)
            DispatchQueue.main.async {
                self.present(callAllertController, animated: true, completion: nil)
            }
        }

    }
    

    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        pasteCodeTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        if pasteCodeTextField.text == ""
        {
           pasteCodeTextField.text = "Jeśli masz kod GoOut wprowadź go tutaj"
        }
        return true
    }
    
    func dismissKeyboard()
    {
        if pasteCodeTextField.text == ""
        {
            pasteCodeTextField.text = "Jeśli masz kod GoOut wprowadź go tutaj"
        }
        view.endEditing(true)
    }

    
    @IBAction func buyAction(_ sender: AnyObject)
    {
        var emailTextField: UITextField?
        let code = self.pasteCodeTextField.text
        if code != "" && code != "Jeśli masz kod GoOut wprowadź go tutaj"
        {
            let alertController = UIAlertController(title:"" , message: "Po aktywowaniu tego pakietu w aplikacji dostępne będą kupony objęte tym pakietem.\nOświadczam, że zapoznałem się z regulaminem i akceptuję jego treść.\n Aby zakończyć proces aktywacji proszę podać adres email.", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "email"
                emailTextField = textField
            })

            let cancelAction = UIAlertAction(title: "Anuluj", style: .cancel) { (action:UIAlertAction!) in
                return
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Potwierdzam", style: .default) { (action:UIAlertAction!) in
                self.realBuy(emailTextField: emailTextField, code: code)
            }
            alertController.addAction(OKAction)
            DispatchQueue.main.async
            {
                self.present(alertController, animated: true, completion:nil)
            }
        }
        
    }
    
    func realBuy(emailTextField :UITextField?, code: String?)
    {

        if emailTextField?.text != nil && emailTextField?.text != ""
        {
            
            HUD.show(.progress)
            RestClient.sharedInstance.registerKuponCode(code!, (emailTextField?.text)!, completion: { (success, mess) in
                DispatchQueue.main.async {
                    if success
                    {
                        if mess != ""
                        {
                            HUD.hide()
                            let callAllertController = UIAlertController(title:"" , message: mess, preferredStyle: .alert)
                            let callAction = UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
                                AppManager.sharedInstance.forceReloadRestaurantList = true
                                _ = self.navigationController?.popViewController(animated: true)
                            })
                            callAllertController.addAction(callAction)
                            self.present(callAllertController, animated: true, completion: nil)
                        }
                        else{
                            HUD.hide()
                            HUD.flash(.success, delay: 3.0)
                            AppManager.sharedInstance.forceReloadRestaurantList = true
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    else
                    {
                        if mess != ""
                        {
                            HUD.hide()
                            let callAllertController = UIAlertController(title:"" , message: mess, preferredStyle: .alert)
                            let callAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            callAllertController.addAction(callAction)
                            self.present(callAllertController, animated: true, completion: nil)
                        }
                        else
                        {
                            HUD.show(.labeledError(title: "Błąd", subtitle: "Brak połącznia z siecią"))
                            HUD.hide(afterDelay: 2.0)
                        }
                    }
                }
            })
        }
        else{
            HUD.show(.labeledError(title: "Błąd", subtitle: "Uzupełnij email!"))
            HUD.hide(afterDelay: 2.0)
        }
    }
    
    func addBottomShadow()
    {
        //ViewConfigurator.addBottomShadow(viewObject: firstPackageView)
        ViewConfigurator.addBottomShadow(viewObject: self.view)
    }
    
    func setupButtonViewLabels()
    {
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: pasteCodeTextField, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: buyButton, setRoundedCorners: true, shouldHaveBorder: false);
        ViewConfigurator.createRoundedCornersAndBorderWidth(viewObject: OpenShopButton, setRoundedCorners: true, shouldHaveBorder: false);
    }
    

}
