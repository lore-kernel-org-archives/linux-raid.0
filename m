From: Thomas Horsten <thomas@horsten.com>
Subject: Driver for BIOS-based software RAIDs
Date: Mon, 13 Oct 2003 19:21:45 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310131921.45824.thomas@horsten.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've written a driver for the Medley software RAID using the ATARAID framework 
in 2.4 kernels (http://www.infowares.com/linux).

Now, I'm looking into writing a better driver that can also be used with 2.6. 
My thoughts are along the lines of using the MD driver infrastructure and 
adding support for "foreign" RAID superblocks (and possibly personalities).

For the Medley RAID this could be quite an elegant solution, as the Medley 
modes are identical to MD's RAID0 and RAID1 and modes (and the RAID10 mode 
identical to a RAID0 embedded in a RAID1 array).

Now, the problem is that these BIOS based software RAID's all use whole disks 
as opposed to individual partitions like the Linux MD driver.

My idea was to either reserve a new major for "md_wholedisk" mode and split it 
into drive,partition blocks of 16/32 inodes each, like the gendisk driver 
supports, or alternatively split the existing major with, say, the first 64 
minors for normal style MD devs and the upper part split like I suggested 
above (I'm not sure if this would work with gendisk though).

Another way of doing it would be to create a separate native MD RAID for each 
partition on the BIOS RAID, but this has the major drawback that the user 
wouldn't be able to repartition the device.

Brief outline of how this would work:

1) User selects CONFIG_MD_FOREIGN_SUPERBLOCKS and CONFIG_MD_WHOLEDISK_RAID, 
along with one oif the BIOS specific drivers like CONFIG_MD_FOREIGN_MEDLEY. 
Each BIOS driver has its own superblock type.

2a) If compiled into the kernel, a hook in the partition parser will first 
pass each drive to the RAID handler, before attempting to parse the partition 
table. RAID handler will call each FOREIGN_driver in turn to see if there is 
a matching RAID superblock. If there is, it will be added as a partial RAID 
and the partition checker will not try to parse the partition table (which 
will be invalid if the drive is part of a RAID).

2b) If the foreign RAID drivers are compiled as modules, upon loading they 
will walk all genhds (or devices they will support), and detect any custom 
superblocks. The drivers will then use a new hook in the genhd code to zero 
out any partitions on that device.

3) The foreign RAID driver creates mddev_s based on its detection. If 
necessary, the foreign RAID driver can also create its own personalities 
(like the special type of RAID0 that Highpoint devices use, that supports 
having a RAID0 where all disks are not of equal size, without wasting space).

Any comments and ideas so far? Is this approach viable?

Thanks :)

Regards,

Thomas

