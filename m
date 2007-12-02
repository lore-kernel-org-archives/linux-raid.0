From: "Daniel Korstad" <dan@korstad.net>
Subject: RE: Abysmal write performance on HW RAID5
Date: Sun, 2 Dec 2007 09:58:49 -0600
Message-ID: <L4B9321A88C864e73A7DD2FB439CFD5BE.1196611095.gateway.korstad.net@MHS>
References: <13980960.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13980960.post@talk.nabble.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: christopherthe1@yahoo.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: ChristopherD [mailto:christopherthe1@yahoo.com]
> Sent: Sunday, December 02, 2007 4:03 AM
> To: linux-raid@vger.kernel.org
> Subject: Abysmal write performance on HW RAID5
> 
> 
> In the process of upgrading my RAID5 array, I've run into a brick wall 
(<
> 4MB/sec avg write perf!) that I could use some help figuring out.  
I'll
> start with the quick backstory and setup.
> 
> Common Setup:
> 
> Dell Dimension XPS T800, salvaged from Mom. (i440BX chipset, Pentium3 
@
> 800MHZ)
> 768MB DDR SDRAM @ 100MHZ FSB  (3x256MB DIMM)
> PCI vid card (ATI Rage 128)
> PCI 10/100 NIC (3Com 905)
> PCI RAID controller (LSI MegaRAID i4 - 4 channel PATA)
> 4 x 250GB (WD2500) UltraATA drives, each connected to separate 
channels on
> the controller
> Ubuntu Feisty Fawn
> 
> In the LSI BIOS config, I setup the full capacity of all four drives 
as a
> single logical disk using RAID5 @ 64K strips size.  I installed the OS
> from
> the CD, allowing it to create a 4GB swap partition (sda2) and use the 
rest
> as a single ext3 partition (sda1) with roughly 700GB space.
> 
> This setup ran fine for months as my home fileserver.  Being new to 
RAID
> at
> the time, I didn't know or think about tuning or benchmarking, etc, 
etc.
> I
> do know that I often moved ISO images to this machine from my gaming 
rig
> using both SAMBA and FTP, with xfer limited by the 100MBit LAN
> (~11MB/sec).

That sounds about right; 11MB * 8 (bit/Byte) = 88Mbit on your 100M LAN.

> 
> About a month or so ago, I hit capacity on the partition.  I dumped 
some
> movies off to a USB drive (500GB PATA) and started watching the drive
> aisle
> at Fry's.  Last week, I saw what I'd been waiting for: Maxtor 500GB 
drives
> @
> $99 each.  So, I bought three of them and started this adventure.
> 
> 
> I'll skip the details on the pain in the butt of moving 700GB of data 
onto
> various drives of various sizes...the end result was the following 
change
> to
> my setup:
> 
> 3 x Maxtor 500GB PATA drives (7200rpm, 16MB cache)
> 1 x IBM/Hitachi Deskstar 500GB PATA (7200rpm, 8MB cache)
> 
> Each drive still on a separate controller channel, this time 
configured
> into
> two logical drives:
> Logical Disk 1:  RAID0, 16GB, 64K stripe size (sda)
> Logical Disk 2:  RAID5, 1.5TB, 128K stripe size (sdb)
> 
> 
> I also took this opportunity to upgrade to the newest Ubuntu 7.10 
(Gutsy),
> and having done some reading, planned to make some tweaks to the 
partition
> formats.  After fighting with the standard CD, which refused to 
install
> the
> OS without also formatting the root partition (but not offering any
> control
> of the formatting), i downloaded the "alternate CD" and used the 
textmode
> installer.
> 
> I set up the partitions like this:
> sda1: 14.5GB ext3, 256MB journal (mounted data_ordered), 4K block 
size,
> stride=16, sparse superblocks, no resize_inode, 1GB reserved for root
> sda2: 1.5GB linux swap
> sdb1: 1.5TB ext2, largefile4 (4MB per inode), stride=32, sparse
> superblocks,
> no resize_inode, 0 reserved for root
> 
> The format command was my first hint of a problem.  The block group
> creation
> counter spun very rapidly up to 9800/11600 and then paused and I heard 
the
> drives thrash.  The block groups completed at a slower pace, and then 
the
> final creation process took several minutes.
> 
> But the real shocker was transferring my data onto this new partition.
> FOUR
> MEGABYTES PER SECOND?!?!
> 
> My initial plan was to plug a single old data drive into the 
motherboard's
> ATA port, thinking the transfer speed within a single machine would be 
the
> fastest possible mechanism.  Wrong.  I ended up mounting the drives 
using
> USB enclosures to my laptop (RedHat EL 5.1) and sharing them via NFS.
> 
> So, deciding the partition was disposable (still unused), I fired up 
dd to
> run some block device tests:
> dd if=/dev/zero of=/dev/sdb bs=1M count=25
> 
> This ran silently and showed 108MB/sec??  OK, that beats 4...let's try
> again!  Now I hear drive activity, and the result says 26MB/sec.  
Running
> it
> a third time immediately brought the rate down to 4MB/sec.  
Apparently,
> the
> first 64MB or so runs nice and fast (cache? the i4 only has 16MB 
onboard).
> 
> I also ran iostat -dx in the background during a 26GB directory copy
> operation, reporting on 60-sec intervals.  This is a typical output:
> 
> Device:    rrqm/s  wrqm/s    r/s    w/s    rMB/s  wMB/s  avgrq-sz  
avgqu-
> sz
> await    svctm  %util
> sda          0.00     0.18      0.00  0.48   0.00   0.00        11.03
> 0.01         21.66    16.73   0.61
> sdb          0.00     0.72      0.03  64.28  0.00   3.95       125.43
> 137.57    2180.23  15.85   100.02
> 
> 
> So, the RAID5 device has a huge queue of write requests with an 
average
> wait
> time of more than 2 seconds @ 100% utilization?  Or is this a bug in
> iostat?
> 
> At this point, I'm all ears...I don't even know where to start.  Is 
ext2
> not
> a good format for volumes of this size?  Then how to explain the block
> device xfer rate being so bad, too?  Is it that I have one drive in 
the
> array that's a different brand?  Or that it has a different cache 
size?
> 
> Anyone have any ideas?
> 
> 
> UPDATE:
> I attached another drive to the motherboard's IDE port and installed
> Windows
> 2003 Server.  I used the swap partition on the RAID0 volume and shrunk 
the
> ext2 filesystem to create some room on the RAID5 volume...these areas
> served
> as testbeds for the Windows write performance.  I used a 750MB ISO 
file as
> my test object, transferring it from another machine on my LAN via FTP 
as
> well as from the lone IDE drive on the same machine.  The lone drive 
FTP'd
> the file @ 11.5MB/sec, so that was my baseline.  The RAID0 volume 
matched
> this (no surprise), but the RAID5 volume was about 4.5MB/sec.  Same 
for
> internal transfers.  So the problem is not with the Linux 
driver...it's
> something in the hardware.
> 
> Right now, I've replaced the one "odd" Deskstar drive with another 
Maxtor
> 500GB/16MB cache drive that matches the other 3 drives in the array 
and
> letting the controller rebuild it.  I'll run more performance tests 
when
> it's done, but it's going to take quite a while.  In the meantime, I'd
> still
> appreciate hearing from the folks here.
> --
> View this message in context: http://www.nabble.com/Abysmal-write-
> performance-on-HW-RAID5-tf4884768.html#a13980960
> Sent from the linux-raid mailing list archive at Nabble.com.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Your LAN transfer sounds about right;
11MB * 8 (bits per Byte) = 88Mbit on your 100M LAN.

I have twelve drives in my system.  Two are in a RAID 1 for the OS with 
ext2 and ten are in a RAID 6 for my data in xfs.  When I notice a 
significant drop in performance on one my raided md# drive, it is 
usually a drive failing, somewhere... (If you have smart running it will 
yell at you at this point too)

I run the following to get a measurement of each drive that is in a raid 
set.  Usually if I am have problems there will be one in the bunch that 
has very low Timing buffered disk reads.  They are usually around 
50MB/sec for me;

hdparm -tT /dev/sd*  <-- If you have IDE drives use; /dev/hd*

/dev/sda:
 Timing cached reads:   2208 MB in  2.00 seconds = 1102.53 MB/sec
 Timing buffered disk reads:  172 MB in  3.01 seconds =  57.10 MB/sec

/dev/sda1:
 Timing cached reads:   2220 MB in  2.00 seconds = 1110.51 MB/sec
 Timing buffered disk reads:  172 MB in  3.01 seconds =  57.17 MB/sec

/dev/sdb:
 Timing cached reads:   2108 MB in  2.00 seconds = 1052.77 MB/sec
 Timing buffered disk reads:  164 MB in  3.03 seconds =  54.12 MB/sec

/dev/sdb1:
 Timing cached reads:   2256 MB in  2.00 seconds = 1126.57 MB/sec
 Timing buffered disk reads:  164 MB in  3.03 seconds =  54.20 MB/sec
.
.
.
. 

If you are having problems with sata controller chipset/drives on your 
Motherboard, that is a different issue...

