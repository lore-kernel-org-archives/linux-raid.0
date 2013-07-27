From: Richard Michael <rmichael@edgeofthenet.org>
Subject: Recovery help? 4-disk RAID5 double-failure, but good disks have event
 count mismatch.
Date: Sat, 27 Jul 2013 12:46:59 -0400
Message-ID: <CABR0jES0HHeyM6_7-whqLQgF6a+u4PCDAdyWPJ5Bp8g1umi2jA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

I have inherited a failed RAID5 and am attempting to recover as much
data as possible.   Full mdadm -E output at the bottom.

The RAID is 4 SATA disks, /dev/sd[abcd]3 and EXT4.

One disk is unable to talk to the controller, another is out-of-date,
the remaining two are current and match each other.

sdb spins up but fails to talk, the kernel hard resets the link
several times, then slows the link to 1.5Gb/s and retries, then
eventually gives up entirely (fail; then "EH complete").  I have no
/dev node, etc..

Bad sectors were found while ddrescue-coping sdc.  It was actually
kicked from the array back on 14-July-2013 02:26:00, and thus has a
lower event count than the remaining two good disks.

/dev/sdc3:
  Update Time : Sun Jul 14 02:26:00 2013
  Checksum : 5a16857a - correct
  Events : 308375


The remaining, functioning, disks sd[ad]3 are in "sync" with each
other, but 10 days (~70,000 events) ahead of sdc3:

/dev/sd[ad]3:
  Update Time : Wed Jul 24 14:01:52 2013
  Checksum : d7cff537 - correct
  Events : 378389


Questions:

0/ Any thoughts on the best method to proceed with recovery?


1/ What will happen if I --assemble --force?  I think the low event
count on sdc3 will be forced up to 378389 and the array will start
degraded.  The filesystem will be corrupted (missing "real/updated"
data on sdc3), but I can fsck and check lost+found to find damaged
file names.  I'll md5sum all against the latest (but old) "backup" to
find silent corruption.


2/ Could the write intent bitmap on sd[ad]3 go far enough back to
replay the last ~70K events to sdc3?  Generally, what are the
limitations of the bitmap -- how many events can be replayed?  I'm not
sure I have a clear understanding of the WIBM.


3/ Should the sdc superblock indicate information about it being
kicked?  It's listed as "clean" and sees all the drives active
('AAAA').


4/ Perhaps beyond the scope of linux-raid, I'm not sure what to do
about sdb.  I've tried different positions on the controller, and
re-orienting the drive (vertical, sideways, etc.).  I could send it
alone for recovery, perhaps.  I don't know how to get lower-level than
the kernel failing to talk to the device.  Perhaps a vendor diagnostic
tool?




Thank you very much in advance for your time and comments.  I hope
you're all having a better weekend than I am. :-)

Regards,
Richard



Full mdadm -E output:
-----------------------------------------

/dev/sda3:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 05d6b8b5:ad42cf19:452afe4d:a71d6f7c
           Name : system.domain.lan:2
  Creation Time : Sat Jul 14 22:31:26 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1871190016 (892.25 GiB 958.05 GB)
     Array Size : 2806783488 (2676.76 GiB 2874.15 GB)
  Used Dev Size : 1871188992 (892.25 GiB 958.05 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 3f59e1c5:c00d4583:2770f4a8:2e54ac7e

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 24 14:01:52 2013
       Checksum : d7cff537 - correct
         Events : 378389

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A..A ('A' == active, '.' == missing)



/dev/sdc3:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 05d6b8b5:ad42cf19:452afe4d:a71d6f7c
           Name : system.domain.lan:2
  Creation Time : Sat Jul 14 22:31:26 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1871190016 (892.25 GiB 958.05 GB)
     Array Size : 2806783488 (2676.76 GiB 2874.15 GB)
  Used Dev Size : 1871188992 (892.25 GiB 958.05 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : b6ceedcc:9bbe475c:a683e0f1:308e04d8

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Jul 14 02:26:00 2013
       Checksum : 5a16857a - correct
         Events : 308375

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)



/dev/sdd3:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 05d6b8b5:ad42cf19:452afe4d:a71d6f7c
           Name : system.domain.lan:2
  Creation Time : Sat Jul 14 22:31:26 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1871190016 (892.25 GiB 958.05 GB)
     Array Size : 2806783488 (2676.76 GiB 2874.15 GB)
  Used Dev Size : 1871188992 (892.25 GiB 958.05 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 2e0b87b5:f22c5571:fb5dc447:307eec7f

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Jul 24 14:01:52 2013
       Checksum : 5599c482 - correct
         Events : 378389

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A..A ('A' == active, '.' == missing)
