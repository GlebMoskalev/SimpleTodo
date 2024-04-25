//
//  ViewController.swift
//  Todo#1
//
//  Created by Глеб Москалев on 23.04.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var todoModel = TodoModel.shared
    
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
        
        todoModel.loadTodos()
    }
    
    @objc func openAlert(){
        let alert = UIAlertController(title: "Create Todo", message: "", preferredStyle: .alert)
        alert.addTextField()
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(cancelButton)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) {_ in
            if let textName = alert.textFields?.first?.text{
                self.todoModel.addTodo(todoName: textName)
                self.reloadTableView()
            }
        }
        alert.addAction(saveButton)

        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            todoModel.deleteTodo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            reloadTableView()
        }
    }
    
    // MARK: - Setup Table View Methods
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
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
    private func reloadTableView() {
            tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoModel.getAllTodos().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "todoCell")
        let todoItem = todoModel.getTodo(at: indexPath.row)
        cell.textLabel?.text = todoItem.name
        
        let imageName = todoItem.isCompleted ? "checkmark.square" : "square"
        let checkMarkButton = UIButton(type: .custom)
        checkMarkButton.tag = indexPath.row
        checkMarkButton.frame = CGRect(x: 0, y: 0, width: cell.contentView.bounds.height, height: cell.contentView.bounds.height)
        checkMarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        checkMarkButton.addTarget(self, action: #selector(touchCheckMark(sender:)), for: .touchUpInside)
        cell.accessoryView = checkMarkButton
        return cell
    }
    
    @objc func touchCheckMark(sender: UIButton){
        todoModel.toogleTodoCompletion(at: sender.tag)
        sender.setImage(UIImage(systemName: todoModel.getTodo(at: sender.tag).isCompleted ? "checkmark.square" : "square"), for: .normal)
    }
}

