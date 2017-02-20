From: Martin Bosner <martin@bosner.de>
Subject: assistance recovering failed raid6 array
Date: Mon, 20 Feb 2017 02:49:18 +0100
Message-ID: <58AA4B1E.1030809@bosner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am running a software raid6 with 36 x 3TB disks (sda to sdaj). All
disks have one partition (gpt, 100%, primary, raid on) and i am using
btrfs on top of the raid.

Last week one of the disks failed and was unrecoverable. I replaced the
disk (sdk) with a new one and the resync process started.
At around 80% recovery two further disks failed and the recovery process
was stopped. That failed disks are sdm and sdh.

All other disks seem to be fine and I was about the use the "mdadm
--create" command when i remembered the lines
"You have been warned! It's better to send an email to the linux-raid
mailing list with detailed information"

So here i am for an advice how to continue.

More details:

Only 35% of the raid space is used.

The disks status is:
sdk: original disk is dead and the replacement was around 80% recovered.
sdm: i was able to copy the first 2 TB with two errors (128kbyte) and
the third TB with around 200GB missing data using ddrescue to a new disk.
sdh: the original disk is dead and i replaced it with a brand new one
and created the partition sdh1.

Since the array is offline i cannot add sdh1 to the raid and trying to
assemble the array gives me:

For mdadm --assemble --force with sdh1:
mdadm: no RAID superblock on /dev/sdh1
mdadm: /dev/sdh1 has no superblock - assembly aborted

For mdadm --assemble --force without sdh1:
mdadm: /dev/md0 assembled from 33 drives, 1 rebuilding and 1 spare - not
enough to start the array.

Full status of /dev/sda1:

mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 5c7c227e:22de5fc1:ca3ebb65:9c283567
           Name : media-storage:0  (local to host media-storage)
  Creation Time : Sun Sep 18 22:46:42 2016
     Raid Level : raid6
   Raid Devices : 36

 Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Array Size : 99624556544 (95009.38 GiB 102015.55 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : f90e9c41:5aa3c3b2:d715781b:1abbb439

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Feb 15 14:08:28 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : b0b57ef2 - correct
         Events : 140559

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAA.AA.AAAAAAAAAAAAAAAAAAAAAAAAA ('A' == active,
'.' == missing, 'R' == replacing)


mdadm --examine for each drive to get "Device Role":

"sda    Device Role : Active device 0"
"sdb    Device Role : Active device 1"
"sdc    Device Role : Active device 2"
"sdd    Device Role : Active device 3"
"sde    Device Role : Active device 4"
"sdf    Device Role : Active device 5"
"sdg    Device Role : Active device 6"
"sdh" mdadm: No md superblock detected on /dev/sdh1.
"sdi    Device Role : Active device 8"
"sdj    Device Role : Active device 9"
"sdk    Device Role : spare"
"sdl    Device Role : Active device 11"
"sdm    Device Role : Active device 12"
"sdn    Device Role : Active device 13"
"sdo    Device Role : Active device 14"
"sdp    Device Role : Active device 15"
"sdq    Device Role : Active device 16"
"sdr    Device Role : Active device 17"
"sds    Device Role : Active device 18"
"sdt    Device Role : Active device 19"
"sdu    Device Role : Active device 20"
"sdv    Device Role : Active device 21"
"sdw    Device Role : Active device 22"
"sdx    Device Role : Active device 23"
"sdy    Device Role : Active device 24"
"sdz    Device Role : Active device 25"
"sdaa    Device Role : Active device 26"
"sdab    Device Role : Active device 27"
"sdac    Device Role : Active device 28"
"sdad    Device Role : Active device 29"
"sdae    Device Role : Active device 30"
"sdaf    Device Role : Active device 31"
"sdag    Device Role : Active device 32"
"sdah    Device Role : Active device 33"
"sdai    Device Role : Active device 34"
"sdaj    Device Role : Active device 35"


The system is Ubuntu 16.04.2 LTS (x86_64) with a 4.4.0-62-generic kernel.

mdadm --version gives me: mdadm - v3.3 - 3rd September 2013

-- 

<https://www.postbox-inc.com/?utm_source=email&utm_medium=siglink&utm_campaign=reach>
