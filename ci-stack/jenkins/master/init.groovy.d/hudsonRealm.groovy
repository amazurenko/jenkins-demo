import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*

import hudson.markup.RawHtmlMarkupFormatter
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.domains.*;
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;


global_domain = Domain.global()
credentials_store =
  Jenkins.instance.getExtensionList(
    'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
  )[0].getStore()

credentials = new BasicSSHUserPrivateKey(CredentialsScope.GLOBAL,null,"root",new BasicSSHUserPrivateKey.UsersPrivateKeySource(),"","")

credentials_store.addCredentials(global_domain, credentials)

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
def adminUsername = System.getenv('JENKINS_ADMIN_USERNAME') ?: 'admin'
def adminPassword = System.getenv('JENKINS_ADMIN_PASSWORD') ?: 'demoadmin'
hudsonRealm.createAccount(adminUsername, adminPassword)

def instance = Jenkins.getInstance()
instance.setSecurityRealm(hudsonRealm)
instance.save()

def strategy = new GlobalMatrixAuthorizationStrategy()

strategy.add(Jenkins.ADMINISTER, adminUsername)

//strategy.add(Jenkins.ADMINISTER, "amazurenko*{{ github_team_name }}")

Jenkins.instance.setAuthorizationStrategy(strategy)  
Jenkins.instance.setMarkupFormatter(new RawHtmlMarkupFormatter(false))

Jenkins.instance.save()
