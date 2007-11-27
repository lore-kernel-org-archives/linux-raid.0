From: ChristopherD <christopherthe1@yahoo.com>
Subject: Abysmal write performance on HW RAID5
Date: Tue, 27 Nov 2007 14:01:22 -0800 (PST)
Message-ID: <13980960.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


In the process of upgrading my RAID5 array, I've run into a brick wall (<
4MB/sec avg write perf!) that I could use some help figuring out.  I'll
start with the quick backstory and setup.

Common Setup:

Dell Dimension XPS T800, salvaged from Mom. (i440BX chipset, Pentium3 @
800MHZ)
768MB DDR SDRAM @ 100MHZ FSB  (3x256MB DIMM)
PCI vid card (ATI Rage 128)
PCI 10/100 NIC (3Com 905)
PCI RAID controller (LSI MegaRAID i4 - 4 channel PATA)
4 x 250GB (WD2500) UltraATA drives, each connected to separate channels on
the controller
Ubuntu Feisty Fawn

In the LSI BIOS config, I setup the full capacity of all four drives as a
single logical disk using RAID5 @ 64K strips size.  I installed the OS from
the CD, allowing it to create a 4GB swap partition (sda2) and use the rest
as a single ext3 partition (sda1) with roughly 700GB space.

This setup ran fine for months as my home fileserver.  Being new to RAID at
the time, I didn't know or think about tuning or benchmarking, etc, etc.  I
do know that I often moved ISO images to this machine from my gaming rig
using both SAMBA and FTP, with xfer limited by the 100MBit LAN (~11MB/sec).

About a month or so ago, I hit capacity on the partition.  I dumped some
movies off to a USB drive (500GB PATA) and started watching the drive aisle
at Fry's.  Last week, I saw what I'd been waiting for: Maxtor 500GB drives @
$99 each.  So, I bought three of them and started this adventure.


I'll skip the details on the pain in the butt of moving 700GB of data onto
various drives of various sizes...the end result was the following change to
my setup:

3 x Maxtor 500GB PATA drives (7200rpm, 16MB cache)
1 x IBM/Hitachi Deskstar 500GB PATA (7200rpm, 8MB cache)

Each drive still on a separate controller channel, this time configured into
two logical drives:
Logical Disk 1:  RAID0, 16GB, 64K stripe size (sda)
Logical Disk 2:  RAID5, 1.5TB, 128K stripe size (sdb)


I also took this opportunity to upgrade to the newest Ubuntu 7.10 (Gutsy),
and having done some reading, planned to make some tweaks to the partition
formats.  After fighting with the standard CD, which refused to install the
OS without also formatting the root partition (but not offering any control
of the formatting), i downloaded the "alternate CD" and used the textmode
installer.

I set up the partitions like this:
sda1: 14.5GB ext3, 256MB journal (mounted data_ordered), 4K block size,
stride=16, sparse superblocks, no resize_inode, 1GB reserved for root
sda2: 1.5GB linux swap
sdb1: 1.5TB ext2, largefile4 (4MB per inode), stride=32, sparse superblocks,
no resize_inode, 0 reserved for root

The format command was my first hint of a problem.  The block group creation
counter spun very rapidly up to 9800/11600 and then paused and I heard the
drives thrash.  The block groups completed at a slower pace, and then the
final creation process took several minutes.

But the real shocker was transferring my data onto this new partition.  FOUR
MEGABYTES PER SECOND?!?!

My initial plan was to plug a single old data drive into the motherboard's
ATA port, thinking the transfer speed within a single machine would be the
fastest possible mechanism.  Wrong.  I ended up mounting the drives using
USB enclosures to my laptop (RedHat EL 5.1) and sharing them via NFS.

So, deciding the partition was disposable (still unused), I fired up dd to
run some block device tests:
dd if=/dev/zero of=/dev/sdb bs=1M count=25

This ran silently and showed 108MB/sec??  OK, that beats 4...let's try
again!  Now I hear drive activity, and the result says 26MB/sec.  Running it
a third time immediately brought the rate down to 4MB/sec.  Apparently, the
first 64MB or so runs nice and fast (cache? the i4 only has 16MB onboard).

I also ran iostat -dx in the background during a 26GB directory copy
operation, reporting on 60-sec intervals.  This is a typical output:

Device:    rrqm/s  wrqm/s    r/s    w/s    rMB/s  wMB/s  avgrq-sz  avgqu-sz 
await    svctm  %util
sda          0.00     0.18      0.00  0.48   0.00   0.00        11.03   
0.01         21.66    16.73   0.61
sdb          0.00     0.72      0.03  64.28  0.00   3.95       125.43  
137.57    2180.23  15.85   100.02


So, the RAID5 device has a huge queue of write requests with an average wait
time of more than 2 seconds @ 100% utilization?  Or is this a bug in iostat?

At this point, I'm all ears...I don't even know where to start.  Is ext2 not
a good format for volumes of this size?  Then how to explain the block
device xfer rate being so bad, too?  Is it that I have one drive in the
array that's a different brand?  Or that it has a different cache size?

Anyone have any ideas?
-- 
View this message in context: http://www.nabble.com/Abysmal-write-performance-on-HW-RAID5-tf4884768.html#a13980960
Sent from the linux-raid mailing list archive at Nabble.com.

