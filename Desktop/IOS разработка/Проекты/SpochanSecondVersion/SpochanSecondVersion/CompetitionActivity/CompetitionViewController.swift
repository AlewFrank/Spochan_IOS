//
//  CompetitionViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 25.03.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CompetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var competitionTableView: UITableView!
    
    let db = Firestore.firestore()
    
    var indexPathForSegue: IndexPath = []
    
    var isDirector: Bool = false
    
    private var service: competitionService?
       private var allcompetitions = [appCompetition]() {
           didSet {
               DispatchQueue.main.async {
                   self.newcompetitions = self.allcompetitions
               }
           }
       }
       
       var newcompetitions = [appCompetition]() {
           didSet {
               DispatchQueue.main.async {
                   self.competitionTableView.reloadData()
               }
           }
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //скрываем, чтоб изначально обычному случайно не включились лишние возможности редактирования фоток
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        competitionTableView.dataSource = self
        competitionTableView.delegate = self
        
        loadData()//загружаем данные из интернета, но пока что никуда не вставляем
        competitionTableView.reloadData()//обновляем отображение страницы, чтоб если как-то хитро изменился массив, то все работало, если допустим удалим новость, когда у какогото пользователя будет открыто приложение
        
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
            service = competitionService()
            service?.get(collectionID: "CompetitionsRussia") { newcompetitions in
                self.allcompetitions = newcompetitions
            }
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newcompetitions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1 //в каждой секции один элемент, чтоб был пропуск между картами
        //return newNotes.count
    }
    
    // расстояние между секциями
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
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
        tableView.deselectRow(at: indexPath, animated: false)//выделение сразу же снимается, чтоб не так, что выбрал один раз и она теперь вечно подсвечивается
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destVC = storyboard.instantiateViewController(identifier: "FullCompetitionInfoViewController") as? FullCompetitionInfoViewController else { return }
        
        destVC.competitionId = newcompetitions[indexPath.section].competitionId ?? "competitionId"
        destVC.competitionTitle = newcompetitions[indexPath.section].competitionTitle ?? "competitionTitle"
        destVC.competitionDescription = newcompetitions[indexPath.section].competitionDescription ?? "competitionDescription"
        destVC.competitionLocation = newcompetitions[indexPath.section].competitionLocation ?? "competitionLocation"
        destVC.competitionAddress = newcompetitions[indexPath.section].competitionAddress ?? "competitionAddress"
        destVC.competitionImageUrl = newcompetitions[indexPath.section].competitionImageUrl ?? "competitionImageUrl"
        
        let daysCompetitionDate = newcompetitions[indexPath.section].daysCompetitionDate ?? "00"
        let monthCompetitionDate = newcompetitions[indexPath.section].monthCompetitionDate ?? "00"
        let yearCompetitionDate = newcompetitions[indexPath.section].yearCompetitionDate ?? "00"
        
        destVC.daysCompetitionDate = newcompetitions[indexPath.section].daysCompetitionDate ?? "00"
        destVC.monthCompetitionDate = newcompetitions[indexPath.section].monthCompetitionDate ?? "00"
        destVC.yearCompetitionDate = newcompetitions[indexPath.section].yearCompetitionDate ?? "00"
        
        destVC.competitionDate = daysCompetitionDate + "." + monthCompetitionDate + "." + yearCompetitionDate
        
        self.show(destVC, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionTableViewCell", for: indexPath) as! CompetitionTableViewCell
        
        cell.update(competitionTitle: newcompetitions[indexPath.section].competitionTitle ?? "competitionTitle",
                    competitionDescription: newcompetitions[indexPath.section].competitionDescription ?? "competitionDescription",
                    competitionLocation: newcompetitions[indexPath.section].competitionLocation ?? "competitionLocation",
                    competitionAddress: newcompetitions[indexPath.section].competitionAddress ?? "competitionAddress",
                    competitionImageUrl: newcompetitions[indexPath.section].competitionImageUrl ?? "competitionImageUrl",
                    daysCompetitionDate: newcompetitions[indexPath.section].daysCompetitionDate ?? "00",
                    monthCompetitionDate: newcompetitions[indexPath.section].monthCompetitionDate ?? "00",
                    yearCompetitionDate: newcompetitions[indexPath.section].yearCompetitionDate ?? "00")
        
        
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
    
    
    //чтоб вернуть из окна с добавлением изображения
    @IBAction func backToCompetitionViewController(_ segue: UIStoryboardSegue) {
        //segue.source это откуда выполняется переход
        guard segue.source is AddCompetitionViewController else {return}
        
        //так бы выглядело если бы addNewsViewController дальше бы использовался
        //guard let addNewsViewController = segue.source as? AddNewsViewController else {return}
        
        
        //sliderValueLabel.text = "\(Int(addNewsViewController.slider.value))"
        //это пример как можно было бы передать данные обратно
    }

}
