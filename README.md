# Description

Partitions, formats and mounts a filesystem.

# Requirements

Currently tested for Ubuntu 12.04

# Usage

Work in progress. Provides a filesystem LWRP. 
Take a look at the resources and providers directory

# Resources 

filesystem 
----------

- supports ext3 and ext4
- see providers/default.rb

Example of creating an ext4 filesystem on /dev/sdb1:

    filesystem "/mnt/persistent" do
      mount_point "/mnt/persistent"
      fstype "ext4"
      volume_label "data_volume"
      device "sdb"
      partition_number "1"
      action :create
    end


filesystem_xfs (providers/xfs.rb)
-----------------------------------

- supports xfs
- volume_label not supported yet
- see providers/xfs.rb


Example of creating an xfs filesystem on /dev/sdb1:

    filesystem "/mnt/persistent" do
      mount_point "/mnt/persistent"
      fstype "xfs"
      device "sdb"
      partition_number "1"
      provider "filesystem_xfs"  
      action :create
    en



# Limitations

- Currently creates a partition using the remaining space on device.
- many others


# Author

Author:: Cary Penniman<cpenniman_at-gmail-dot_com>
