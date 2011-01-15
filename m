From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Quick question about parted/fdisk for 2TB disks.
Date: Fri, 14 Jan 2011 20:52:49 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1101142052080.18371@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,


    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1        3891    31250000   fd  Linux raid autodetect
Partition 1 does not end on cylinder boundary.
/dev/sda2   *        3891        3907      131072   fd  Linux raid autodetect
Partition 2 does not end on cylinder boundary.
/dev/sda3            3907      243202  1922132488   fd  Linux raid autodetect
Partition 3 does not end on cylinder boundary.

But with parted, no issues:

(parted) print 
Model: ATA WDC WD2001FASS-0 (scsi)
Disk /dev/sda: 2000GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos

Number  Start   End     Size    Type     File system     Flags
  1      1049kB  32.0GB  32.0GB  primary  linux-swap(v1)  raid
  2      32.0GB  32.1GB  134MB   primary  ext3            boot, raid
  3      32.1GB  2000GB  1968GB  primary  ext4            raid

(parted)

Only use parted for 2TB+?

Justin.

