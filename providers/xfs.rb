action :create do

  # settings 
  mount_point = new_resource.mount_point
  fstype = new_resource.fstype 
  raise "Only fstype == 'xfs' is supported with this provider" unless fstype == "xfs"
  volume_label = new_resource.volume_label
  device = new_resource.device
  partition_number = new_resource.partition_number
  
  # misc variable mutation
  device_path = "/dev/#{device}"
  partition = "#{device}#{partition_number}"
  partition_path = "/dev/#{partition}"

  # install xfs utils (if needed)
  package "xfsprogs" 
  package "xfsdump"

  # create a single partition on the device
  bash "partition device #{device_path}" do
    code <<-EOF    
    sbin/fdisk #{device_path} << EOF
o
n
p
1


w
    EOF
    not_if "/bin/grep #{partition} /proc/partitions" 
  end
  
  # format the parition
  execute "mkfs.xfs #{partition_path}" do
    not_if "mount | grep #{partition}"
  end
  
  # make sure mount point exists
  directory mount_point
  
  # wait for filesystem to be ready
  execute "sleep 60"
  
  # mount filesystem and add to fstab
  mount mount_point do
    device partition_path
    fstype fstype
    options "uquota"
    action [:mount, :enable]
  end
  

end
