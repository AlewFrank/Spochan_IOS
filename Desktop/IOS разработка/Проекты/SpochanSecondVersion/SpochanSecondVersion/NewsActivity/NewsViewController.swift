//
//  ListViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 20.03.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newsTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var indexPathForSegue: IndexPath = []
    
    var isDirector: Bool = false
    
    private var service: NewService?
       private var allnews = [appNew]() {
           didSet {
               DispatchQueue.main.async {
                   self.newNotes = self.allnews
               }
           }
       }
       
       var newNotes = [appNew]() {
           didSet {
               DispatchQueue.main.async {
                   self.newsTableView.reloadData()
               }
           }
       }
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //скрываем, чтоб изначально обычному случайно не включились лишние возможности редактирования фоток
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        loadData()//загружаем данные из интернета, но пока что никуда не вставляем
        newsTableView.reloadData()//обновляем отображение страницы, чтоб если как-то хитро изменился массив, то все работало, если допустим удалим новость, когда у какогото пользователя будет открыто приложение
        
        
        let user = Auth.auth().currentUser
        if let user = user {
        let uid = user.uid
            
        self.db.collection("UsersRussia").getDocuments { (snapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in snapshot!.documents {
                      let docId = document.documentID
                    if docId == uid {
                        self.isDirector = document.get("director") as? Bool ?? false
                        if self.isDirector {
                            self.navigationController?.setNavigationBarHidden(false, animated: true)
                            //обязательно во viewWillDisappear вернуть все, чтоб на другие viewController никак не влияла
                        }

                    }
                   }
               }
        }
    }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillDisappear(true)
    }
        
    
    func loadData() {
            service = NewService()
            service?.get(collectionID: "NewsRussia") { newNotes in
                self.allnews = newNotes
            }
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newNotes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1 //в каждой секции один элемент, чтоб был пропуск между картами
        //return newNotes.count
        }
    
    // расстояние между секциями
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 16
        }
    
    // Убирает цвет у разделительной полосы между карточками
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
        }
    
    //для высоты каждой ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //автоматическая высота
    }
    
    
    //действ. при нажатии на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)//выделение сразу же снимается, чтоб не так, что выбрал один раз и она теперь вечно подсвечивает
        
        if isDirector {
            self.openDialogWindow(indexPath: indexPath)//создали ниже
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.update(newsTitle: newNotes[indexPath.section].newsTitle ?? "newsTitle",
                    newsDescription: newNotes[indexPath.section].newsDescription ?? "newsDescription",
                    newsData: newNotes[indexPath.section].newsData ?? "newsData",
                    newsTime: newNotes[indexPath.section].newsTime ?? "newsTime",
                    newsImageUrl_1: newNotes[indexPath.section].newsImageUrl_1 ?? "",
                    newsImageUrl_2: newNotes[indexPath.section].newsImageUrl_2 ?? "",
                    newsImageUrl_3: newNotes[indexPath.section].newsImageUrl_3 ?? "",
                    newsImageUrl_4: newNotes[indexPath.section].newsImageUrl_4 ?? "",
                    newsImageUrl_5: newNotes[indexPath.section].newsImageUrl_5 ?? "")
        
        
//        cell.backgroundColor = UIColor.white
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7  //тут проблема, что ячейка в плотную к стенкам и разделителям, соответственно тень просто не видна
//        cell.clipsToBounds = true
        
        return cell
       }
    
    
    //такой хитрый способ, чтоб можно было как бы нажать на изображение, у нас прозрачная кнопка как бы поверх изображения
    @IBAction func imagePressed(_ sender: UIButton) {
        if let indexPath = newsTableView.indexPath(forItem: sender) {indexPathForSegue = indexPath}
    }
    
    
    //чтоб вернуть из окна с добавлением изображения
    @IBAction func backToNewsViewController(_ segue: UIStoryboardSegue) {
        //segue.source это откуда выполняется переход
        guard segue.source is AddNewsViewController else {return}
        
        //так бы выглядело если бы addNewsViewController дальше бы использовался
        //guard let addNewsViewController = segue.source as? AddNewsViewController else {return}
        
        
        //sliderValueLabel.text = "\(Int(addNewsViewController.slider.value))"
        //это пример как можно было бы передать данные обратно
    }
    
    
    func openDialogWindow(indexPath: IndexPath) {
        let ac = UIAlertController(title: "", message: "Отредактировать новостную запись?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let destVC = storyboard.instantiateViewController(identifier: "AddNewsViewController") as? AddNewsViewController else { return }
            destVC.titleForEditing = self.newNotes[indexPath.section].newsTitle ?? "newsTitle"
            destVC.descriptionForEditing = self.newNotes[indexPath.section].newsDescription ?? "newsDescription"
            destVC.timeForEditing = self.newNotes[indexPath.section].newsTime ?? "newsTime"
            destVC.dataForEditing = self.newNotes[indexPath.section].newsData ?? "newsData"
            destVC.idForEditing = self.newNotes[indexPath.section].newsID ?? ""
            
            destVC.newsImageUrl_1 = self.newNotes[indexPath.section].newsImageUrl_1 ?? ""
            destVC.newsImageUrl_2 = self.newNotes[indexPath.section].newsImageUrl_2 ?? ""
            destVC.newsImageUrl_3 = self.newNotes[indexPath.section].newsImageUrl_3 ?? ""
            destVC.newsImageUrl_4 = self.newNotes[indexPath.section].newsImageUrl_4 ?? ""
            destVC.newsImageUrl_5 = self.newNotes[indexPath.section].newsImageUrl_5 ?? ""
            
            self.show(destVC, sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
        }
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true)
    }
    
    
    
    //переход по нажатию на изображение
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "showImagesForNews" else {return} //в кавычках это идентификатор перехода
        guard let destVC = segue.destination as? ImagesViewController else {return}
        destVC.newsImageUrl_1 = newNotes[indexPathForSegue.section].newsImageUrl_1
        destVC.newsImageUrl_2 = newNotes[indexPathForSegue.section].newsImageUrl_2
        destVC.newsImageUrl_3 = newNotes[indexPathForSegue.section].newsImageUrl_3
        destVC.newsImageUrl_4 = newNotes[indexPathForSegue.section].newsImageUrl_4
        destVC.newsImageUrl_5 = newNotes[indexPathForSegue.section].newsImageUrl_5
    }
    
}






extension UITableView { //расширение,чтобы мы могли узнавать indexPath той ячейки, на которую нажали в методе imagePressed
func indexPath(forItem: AnyObject) -> IndexPath? {
    let itemPosition: CGPoint = forItem.convert(CGPoint.zero, to: self)
    return self.indexPathForRow(at: itemPosition)
}}


