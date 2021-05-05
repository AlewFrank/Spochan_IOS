//
//  newCompetitionFirebase.swift
//  SpochanSecondVersion
//
//  Created by Admin on 13.04.2021.
//

import Foundation
import FirebaseFirestore

//ЗАБИРАЕМ ДАННЫЕ ИЗ БАЗЫ ДАННЫХ

extension appCompetition {
    static func build(from documents: [QueryDocumentSnapshot]) -> [appCompetition] {
        var appCompetitions = [appCompetition]()
        for document in documents {
            appCompetitions.append(appCompetition(competitionTitle: document["competitionTitle"] as? String ?? "",
                                                  competitionDescription: document["competitionDescription"] as? String ?? "",
                                                  competitionLocation: document["competitionLocation"] as? String ?? "",
                                                  competitionAddress: document["competitionAddress"] as? String ?? "",
                                                  competitionImageUrl: document["competitionImageUrl"] as? String ?? "",
                                                  daysCompetitionDate: document["daysCompetitionDate"] as? String ?? "",
                                                  monthCompetitionDate: document["monthCompetitionDate"] as? String ?? "",
                                                  yearCompetitionDate: document["yearCompetitionDate"] as? String ?? ""))
        }
        return appCompetitions
    }
}

