From: Vijay Kumar <vijay@calsoftinc.com>
Subject: hadware raid [_U] issue.
Date: Wed, 24 Dec 2003 16:23:11 +0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1072261391.21554.125.camel@localhost.localdomain>
References: <20031224192810.1e79f5a3.ietf@2c9d1f3141b658e37c53395b25a04078.nosense.org>
Reply-To: vijay@calsoftinc.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031224192810.1e79f5a3.ietf@2c9d1f3141b658e37c53395b25a04078.nosense.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, 

I have a redhat box with Hardware Raid. Below ar ethe outputs of various
files/commands. Please let me know whether there is anything wrong.
I think there might be some problem in md0, but I am not very sure. 
Somone told me that since the box runs hardware the md-status does not
matter. What does the "[UU]" mean in mdstat ? In md0, one U is missing. 
What should I do next ?

Kindly help me. 
Regards, 
Vijay Kumar. 

Below is output of cat /prc/mdstat 

-------------------------------------------
Personalities : [raid1]
read_ahead 1024 sectors
md2 : active raid1 hdc5[0] hdd5[1]
      30716160 blocks [2/2] [UU]

md1 : active raid1 hdc3[0] hdd3[1]
      30716160 blocks [2/2] [UU]

md0 : active raid1 hdd2[1]
      93699008 blocks [2/1] [_U]

md3 : active raid1 hdc1[0] hdd1[1]
      104320 blocks [2/2] [UU]

unused devices: <none>
--------------------------------
Below is the output of /etc/raidtab

raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdc3
    raid-disk     0
    device          /dev/hdd3
    raid-disk     1
raiddev             /dev/md3
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdc1
    raid-disk     0
    device          /dev/hdd1
    raid-disk     1
raiddev             /dev/md2
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdc5
    raid-disk     0
    device          /dev/hdd5
    raid-disk     1
raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdc2
    raid-disk     0
    device          /dev/hdd2
    raid-disk     1

Below is the output of /etc/fstab: 

/dev/md1                /                       ext3    defaults       
1 1
/dev/md3                /boot                   ext3    defaults       
1 2
/dev/md2                /home/gforge/cvsroot    ext3    defaults       
1 2
none                    /dev/pts                devpts  gid=5,mode=620 
0 0
/dev/md0                /home                   ext3    defaults       
1 2
none                    /proc                   proc    defaults       
0 0
none                    /dev/shm                tmpfs   defaults       
0 0
/dev/hdc6               swap                    swap    defaults       
0 0
/dev/fd0                /mnt/floppy             auto   
noauto,owner,kudzu 0 0


Below is teh output of "fdisk -l" : 

Disk /dev/hdc: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1   *         1        13    104391   fd  Linux raid autodetect
/dev/hdc2            14     11678  93699112+  fd  Linux raid autodetect
/dev/hdc3         11679     15502  30716280   fd  Linux raid autodetect
/dev/hdc4         15503     19457  31768537+   f  Win95 Ext'd (LBA)
/dev/hdc5         15503     19326  30716248+  fd  Linux raid autodetect
/dev/hdc6         19327     19457   1052226   82  Linux swap

Disk /dev/hdd: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdd1   *         1        13    104391   fd  Linux raid autodetect
/dev/hdd2            14     11678  93699112+  fd  Linux raid autodetect
/dev/hdd3         11679     15502  30716280   fd  Linux raid autodetect
/dev/hdd4         15503     19457  31768537+   f  Win95 Ext'd (LBA)
/dev/hdd5         15503     19326  30716248+  fd  Linux raid autodetect

Disk /dev/hda: 40.0 GB, 40020664320 bytes
255 heads, 63 sectors/track, 4865 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *         1         6     48163+  83  Linux
/dev/hda2             7      1918  15358140   83  Linux
/dev/hda3          1919      3193  10241437+  83  Linux
/dev/hda4          3194      4865  13430340    f  Win95 Ext'd (LBA)
/dev/hda5          3194      3257    514048+  82  Linux swap



