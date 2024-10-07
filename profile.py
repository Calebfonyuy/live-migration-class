# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
# Import the Emulab specific extensions.
import geni.rspec.emulab as emulab

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()

osImage = 'urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU22-64-STD'

clientTypes = ['r320', 'r320', 'c6220']

ip_count = 1
ifaces = []

for c_type in clientTypes:
    nfsClient = request.RawPC(c_type + "_node-"+str(ip_count))
    nfsClient.disk_image = osImage
    nfsClient.hardware_type = c_type
    nfsClient.routable_control_ip = True
    c_iface = nfsClient.addInterface('interface-'+str(ip_count+1), pg.IPv4Address('192.168.6.'+str(ip_count),'255.255.255.0'))
    ifaces.append(c_iface)
    nfsClient.addService(pg.Execute(shell="sh", command="sudo /bin/bash /local/repository/install_xen.sh"))
    ip_count = ip_count + 1


# The NFS network. All these options are required.
nfsLan = request.LAN("live-migration-lan")
# Must provide a bandwidth. BW is in Kbps
nfsLan.bandwidth         = 100000
nfsLan.best_effort       = True
nfsLan.vlan_tagging      = True
nfsLan.link_multiplexing = True
for iface in ifaces:
    nfsLan.addInterface(iface)

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)