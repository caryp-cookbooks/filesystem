actions :create

attribute :mount_point,       :default => "/mnt/persistent", :name_attribute => true
attribute :fstype,            :default => "ext3", :equal_to => ["ext3", "ext4", "xfs"]
attribute :volume_label,      :default => "data_volume"
attribute :device,            :default => "sdb"
attribute :partition_number,  :default => "1"  