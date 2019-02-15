#
# Description: This method is used to Customize the RHEV, RHEV PXE, and RHEV ISO Provisioning Request
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Get provisioning object
prov = $evm.root["miq_provision"]

$evm.log("info", "Provisioning ID:<#{prov.id}> Provision Request ID:<#{prov.miq_provision_request.id}> Provision Type: <#{prov.provision_type}>")

dialog_vm_name = prov.get_option(:dialog_vm_name)
if not dialog_vm_name.nil?
  $evm.log("info", "Setting VM Name to: #{dialog_vm_name}")
  prov.set_option(:vm_target_name,dialog_vm_name)
end


tshirtsize = prov.get_option(:dialog_tshirtsize)
vm_memory = prov.get_option(:dialog_vm_memory)
vm_cores = prov.get_option(:dialog_vm_cores)

case tshirtsize
  when "S"
    prov.set_option(:vm_memory,2048)
    prov.set_option(:cores_per_socket,1)
    $evm.log("info","T-Shirt Size Small: 1 Cores, 2 GB RAM")
  
  when "M"
    prov.set_option(:vm_memory,4096)
    prov.set_option(:cores_per_socket,2)
    $evm.log("info","T-Shirt Size Medium: 2 Cores, 4 GB RAM")

  when "L"
    prov.set_option(:vm_memory,4096)
    prov.set_option(:cores_per_socket,4)
    $evm.log("info","T-Shirt Size Large: 4 Cores, 4 GB RAM")
  
  when "XL"
    prov.set_option(:vm_memory,8192)
    prov.set_option(:cores_per_socket,4)
    $evm.log("info","T-Shirt Size Extra Large: 4 Cores, 8 GB RAM")
end


# In here we´ll override T-Shirt info with values in extra tab if any
if vm_memory.to_i >0 
  prov.set_option(:vm_memory,vm_memory.to_i * 1024)
  $evm.log("info","T-Shirt #{tshirtsize} - Memory Override: #{vm_memory}")
end

if vm_cores.to_i > 0
  prov.set_option(:cores_per_socket, vm_cores.to_i)
  $evm.log("info","T-Shirt #{tshirtsize} - Cores Override: #{vm_cores}")
end


## Setting up Networking config overriding custom spec in VMware

#### This is not needed if in override section static conf has been selected
#addr_mode = prov.get_option(:dialog_addr_mode)
#if not addr_mode.nil?
#  $evm.log("info", "Setting IP Address Mode to: #{addr_mode}")
#  prov.set_option(:addr_mode,addr_mode)
#else
#    $evm.log("warn", "IP Address Mode unknown or not suministrated")
#end

ip_addr = prov.get_option(:dialog_ip_addr)
if not ip_addr.nil?
  $evm.log("info", "Setting IP Address to: #{ip_addr}")
  prov.set_option(:ip_addr,ip_addr)
else
    $evm.log("warn", "IP Address unknown or not suministrated")
end

subnet_mask = prov.get_option(:dialog_subnet_mask)
if not subnet_mask.nil?
  $evm.log("info", "Setting Subnet Mask to: #{subnet_mask}")
  prov.set_option(:subnet_mask,subnet_mask)
else
    $evm.log("warn", "Subnet Mask unknown or not suministrated")
end

gateway = prov.get_option(:dialog_gateway)
if not gateway.nil?
  $evm.log("info", "Setting Gateway to: #{gateway}")
  prov.set_option(:gateway,gateway)
else
    $evm.log("warn", "Gateway unknown or not suministrated")
end

prov.attributes.sort.each { |k,v| $evm.log("info","Prov attributes: #{v}: #{k}") }
