From: dfc <chernoff@astro.cornell.edu>
Subject: USB chasis fails, fate of the software raid?
Date: Wed, 18 Oct 2017 15:04:41 -0400
Message-ID: <1508353481.2692.9.camel@astro.cornell.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an Orico (3559SUSJ3) external 5 bay
hard disk drive enclosure attached via
USB to my desktop computer.

It holds 5 * 4 TB disks in raid5 and
has functioned for a couple of years.

Then the power supply (or fan
or some internal component of the chasis)
failed and -- from one boot to the next -- 
the chasis is DOA, i.e. it does not even power
on the disks. 

When last used, the drives were all active and 
in good shape; I copy below the output of the
mdadm --detail list
just a short time before the failure.

My main question is whether inserting
the 5 disks into another JBOD chasis
is likely to work? In particular is
mdadm "smart enough" to find all
the components and/or do I need to do
something to help it along? In fact,
our IT person has suggested that the
data may well be lost.

Details: 
raid5 (no spares)
20 TB
XFS filesystem
Debian 3.16.0-4-amd64

Also, since I first used the JBOD with software
raid I came to realize that the usb connection
is not a good choice (though I have never had
problems). What sort of connection (at the low
price end of the market for HDD enclosures)
would be better? eSata or something else?

Many thanks for answers/suggestions.
David
-----------------------------------------------------------
OUTPUT of mdadm --detail list

/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 954b2546:5c467e9c:a4eb74e3:27dad837
           Name : impala:0
  Creation Time : Fri May 22 15:32:31 2015
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : f0cda836:8c1c28d1:53710d20:db8d088a

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep  2 18:54:20 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 3d0d8085 - correct
         Events : 197036

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 954b2546:5c467e9c:a4eb74e3:27dad837
           Name : impala:0
  Creation Time : Fri May 22 15:32:31 2015
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 2e1a57ff:f892fb23:1f698390:53dd98e3

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep  2 18:54:20 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 22958a72 - correct
         Events : 197036

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 954b2546:5c467e9c:a4eb74e3:27dad837
           Name : impala:0
  Creation Time : Fri May 22 15:32:31 2015
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 3be7bbb4:4e5f07e3:f78f3c31:5bd6df6b

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep  2 18:54:20 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c00643b3 - correct
         Events : 197036

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 954b2546:5c467e9c:a4eb74e3:27dad837
           Name : impala:0
  Creation Time : Fri May 22 15:32:31 2015
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 2b09eed0:0a6ead54:48671d28:0abd1b6e

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep  2 18:54:20 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 46fb325e - correct
         Events : 197036

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 954b2546:5c467e9c:a4eb74e3:27dad837
           Name : impala:0
  Creation Time : Fri May 22 15:32:31 2015
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 7813771264 (3725.90 GiB 4000.65 GB)
     Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 324b49de:233d8769:7f75afad:dddb0ec8

Internal Bitmap : 8 sectors from superblock
    Update Time : Sat Sep  2 18:54:20 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 48b57088 - correct
         Events : 197036

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' == active, '.' == missing, 'R' ==
replacing)
             
