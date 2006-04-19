From: "Karl Schricker" <k_schricker@gmx.net>
Subject: Raid5 says it's rebuilding, but it lies :)
Date: Wed, 19 Apr 2006 03:04:17 +0200 (MEST)
Message-ID: <13525.1145408657@www047.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a raid5 configuration with 4 disks, of which all were active.  My
system froze due to a separate issue (firewire), so I had to power cycle. 
In the past, I've always been able to recover with fsck on /dev/md0, however
this time I was not, and I am unable to re-assemble the array now.

I'm really hoping someone can help me with this.  I've been googling and
reading the mdadm manpage for 3 days and getting nowhere.

After booting, I get 3 active disks and one faulty.  Theoretically with
raid5 I should be able to recover from this, right? :)  When I add it back
to the array, it changes to "spare rebuilding".  However it lies: no Rebuild
Status ever shows up (and I let it run overnight).

Here are the vitals:

# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sun Mar 12 13:07:20 2006
     Raid Level : raid5
    Device Size : 244198464 (232.89 GiB 250.06 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Apr 16 18:28:44 2006
          State : active, degraded
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : f4bc2cef:bacf1707:b5a00571:7384b969
         Events : 0.400844

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      spare rebuilding   /dev/sdc
       3       8       48        3      active sync   /dev/sdd

# cat /proc/mdstat
Personalities : [raid5]
md0 : inactive sdc[2] sda[0] sdd[3] sdb[1]
      976793856 blocks
unused devices: <none>

# mdadm --run /dev/md0
mdadm: failed to run array /dev/md0: Invalid argument

# cat /etc/mdadm.conf
DEVICE /dev/sda /dev/sdb /dev/sdc /dev/sdd
ARRAY /dev/md0 level=raid5 num-devices=4
UUID=f4bc2cef:bacf1707:b5a00571:7384b969

Log entries during reboot:

Apr 16 18:59:46 pingo kernel: md: md0 stopped.
Apr 16 18:59:46 pingo kernel: md: bind<sdb>
Apr 16 18:59:46 pingo kernel: md: bind<sdc>
Apr 16 18:59:46 pingo kernel: md: bind<sdd>
Apr 16 18:59:46 pingo kernel: md: bind<sda>
Apr 16 18:59:46 pingo kernel: md: kicking non-fresh sdc from array!
Apr 16 18:59:46 pingo kernel: md: unbind<sdc>
Apr 16 18:59:46 pingo kernel: md: export_rdev(sdc)
Apr 16 18:59:46 pingo kernel: md: md0: raid array is not clean -- starting
backg
round reconstruction
Apr 16 18:59:46 pingo kernel: raid5: automatically using best checksumming
funct
ion: pIII_sse
Apr 16 18:59:46 pingo kernel:    pIII_sse  :  4480.000 MB/sec
Apr 16 18:59:46 pingo kernel: raid5: using function: pIII_sse (4480.000
MB/sec)
Apr 16 18:59:46 pingo kernel: md: raid5 personality registered as nr 4
Apr 16 18:59:46 pingo kernel: raid5: device sda operational as raid disk 0
Apr 16 18:59:46 pingo kernel: raid5: device sdd operational as raid disk 3
Apr 16 18:59:46 pingo kernel: raid5: device sdb operational as raid disk 1
Apr 16 18:59:46 pingo kernel: raid5: cannot start dirty degraded array for
md0
Apr 16 18:59:46 pingo kernel: RAID5 conf printout:
Apr 16 18:59:46 pingo kernel:  --- rd:4 wd:3 fd:1
Apr 16 18:59:46 pingo kernel:  disk 0, o:1, dev:sda
Apr 16 18:59:46 pingo kernel:  disk 1, o:1, dev:sdb
Apr 16 18:59:46 pingo kernel:  disk 3, o:1, dev:sdd
Apr 16 18:59:46 pingo kernel: raid5: failed to run raid set md0
Apr 16 18:59:46 pingo kernel: md: pers->run() failed ...

-- 
Echte DSL-Flatrate dauerhaft für 0,- Euro*!
"Feel free" mit GMX DSL! http://www.gmx.net/de/go/dsl
