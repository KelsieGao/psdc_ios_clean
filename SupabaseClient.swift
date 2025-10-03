import Foundation
import Supabase

class SupabaseClient {
    static let shared = SupabaseClient()

    let client: SupabaseClient

    private init() {
        guard let supabaseURL = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
              let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
              let url = URL(string: supabaseURL) else {
            fatalError("Missing Supabase configuration in Info.plist")
        }

        client = SupabaseClient(supabaseURL: url, supabaseKey: supabaseKey)
    }

    func insertHeartRateData(_ data: [String: Any]) async throws {
        let heartRateData: [String: Any] = [
            "device_id": data["device"] as? String ?? "",
            "heart_rate": data["hr"] as? Int ?? 0,
            "rr_interval": data["rr"] as? Int ?? 0,
            "rr_available": data["rrAvailable"] as? Bool ?? false,
            "contact_status": data["contactStatus"] as? Bool ?? false,
            "contact_status_supported": data["contactStatusSupported"] as? Bool ?? false,
            "timestamp": data["timestamp"] as? Int64 ?? 0
        ]

        try await client
            .from("heart_rate_data")
            .insert(heartRateData)
            .execute()
    }

    func insertAccelerometerData(_ data: [String: Any]) async throws {
        let accData: [String: Any] = [
            "device_id": data["deviceId"] as? String ?? "",
            "user_id": data["userId"] as? String ?? "demo-user",
            "x": data["x"] as? Int ?? 0,
            "y": data["y"] as? Int ?? 0,
            "z": data["z"] as? Int ?? 0,
            "timestamp": data["timestamp"] as? Int64 ?? 0
        ]

        try await client
            .from("accelerometer_data")
            .insert(accData)
            .execute()
    }
}
