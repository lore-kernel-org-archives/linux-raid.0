From: vherva@turing.netspan.fi
Subject: 3-disk RAID1 - only two disks active
Date: Tue, 15 Nov 2005 15:26:22 +0200
Message-ID: <20051115152622.A2237@turing.netspan.fi>
Reply-To: linux-raid@vger.kernel.org, vherva@turing.netspan.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had two disks taken off from the three-disk raid set (hda,hdb,hdc - hdc
failed by itself, hdb was marked bad with raidsetfaulty). When the new disks
were added back to the set (with raidhotadd), only two of them became active
and one remained as a hot spare.

I there a way to reconfigure all three to become active again?

This is kernel 2.4.32-rc1.

> cat /proc/mdstat
Personalities : [raid1]
read_ahead 1024 sectors
md1 : active raid1 hdb1[2] hdc1[1] hda1[0]
      102720 blocks [2/2] [UU]

md2 : active raid1 hdb2[2] hdc2[1] hda2[0]
      1024064 blocks [2/2] [UU]

md3 : active raid1 hdb3[2] hdc3[1] hda3[0]
      37955648 blocks [2/2] [UU]

unused devices: <none>

> mdadm --detail /dev/md1
/dev/md1:
        Version : 00.90.00
  Creation Time : Fri May 10 13:42:55 2002
     Raid Level : raid1
     Array Size : 102720 (100.33 MiB 105.19 MB)
    Device Size : 102720 (100.33 MiB 105.19 MB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Nov 14 23:17:03 2005
          State : active
 Active Devices : 2
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 1
           
           UUID : d3f91d5b:5587896d:982609b1:c6a3e584
         Events : 0.191
    
    Number   Major   Minor   RaidDevice State
       0       3        1        0      active sync   /dev/hda1
       1      22        1        1      active sync   /dev/hdc1
       
       2       3       65        2      spare   /dev/hdb1


> cat /etc/raidtab
raiddev             /dev/md3
raid-level                  1
nr-raid-disks               3
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda3
    raid-disk     0
    device          /dev/hdb3
    raid-disk     1
    device          /dev/hdc3
    raid-disk     2
raiddev             /dev/md2
raid-level                  1
nr-raid-disks               3
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda2
    raid-disk     0
    device          /dev/hdb2
    raid-disk     1
    device          /dev/hdc2
    raid-disk     2
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               3
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hda1
    raid-disk     0
    device          /dev/hdb1
    raid-disk     1
    device          /dev/hdc1
    raid-disk     2
