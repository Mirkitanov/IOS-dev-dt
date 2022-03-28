//
//  Data+JSONPrettyPrint.swift
//  Navigation
//
//  Created by Админ on 28.03.2022.
//  Copyright © 2022 Artem Novichkov. All rights reserved.
//

import Foundation

extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }

        return prettyPrintedString
    }
}
