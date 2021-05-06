//
//  TWMNSTError.swift
//  ImageProcessing
//
//  Created by StuTan on 2021/5/5.
//

import Foundation

public enum TWMNSTError : Error {
    case unknown
    case assetPathError
    case modelError
    case resizeError
    case pixelBufferError
    case predictionError
}

extension TWMNSTError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .assetPathError:
            return "Model file not found"
        case .modelError:
            return "Model error"
        case .resizeError:
            return "Resizing failed"
        case .pixelBufferError:
            return "Pixel Buffer conversion failed"
        case .predictionError:
            return "CoreML prediction failed"
        }
    }
}
