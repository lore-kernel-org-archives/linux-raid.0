From: Paul Tonelli <paul@tonel.li>
Subject: Recovery after accidental raid5 superblock rewrite
Date: Sat, 3 Jun 2017 21:46:44 +0200
Message-ID: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I am trying to recover an ext4 partition on lvm2 on raid5. After reading 
to find solutions by myself, I tried to go on the freenod irc linux-raid 
channel, who advised me to describe my problem here, so here I am.

The first part of the mail describes what led to my issue, the second 
part is what I tried to solve it, the third is my current status, the 
fourth are the questions. the mail can be read in markdown.

Part I: creation and loss of the array
=============================================

The raid is on 3 sata disks of 3Tb each. It was initialised as:

```
mdadm --create --verbose --force /dev/md0 --level=5 --raid-devices=2  
/dev/sdb /dev/sdc
pvcreate /dev/md0
vgcreate vg0 /dev/md0
lvcreate -L 2.5T -n data /dev/vg0 #command guessed from the lvm archives 
files
mkfs.ext4 /dev/vg0/data
```

the raid did not initialize correctly at each boot I had to rebuild the 
disk using :

```
mdadm --create --verbose --force --assume-clean /dev/md0 --level=5 
--raid-devices=2  /dev/sdb /dev/sdc
```

it would then mount without issue (autodetection of the vg and lv worked)

I then extended as follow to add a third disk, (hot plugged to the 
system this has its importance). The raid had the time to grow and I was 
able to extend everything on top of it:

```
sudo mdadm --add /dev/md0 /dev/sdd
sudo mdadm --grow --raid-devices=3 /dev/md0
sudo lvextend -L +256G /dev/mapper/vg0-data
sudo resize2fs /dev/vg0/data
sudo lvextend -L +256G /dev/mapper/vg0-data
sudo resize2fs /dev/vg0/data
sudo lvresize -L +500G  /dev/vg0/data
sudo resize2fs /dev/vg0/data
```

Here the machine crashed for unrelated reasons

The data was not backupped: this was a transition situation where we 
regrouped data from several machines and the backup nas was being setup 
when this occured (this was the first mistake).

at reboot, I could not reassemble the raid and I did (this was the 
second mistake, I had not read the wiki at this time):

mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb 
/dev/sdc /dev/sdd

I realized my error half an hour later when I could not detect any 
volume group or mount anything and immediately stopped the rebuild of 
drive sdd which was occuring (it was stopped <5%, so the first 5% of 
disk sdd are now wrong).

Actually, between the reboots, the hard drive order had changed (because 
the disk had been hotplugged initially), the most probable change is:

sdc became sdd
sdb became sdc
sdd became sdb

I immediately made backups of the three disks to spares using dd (to sde 
sdf and sdg) and have been testing different methods to get back my data 
ever since without success.

I made another mistake during the 3 days I spent trying to recover the 
data, I switched two disks ids in a dd command and overwrite the first 
800Mb or so of disk c:

```
dd if=/dev/sdc of=/dev/sdf bs=64k count=12500
```

The data contained on the disks is yml files, pictures (lots of it, with 
a specific order) and binary files. Recovering of huge yml (Gb long) and 
the structure of the filesystem are the most important data.

Part 2: What I tried
====================

The main test has been to rebuild the raid5 with the different possible 
disk orders and try to detect data on it.

I tried several disk orders, restored the physical volume, volume group 
and logical volume using:

```
mdadm --create --assume-clean --level=5 --raid-devices=3 /dev/md0 
/dev/sdc missing /dev/sdb
pvcreate --uuid "Q2Z32D-iyPj-9QYp-uXBC-q02e-s8QK-6eqv4d" --restorefile 
/home/ptonelli/backup_raid/lvm/backup/vg0 /dev/md0
vgcfgrestore vg0 -f /home/ptonelli/backup_raid/lvm/backup/vg0
vgchange -a a vg0
testdisk /dev/vg0/data
```

and did a deep scan of the disks and let it run until it reached 3%. I 
got the following data (m for missing):

- sdd(m) sdb sdc : 258046 782334 1306622 1830910 2355198
- sdd(m) sdc sdb : 783358 1306622, 23562222
- sdb sdd(m) sdc : 258046 1307646 1830910
- sdc sdd(m) sdb : 259070 783358 1307646 1831834 235622
- sdb sdc sdd(m) : nothing detected
- sdc sdb sdd(m) : 259070 782334 1831934 235198

I wrote only the ext4 superblocks start position returned by testdisk), 
the rest of the data was the same each time and matched the ext4 
partition size I am trying to recover.

between each test, I restored the disks with the following method:

```
vgchange -a n vg0
mdadm --stop /dev/md0
dd if=/dev/sde of=/dev/sdb bs=64k count=125000
dd if=/dev/sdf of=/dev/sdc bs=64k count=125000
dd if=/dev/sdg of=/dev/sdd bs=64k count=125000
```

on the most promising orders ([sdc, missing, sdb] and [missing, sdb, 
sdc])  i tried to rebuild the ext4 filesystem from the earliest 
superblock using):

```
for i in $(seq 0 64000);do echo $i;e2fsck -b $i /dev/vg0/data;done
#and then
e2fsck -b 32XXX /dev/vg0/data -y
```

Each time the superblock was found aroud block 32000 , with a little 
difference between the two attempts.

I let it run, it ran fixing/deleting... inodes for 3 hours (from the 
output, one out of 10 inodes was modified during the repair), after 3 
hours it was still at ~22 000 000 inodes so I guess the disk structure 
is incorrect, I expected the repair to  be a lot shorter with correct 
structure.

I completely restored the disk between and after the tests with dd.

Part 3: current situation
=========================

So What I have:

- all three raid superblocks are screwed and were overwritten without 
backup, but I have the commands used to build the initial backup
- I have all the incremental files for the lvm2 structure and the latest 
file matches the ext4 superblocks found on the disks
- I have "nearly" complete backup of the three raid5 disks:
   - one is good appart from the raid superblock (sdb)
   - one is missing ~1 GB at the start (sdc)
   - one is missing ~120 GB at the start of the array, I have marked 
this disk as missing for all my tests

but I cannot find my data.

additional system info:
the machine is running with an amd64 debian jessie with backports 
enabled, mdadm is the standard debian: v3.3.2 - 21st August 2014

I put here the relevant part of the lvm backup and archive files (I can 
provide the full files if necessary)

before extension:

```
physical_volumes {

pv0 {
         id = "Q2Z32D-iyPj-9QYp-uXBC-q02e-s8QK-6eqv4d"
         device = "/dev/md0"     # Hint only

         status = ["ALLOCATABLE"]
         flags = []
         dev_size = 5860270080   # 2.7289 Terabytes
         pe_start = 2048
         pe_count = 715364       # 2.7289 Terabytes
         }
}

logical_volumes {

data {
id = "OwfU2H-UStb-fkaD-EAvk-fetk-CiOk-xkaWkA"
creation_time = 1494949403      # 2017-05-16 17:43:23 +0200
segment_count = 1

segment1 {
         start_extent = 0
         extent_count = 681575   # 2.6 Terabytes

         type = "striped"
         stripe_count = 1        # linear

         stripes = [
                 "pv0", 0
         ]
```

after extension:

```
pv0 {
         id = "Q2Z32D-iyPj-9QYp-uXBC-q02e-s8QK-6eqv4d"
         device = "/dev/md0"     # Hint only

         status = ["ALLOCATABLE"]
         flags = []
         dev_size = 11720538112  # 5.4578 Terabytes
         pe_start = 2048
         pe_count = 1430729      # 5.4578 Terabytes
}
}

logical_volumes {

data {
creation_time = 1494949403      # 2017-05-16 17:43:23 +0200
segment_count = 1

segment1 {
         start_extent = 0
         extent_count = 1065575  # 4.06485 Terabytes

         type = "striped"
         stripe_count = 1        # linear

         stripes = [
                 "pv0", 0
         ]
```

from the raid wiki, I believe only this information is useful as the 
raid superblocks are wrong:

```
PCI [ahci] 00:11.4 SATA controller: Intel Corporation Wellsburg sSATA 
Controller [AHCI mode] (rev 05)
├scsi 0:0:0:0 ATA      Crucial_CT1050MX {1651150EFB63}
│└sda 978.09g [8:0] Partitioned (gpt)
│ ├sda1 512.00m [8:1] vfat {5AB9-E482}
│ │└Mounted as /dev/sda1 @ /boot/efi
│ ├sda2 29.80g [8:2] ext4 {f8f9eb9a-fc49-4b2b-8c8c-27278dfc7f29}
│ │└Mounted as /dev/sda2 @ /
│ ├sda3 29.80g [8:3] swap {1ea1c6c1-7ec7-49cc-8696-f1fb8fb6e7b0}
│ └sda4 917.98g [8:4] PV LVM2_member 910.83g used, 7.15g free 
{TJKWU2-oTcU-mSBC-sGHz-ZTg7-8HoY-u0Tyjj}
│  └VG vg_ssd 917.98g 7.15g free {hguqji-h777-K0yt-gjma-gEbO-HUfw-NU9aRK}
│   └redacted
├scsi 1:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N3EP81NC}
│└sdb 2.73t [8:16] Partitioned (gpt)
│ ├sdb1 2.37g [8:17] ext4 '1.42.6-5691' 
{30ef58b3-1e3f-4f33-ade7-7365ebd8c427}
│ ├sdb2 2.00g [8:18] Empty/Unknown
│ └sdb3 2.72t [8:19] Empty/Unknown
├scsi 2:0:0:0 ATA      WDC WD30EFRX-68E {WD-WMC4N1087039}
│└sdc 2.73t [8:32] Partitioned (gpt)
└scsi 3:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N3EP8C25}
  └sdd 2.73t [8:48] Partitioned (gpt)
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation Wellsburg 6-Port 
SATA Controller [AHCI mode] (rev 05)
├scsi 4:x:x:x [Empty]
├scsi 5:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N0XARKSC}
│└sde 2.73t [8:64] Partitioned (gpt)
│ ├sde1 2.37g [8:65] ext4 '1.42.6-5691' 
{30ef58b3-1e3f-4f33-ade7-7365ebd8c427}
│ ├sde2 2.00g [8:66] Empty/Unknown
│ └sde3 2.72t [8:67] Empty/Unknown
├scsi 6:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N7KPUH6U}
│└sdf 2.73t [8:80] Partitioned (gpt)
├scsi 7:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N1TYVTEN}
│└sdg 2.73t [8:96] Partitioned (gpt)
├scsi 8:x:x:x [Empty]
└scsi 9:x:x:x [Empty]
Other Block Devices
└md0 0.00k [9:0] MD vnone  () clear, None (None) None {None}
                  Empty/Unknown
```


I am currently digging on the mailing list archive to find more 
information and things to test.

Part 4: Questions
==================

- How much am I screwed ? Do you believe I can still get most of my data 
back, what about the ext4 folder tree ?

- what should be my next steps (I would be happy to use any link to 
relevant software/procedures).

- Is all the necessary information here or should I gather additional 
information before continuing

- I am a the point where hiring somebody / a company with better 
experience than mine to solve this issue is necessary. If yes who would 
you advise, if this is an allowed question on the mailing list ?


Thank you for reading me down to this point, and thank you for your 
answer if you can take the time to answer.
