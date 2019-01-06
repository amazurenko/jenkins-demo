import org.jenkinsci.plugins.docker.commons.tools.*
import hudson.tools.InstallSourceProperty;
import hudson.tools.ToolProperty;
import hudson.tools.ToolPropertyDescriptor;
import hudson.util.DescribableList;

def dockerDesc = jenkins.model.Jenkins.instance.getExtensionList(org.jenkinsci.plugins.docker.commons.tools.DockerTool.DescriptorImpl.class)[0]

def isp = new InstallSourceProperty()
def autoInstaller = new org.jenkinsci.plugins.docker.commons.tools.DockerToolInstaller("","latest")
isp.installers.add(autoInstaller)

def proplist = new DescribableList<ToolProperty<?>, ToolPropertyDescriptor>()
proplist.add(isp)

def installation = new DockerTool("dockerTool", "", proplist)

dockerDesc.setInstallations(installation)
dockerDesc.save()