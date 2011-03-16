From: Xavier Brochard <xavier@alternatif.org>
Subject: inactive raid after kernel 2.6.32 update
Date: Wed, 16 Mar 2011 22:24:31 +0100
Message-ID: <201103162224.31958.xavier@alternatif.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody

I have a serious problem with software Raid10 on a Dell server. It started like 
a corrupted file system, but I quickly thought of a harware or raid problem. 
May be someone here can help me to understand and to properly recover my datas.

Here's a full description of my problem. It's too long but I don't want to forget something.

The Dell server is 3 months old, with a Perc 200 controler (that is, a LSI card) 
setup as a disk controler only for 6 sata-3 hard-drives and 1 sata-2 SSD card. 
5 HD are members of the Raid array, one is spare.
Each drive contains one partition

The software Raid10 is setup on 4 HD plus 1 spare. The whole hd are used, with 
one partition as raid. LVM is setup upon raid. System is on SSD.

Here's my fstab, sdb is the SSD:
--------------------------------------------------
# / was on /dev/sdb2 during installation
UUID=8bb91544-89f2-476b-83e5-0e05437b7323 /               ext4    errors=remount-ro,noatime 0       1
# /boot was on /dev/sdb1 during installation
UUID=5aae8f66-809f-41a3-b89e-caa53ba08b46 /boot           ext3    defaults,noatime        0       2
/dev/mapper/tout-home /home           ext4    usrquota,grpquota 0       2
/dev/mapper/tout-sauvegarde /home/sauvegardes ext4    noatime,noexec  0       2
/dev/mapper/tout-tmp /tmp            ext4    defaults,noatime        0       2
/dev/mapper/tout-var /var            ext4    defaults,noatime        0       2
/dev/mapper/tout-swap none            swap    sw              0       0

The OS is ubuntu Lucid, server version, kernel is 
Ubuntu 2.6.32-29.58-server 2.6.32.28+drm33.13

Problem started after a kernel update and a reboot. I was not there.
Someone gives me a phone call, describing a fsck problem: the system 
wasn't able to mount some partition and ask to skip or to fsck manually. 
I said skip and then I connected with ssh.

Actually, no partition from raid/lvm was mounted except swap.
I've run fsck on the /tmp partition, it started to fix and recover some files, 
ending in a partially recovered FS, with lots of I/O errors in syslog. Some 
directories were read-only, even for root. I've run a mkfs (without checking 
blocks) to see what would happened. It works but with plenty of I/O errors 
in syslog.
 
Looks like a hardware disk problem... but I was skeptical. 

/proc/mdstat gives me:
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md0 : inactive sdd1[2](S) sdg1[4](S) sdf1[3](S) sde1[1](S) sdc1[0](S)
      2441919680 blocks

A reboot on a previous kernel didn't help.
I've run Dell utilities to test the controler card (lsi) and half of the 
hard-drives with smart short-test. It gaves no errors.

Then I've booted on System-rescue-cd (which is still running).
I examined smart values and they looks ok.

Syslog show a little mpt2sas error:
mpt2sas0: failure at /build/buildd/linux-2.6.32/drivers/scsi/mpt2sas/mpt2sas_scsih.c:3801/_scsih_add_device()!
but some dell support forums talk about this as a cosmetic error.

Launching some mdadm commands
%mdam -Av /dev/md0 /dev/sd[cdefg]1
gives
mdadm: looking for devices for /dev/md0
mdadm: cannot open device /dev/sdc1: Device or resource busy
mdadm: /dev/sdc1 has no superblock - assembly aborted

% mdadm --stop /dev/md0
% mdadm -Av /dev/md0 /dev/sd[cdefg]1
gives
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 4.
mdadm: added /dev/sdc1 to /dev/md0 as 0
mdadm: added /dev/sde1 to /dev/md0 as 1
mdadm: added /dev/sdf1 to /dev/md0 as 3
mdadm: added /dev/sdg1 to /dev/md0 as 4
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: /dev/md0 assembled from 1 drive and 1 spare - not enough to start the array.


Launching
%mdadm --examine /dev/sd[cdefg]1
show 2 inverted hard-drives, sdc1 and sdd1, and a problem with sde1:

/dev/sdc1
-----------------
this  1  8  49  1  active sync  /dev/sdd1
0     0  8  33  0  active sync  /dev/sdc1
1     1  8  49  1  active sync  /dev/sdd1
2     2  8  65  2  active sync  /dev/sde1
3     3  8  81  3  active sync  /dev/sdf1 
4     4  8  97  4  spare        /dev/sdg1

/dev/sdd1
---------------
this  0  8  33  0  active sync  /dev/sdc1
0     0  8  33  0  active sync  /dev/sdc1
1     1  8  49  1  active sync  /dev/sdd1
2     2  8  65  2  active sync  /dev/sde1
3     3  8  81  3  active sync  /dev/sdf1 
4     4  8  97  4  spare        /dev/sdg1

/dev/sde1
-----------------
this  2  8  65  2  active sync  /dev/sde1
0     0  0   0  0  removed
1     1  0   0  1  faulty removed
2     2  8  65  2  active sync  /dev/sde1
3     3  0   0  3  faulty removed
(nothing for disk #5)

/dev/sdf1 and /dev/sdg1 are "normal".
A part of this, every disk is reported as clean with correct checksum.


Now I have some questions:
Can you help me to understand what happened ? 
Is it a hardware problem (lsi card or hard drive) or rather a software bug 
that has corrupted the partitions?
I'm not sure about the properly way to repair this, as long as I dont understand.

Should I recreate missing superblock or try to reassemble the array?

Thanks for any help you can provide.
kind regards,
Xavier
xavier@alternatif.org 
