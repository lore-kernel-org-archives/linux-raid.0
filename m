From: Pieter De Wit <pieter@insync.za.net>
Subject: Is partition alignment needed for RAID partitions ?
Date: Mon, 30 Dec 2013 10:04:35 +1300
Message-ID: <52C08E63.8020800@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi List,

I am taking advantage of the holiday season by testing some NAS devices 
for work. This now allows me to rebuild my home storage.

My current setup is as follow:

/dev/sda 250 gig drive (/boot is mounted here since I had no other use 
for the drive)
/dev/sdb 2TB drive
/dev/sdc 2TB drive

/dev/sdb and sdc has two MD devices on them, a RAID1 and a RAID0 device. 
/dev/sdb and sdc was taken out of a MAC server, so the partition table 
is a mess, I want to rebuild them.

All of these house LVM PV's

The RAID1 device contains all my "critical" data ( root device, logs, 
photos etc) while the RAID0 device contains all data I have other 
sources for.

So my question is, do I need to align the partitions for the raid devices ?

These are desktop grade drives, but for the RAID0 device I saw quite low 
throughput (15meg/sec moving data to the NAS via gig connection). I just 
created a RAID1 device between /dev/sda and an iSCSI target on the NAS, 
and it synced at 48meg/sec, moving data at 30meg/sec - double that of 
the RAID0 device. I would have expected the RAID0 device to easily get 
up to the 60meg/sec mark ?

Cheers,

Pieter
