//
//  MainViewController.swift
//  Clean Swift Template Project
//
//  Created by Murilo de Souza Lopes on 02/08/19.
//  Copyright (c) 2019 Murilo de Souza Lopes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainDisplayLogic: class
{
    func displaySomething(viewModel: Main.Something.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic
{
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    var items: [Item] = []
    let mainView = MainView()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupMainView()
        
        doInit()
    }
    
    func setupMainView(){
        title = "Github API"
        mainView.tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.idCell)
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func doInit()
    {
        let request = Main.Something.Request()
        interactor?.doSomething(request: request)
    }
    
    func displaySomething(viewModel: Main.Something.ViewModel)
    {
        items = viewModel.item
        mainView.tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.idCell, for: indexPath) as? MainTableViewCell{
            
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    
}

extension MainViewController: UITableViewDelegate{}
