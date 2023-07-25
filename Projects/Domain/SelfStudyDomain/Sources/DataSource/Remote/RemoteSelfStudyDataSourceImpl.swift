import SelfStudyDomainInterface
import NetworkingInterface

final class RemoteSelfStudyDataSourceImpl: RemoteSelfStudyDataSource {
    private let networking: any Networking

    init(networking: any Networking) {
        self.networking = networking
    }

    func fetchSelfStudyInfo() async throws -> SelfStudyInfoEntity {
        try await networking.request(
            SelfStudyEndpoint.fetchSelfStudyInfo,
            dto: FetchSelfStudyInfoResponseDTO.self
        )
        .toDomain()
    }

    func applySelfStudy() async throws {
        try await networking.request(SelfStudyEndpoint.applySelfStudy)
    }
}
