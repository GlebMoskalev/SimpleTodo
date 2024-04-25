//
//  ViewController.swift
//  Todo#1
//
//  Created by Глеб Москалев on 23.04.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var todos: [TodoItem] = [TodoItem]()
    
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
        
        navigationItem.title = "Todo List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAlert))
        
        if let encodedData = UserDefaults.standard.array(forKey: "Todos") as? [Data]{
            todos = encodedData.compactMap({ try? JSONDecoder().decode(TodoItem.self, from: $0)})
            print(todos)
            
    
        }
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
        let data = todos.map({ try? JSONEncoder().encode($0)})
        UserDefaults.standard.set(data, forKey: "Todos")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let data = todos.map({ try? JSONEncoder().encode($0)})
            UserDefaults.standard.set(data, forKey: "Todos")
        }
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
        checkMarkButton.frame = CGRect(x: 0, y: 0, width: cell.contentView.bounds.height, height: cell.contentView.bounds.height)
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

