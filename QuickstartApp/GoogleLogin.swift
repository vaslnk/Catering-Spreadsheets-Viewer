import GoogleAPIClientForREST
import GoogleSignIn
import UIKit

protocol GoogleLoginDelegate {
//    func personSelectionViewController(vc:PersonSelectionViewController, didSelectPerson personName:String);
    func googleLogin(vc: GoogleLogin, didFinishAuth service: GTLRSheetsService)
}


class GoogleLogin: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    private let scopes = [kGTLRAuthScopeSheetsSpreadsheetsReadonly]
    private var query: GTLRSheetsQuery!
    private let service = GTLRSheetsService()
    let justText = UILabel()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    var imageHungry: UIImageView?
    var delegate: GoogleLoginDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        //Add backgroundimage
        let image = UIImage(named: "foodService.png")
        let imageView = UIImageView(image: image!)
        imageHungry = imageView
        imageHungry?.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        imageHungry?.translatesAutoresizingMaskIntoConstraints = true
        imageHungry?.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 100)
        imageHungry?.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        view.addSubview(imageHungry!)
        
        
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        
        signInButton.frame = CGRect(x: 150, y: 160, width: 100, height: 50);
        signInButton.autoresizingMask = [.flexibleBottomMargin, .flexibleHeight];
        signInButton.translatesAutoresizingMaskIntoConstraints = true

        // Add the sign-in button.
        view.addSubview(signInButton)
        signInButton.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 70)
        signInButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if (error) != nil {
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.justText.isHidden = true
            self.imageHungry?.isHidden = true
            let image = UIImage(named: "readdle1.png")
            let logo = UIImageView(image: image!)
            logo.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
            logo.translatesAutoresizingMaskIntoConstraints = true
            logo.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 100)
            logo.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
            view.addSubview(logo)
            //Create Activity Indicator
            let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            myActivityIndicator.center = view.center
            myActivityIndicator.hidesWhenStopped = false
            myActivityIndicator.startAnimating()
            view.addSubview(myActivityIndicator)
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            delegate?.googleLogin(vc: self, didFinishAuth: service)
        }
    }
    
    func logout(){
        //logout code
        GIDSignIn.sharedInstance().signOut()
    }
    
}

func showAlert(vc: UIViewController, title : String, message: String) {
    let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: UIAlertControllerStyle.alert
    )
    let ok = UIAlertAction(
        title: "OK",
        style: UIAlertActionStyle.default,
        handler: nil
    )
    alert.addAction(ok)
    vc.present(alert, animated: true)
}
