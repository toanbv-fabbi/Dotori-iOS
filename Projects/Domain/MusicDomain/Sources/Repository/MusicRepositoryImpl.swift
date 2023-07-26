import MusicDomainInterface

final class MusicRepositoryImpl: MusicRepository {
    private let remoteMusicDataSource: any RemoteMusicDataSource

    init(remoteMusicDataSource: any RemoteMusicDataSource) {
        self.remoteMusicDataSource = remoteMusicDataSource
    }

    func fetchMusicList() async throws -> [MusicEntity] {
        try await remoteMusicDataSource.fetchMusicList()
    }
}
