From: Chris Maxwell <cmaxwell@dal.ca>
Subject: Assistance Reviewing Proposed Recovery Measures
Date: Fri, 19 Aug 2016 17:18:44 -0300 (ADT)
Message-ID: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1384045802-408353636-1471637924=:23388"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1384045802-408353636-1471637924=:23388
Content-Type: TEXT/PLAIN; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 8BIT

I am looking for some advice rather than blundering around making things worse, as 
recommended by https://raid.wiki.kernel.org/index.php/RAID_Recovery

I have been asked to step in on a situation with a failing disk(s) in a RAID setup.
I can not really explain why it was setup in the below manner, but one would have 
expected it would mean the system is far more recoverable that it is proving to be.

As far as I can tell, I have a hardware RAID array running on a 3Ware controller, 
that has 2 mirrors, each with 2 disks.  Then on top of this is a Linux Software 
RAID disk disk, and then LVM built on top of that.  This is laid out again in slightly 
more detail below.  (However, it appears to me that the hardware RAID would be a 
red herring, at least as a recovery mechanism, since even the remaining non-failed 
disk in sdc is getting errors.  So let us consider this as a pure software Linux RAID issue.)

There was an entry in the log that one side of md0 was failing.   Unfortunately, the sysadmin 
called it wrong as to which side was failing, and removed sdb1 (the good disk) from the md0 instead of sdc1 (the bad disk).
So how do we come back from that?  sdb1 seems fine, I just need to figure out how to 
make it so sdb1 is the only device in the md0 mirror, and then reconstruct the 
LVM structure.


I started with “copy the data off the running disk (the surviving sdc1 mirror)”, but am getting errors, so 
I figured it would be better to get it from the good mirror copy.

Generally, s/w mirror and LVM just work, so I have not really delved closely into 
what should and should not work, and the header blocks on the various devices involved.
Therefore, I don’t really know if it is strange that just using sdb1 as a LVM PV disk and 
build up my LVM structure from that.

I have a bash_history file to list out all the commands that were run (Figure 3).

Versions:
     * Linux private2 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012 x86_64 x86_64 x86_64 GNU/Linux
     * mdadm - v2.6.9 - 10th March 2009

But I figured that something along these lines is something like what is needed:
mdadm  --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1
mdadm  --assemble --force /dev/md1 /dev/sdb1 missing

However, this fails.

https://raid.wiki.kernel.org/index.php/RAID_Recovery suggest one can create rather than assemble a sw raid. 
(Not sure whether to call it md0 or md1)
mdadm --create /dev/md0 --metadata=0.90 --raid-devices=2 --level=raid1 /dev/sdb1 missing

However, the it also says

> Recreating should be considered a *last* resort, only to be used when everything else fails. People getting this wrong is one of the primary reasons people lose data. It is very commonly used way too early in the fault finding process. You have been warned! It's better to send an email to the linux-raid mailing list with detailed information (mdadm --examine from all component drives plus log entries from when the failure happened, including mdadm and kernel version) and ask for advice than to try to use --create --assume-clean and getting it wrong.



So before I messed things up even worse, I figured I would consult the experts to see what my next 
step should be.






==========================================================================
Figure 1: Detailed description of the storage structure:

I had determined that the disk layout is so:
/dev/sda = a SSD

The machine has a 3ware Hardware RAID controller which is showing sdb and sdc as disks.  (Unit 0 and Unit 1).
Unit 0 (sdb) is made up of
Phy 0: WD WCAW35791262
Phy 1:  Seagate 9QJ7N744

Unit 1(sdc) is made up of
Phy 2: Seagate 9QJ7F3PJ and
Phy 3: Seagate 9QJ7R3Y1

These are then combined into mirror md0 made of sdb1 and sdc1
This is the physical volume for LVM VG lvm-raid, which then has LV inside:
lvmdata1 and gokcen




==========================================================================
Figure 2: mdadm —examine of /dev/sdb1 and sdc1:

# mdadm --examine /dev/sd[bc]1 >> raid.status.latest

/dev/sdb1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : fdd98007:78663948:0760cb1c:ce437c35
   Creation Time : Mon Oct 18 10:54:29 2010
      Raid Level : raid1
   Used Dev Size : 976551040 (931.31 GiB 999.99 GB)
      Array Size : 976551040 (931.31 GiB 999.99 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Thu Aug  4 12:11:38 2016
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1
        Checksum : d3a40069 - correct
          Events : 858


       Number   Major   Minor   RaidDevice State
this     2       8       17        2      spare   /dev/sdb1

    0     0       0        0        0      removed
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8       17        2      spare   /dev/sdb1
/dev/sdc1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : fdd98007:78663948:0760cb1c:ce437c35
   Creation Time : Mon Oct 18 10:54:29 2010
      Raid Level : raid1
   Used Dev Size : 976551040 (931.31 GiB 999.99 GB)
      Array Size : 976551040 (931.31 GiB 999.99 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Thu Aug  4 12:11:38 2016
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1
        Checksum : d3a4007d - correct
          Events : 858


       Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

    0     0       0        0        0      removed
    1     1       8       33        1      active sync   /dev/sdc1
    2     2       8       17        2      spare   /dev/sdb1



=====================================================================
Figure 3: bash_history of what I have done:

This is the history of the commands I have tried, but it does not really say what the 
reported results were:


mdadm list
mdadm /dev/md0 status
mdadm --detail /dev/md0
df -k
mount -o ro /dev/md0 /mnt/data
pvdisplay
vgdisplay
pvdisplay
vgdisplay
lvdisplay
pvdisplay
lvdisplay
umount /mnt/data
mount -o ro /dev/lvm-raid/gokcen /mnt/data
df -k
mdadm --detail /dev/md0
fdisk -l /dev/sdb
blkid /dev/sdb
lsscsi 
dmesg | less
lsscsi 
mdadm /dev/md0  --add /dev/sdb1
mdadm --detail /dev/md0
umount /mnt/data
mdadm /dev/md0 --fail /dev/sbd1
mdadm /dev/md0 --fail /dev/sdb1
mdadm --detail /dev/md0
mdadm /dev/md0 --remove /dev/sdb1
pvdisplay
fdisk -l /dev/sdb
dd if=/dev/sdb1 bs=1024 count=10 | less
pvdisplay
less /proc/mdstat 
mdadm /dev/md0 --assume-clean --re-add /dev/sdb1
mdadm /dev/md0  --re-add --assume-clean /dev/sdb1
mdadm --stop /dev/md0
vgdisplay
vgdisplay -v
vgdisplay -v | less
df -k
mkdir RaidFail
cd RaidFail/
mdadm --examine /dev/sd[bc]1 >> raid.status
less raid.status 
dd if=/dev/sdb1 bs=1024 count=10 | less
dd if=/dev/sdb1 bs=1024 count=1 | less
dd if=/dev/sdb1 bs=1024 count=1 of=sdb1.1024
dd if=/dev/sdc1 bs=1024 count=1 of=sdc1.1024 &
less sdc1.1024 
mdadm --detail /dev/md0
dmesg | less
mount -o ro /mnt/data
ls /mnt/data
df -k
df -h
mdadm --examine /dev/sd[bc]1 | egrep 'Event|dev/sd'
mdadm --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1
lvdisplay | less
less raid.status 
lsscsi 
dmidecode | grep sdb
dmidecode | grep disk
dmidecode | grep -i disk
dmidecode 
dmidecode  | less
lsscsi 
dmidecode  | less
lsscsi 
lsscsi -l
lshw -class disk | less
hdparm -I /dev/sdb | less
hdparm -I /dev/sd 
hdparm -I /dev/sd*
hdparm -I /dev/sd? 2>&1 | less
smartctl -i /dev/sdb | less
smartctl -i -d 3ware,0 /dev/sdb | less
smartctl -i -d 3ware,1 /dev/sdb | less
lshw -class disk | less
df -k
umount /mnt/data
shutdown -h 10:36 "Try to reassemble RAID mirror /dev/data"
mdadm --detail /dev/md0
mdadm /dev/md0 --stop
mdadm /dev/md0 --assemble --force /dev/sdb1 /dev/sdc1
mdadm  --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1
mdadm --stop /dev/md0
df -k
mdadm  --re-add  /dev/md0 /dev/sdb1
cat /proc/mdstat 
cat /etc/fstab
mkdir /mnt/data /mnt/gokcen
mount /mnt/data
lvdisplay
lvchange -an /dev/lvm-raid/gokcen 
lvchange -an /dev/lvm-raid/lvmdata1 
df -k
cd /mnt
cd data/
ls
tar -czf /dev/null .
mount
umount /mnt/data
cd 
umount /mnt/data
mount
lvchange -an /dev/lvm-raid/lvmdata1 
vgdisplay 
vgchange -an lvm-raid
vgdisplay 
man vgchange
dmsetup ls
pvdisplay
mdadm --stop /dev/md0
man mdadm
mdadm --examine /dev/sdb1
mdadm --examine /dev/sdc1
mdadm  --assemble --force /dev/md0 /dev/sdb1 /dev/sdc1
mdadm --examine /dev/sdb1
mdadm --examine /dev/sdc1
mdadm --examine /dev/sdb1
mdadm  --assemble --force /dev/md0 /dev/sdb1 
mdadm --stop /dev/md0
mdadm  --assemble --force /dev/md0 /dev/sdb1 
mdadm --detail /dev/md0
mdadm --examine /dev/sdb1
mdadm --remove /dev/md0 /dev/sdb1
man mdadm 
man mdadm 
less /etc/mdadm.conf 
vi /etc/mdadm.conf 
cd /etc/
mv -iv mdadm.conf mdadm.conf.old
cp mdadm.conf.old mdadm.conf
vi mdadm.conf
vi mdadm.conf
mdadm --run /dev/md0
vi mdadm.conf
mdadm --run /dev/md0
mdadm --detail /dev/md0
mdadm  --assemble --force /dev/md0 /dev/sdb1 
mdadm --examine /dev/sdb1
mdadm --examine /dev/sdc1
mdadm --examine /dev/sdb1
mdadm  --assemble --force /dev/md1 /dev/sdb1 
mdadm  --assemble --force /dev/md1 /dev/sdb1 missing
cat /proc/mdstat 
man pvscan
man pvcreate
man pvdisplay
pvdisplay /dev/sdb1
pvdisplay /dev/sdc1
ls -l /dev/md0
dmraid --raid_devices
pvdisplay 
mdadm  --assemble --force --run /dev/md1 /dev/sdb1 
mdadm  --assemble --force --run /dev/md0 /dev/sdb1 
mdadm --examine /dev/sd[bc]1 >> raid.status.latest
cat /proc/mdstat 
mdadm --detail /dev/md0
/sbin/mdadm --detail /dev/md0


==================================================
Figure 4: Sampling of messages from /var/log/messages

Jul 24 04:22:01 private2 kernel: md: syncing RAID array md0
Jul 24 04:22:01 private2 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Jul 24 04:22:01 private2 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Jul 24 04:22:01 private2 kernel: md: using 128k window, over a total of 976551040 blocks.
Jul 24 04:26:05 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=2.
Jul 24 04:26:05 private2 kernel: sd 6:0:1:0: Unhandled sense code
Jul 24 04:26:05 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Jul 24 04:26:05 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jul 24 04:26:05 private2 kernel: sdc: Current: sense key: Medium Error
Jul 24 04:26:05 private2 kernel:     Add. Sense: Unrecovered read error
Jul 24 04:26:05 private2 kernel: 
Jul 24 04:26:31 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=2.
Jul 24 04:26:35 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=2.
Jul 24 04:26:51 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0204): Drive timeout:port=2.
Jul 24 04:26:51 private2 kernel: sd 6:0:1:0: Unhandled sense code
Jul 24 04:26:51 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Jul 24 04:26:51 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jul 24 04:26:51 private2 kernel: sdc: Current: sense key: Hardware Error
Jul 24 04:26:51 private2 kernel:     Add. Sense: Logical unit communication time-out
[….]
Jul 24 05:34:31 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Jul 24 05:34:31 private2 kernel: sd 6:0:1:0: Unhandled sense code
Jul 24 05:34:31 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Jul 24 05:34:31 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Jul 24 05:34:31 private2 kernel: sdc: Current: sense key: Medium Error
Jul 24 05:34:31 private2 kernel:     Add. Sense: Unrecovered read error
Jul 24 05:34:31 private2 kernel: 
Jul 24 05:36:17 private2 kernel: sd 6:0:1:0: WARNING: (0x06:0x002C): Command (0x28) timed out, resetting card.
Jul 24 05:37:18 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x06:0x001F): Microcontroller not ready during reset sequence.
Jul 24 05:38:20 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x06:0x001F): Microcontroller not ready during reset sequence.
Jul 24 05:38:20 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x06:0x002B): Controller reset failed during scsi host reset.
Jul 24 05:38:20 private2 kernel: sd 6:0:1:0: scsi: Device offlined - not ready after error recovery
Jul 24 05:38:20 private2 last message repeated 17 times
Jul 24 05:38:20 private2 kernel: sd 6:0:0:0: scsi: Device offlined - not ready after error recovery
Jul 24 05:38:20 private2 kernel: sd 6:0:1:0: scsi: Device offlined - not ready after error recovery
Jul 24 05:38:20 private2 kernel: sd 6:0:0:0: scsi: Device offlined - not ready after error recovery
Jul 24 05:38:20 private2 kernel: sd 6:0:1:0: scsi: Device offlined - not ready after error recovery
[….]
Jul 24 05:38:20 private2 kernel: sd 6:0:1:0: rejecting I/O to offline device
Jul 24 05:38:20 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 24 05:38:20 private2 last message repeated 4 times
Jul 24 05:38:20 private2 kernel: sd 6:0:1:0: rejecting I/O to offline device
Jul 24 05:38:20 private2 last message repeated 13 times
Jul 24 05:38:20 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 24 05:38:20 private2 last message repeated 5 times
Jul 24 05:38:20 private2 kernel: RAID1 conf printout:
Jul 24 05:38:20 private2 kernel:  --- wd:1 rd:2
Jul 24 05:38:20 private2 kernel:  disk 0, wo:0, o:1, dev:sdb1
Jul 24 05:38:20 private2 kernel:  disk 1, wo:1, o:0, dev:sdc1
Jul 24 05:38:20 private2 kernel: RAID1 conf printout:
Jul 24 05:38:20 private2 kernel:  --- wd:1 rd:2
Jul 24 05:38:20 private2 kernel:  disk 0, wo:0, o:1, dev:sdb1
Jul 25 10:10:46 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 25 10:10:46 private2 last message repeated 3 times
Jul 25 10:10:46 private2 kernel: Aborting journal on device dm-2.
Jul 25 10:10:46 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 25 10:10:46 private2 kernel: Buffer I/O error on device dm-2, logical block 1545
Jul 25 10:10:46 private2 kernel: lost page write due to I/O error on dm-2
Jul 25 10:10:46 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 25 10:10:46 private2 last message repeated 2 times
Jul 25 10:10:47 private2 kernel: ext3_abort called.
[….]
Jul 28 17:51:28 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 28 17:51:28 private2 kernel: EXT3-fs error (device dm-2): ext3_get_inode_loc: unable to read inode block - inode=2457601, block=4915202
Jul 28 17:51:28 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 28 17:51:28 private2 kernel: EXT3-fs error (device dm-2): ext3_get_inode_loc: unable to read inode block - inode=2457606, block=4915202
Jul 28 17:51:28 private2 kernel: sd 6:0:0:0: rejecting I/O to offline device
Jul 28 17:51:28 private2 kernel: EXT3-fs error (device dm-2): ext3_get_inode_loc: unable to read inode block - inode=2457604, block=4915202
[….]



Aug  4 11:42:06 private2 smartd[6062]: Problem creating device name scan list 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sda, opened 
Aug  4 11:42:06 private2 smartd[6062]: Device /dev/sda: using '-d sat' for ATA disk behind SAT layer. 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sda, opened 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sda, not found in smartd database. 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sda, can't monitor Current Pending Sector count - no Attribute 197 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sda, can't monitor Offline Uncorrectable Sector count  - no Attribute 198 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sda, is SMART capable. Adding to "monitor" list. 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sdb, opened 
Aug  4 11:42:06 private2 smartd[6062]: Device /dev/sdb, please try adding '-d 3ware,N' 
Aug  4 11:42:06 private2 smartd[6062]: Device /dev/sdb, you may need to replace /dev/sdb with /dev/twaN or /dev/tweN 
Aug  4 11:42:06 private2 smartd[6062]: Device: /dev/sdc, opened 
Aug  4 11:42:06 private2 smartd[6062]: Device /dev/sdc, please try adding '-d 3ware,N' 
Aug  4 11:42:06 private2 smartd[6062]: Device /dev/sdc, you may need to replace /dev/sdc with /dev/twaN or /dev/tweN 
Aug  4 11:42:06 private2 smartd[6062]: Monitoring 0 ATA and 1 SCSI devices 
Aug  4 11:42:06 private2 smartd[6064]: smartd has fork()ed into background mode. New PID=6064. 
Aug  4 11:42:07 private2 avahi-daemon[6035]: Server startup complete. Host name is private2.local. Local service cookie is 3477185208.
Aug  4 11:43:55 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0026): Drive ECC error reported:port=3, unit=1.
Aug  4 11:43:55 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x002D): Source drive error occurred:port=3, unit=1.
Aug  4 11:43:55 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0004): Rebuild failed:unit=1.
Aug  4 11:43:55 private2 kernel: 3w-9xxx: scsi6: AEN: INFO (0x04:0x003B): Rebuild paused:unit=1.
Aug  4 11:54:07 private2 kernel: md: md0 still in use.
Aug  4 11:55:34 private2 kernel: md: bind<sdb1>
Aug  4 11:55:34 private2 kernel: RAID1 conf printout:
Aug  4 11:55:34 private2 kernel:  --- wd:1 rd:2
Aug  4 11:55:34 private2 kernel:  disk 0, wo:1, o:1, dev:sdb1
Aug  4 11:55:34 private2 kernel:  disk 1, wo:0, o:1, dev:sdc1
Aug  4 11:55:34 private2 kernel: md: syncing RAID array md0
Aug  4 11:55:34 private2 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Aug  4 11:55:34 private2 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Aug  4 11:55:34 private2 kernel: md: using 128k window, over a total of 976551040 blocks.
Aug  4 11:56:37 private2 kernel: sd 6:0:1:0: WARNING: (0x06:0x002C): Command (0x28) timed out, resetting card.
Aug  4 11:56:51 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x000A): Drive error detected:unit=1, port=3.
Aug  4 11:56:51 private2 kernel: 3w-9xxx: scsi6: AEN: INFO (0x04:0x005E): Cache synchronization completed:unit=0.
Aug  4 11:56:51 private2 kernel: 3w-9xxx: scsi6: AEN: INFO (0x04:0x005E): Cache synchronization completed:unit=1.
Aug  4 11:57:10 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 11:57:10 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 11:57:10 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 11:57:10 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[…]
Aug  4 11:58:40 private2 kernel: raid1: sdc: unrecoverable I/O read error for block 388480
Aug  4 11:58:40 private2 kernel: md: md0: sync done.
Aug  4 11:58:41 private2 kernel: RAID1 conf printout:
Aug  4 11:58:41 private2 kernel:  --- wd:1 rd:2
Aug  4 11:58:41 private2 kernel:  disk 0, wo:1, o:1, dev:sdb1
Aug  4 11:58:41 private2 kernel:  disk 1, wo:0, o:1, dev:sdc1
Aug  4 11:58:41 private2 kernel: RAID1 conf printout:
Aug  4 11:58:41 private2 kernel:  --- wd:1 rd:2
Aug  4 11:58:41 private2 kernel:  disk 1, wo:0, o:1, dev:sdc1
Aug  4 11:58:41 private2 kernel: kjournald starting.  Commit interval 5 seconds
Aug  4 11:58:41 private2 kernel: EXT3 FS on dm-2, internal journal
Aug  4 11:58:41 private2 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Aug  4 12:03:15 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 12:03:15 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 12:03:15 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 12:03:15 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Aug  4 12:03:15 private2 kernel: sdc: Current: sense key: Medium Error
Aug  4 12:03:15 private2 kernel:     Add. Sense: Unrecovered read error
Aug  4 12:03:15 private2 kernel: 
Aug  4 12:03:15 private2 kernel: EXT3-fs error (device dm-2): ext3_get_inode_loc: unable to read inode block - inode=71516957, block=143032346
Aug  4 12:03:15 private2 kernel: Aborting journal on device dm-2.
Aug  4 12:03:15 private2 kernel: ext3_abort called.
Aug  4 12:03:15 private2 kernel: EXT3-fs error (device dm-2): ext3_journal_start_sb: Detected aborted journal
Aug  4 12:03:15 private2 kernel: Remounting filesystem read-only
Aug  4 12:03:18 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 12:03:18 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 12:03:18 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 12:03:18 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Aug  4 12:03:18 private2 kernel: sdc: Current: sense key: Medium Error
Aug  4 12:03:18 private2 kernel:     Add. Sense: Unrecovered read error
Aug  4 12:03:18 private2 kernel: 
Aug  4 12:03:18 private2 kernel: EXT3-fs error (device dm-2): ext3_get_inode_loc: unable to read inode block - inode=71516956, block=143032346
Aug  4 12:03:46 private2 kernel: ext3_abort called.
Aug  4 12:03:46 private2 kernel: EXT3-fs error (device dm-2): ext3_put_super: Couldn't clean up the journal
Aug  4 12:06:17 private2 kernel: md: md0 stopped.
Aug  4 12:06:17 private2 kernel: md: unbind<sdb1>
Aug  4 12:06:17 private2 kernel: md: export_rdev(sdb1)
Aug  4 12:06:17 private2 kernel: md: unbind<sdc1>
Aug  4 12:06:17 private2 kernel: md: export_rdev(sdc1)
Aug  4 12:07:59 private2 kernel: md: md0 stopped.
Aug  4 12:07:59 private2 kernel: md: bind<sdb1>
Aug  4 12:07:59 private2 kernel: md: bind<sdc1>
Aug  4 12:07:59 private2 kernel: raid1: raid set md0 active with 1 out of 2 mirrors
Aug  4 12:07:59 private2 kernel: RAID1 conf printout:
Aug  4 12:07:59 private2 kernel:  --- wd:1 rd:2
Aug  4 12:07:59 private2 kernel:  disk 0, wo:1, o:1, dev:sdb1
Aug  4 12:07:59 private2 kernel:  disk 1, wo:0, o:1, dev:sdc1
Aug  4 12:07:59 private2 kernel: md: syncing RAID array md0
Aug  4 12:07:59 private2 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Aug  4 12:07:59 private2 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
Aug  4 12:07:59 private2 kernel: md: using 128k window, over a total of 976551040 blocks.
Aug  4 12:09:58 private2 kernel: sd 6:0:1:0: WARNING: (0x06:0x002C): Command (0x28) timed out, resetting card.
Aug  4 12:10:07 private2 kernel: INFO: task md0_resync:6417 blocked for more than 120 seconds.
Aug  4 12:10:07 private2 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Aug  4 12:10:07 private2 kernel: md0_resync    D ffffffff801563dc     0  6417    465                6416 (L-TLB)
Aug  4 12:10:07 private2 kernel:  ffff81065b64bca0 0000000000000046 0000000000000000 ffff81065b677ea0
Aug  4 12:10:07 private2 kernel:  0000000000000001 000000000000000a ffff8106853c9820 ffff81068525f7e0
Aug  4 12:10:07 private2 kernel:  000001c990bde7ec 00000000000040f4 ffff8106853c9a08 000000048008d299
Aug  4 12:10:07 private2 kernel: Call Trace:
Aug  4 12:10:07 private2 kernel:  [<ffffffff883864e9>] :raid1:raise_barrier+0x12c/0x164
Aug  4 12:10:07 private2 kernel:  [<ffffffff8008ee74>] default_wake_function+0x0/0xe
Aug  4 12:10:07 private2 kernel:  [<ffffffff883877fb>] :raid1:sync_request+0x17a/0x50d
Aug  4 12:10:07 private2 kernel:  [<ffffffff801563dc>] __next_cpu+0x19/0x28
Aug  4 12:10:07 private2 kernel:  [<ffffffff8021f649>] is_mddev_idle+0xa7/0x102
Aug  4 12:10:07 private2 kernel:  [<ffffffff80223104>] md_do_sync+0x464/0x84b
Aug  4 12:10:07 private2 kernel:  [<ffffffff800a3290>] keventd_create_kthread+0x0/0xc4
Aug  4 12:10:07 private2 kernel:  [<ffffffff80222c8a>] md_thread+0xf8/0x10e
Aug  4 12:10:07 private2 kernel:  [<ffffffff80222b92>] md_thread+0x0/0x10e
Aug  4 12:10:07 private2 kernel:  [<ffffffff8003264c>] kthread+0xfe/0x132
Aug  4 12:10:07 private2 kernel:  [<ffffffff8005dfb1>] child_rip+0xa/0x11
Aug  4 12:10:07 private2 kernel:  [<ffffffff800a3290>] keventd_create_kthread+0x0/0xc4
Aug  4 12:10:07 private2 kernel:  [<ffffffff8003254e>] kthread+0x0/0x132
Aug  4 12:10:07 private2 kernel:  [<ffffffff8005dfa7>] child_rip+0x0/0x11
Aug  4 12:10:07 private2 kernel: 
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: INFO (0x04:0x000B): Rebuild started:unit=1.
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=3.
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x000A): Drive error detected:unit=1, port=3.
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=3.
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0026): Drive ECC error reported:port=3, unit=1.
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x002D): Source drive error occurred:port=3, unit=1.
Aug  4 12:10:12 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0004): Rebuild failed:unit=1.
Aug  4 12:10:13 private2 kernel: 3w-9xxx: scsi6: AEN: INFO (0x04:0x003B): Rebuild paused:unit=1.
Aug  4 12:10:13 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=3.
Aug  4 12:10:13 private2 kernel: 3w-9xxx: scsi6: AEN: ERROR (0x04:0x0009): Drive timeout detected:port=3.
Aug  4 12:10:27 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 12:10:27 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 12:10:27 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 12:10:27 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Aug  4 12:10:27 private2 kernel: sdc: Current: sense key: Medium Error
Aug  4 12:10:27 private2 kernel:     Add. Sense: Unrecovered read error

[…]
Aug  4 12:11:28 private2 kernel: raid1: sdc: unrecoverable I/O read error for block 390272
Aug  4 12:11:31 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 12:11:31 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 12:11:31 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 12:11:31 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Aug  4 12:11:31 private2 kernel: sdc: Current: sense key: Medium Error
Aug  4 12:11:31 private2 kernel:     Add. Sense: Unrecovered read error
Aug  4 12:11:31 private2 kernel: 
Aug  4 12:11:31 private2 kernel: raid1: sdc: unrecoverable I/O read error for block 390144
Aug  4 12:11:34 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 12:11:34 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 12:11:34 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 12:11:34 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Aug  4 12:11:34 private2 kernel: sdc: Current: sense key: Medium Error
Aug  4 12:11:34 private2 kernel:     Add. Sense: Unrecovered read error
Aug  4 12:11:34 private2 kernel: 
Aug  4 12:11:34 private2 kernel: raid1: sdc: unrecoverable I/O read error for block 390400
Aug  4 12:11:38 private2 kernel: 3w-9xxx: scsi6: ERROR: (0x03:0x0202): Drive ECC error:port=3.
Aug  4 12:11:38 private2 kernel: sd 6:0:1:0: Unhandled sense code
Aug  4 12:11:38 private2 kernel: sd 6:0:1:0: SCSI error: return code = 0x08000004
Aug  4 12:11:38 private2 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Aug  4 12:11:38 private2 kernel: sdc: Current: sense key: Medium Error
Aug  4 12:11:38 private2 kernel:     Add. Sense: Unrecovered read error
Aug  4 12:11:38 private2 kernel: 
Aug  4 12:11:38 private2 kernel: raid1: sdc: unrecoverable I/O read error for block 392064
Aug  4 12:11:38 private2 kernel: RAID1 conf printout:
Aug  4 12:11:38 private2 kernel:  --- wd:1 rd:2
Aug  4 12:11:38 private2 kernel:  disk 0, wo:1, o:1, dev:sdb1
Aug  4 12:11:38 private2 kernel:  disk 1, wo:0, o:1, dev:sdc1
Aug  4 12:11:38 private2 kernel: RAID1 conf printout:
Aug  4 12:11:38 private2 kernel:  --- wd:1 rd:2
Aug  4 12:11:38 private2 kernel:  disk 1, wo:0, o:1, dev:sdc1
Aug  4 12:12:15 private2 kernel: md: md0 stopped.
Aug  4 12:12:15 private2 kernel: md: unbind<sdc1>
Aug  4 12:12:15 private2 kernel: md: export_rdev(sdc1)
Aug  4 12:12:15 private2 kernel: md: unbind<sdb1>
Aug  4 12:12:15 private2 kernel: md: export_rdev(sdb1)
Aug  4 12:12:19 private2 kernel: md: md0 stopped.
Aug  4 12:19:15 private2 kernel: md: md0 stopped.
Aug  4 12:24:57 private2 kernel: md: md1 stopped.
Aug  4 12:34:03 private2 kernel: md: md1 stopped.
Aug  4 13:06:17 private2 kernel: md: md1 stopped.
Aug  4 13:06:25 private2 kernel: md: md0 stopped.



   Chris Maxwell
   Unix SysAdmin, Faculty of Computer Science, Dalhousie University
   Halifax, Nova Scotia, Canada
   (902) 494-1369 / chris.maxwell@dal.ca / FAX: (902) 492-1517
---1384045802-408353636-1471637924=:23388--
