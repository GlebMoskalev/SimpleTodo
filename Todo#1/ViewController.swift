//
//  ViewController.swift
//  Todo#1
//
//  Created by Глеб Москалев on 23.04.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var todos: [TodoItem] = [TodoItem(name: "Test todo item")]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        constraintTableView()
        configureTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAlert))
    }
    @objc func openAlert(){
        let alert = UIAlertController(title: "Create Todo", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancelButton)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) {_ in
            if let textName = alert.textFields?.first?.text{
                self.addTodo(name: textName)
            }
        }
        alert.addAction(saveButton)

        present(alert, animated: true)
    }
    
    // MARK: - Table View Methods
    private func addTodo(name: String){
        todos.append(TodoItem(name: name))
        tableView.reloadData()
    }
    
    // MARK: - Setup Table View Methods
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
//        tableView.allowsSelection = false
    }
    
    private func constraintTableView(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    // MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "todoCell")
        let todoItem = todos[indexPath.row]
        cell.textLabel?.text = todoItem.name
        
        let checkMarkButton = UIButton(type: .custom)
        checkMarkButton.tag = indexPath.row
        checkMarkButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        checkMarkButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkMarkButton.addTarget(self, action: #selector(touchCheckMark(sender:)), for: .touchUpInside)
        cell.accessoryView = checkMarkButton
        return cell
    }
    
    @objc func touchCheckMark(sender: UIButton){
        todos[sender.tag].isCompleted.toggle()
        if todos[sender.tag].isCompleted{
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
}

