From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 09:50:16 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: apiszcz@solarrain.com
List-Id: linux-raid.ids

The (up to) 30% percent figure is mentioned here:
http://insights.oetiker.ch/linux/raidoptimization.html

On http://forums.storagereview.net/index.php?showtopic=25786:
This user writes about the problem:
XP, and virtually every O/S and partitioning software of XP's day, by default places the first partition on a disk at sector 63. Being an odd number, and 31.5KB into the drive, it isn't ever going to align with any stripe size. This is an unfortunate industry standard.
Vista on the other hand, aligns the first partition on sector 2048 by default as a by-product of it's revisions to support large-sector sized hard drives. As RAID5 arrays in write mode mimick the performance characteristics of large-sector size hard drives, this comes as a great if not inadvertent benefit. 2048 is evenly divisible by 2 and 4 (allowing for 3 and 5 drive arrays optimally) and virtually every stripe size in common use. If you are however using a 4-drive RAID5, you're SOOL.

Page 9 in this PDF (EMC_BestPractice_R22.pdf) shows the problem graphically:
http://bbs.doit.com.cn/attachment.php?aid=6757

------

Now to my setup / question:

# fdisk -l /dev/sdc

Disk /dev/sdc: 150.0 GB, 150039945216 bytes
255 heads, 63 sectors/track, 18241 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x5667c24a

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       18241   146520801   fd  Linux raid autodetect

---

If I use 10-disk RAID5 with 1024 KiB stripe, what would be the correct 
start and end size if I wanted to make sure the RAID5 was stripe aligned?

Or is there a better way to do this, does parted handle this situation 
better?

What is the best (and correct) way to calculate stripe-alignment on the 
RAID5 device itself?

---

The EMC paper recommends:

Disk partition adjustment for Linux systems
In Linux, align the partition table before data is written to the LUN, as 
the partition map will be rewritten
and all data on the LUN destroyed. In the following example, the LUN is 
mapped to
/dev/emcpowerah, and the LUN stripe element size is 128 blocks. Arguments 
for the fdisk utility are
as follows:
fdisk    /dev/emcpowerah
x      # expert mode
b      # adjust starting block number
1      # choose partition 1
128 #    set it to 128, our stripe element size
w      # write the new partition

---

Does this also apply to Linux/SW RAID5?  Or are there any caveats that are 
not taken into account since it is based in SW vs. HW?

---

What it currently looks like:

Command (m for help): x

Expert command (m for help): p

Disk /dev/sdc: 255 heads, 63 sectors, 18241 cylinders

Nr AF  Hd Sec  Cyl  Hd Sec  Cyl     Start      Size ID
  1 00   1   1    0 254  63 1023         63  293041602 fd
  2 00   0   0    0   0   0    0          0          0 00
  3 00   0   0    0   0   0    0          0          0 00
  4 00   0   0    0   0   0    0          0          0 00

Justin.
