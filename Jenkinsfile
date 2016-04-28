properties(
  [ [$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', daysToKeepStr: '30'] ]
  , [$class: 'GithubProjectProperty', projectUrlStr: 'http://github.com/lstephen/docker-docker-push']
  ])

def construi(target) {
  wrap([$class: 'AnsiColorBuildWrapper', colorMapName: 'xterm']) {
    sh "construi ${target}"
  }
}

node('construi') {
  stage 'Checkout'
  checkout scm
  sh "git checkout ${env.BRANCH_NAME}"

  stage 'Build'
  construi 'build'
}

if (env.BRANCH_NAME == 'master') {
  node('construi') {
    stage 'Release'

    construi 'versiune'
    currentBuild.description = "Release v${readFile('VERSION')}"

    withCredentials(
      [
        [ $class: 'UsernamePasswordMultiBinding'
        , usernameVariable: 'DOCKER_PUSH_USERNAME'
        , passwordVariable: 'DOCKER_PUSH_PASSWORD'
        , credentialsId: 'c61346cf-aca8-4ae6-bee8-e8ccf02eaa12'
        ]
      , [ $class: 'FileBinding'
        , variable: 'GIT_SSH_KEY'
        , credentialsId: 'cfbecb37-737f-4597-86f7-43fb2d3322cc' ]
      ]) {
        construi 'release'
        currentBuild.description = new File('VERSION').text
    }
  }
}

