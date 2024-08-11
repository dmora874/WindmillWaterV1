import Foundation

class GoogleSheetsService {
    private let accessToken = "ya29.a0AcM612ylSq8_7laAKDt6tKdeIVZqyHKO9w2s_dG1nZSrquW_k_tTEI03JVXMSzIR7oxw5oRM1EXsSzVL7_Ogo5HTwn6i1x7XikFh2SUu5t8-Sn0mVR0rdE8bd3xCfqqiYgth35m6vxc5-eQ1l8xThFvCcCqMVCJdvTVSaCgYKAU0SARASFQHGX2MiZfbAyh2acpQEueB02nDL4A0171"  // Replace with your actual access token
    private let spreadsheetId = "1HZN8qFO4SSX2N7Spo5kUaMXh89WxNnEp_oykTiI9dIU"  // Replace with your spreadsheet ID
    private let range = "Customers!A2:H"  // Replace with the desired range (e.g., A2:E)

    func fetchCustomerData(completion: @escaping ([[String]]?) -> Void) {
        let urlString = "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching Google Sheet data: \(error)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data received from Google Sheets")
                completion(nil)
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let values = json["values"] as? [[String]] {
                    print("Fetched Google Sheet data: \(values)")
                    completion(values)
                } else {
                    print("Failed to parse Google Sheet data")
                    completion(nil)
                }
            } catch {
                print("JSON Parsing error: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
