From: "Blair, Douglas" <Douglas.Blair@vsacorp.com>
Subject: Certain commands lock up
Date: Mon, 5 Aug 2002 18:23:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <75646B517E17BB44A709D30BE1753E42058703@hq-mdmail.hq.viaken.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Folks,

Just pulled down the 1.00.2 source.  I am experiencing
some difficulty with a RAID I am trying to set up.  I am
able to create a 14 disk RAID-0 array with mkraid, mount
it, and write to it, but any subsequent attempt to
interact with the md device causes the command to hang,
and makes the machine un-haltable.  I first encountered
this when I tried to call sync, but after a hard reset,
also experienced it with umount.  Everything else in the
system seems to continue okay, and init 0 takes *almost*
everything down, but not quite.

     I have a dual-processor system, but strangeness like
this also seems to occur with the -up kernel.  Thanks for
any insight you might be able to provide.

Best,

Douglas Blair
Bioinformatics Scientist
VSA Corp.


Hardware:
   2 CPU 1400 MHz Athlon
   30 GB IDE boot disk
   LSI Logic dual Symbios 53c1010 SCSI card (Ultra 160)
   StorCase InfoStation 2x7 SCSI enclosure
   14 Seagate 36GB drives

Software:
   Red Hat 7.3 (2.4.18-3 from the iso images)
   Rebuilt athlon SMP kernel to include scsi support
   sym53c8xx SCSI driver

from dmesg:

SCSI subsystem driver Revision: 1.00
sym53c8xx: at PCI bus 0, device 11, function 0
sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
sym53c8xx: 53c1010-66 detected with Symbios NVRAM
sym53c8xx: at PCI bus 0, device 11, function 1
sym53c8xx: setting PCI_COMMAND_PARITY...(fix-up)
sym53c8xx: 53c1010-66 detected with Symbios NVRAM
sym53c1010-66-0: rev 0x1 on pci bus 0 device 11 function 0 irq 10
sym53c1010-66-0: Symbios format NVRAM, ID 7, Fast-80, Parity Checking
sym53c1010-66-0: on-chip RAM at 0xf4000000
sym53c1010-66-0: restart (scsi reset).
sym53c1010-66-0: handling phase mismatch from SCRIPTS.
sym53c1010-66-0: Downloading SCSI SCRIPTS.
sym53c1010-66-1: rev 0x1 on pci bus 0 device 11 function 1 irq 10
sym53c1010-66-1: Symbios format NVRAM, ID 7, Fast-80, Parity Checking
sym53c1010-66-1: on-chip RAM at 0xf4002000
sym53c1010-66-1: restart (scsi reset).
sym53c1010-66-1: handling phase mismatch from SCRIPTS.
sym53c1010-66-1: Downloading SCSI SCRIPTS.
scsi0 : sym53c8xx-1.7.3c-20010512
scsi1 : sym53c8xx-1.7.3c-20010512
blk: queue f6288e18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: SEAGATE   Model: ST336705LC        Rev: 5063
  Type:   Direct-Access                      ANSI SCSI revision: 03
...13 more...


/etc/raidtab:

raiddev /dev/md0
   raid-level              0
   nr-raid-disks           14
   persistent-superblock   1
   chunk-size              64

   device                  /dev/sda1
   raid-disk               0
   device                  /dev/sdb1
   raid-disk               1
   device                  /dev/sdc1
   raid-disk               2
   device                  /dev/sdd1
   raid-disk               3
   device                  /dev/sde1
   raid-disk               4
   device                  /dev/sdf1
   raid-disk               5
   device                  /dev/sdg1
   raid-disk               6
   device                  /dev/sdh1
   raid-disk               7
   device                  /dev/sdi1
   raid-disk               8
   device                  /dev/sdj1
   raid-disk               9
   device                  /dev/sdk1
   raid-disk               10
   device                  /dev/sdl1
   raid-disk               11
   device                  /dev/sdm1
   raid-disk               12
   device                  /dev/sdn1
   raid-disk               13


# mkraid -R --configfile /etc/raidtab.old /dev/md0
DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sda1, 35843056kB, raid superblock at 35842944kB
disk 1: /dev/sdb1, 35843056kB, raid superblock at 35842944kB
disk 2: /dev/sdc1, 35843056kB, raid superblock at 35842944kB
disk 3: /dev/sdd1, 35843056kB, raid superblock at 35842944kB
disk 4: /dev/sde1, 35843056kB, raid superblock at 35842944kB
disk 5: /dev/sdf1, 35843056kB, raid superblock at 35842944kB
disk 6: /dev/sdg1, 35843056kB, raid superblock at 35842944kB
disk 7: /dev/sdh1, 35843056kB, raid superblock at 35842944kB
disk 8: /dev/sdi1, 35843056kB, raid superblock at 35842944kB
disk 9: /dev/sdj1, 35843056kB, raid superblock at 35842944kB
disk 10: /dev/sdk1, 35843056kB, raid superblock at 35842944kB
disk 11: /dev/sdl1, 35843056kB, raid superblock at 35842944kB
disk 12: /dev/sdm1, 35843056kB, raid superblock at 35842944kB
disk 13: /dev/sdn1, 35843056kB, raid superblock at 35842944kB
# more /proc/mdstat
Personalities : [raid0] 
read_ahead 1024 sectors
md0 : active raid0 sdn1[13] sdm1[12] sdl1[11] sdk1[10] sdj1[9] sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
      501801216 blocks 64k chunks
      
unused devices: <none>
# mke2fs -m 1 /dev/md0 
mke2fs 1.27 (8-Mar-2002)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
62734336 inodes, 125450304 blocks
1254503 blocks (1.00%) reserved for the super user
First data block=0
3829 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 	4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968, 
	102400000

Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 34 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
# mount /dev/md0 /data01
# df
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/hda2               248895    229532      6511  98% /
/dev/hda1                31079     18612     10863  64% /boot
none                   1032772         0   1032772   0% /dev/shm
/dev/hda6             25529688   3286308  20946536  14% /usr
/dev/hda5              1011928    101532    858992  11% /var
/dev/md0             493926560    215004 488693544   1% /data01
# cd /data01
# ls -las
total 21
   4 drwxrwxrwx    3 root     root         4096 Jul  5 15:10 .
   1 drwxr-xr-x   22 root     root         1024 Jul  5 13:32 ..
  16 drwx------    2 root     root        16384 Jul  3 19:57 lost+found
# sync    (returns immediately)
# time dd if=/dev/zero of=/data01/10GB bs=1048576 count=10000      
10000+0 records in
10000+0 records out

real	0m50.411s
user	0m0.050s
sys	0m44.000s
# ls -las /data01
total 10250037
      4 drwxr-xr-x    3 root     root         4096 Jul  5 15:44 .
      1 drwxr-xr-x   22 root     root         1024 Jul  5 15:35 ..
10250016 -rw-r--r--    1 root     root     10485760000 Jul  5 15:45 10GB
     16 drwx------    2 root     root        16384 Jul  5 15:43 lost+found
# sync    (never returns, sync process defunct, can't halt/reboot)


In another window:
$ ps ax | grep sync
 2125 pts/0    D      0:00 sync
 2206 pts/1    S      0:00 grep sync

All attempts to ls, umount, etc. hang after this.

Filesystem is unclean after rebooting, and I get a partial
file after the fsck and remount.  When I add a journal and
the same thing happens, the clean filesystem has no file.
Also, this doesn't *always* happen, but most times does.
