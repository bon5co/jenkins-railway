import hudson.model.User
import jenkins.security.ApiTokenProperty

// Install the admin API token from JENKINS_API_TOKEN ("11" + 32 hex), once per value.
def raw = System.getenv('JENKINS_API_TOKEN')
if (!raw) {
    println 'api-token: JENKINS_API_TOKEN not set, skipping'
    return
}
if (!(raw ==~ /^11[0-9a-f]{32}$/)) {
    println 'api-token: JENKINS_API_TOKEN must be "11" followed by 32 lowercase hex characters, skipping'
    return
}
def user = User.getById('admin', true)
def prop = user.getProperty(ApiTokenProperty)
if (prop == null) {
    println 'api-token: admin has no ApiTokenProperty, skipping'
    return
}
def store = prop.tokenStore
if (store.findMatchingToken(raw) != null) {
    println 'api-token: token already present'
    return
}
store.addFixedNewToken('agent', raw, null)
user.save()
println 'api-token: installed token "agent" for admin'
