//
//  ViewController.swift
//  CITest
//
//  Created by Admin on 6/17/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper
import RxSwift
import Moya_ObjectMapper
class ViewController: UIViewController {
    
    var tableView: UITableView?
    var api: MoyaProvider<Api> = MoyaProvider()
    var bag = DisposeBag()
    var beers = [Beer]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        api.rx.request(.getList)
            .asObservable()
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "qw", qos: .background)))
            .mapArray(Beer.self)
            .observeOn(MainScheduler.instance)
            .subscribe {[weak self] event in
                switch event {
                    
                case .next(let beers):
                    self?.showBeers(beers: beers)
                case .error(_):
                    break
                case .completed:
                    break
                }
        }
        .disposed(by: bag)
        
    }
    
    private func showBeers(beers: [Beer]) {
    self.beers = beers
    tableView?.reloadData()
    }
    
    
    private func setupTableView(){
        tableView = UITableView(frame: .zero)
        guard let table = tableView else {
            fatalError()
        }
        view.addSubview(table)
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView?.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView?.register(BeerCell.self, forCellReuseIdentifier: BeerCell.identifire)
        tableView?.dataSource = self
        table.delegate = self
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerCell.identifire, for: indexPath) as? BeerCell else {
            fatalError()
        }
        cell.setupWithBeer(beer: beers[indexPath.row])
        return cell
    }
    
  
}

struct Beer: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        country <- map["country"]
    }
    
   var name = ""
   var country = ""
}


class BeerCell: UITableViewCell {
     static let identifire = "BeerCell"
    
    var nameLabel: UILabel = {
        let name = UILabel()
        name.textColor = .blue
        return name
    }()
    
    var countryLabel: UILabel = {
        let name = UILabel()
        name.textColor = .black
        return name
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(countryLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        countryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        countryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: countryLabel.leadingAnchor, constant: -8).isActive = true
    }
    
    func setupWithBeer(beer: Beer){
        nameLabel.text = beer.name
        countryLabel.text = beer.country
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
