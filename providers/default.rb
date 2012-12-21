action :create do

  # settings 
  mount_point = new_resource.mount_point
  fstype = new_resource.fstype 
  volume_label = new_resource.volume_label
  device = new_resource.device
  partition_number = new_resource.partition_number
  
  # misc variable mutation
  device_path = "/dev/#{device}"
  partition = "#{device}#{partition_number}"
  partition_path = "/dev/#{partition}"

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
  bash "mkfs on #{partition_path}" do
    code <<-EOF
      /sbin/mkfs.#{fstype} -L #{volume_label} -b 4096 #{partition_path}
    EOF
    not_if "/sbin/dumpe2fs #{partition_path}"
  end
  
  # make sure mount point exists
  directory mount_point
  
  # mount filesystem and add to fstab
  mount mount_point do
    device partition_path
    fstype fstype
    action [:mount, :enable]
  end

end
