From: "Claudio Lapidus" <clapidus@hotmail.com>
Subject: raid5 not responding (LONG)
Date: Mon, 11 Aug 2003 20:11:57 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BAY7-DAV44JannZX30a000188e8@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

(I just subscribed and I'm not really sure if this list is for user support,
sorry if it isn't, please direct me to the appropiate resource. Also, sorry
for the long post, but I'm trying to give all pertinent info at once).

Here I have a small ProLiant with three 9.1GB SCSI disks arranged in raid5,
and subsequently shared via samba for a dozen windows users. Today it
stopped to respond to everything, even an 'ls /mnt/u01' (there it is
mounted) does not come back at all! From system logs, it looks like a disk
has failed, but I do not know how to restore proper operation. It hasn't
come back online yet, more than one hour after initial failure.

Please, any advice to start troubleshooting this one will be very much
appreciated.

Follows relevant info:

[root@edrs log]# uname -a
Linux edrs 2.4.18-27.7.x #1 Fri Mar 14 06:44:53 EST 2003 i686 unknown

[root@edrs root]# uptime
  8:36pm  up 14 days,  5:58,  5 users,  load average: 56.99, 56.61, 54.43

[root@edrs log]# cat /etc/redhat-release
Red Hat Linux release 7.3 (Valhalla)

[root@edrs log]# rpm -q raidtools
raidtools-1.00.2-1.3

[root@edrs log]# cat /etc/raidtab
raiddev /dev/md0
        raid-level      5
        nr-raid-disks   3
        nr-spare-disks  0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size      32
        device          /dev/sdb1
        raid-disk       0
        device          /dev/sdc1
        raid-disk       1
        device          /dev/sdd1
        raid-disk       2


[root@edrs log]# cat /etc/fstab
/dev/sda8               /                       ext3    defaults        1 1
/dev/sda1               /boot                   ext3    defaults        1 2
/dev/sda6               /home                   ext3    defaults        1 2
/dev/cdrom              /mnt/cdrom              iso9660 noauto,owner,ro 0 0
/dev/sda5               /usr                    ext3    defaults        1 2
/dev/sda7               /var                    ext3    defaults        1 2
/dev/md0                /mnt/u01                ext3    defaults        1 2
/dev/fd0                /mnt/floppy             auto    noauto,owner    0 0
none                    /proc                   proc    defaults        0 0
none                    /dev/shm                tmpfs   defaults        0 0
none                    /dev/pts                devpts  gid=5,mode=620  0 0
/dev/sda9               swap                    swap    defaults        0 0
/var/SWAP               swap                    swap    defaults        0 0

[root@edrs log]# cat /etc/mtab
/dev/sda8 / ext3 rw 0 0
none /proc proc rw 0 0
/dev/sda1 /boot ext3 rw 0 0
/dev/sda6 /home ext3 rw 0 0
/dev/sda5 /usr ext3 rw 0 0
/dev/sda7 /var ext3 rw 0 0
/dev/md0 /mnt/u01 ext3 rw 0 0
none /dev/shm tmpfs rw 0 0
none /dev/pts devpts rw,gid=5,mode=620 0 0


[root@edrs log]# cat /proc/mdstat
Personalities : [raid5]
read_ahead 1024 sectors
md0 : active raid5 sdd1[2] sdc1[1] sdb1[0](F)
      17767680 blocks level 5, 32k chunk, algorithm 2 [3/2] [_UU]

unused devices: <none>



[root@edrs log]# tail -20 /var/log/messages
Aug 11 18:34:57 edrs kernel: scsi0: ERROR on channel 0, id 1, lun 0, CDB:
Read (10) 00 00 03 c1 2f 00 00 40 00
Aug 11 18:34:57 edrs kernel: Info fld=0x3c134, Current sd08:11: sense key
Medium Error
Aug 11 18:34:57 edrs kernel: Additional sense indicates Unrecovered read
error - recommend reassignment
Aug 11 18:34:57 edrs kernel:  I/O error: dev 08:11, sector 246000
Aug 11 18:34:57 edrs kernel: raid5: Disk failure on sdb1, disabling device.
Operation continuing on 2 devices
Aug 11 18:34:57 edrs kernel: md: updating md0 RAID superblock on device
Aug 11 18:34:57 edrs kernel: md: sdd1 [events: 00000038]<6>(write) sdd1's sb
offset: 8883840
Aug 11 18:34:57 edrs kernel: md: recovery thread got woken up ...
Aug 11 18:34:57 edrs kernel: md0: no spare disk to reconstruct array! --
continuing in degraded mode
Aug 11 18:34:57 edrs kernel: md: recovery thread finished ...
Aug 11 19:01:00 edrs CROND[18309]: (root) CMD (run-parts /etc/cron.hourly)
Aug 11 19:01:48 edrs sshd(pam_unix)[18318]: session opened for user root by
(uid=0)
Aug 11 19:02:36 edrs sshd(pam_unix)[18359]: session opened for user root by
(uid=0)
Aug 11 19:03:42 edrs sshd(pam_unix)[18402]: session opened for user root by
(uid=0)
Aug 11 19:17:32 edrs kernel: lease timed out
Aug 11 20:01:00 edrs CROND[18539]: (root) CMD (run-parts /etc/cron.hourly)
Aug 11 20:01:03 edrs sshd(pam_unix)[18537]: session opened for user root by
(uid=0)
Aug 11 20:06:15 edrs kernel: 10.65.44.10 sent an invalid ICMP error to a
broadcast.
Aug 11 20:06:15 edrs kernel: 10.70.44.10 sent an invalid ICMP error to a
broadcast.
Aug 11 20:18:15 edrs kernel: 10.70.44.9 sent an invalid ICMP error to a
broadcast.





Looking back for the last boot, I found:

[root@edrs root]# cat /var/log/messages.2
...<snip>...
Jul 28 14:39:01 edrs fsck: /dev/md0: recovering journal
Jul 28 14:39:08 edrs fsck: /dev/md0: clean, 20402/2223872 files,
2441914/4441920 blocks
Jul 28 14:39:08 edrs rc.sysinit: Checking filesystems succeeded
Jul 28 14:39:10 edrs rc.sysinit: Mounting local filesystems:  succeeded
...<snip>...
Jul 28 14:40:22 edrs kernel: md: md driver 0.90.0 MAX_MD_DEVS=256,
MD_SB_DISKS=27
Jul 28 14:40:22 edrs kernel: md: Autodetecting RAID arrays.
Jul 28 14:40:22 edrs kernel: md: autorun ...
Jul 28 14:40:23 edrs kernel: md: ... autorun DONE.
Jul 28 14:40:25 edrs kernel: SCSI subsystem driver Revision: 1.00
Jul 28 14:40:26 edrs kernel: kmod: failed to exec /sbin/modprobe -s -k
scsi_hostadapter, errno = 2
Jul 28 14:40:26 edrs kernel: ncr53c8xx: at PCI bus 1, device 9, function 0
Jul 28 14:40:26 edrs kernel: ncr53c8xx: 53c875 detected
Jul 28 14:40:26 edrs kernel: ncr53c8xx: at PCI bus 1, device 9, function 1
Jul 28 14:40:26 edrs kernel: ncr53c8xx: 53c875 detected
Jul 28 14:40:26 edrs kernel: ncr53c875-0: rev 0x14 on pci bus 1 device 9
function 0 irq 9
Jul 28 14:40:26 edrs kernel: ncr53c875-0: ID 7, Fast-20, Parity Checking
Jul 28 14:40:27 edrs kernel: ncr53c875-1: rev 0x14 on pci bus 1 device 9
function 1 irq 10
Jul 28 14:40:27 edrs kernel: ncr53c875-1: ID 7, Fast-20, Parity Checking
Jul 28 14:40:27 edrs kernel: scsi0 : ncr53c8xx-3.4.3b-20010512
Jul 28 14:40:27 edrs kernel: scsi1 : ncr53c8xx-3.4.3b-20010512
Jul 28 14:40:28 edrs kernel: ncr53c875-0-<0,*>: FAST-20 WIDE SCSI 40.0 MB/s
(50 ns, offset 16)
Jul 28 14:40:28 edrs kernel:   Vendor: COMPAQ    Model: MAB3045SC
Rev: 0814
Jul 28 14:40:29 edrs kernel:   Type:   Direct-Access
ANSI SCSI revision: 02
Jul 28 14:40:29 edrs kernel: ncr53c875-0-<1,*>: FAST-20 WIDE SCSI 40.0 MB/s
(50 ns, offset 15)
Jul 28 14:40:29 edrs kernel:   Vendor: COMPAQ    Model: DGHS09Y
Rev: 01C0
Jul 28 14:40:29 edrs kernel:   Type:   Direct-Access
ANSI SCSI revision: 03
Jul 28 14:40:29 edrs kernel: ncr53c875-0-<2,*>: FAST-20 WIDE SCSI 40.0 MB/s
(50 ns, offset 16)
Jul 28 14:40:29 edrs kernel:   Vendor: COMPAQ    Model: MAB3091SC
Rev: 0814
Jul 28 14:40:29 edrs kernel:   Type:   Direct-Access
ANSI SCSI revision: 02
Jul 28 14:40:29 edrs kernel: ncr53c875-0-<3,*>: FAST-20 WIDE SCSI 40.0 MB/s
(50 ns, offset 15)
Jul 28 14:40:29 edrs kernel:   Vendor: COMPAQ    Model: DGHS09Y
Rev: 01C0
Jul 28 14:40:29 edrs kernel:   Type:   Direct-Access
ANSI SCSI revision: 03
Jul 28 14:40:29 edrs kernel: Attached scsi disk sda at scsi0, channel 0, id
0, lun 0
Jul 28 14:40:29 edrs kernel: Attached scsi disk sdb at scsi0, channel 0, id
1, lun 0
Jul 28 14:40:30 edrs kernel: Attached scsi disk sdc at scsi0, channel 0, id
2, lun 0
Jul 28 14:40:30 edrs kernel: Attached scsi disk sdd at scsi0, channel 0, id
3, lun 0
Jul 28 14:40:30 edrs kernel: SCSI device sda: 8386000 512-byte hdwr sectors
(4294 MB)
Jul 28 14:40:30 edrs kernel: Partition check:
Jul 28 14:40:30 edrs kernel:  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
Jul 28 14:40:30 edrs kernel: SCSI device sdb: 17773500 512-byte hdwr sectors
(9100 MB)
Jul 28 14:40:30 edrs kernel:  sdb: sdb1
Jul 28 14:40:30 edrs kernel: SCSI device sdc: 17773500 512-byte hdwr sectors
(9100 MB)
Jul 28 14:40:30 edrs kernel:  sdc: sdc1
Jul 28 14:40:31 edrs kernel: SCSI device sdd: 17773500 512-byte hdwr sectors
(9100 MB)
Jul 28 14:40:31 edrs kernel:  sdd: sdd1
Jul 28 14:40:32 edrs kernel: raid5: measuring checksumming speed
Jul 28 14:40:32 edrs kernel:    8regs     :   733.184 MB/sec
Jul 28 14:40:32 edrs kernel:    32regs    :   346.112 MB/sec
Jul 28 14:40:32 edrs kernel:    pII_mmx   :   894.976 MB/sec
Jul 28 14:40:32 edrs kernel:    p5_mmx    :   933.888 MB/sec
Jul 28 14:40:33 edrs kernel: raid5: using function: p5_mmx (933.888 MB/sec)
Jul 28 14:40:33 edrs kernel: md: raid5 personality registered as nr 4
Jul 28 14:40:33 edrs kernel: Journalled Block Device driver loaded
Jul 28 14:40:33 edrs kernel: md: Autodetecting RAID arrays.
Jul 28 14:40:33 edrs kernel:  [events: 00000036]
Jul 28 14:40:34 edrs kernel:  [events: 00000036]
Jul 28 14:40:34 edrs kernel:  [events: 00000036]
Jul 28 14:40:34 edrs kernel: md: autorun ...
Jul 28 14:40:35 edrs kernel: md: considering sdd1 ...
Jul 28 14:40:35 edrs kernel: md:  adding sdd1 ...
Jul 28 14:40:35 edrs kernel: md:  adding sdc1 ...
Jul 28 14:40:36 edrs kernel: md:  adding sdb1 ...
Jul 28 14:40:36 edrs kernel: md: created md0
Jul 28 14:40:36 edrs kernel: md: bind<sdb1,1>
Jul 28 14:40:37 edrs kernel: md: bind<sdc1,2>
Jul 28 14:40:37 edrs kernel: md: bind<sdd1,3>
Jul 28 14:40:37 edrs kernel: md: running: <sdd1><sdc1><sdb1>
Jul 28 14:40:37 edrs kernel: md: sdd1's event counter: 00000036
Jul 28 14:40:38 edrs kernel: md: sdc1's event counter: 00000036
Jul 28 14:40:38 edrs kernel: md: sdb1's event counter: 00000036
Jul 28 14:40:39 edrs kernel: md: md0: raid array is not clean -- starting
background reconstruction
Jul 28 14:40:39 edrs kernel: md0: max total readahead window set to 496k
Jul 28 14:40:39 edrs kernel: md0: 2 data-disks, max readahead per data-disk:
248k
Jul 28 14:40:40 edrs kernel: raid5: device sdd1 operational as raid disk 2
Jul 28 14:40:40 edrs kernel: raid5: device sdc1 operational as raid disk 1
Jul 28 14:40:40 edrs kernel: raid5: device sdb1 operational as raid disk 0
Jul 28 14:40:40 edrs kernel: raid5: allocated 3291kB for md0
Jul 28 14:40:41 edrs kernel: raid5: raid level 5 set md0 active with 3 out
of 3 devices, algorithm 2
Jul 28 14:40:41 edrs kernel: raid5: raid set md0 not clean; reconstructing
parity
Jul 28 14:40:41 edrs kernel: RAID5 conf printout:
Jul 28 14:40:42 edrs kernel:  --- rd:3 wd:3 fd:0
Jul 28 14:40:42 edrs kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
Jul 28 14:40:42 edrs kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
Jul 28 14:40:43 edrs kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
Jul 28 14:40:43 edrs kernel: RAID5 conf printout:
Jul 28 14:40:44 edrs kernel:  --- rd:3 wd:3 fd:0
Jul 28 14:40:44 edrs kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
Jul 28 14:40:44 edrs kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
Jul 28 14:40:45 edrs kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
Jul 28 14:40:45 edrs kernel: md: updating md0 RAID superblock on device
Jul 28 14:40:45 edrs kernel: md: sdd1 [events: 00000037]<6>(write) sdd1's sb
offset: 8883840
Jul 28 14:40:45 edrs kernel: md: syncing RAID array md0
Jul 28 14:40:45 edrs kernel: md: minimum _guaranteed_ reconstruction speed:
100 KB/sec/disc.
Jul 28 14:40:45 edrs kernel: md: using maximum available idle IO bandwith
(but not more than 10000 KB/sec) for reconstruction.
Jul 28 14:40:45 edrs kernel: md: using 508k window, over a total of 8883840
blocks.
Jul 28 14:40:45 edrs kernel: md: sdc1 [events: 00000037]<6>(write) sdc1's sb
offset: 8883840
Jul 28 14:40:46 edrs kernel: md: sdb1 [events: 00000037]<6>(write) sdb1's sb
offset: 8883840
Jul 28 14:40:46 edrs kernel: md: ... autorun DONE.
Jul 28 14:40:46 edrs kernel: EXT3-fs: INFO: recovery required on readonly
filesystem.
Jul 28 14:40:46 edrs kernel: EXT3-fs: write access will be enabled during
recovery.
Jul 28 14:40:46 edrs kernel: kjournald starting.  Commit interval 5 seconds
Jul 28 14:40:46 edrs kernel: EXT3-fs: recovery complete.
Jul 28 14:40:46 edrs kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Jul 28 14:40:46 edrs kernel: EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,8),
internal journal
Jul 28 14:40:47 edrs kernel: kjournald starting.  Commit interval 5 seconds
Jul 28 14:40:47 edrs kernel: EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,1),
internal journal
Jul 28 14:40:47 edrs kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Jul 28 14:40:47 edrs kernel: kjournald starting.  Commit interval 5 seconds
Jul 28 14:40:47 edrs kernel: EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,6),
internal journal
Jul 28 14:40:47 edrs kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Jul 28 14:40:47 edrs kernel: kjournald starting.  Commit interval 5 seconds
Jul 28 14:40:47 edrs kernel: EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,5),
internal journal
Jul 28 14:40:47 edrs kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Jul 28 14:40:48 edrs kernel: kjournald starting.  Commit interval 5 seconds
Jul 28 14:40:48 edrs kernel: EXT3 FS 2.4-0.9.18, 14 May 2002 on sd(8,7),
internal journal
Jul 28 14:40:48 edrs kernel: EXT3-fs: mounted filesystem with ordered data
mode.
Jul 28 14:40:48 edrs kernel: kjournald starting.  Commit interval 5 seconds
Jul 28 14:40:48 edrs kernel: EXT3 FS 2.4-0.9.18, 14 May 2002 on md(9,0),
internal journal
Jul 28 14:40:48 edrs kernel: EXT3-fs: mounted filesystem with ordered data
mode.
...<snip>...
Jul 28 14:53:31 edrs kernel: md: md0: sync done.
Jul 28 14:53:31 edrs kernel: raid5: resync finished.



thanks in advance
cl.

