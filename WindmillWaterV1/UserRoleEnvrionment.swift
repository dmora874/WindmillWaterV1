import SwiftUI

struct UserRoleKey: EnvironmentKey {
    static let defaultValue: UserRole? = nil
}

extension EnvironmentValues {
    var userRole: UserRole? {
        get { self[UserRoleKey.self] }
        set { self[UserRoleKey.self] = newValue }
    }
}
