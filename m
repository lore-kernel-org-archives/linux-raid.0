From: Brandon Evans <maillists@hosttuls.com>
Subject: Kernal Panic when booting redhat.  Raid devices mount fine under
 Knoppix
Date: Wed, 10 Dec 2003 15:03:31 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FD7A643.7060602@hosttuls.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Using rsync, I mirrored one server to some raid 1 partitions on  another 
server running knoppix.  The Raid devices mount fine
under knoppix 3.3, but when I try to boot Redhat 7.3, the servers can 
not read the superblock on the root device (/dev/md1), so the system panics.
   This has happened on 2 servers so far.

The error I am getting is this:

EXT3-fs: unable to read superblock
mount:error 22 mounting ext3 flags

There is also something like this:  pivotroot: pivot_root 
(/sysroot,/sysroot/initrd) failed 2.  But I left my notes at home, so 
I'm not sure
  that is exactly what the error says.  The same migration process 
worked fine in the test environment, but on the live servers,
with more data (20 Gigs), the server produce the above errors.

Why is Knoppix able to mount the root partition, but Redhat not?

To rsync, I used these steps: 
http://hosttuls.com/whitepapers/SyncServerMigration.txt

Raidtab:

raiddev             /dev/md0
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/hda1
     raid-disk     0
     device          /dev/hdd1
     raid-disk     1
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
     device          /dev/hda3
     raid-disk     0
     device          /dev/hdd2
     raid-disk     1



Fstab:

/dev/md1        /       ext3    defaults,usrquota,grpquota      1       1
/dev/md0             /boot                   ext3    defaults        1 2
none                    /dev/pts                devpts  gid=5,mode=620  0 0
none                    /proc                   proc    defaults        0 0
none                    /dev/shm                tmpfs   defaults        0 0
/dev/hda2               swap                    swap    defaults        0 0
/dev/cdrom              /mnt/cdrom              iso9660 
noauto,owner,kudzu,ro 0 0
/dev/fd0                /mnt/floppy             auto 
noauto,owner,kudzu 0 0



Lilo Entry:

image=/boot/vmlinuz-2.4.20-20.7smp
         label=rh-2.4.20-20r
         initrd=/boot/initrd-2.4.20-20.7smp.raid.img
         read-only
         root=/dev/md1



df:
Filesystem            Size  Used Avail Use% Mounted on
/dev/md1              112G   26G   80G  24% /
none                  112G   26G   80G  24% /proc
/dev/md0               99M   28M   65M  30% /boot
none                  112G   26G   80G  24% /dev/pts
none                  112G   26G   80G  24% /dev/shm
/proc                 112G   26G   80G  24% /proc





-- 
     Brandon E.
