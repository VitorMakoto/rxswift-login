//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Result<Value> {
    case success(Value)
    case failure(Swift.Error)
}

enum APIError: Swift.Error {
    case unableToParseStatus
    case unableToParseResults
    case unableToParse
    case unknown
}

struct APIParser {
    private struct Keys {
        static let responseStatus = "status"
        static let responseResults = "results"
        static let responseResultsType = "type"
        static let responseResultsData = "data"
    }

    private struct Values {
        static let responseOkStatusValue = "OK"
    }

    static func parseResults(json: JSON, onStatusErrorHandler:
        (_ status: String) -> Result<[ResultsItem]>) -> Result<[ResultsItem]> {

        let decodedStatus = json[Keys.responseStatus].string
        let decodedResults = json[Keys.responseResults].array

        guard let status = decodedStatus else {
            return Result.failure(APIError.unableToParseStatus)
        }

        if status != Values.responseOkStatusValue {
            return onStatusErrorHandler(status)
        }

        guard let results = decodedResults else {
            return Result.failure(APIError.unableToParseResults)
        }

        let resultsItems = results.flatMap { resultJson -> ResultsItem? in
            let decodedType = resultJson[Keys.responseResultsType].string
            let decodedData = resultJson[Keys.responseResultsData]

            guard let type = decodedType,
                let resultItemType = ResultsItemType(rawValue: type) else {
                    return nil
            }

            return resultItemType.resultItem(json: decodedData)
        }

        return Result.success(resultsItems)
    }
}
