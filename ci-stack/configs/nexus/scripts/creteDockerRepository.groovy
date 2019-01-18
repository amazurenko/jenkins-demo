import groovy.json.JsonSlurper
import org.sonatype.nexus.repository.config.Configuration

//parsed_args = new JsonSlurper().parseText(args)

configuration = new Configuration(
        repositoryName: 'demo-registry',
        recipeName: 'docker-hosted',
        online: true,
        attributes: [
                docker: [
                        httpPort: '8085',
                        v1Enabled : true
                ],
                storage: [
                        writePolicy: 'ALLOW',
                        blobStoreName: 'default',
                        strictContentTypeValidation: true
                ]
        ]
)

def existingRepository = repository.getRepositoryManager().get('demo-registry')

if (existingRepository != null) {
    existingRepository.stop()
    configuration.attributes['storage']['blobStoreName'] = existingRepository.configuration.attributes['storage']['blobStoreName']
    existingRepository.update(configuration)
    existingRepository.start()
} else {
    repository.getRepositoryManager().create(configuration)
}
