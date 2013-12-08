From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 04:18:32 -0600
Message-ID: <52A44778.8040502@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guys,

  I have an older box that is a fax server where the Event Count for /dev/md1 is
off by 1, but the array cannot be reassembled with --assemble --force /dev/dm1
/dev/sda5 /dev/sdb5. Per the warnings in the wiki, I'm asking for help before I
go attempt to recreate the array and screw something up. Here is the relevant
information. The box is running openSuSE 11 (2.6.25) with mdraid 2.6.4. This box
has run flawlessly for years.

  I have 3 mdraid partitions on this box:

  /dev/md0 sda1/sdb1   /boot
  /dev/md1 sda5/sdb5   /
  /dev/md2 sda7/sdb7   /home

  After booting the 11.0 install dvd and booting Recovery Console, mdraid found
and assembled all arrays, md0 and md2 are fine, its is just md1 that is the problem:

# cat /proc/mdstat
Personalities : [raid1]
md2 : active raid1 sda7[0] sdb7[1]
      221929772 blocks super 1.0 [2/2] [UU]
          bitmap: 0/424 pages [0KB], 256KB chunk

md1 : inactive sda5[0] sdb5[1]
      41945504 blocks super 1.0

md0 : active raid1 sda1[0] sdb1[1]
      104376 blocks super 1.0 [2/2] [UU]
          bitmap: 0/7 pages [0KB], 8KB chunk

  The array information on disk for both disks (sda5/sdb5) shows the exact same
Update Time, (Tue Nov 19 15:28:38 2013) the only difference between the output
is the checksums (both shown correct) and the Events : 148/149 The full output
of mdadm --examine /dev/sd[ab]5 is here and in a (1.7 M screenshot) below:

          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
           Name : 1
  Creation Time : Thu Aug 21 06:43:22 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 41945504 (20.00 GiG 21.48 GB)
     Array Size : 41945504 (20.00 GiG 21.48 GB)
   Super Offset : 41945632 sectors
          State : clean
    Device UUID : e8c1c580:db4d853e:6fac1c8f:fb5399d7

Internal Bitmap : -81 sectors from superblock
    Update Time : Tue Nov 19 15:28:38 2013
       checksum : d37d1086 - correct
         Events : 148

     Array Slot : 0 (0,1)
    Array State : Uu

          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
           Name : 1
  Creation Time : Thu Aug 21 06:43:22 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 41945504 (20.00 GiG 21.48 GB)
     Array Size : 41945504 (20.00 GiG 21.48 GB)
   Super Offset : 41945632 sectors
          State : clean
    Device UUID : 6edfa3f8:c8c4316d:66c19315:5eda0911

Internal Bitmap : -81 sectors from superblock
    Update Time : Tue Nov 19 15:28:38 2013
       checksum : 39ef40a5 - correct
         Events : 149

     Array Slot : 1 (0,1)
    Array State : uU

http://www.3111skyline.com/dl/screenshots/suse/mdadm-examine.jpg  (1.7 Meg)

  I have read through https://raid.wiki.kernel.org/index.php/RAID_Recovery and I
can confirm that mdadm --stop /dev/md1, stops the array and removes the device
for the information shown in cat /proc/mdstat. I have attempted to assemble and
force to get the array running but I am left with the same Input/Output error.

  What does it look like the next proper course of action should be? I am new to
triaging non-working raid arrays, so all I can do is read. The next step appears
to be recreating the drives and hoping it all works. Am I at that "last resort"
yet? or are there a few more tricks to try. Thank you in advance for any help
you can give.
-- 
David C. Rankin, J.D.,P.E.
