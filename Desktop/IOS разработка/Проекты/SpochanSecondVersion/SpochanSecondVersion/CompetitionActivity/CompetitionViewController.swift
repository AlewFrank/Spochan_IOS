//
//  CompetitionViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 25.03.2021.
//

import UIKit

class CompetitionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var competitionTableView: UITableView!
    
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

        competitionTableView.dataSource = self
        competitionTableView.delegate = self
        
        loadData()//загружаем данные из интернета, но пока что никуда не вставляем
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
        tableView.deselectRow(at: indexPath, animated: false)//выделение сразу же снимается, чтоб не так, что выбрал один раз и она теперь вечно подсвечивается
        
        
        
        //переход делай так же, как и делали когда учились
        
        
        
        
        
        print("Ячейка выделяется")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompetitionTableViewCell", for: indexPath) as! CompetitionTableViewCell
        
        cell.update(competitionTitle: newcompetitions[indexPath.section].competitionTitle ?? "competitionTitle",
                    competitionDescription: newcompetitions[indexPath.section].competitionDescription ?? "competitionTitle",
                    competitionLocation: newcompetitions[indexPath.section].competitionLocation ?? "competitionTitle",
                    competitionAddress: newcompetitions[indexPath.section].competitionAddress ?? "competitionTitle",
                    competitionImageUrl: newcompetitions[indexPath.section].competitionImageUrl ?? "competitionTitle",
                    daysCompetitionDate: newcompetitions[indexPath.section].daysCompetitionDate ?? "competitionTitle",
                    monthCompetitionDate: newcompetitions[indexPath.section].monthCompetitionDate ?? "competitionTitle",
                    yearCompetitionDate: newcompetitions[indexPath.section].yearCompetitionDate ?? "competitionTitle")
        
        
        
        
    
        
        
//        cell.backgroundColor = UIColor.white
//        cell.layer.borderColor = UIColor.black.cgColor
//        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 15
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cell.layer.shadowRadius = 12.0
        cell.layer.shadowOpacity = 0.7  //тут проблема, что ячейка в плотную к стенкам и разделителям, соответственно тень просто не видна
//        cell.clipsToBounds = true
        
        return cell
       }
}
