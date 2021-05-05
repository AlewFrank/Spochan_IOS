//
//  competitionService.swift
//  SpochanSecondVersion
//
//  Created by Admin on 13.04.2021.
//

import Foundation
import FirebaseFirestore

//Service – это компонент приложения, который используется для выполнения долгих фоновых операций без взаимодействия с пользователем. Любой компонент приложения может запустить сервис, который продолжит работу, даже если пользователь перейдет в другое приложение.

class competitionService {
    let database = Firestore.firestore()

    func get(collectionID: String, handler: @escaping ([appCompetition]) -> Void) {
        database.collection("CompetitionsRussia")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(appCompetition.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}
