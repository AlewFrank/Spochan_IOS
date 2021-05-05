//
//  userService.swift
//  SpochanSecondVersion
//
//  Created by Admin on 20.03.2021.
//

import Foundation
import FirebaseFirestore

//Service – это компонент приложения, который используется для выполнения долгих фоновых операций без взаимодействия с пользователем. Любой компонент приложения может запустить сервис, который продолжит работу, даже если пользователь перейдет в другое приложение.

class NewService {
    let database = Firestore.firestore()

    func get(collectionID: String, handler: @escaping ([appNew]) -> Void) {
        database.collection("NewsRussia")
            .addSnapshotListener { querySnapshot, err in
                if let error = err {
                    print(error)
                    handler([])
                } else {
                    handler(appNew.build(from: querySnapshot?.documents ?? []))
                }
            }
    }
}
