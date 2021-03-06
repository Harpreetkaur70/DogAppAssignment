//
//  ViewController.swift
//  DogBreedAssignment
//
//  Created by TJ on 1/30/22.
//

import UIKit
import Alamofire
import SDWebImage
let randomDogImgApi = "https://dog.ceo/api/breeds/image/random"      //Api URL for images
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let dogApi = "https://dog.ceo/api/breeds/list/all"              //API URL for dog list
  
    var dogs = [String]()
    var breads = [Dictionary<String,Any>.Values.Element]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getDogBreedsServiceRequest()
    }

//MARK: WebService
    func getDogBreedsServiceRequest(){
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            
        AF.request(dogApi, method: .get, parameters: [:], encoding: URLEncoding.default, headers:  headers ).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success( _):
                    //success, do anything
                    if let data = response.value as? Dictionary<String,Any>, let resp = data["message"] as? Dictionary<String,Any>{    //information saving in data array
                       
                        self.dogs = Array(resp.keys)
                        
                        let val = resp.values.map({$0})
                        self.breads = val
                                        
                        self.tableView.reloadData()
                       
                    }                    
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                }
                 
            }
        
    }
    func getRandomDogImages(cell:UITableViewCell){
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
    AF.request(randomDogImgApi, method: .get, parameters: [:], encoding: URLEncoding.default, headers:  headers ).validate(contentType: ["application/json"]).responseJSON { response in
            switch response.result {
            case .success( _):
                //success, do anything
                if let data = response.value as? Dictionary<String,Any>, let img = data["message"] as? String{
                   
                    DispatchQueue.main.async {
                        (cell.viewWithTag(50) as! UIImageView).sd_setImage(with: URL(string: img), completed: nil)
                    }
                   
                }
                
                break
            case .failure(let error):
                print(error.localizedDescription)  //print error message
                break
            }
             
        }
    }
}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    //Custom Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {   //Adding data to the table view.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let dogie = dogs[indexPath.row]
        let breads = (breads[indexPath.row] as? Array<String>)
        
        if (breads?.count ?? 0) > 0{
            (cell.viewWithTag(5) as! UILabel).text = dogie + ":"
        }else{
            (cell.viewWithTag(5) as! UILabel).text = dogie
        }
        (cell.viewWithTag(10) as! UILabel).text =  breads!.joined(separator:", ")
        self.getRandomDogImages(cell: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "images", sender: nil)
    }
}


