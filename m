From: Jesse Burkhardt <jesse@skybuilders.com>
Subject: Fedora 2.0 - raid1 not working
Date: Tue, 09 Nov 2004 14:08:22 -0500
Message-ID: <419115A5.4050905@skybuilders.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am new to raid installations. I have installed Fedora 2.0 onto a 
system with two identical drives that I configured to be a raid1 mirror 
through the disk druid interface. I created partition mirrors for both 
the /boot partition (md0) and the / partition (md1). Then I created same 
sized, non-mirrored swap partitions on each of the identical drives. 
After the installation process, I found that I could boot with both 
physical drives online and only one of the two physical drives when 
booting in a single drive (failure simulation) mode.

I am wondering if there is a required kernel module that is not loaded 
or compiled into the default Fedora 2.6 kernel.

When I look into the process list I see processes called md0_raid and 
md1_raid. I did not run the raidstart command but assume that it 
probably has been run.

Also here are a few raid file listings:

/etc/raidtab

raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  256
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda3
    raid-disk     0
    device          /dev/hdd3
    raid-disk     1
raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  256
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda1
    raid-disk     0
    device          /dev/hdd1
    raid-disk     1

And /proc/mdstat

Personalities : [raid1]
md1 : active raid1 hda3[0]
      242958848 blocks [2/1] [U_]

md0 : active raid1 hda1[0]
      104192 blocks [2/1] [U_]

unused devices: <none>


Thanks for any help.
-- 

Jesse Burkhardt, Cambridge MA
jesse@skybuilders.com (w) 617-876-5680
aerogoose.com (h) 617-354-5523
