//
//  DogImageController.swift
//  DogBreedAssignment
//
//  Created by TJ on 3/10/22.
//

import UIKit
import Alamofire
class DogImageController: UIViewController {
    @IBOutlet weak var dogImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getRandomDogImages()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func newImageAction(_ sender: Any) {
        self.getRandomDogImages()
    }
 //MARK: DogRandom Images webservice
    func getRandomDogImages(){
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"            //Content type is json array
        ]
        
    AF.request(randomDogImgApi, method: .get, parameters: [:], encoding: URLEncoding.default, headers:  headers ).validate(contentType: ["application/json"]).responseJSON { response in
            switch response.result {
            case .success( _):
                //success, do anything
                if let data = response.value as? Dictionary<String,Any>, let img = data["message"] as? String{
                    DispatchQueue.main.async {
                        self.dogImage.sd_setImage(with: URL(string: img), completed: nil)
                    }
                }
                break
                
            case .failure(let error):
                print(error.localizedDescription)   //print error message
                break
            }
             
        }
    }
}
