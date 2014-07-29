From: "Matthias Appel" <appel.matthias@gmail.com>
Subject: Crash during recover
Date: Tue, 29 Jul 2014 12:30:53 +0200
Message-ID: <026c01cfab18$2f479960$8dd6cc20$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a problem with my 4 disk software raid 5.
I had a defective disk which I identified and changed and the rebuild
started.

But somewhere around 6pm the machine crashed and I had to reset it this
morning.
The problem is the raid won't start because it complains about missing
drives.

I did mdadm -examine and saw the event counter on one disk was slightly off
and obviously two disks fell off the raid the same time, giving me ..AA like
you see down below.

I tried to force assemble the array and I got the message about the event
counter being adjusted.
I assumed the raid would start now, like multiple times before I had same
issues with multiple failing drives/controllers

But this time not....I says that the raid is missing 2 disks but examine
looks not this bad AFAIKS.
I read the recovery wiki entry, but there it tells me to recreate the array
without initial sync but I don't want to go this way because I think this
should only be the last resort.

Can anybody look at the mdadm --examine of my disks and tell me why my raid
is complaining about missing disks and how to recover from this issue:

If you need some more information, pleas tell me, what you need and I will
try to get it!

Thanks in advance,

Matthias




Here is the --examine of the disks after the force-assemble

/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2e92b765:730a9310:870e48a2:7f759d45
           Name : backup:0
  Creation Time : Mon Aug 26 17:04:55 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c98c2108:b11f4325:1f253a63:41e34ffc

    Update Time : Mon Jul 28 18:05:08 2014
       Checksum : a815fb01 - correct
         Events : 97489

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : ..AA ('A' == active, '.' == missing)
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2e92b765:730a9310:870e48a2:7f759d45
           Name : backup:0
  Creation Time : Mon Aug 26 17:04:55 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1c3c0ae0:95795583:5dab91d2:e3c6c498

    Update Time : Mon Jul 28 18:04:41 2014
       Checksum : e9dc6dfb - correct
         Events : 97489

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.AA ('A' == active, '.' == missing)
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2e92b765:730a9310:870e48a2:7f759d45
           Name : backup:0
  Creation Time : Mon Aug 26 17:04:55 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 346359eb:bc603745:24a9fdbb:8066b03a

    Update Time : Mon Jul 28 18:05:08 2014
       Checksum : 426619bd - correct
         Events : 97489

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : ..AA ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 2e92b765:730a9310:870e48a2:7f759d45
           Name : backup:0
  Creation Time : Mon Aug 26 17:04:55 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 8790405120 (8383.18 GiB 9001.37 GB)
  Used Dev Size : 5860270080 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fef8f1d6:146d44c5:80ff2aa5:31943690

    Update Time : Mon Jul 28 18:05:08 2014
       Checksum : ecbf3d9a - correct
         Events : 97489

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ..AA ('A' == active, '.' == missing)



