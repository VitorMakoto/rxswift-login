//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import Argo

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

        let decodedStatus: Decoded<String> = json <| Keys.responseStatus
        let decodedResults: Decoded<JSON> = json <| Keys.responseResults

        guard let status = decodedStatus.value else {
            return Result.failure(APIError.unableToParseStatus)
        }

        if status != Values.responseOkStatusValue {
            return onStatusErrorHandler(status)
        }

        guard let results = decodedResults.value else {
            return Result.failure(APIError.unableToParseResults)
        }

        switch results {
        case .array(let resultsJsons):
            let resultsItems = resultsJsons.flatMap { resultJson -> ResultsItem? in
                let decodedType: Decoded<String> = resultJson <| Keys.responseResultsType
                let decodedData: Decoded<JSON> = resultJson <| Keys.responseResultsData

                guard let type = decodedType.value,
                    let data = decodedData.value,
                    let resultItemType = ResultsItemType(rawValue: type) else {
                        return nil
                }

                return resultItemType.resultItem(json: data)
            }

            return Result.success(resultsItems)
        case .object, .string, .number, .bool, .null:
            return Result.failure(APIError.unableToParse)
        }
    }
}
