//
//  userFirebase.swift
//  SpochanSecondVersion
//
//  Created by Admin on 20.03.2021.
//

import Foundation
import FirebaseFirestore

//ЗАБИРАЕМ ДАННЫЕ ИЗ БАЗЫ ДАННЫХ

extension appNew {
    static func build(from documents: [QueryDocumentSnapshot]) -> [appNew] {
        var appNews = [appNew]()
        for document in documents {
            appNews.append(appNew(newsID: document["newsId"] as? String ?? "",
                                  newsTitle: document["newsTitle"] as? String ?? "",
                                  newsDescription: document["newsDescription"] as? String ?? "",
                                  newsData: document["newsData"] as? String ?? "",
                                  newsTime: document["newsTime"] as? String ?? "",
                                  newsImageUrl_1: document["newsImageUrl_1"] as? String ?? "",
                                  newsImageUrl_2: document["newsImageUrl_2"] as? String ?? "",
                                  newsImageUrl_3: document["newsImageUrl_3"] as? String ?? "",
                                  newsImageUrl_4: document["newsImageUrl_4"] as? String ?? "",
                                  newsImageUrl_5: document["newsImageUrl_5"] as? String ?? "",
                                  previousImageIndex: 0,
                                  nextImageIndex: 2))
        }
        return appNews
    }
}
