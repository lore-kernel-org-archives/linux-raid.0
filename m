From: DeadManMoving <sequel@neofreak.org>
Subject: failed RAID 5 array
Date: Wed, 12 Nov 2014 10:58:02 -0500
Message-ID: <1415807882.4241.36.camel@lappy.neofreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: DeadManMoving <sequel@neofreak.org>
List-Id: linux-raid.ids

Hi list,

I have a failed RAID 5 array, composed of 4 x 2TB drives without hot
spare. On the fail array, it looks like there is one drive out of sync
(the one with a lower Events counts) and another drive with a missing or
corrupted superblock (dmesg is reporting "does not have a valid v1.2
superblock, not importing!" and i have a : Checksum : 5608a55a -
expected 4108a55a).

All drives seems good though, the problem was probably triggered by a a
broken communication between the external eSATA expansion card and
external drive enclosure (card, cable or backplane in the enclosure i
guess...).

I am now in the process of making exact copies of the drives with dd to
other drives.

I have an idea on how to try to get my data back but i would be happy if
someone could help/validate with the steps i intent to follow to get
there.

On that array, i have ~ 85% of data which is already backed up somewhere
else, ~ 10% of data for which i do not care much, but there is ~ 5% of
data that is really important to me and for which i do not have other
copies around :|

So, here are the steps i intend to follow once the dd process is gonna
be over :


- take the drives which i made the dd on it
- try to create a new array on the two good drives, plus the one with
the superblock problem, by respecting the order (according to data i
have gathered from the drives), with the correct chunk size, with a
command like this :

# mdadm --create --assume-clean --level=5 --chunk=512
--raid-devices=4 /dev/md127 /dev/sdd /dev/sde /dev/sdb missing

- if the array is coming up nicely, will try to validate if fs is good
on it :

# fsck.ext4 -n /dev/md127

- if all is still fine, mount the array read-only and backup all i need
as fast as possible!

- then i guess i could add the drive (/dev/sdc) back to the array :

# mdadm --add /dev/md127 /dev/sdc



Can anyone tell me if those steps make sense? Does i miss something
obvious? Does i have any chance to recover my data with that procedure?
I would like to avoid trials and errors since it take 24 hours to make a
full copy of a drive with dd (4 days for the four drives).



Here is the output of mdadm --examine of my four drives :


/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d707f577:a9e572d5:e5d5f10c:b232f15a
           Name : abc:xyz  (local to host abc)
  Creation Time : Fri Aug  9 21:55:47 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=1200 sectors
          State : clean
    Device UUID : 2b438b47:db326d4a:0ae82357:1b88590d

    Update Time : Mon Nov 10 15:48:17 2014
       Checksum : ebfcf43 - correct
         Events : 9370

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)



/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xa
     Array UUID : d707f577:a9e572d5:e5d5f10c:b232f15a
           Name : abx:xyz  (local to host abc)
  Creation Time : Fri Aug  9 21:55:47 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
Recovery Offset : 0 sectors
   Unused Space : before=1960 sectors, after=1200 sectors
          State : active
    Device UUID : 011e3cbb:42c0ac0a:d6815904:2150169a

    Update Time : Mon Nov 10 15:44:07 2014
  Bad Block Log : 512 entries available at offset 72 sectors - bad
blocks present.
       Checksum : 7ca998a5 - correct
         Events : 9358

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)



/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d707f577:a9e572d5:e5d5f10c:b232f15a
           Name : abc:xyz  (local to host abc)
  Creation Time : Fri Aug  9 21:55:47 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=1200 sectors
          State : clean
    Device UUID : 67ffc02b:c8a013a7:3f17dc65:d1040e05

    Update Time : Mon Nov 10 15:48:17 2014
       Checksum : 5608a55a - expected 4108a55a
         Events : 9370

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)



/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : d707f577:a9e572d5:e5d5f10c:b232f15a
           Name : abc:xyz  (local to host abc)
  Creation Time : Fri Aug  9 21:55:47 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
     Array Size : 5860538880 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=1200 sectors
          State : clean
    Device UUID : 7b37a749:f1e575d1:50eea3c4:2083b9be

    Update Time : Mon Nov 10 15:48:17 2014
       Checksum : b6c477f4 - correct
         Events : 9370

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing, 'R' == replacing)





Thanks and regards,

Tony

