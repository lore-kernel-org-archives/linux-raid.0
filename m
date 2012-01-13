From: Tomasz Chmielewski <tch@wpkg.org>
Subject: not able to resize/grow RAID-1 (beyond 1 TB?)
Date: Fri, 13 Jan 2012 21:35:02 +0100
Message-ID: <4F109576.5090604@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have mdadm RAID-1 array which is 1 TB big.

I would like to increase it to ~3 TB, since this is what the new 
partition size is - however, mdadm doesn't want to do it and stays with 
the old size.

Here, mdadm -D output showing the array is 1024 GB:

# mdadm -D /dev/md2
/dev/md2:
         Version : 1.2
   Creation Time : Fri Jan 13 07:02:29 2012
      Raid Level : raid1
      Array Size : 1073740800 (1024.00 GiB 1099.51 GB)
   Used Dev Size : 1073740800 (1024.00 GiB 1099.51 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Fri Jan 13 21:25:09 2012
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : rescue:2
            UUID : 9fc28b3f:7b91d523:8aa20629:5f5bd029
          Events : 6699

     Number   Major   Minor   RaidDevice State
        0       8        3        0      active sync   /dev/sda3
        1       8       19        1      active sync   /dev/sdb3


Here, we can see the partitions used by /dev/md2 are ~3 TB big:

# parted /dev/sda
GNU Parted 2.3
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: ATA ST3000DM001-9YN1 (scsi)
Disk /dev/sda: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  5      1049kB  2097kB  1049kB                     bios_grub
  1      2097kB  34.4GB  34.4GB                     raid
  2      34.4GB  34.9GB  537MB                      raid
  3      34.9GB  3001GB  2966GB                     raid

(parted) q

# parted /dev/sdb
GNU Parted 2.3
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: ATA ST3000DM001-9YN1 (scsi)
Disk /dev/sdb: 3001GB
Sector size (logical/physical): 512B/4096B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  5      1049kB  2097kB  1049kB                     bios_grub
  1      2097kB  34.4GB  34.4GB                     raid
  2      34.4GB  34.9GB  537MB                      raid
  3      34.9GB  3001GB  2966GB                     raid

(parted) q



Now, let's try to grow - it stays unchanged at 1024 GB:

# mdadm --grow /dev/md2 --size=max
mdadm: component size of /dev/md2 has been set to 1073740800K


What am I doing wrong here?


-- 
Tomasz Chmielewski
http://wpkg.org
