//
//  PriceTagService.swift
//  shellme
//
//  Created by 斉藤祐大 on 2025/02/21.
//

import Foundation
import ArkanaKeys
import Network

struct PriceTagResponse: Codable {
    let name: String
    let price: Double
}

struct BoundingBox: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double
}

struct TextItem: Codable {
    let text: String
    let boundingBox: BoundingBox

    enum CodingKeys: String, CodingKey {
        case text
        case boundingBox = "bounding_box"
    }
}

struct PriceTagRequest: Codable {
    let items: [TextItem]
}

enum PriceTagServiceError: LocalizedError {
    case offline
    case invalidResponse
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .offline:
            return "オフラインなので使えない"
        case .invalidResponse:
            return "無効なレスポンスです"
        case .serverError(let message):
            return "サーバーエラー: \(message)"
        }
    }
}

final class PriceTagService: Sendable {
    #if DEBUG
    private let baseURL = Keys.Debug().bASE_URL
    #else
    private let baseURL = Keys.Release().bASE_URL
    #endif

    func parsePriceTag(items: [TextItem]) async throws -> PriceTagResponse {
        guard let url = URL(string: "\(baseURL)/api/parse-price-tag") else {
            throw URLError(.badURL)
        }

        // ネットワーク接続確認
        guard await isNetworkAvailable() else {
            throw PriceTagServiceError.offline
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = PriceTagRequest(items: items)
        request.httpBody = try JSONEncoder().encode(requestBody)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw PriceTagServiceError.invalidResponse
            }

            guard httpResponse.statusCode == 200 else {
                throw PriceTagServiceError.serverError("ステータスコード: \(httpResponse.statusCode)")
            }

            let priceTagResponse = try JSONDecoder().decode(PriceTagResponse.self, from: data)
            return priceTagResponse

        } catch {
            throw PriceTagServiceError.serverError(error.localizedDescription)
        }
    }

    private func isNetworkAvailable() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                monitor.cancel()
                continuation.resume(returning: path.status == .satisfied)
            }
            monitor.start(queue: DispatchQueue.global())
        }
    }
}
