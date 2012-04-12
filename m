From: Martin Wegner <mw@mroot.net>
Subject: Problem assembling a degraded RAID5
Date: Thu, 12 Apr 2012 20:02:53 +0200
Message-ID: <4F8718CD.4070904@mroot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I've had a disk "failure" in a raid5 containing 4 drives and 1 spare.
The raid5 still reported to be clean but smart data was indicating one
drive failing. So I did these steps:

1. I shut down the system and replaced the failing drive with a new one.
2. Upon booting the system, another drive of this array was missing. I
thought it would be the spare device and tried to start the array with
the remaining 3 devices (out of the 4 non-spare), but it didn't work.
All devices were set up as spare in the array (so I also used --force
eventually, but still no luck.). So I came to the conclusion that the
missing device was not the spare device.
3. I shut down the system again and re-checked all the cables and also
re-installed the failing device and removed the new one. So, the raid
array should be (physically and the actual data on the array) in the
exact same state as before I had removed the disk.

But the raid5 array cannot be started anymore. mdadm reports that the
superblocks of the devices do not match.

Can anyone help me how to recover this raid array? I'm pretty desperate
at this point.

Here is the data of $ mdadm --examine ... of all member devices:

/dev/sda5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
           Name : garm:1  (local to host garm)
  Creation Time : Fri Jul  1 20:02:44 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b80889b3:d910f7cf:940fe571:45fdbd79

    Update Time : Thu Apr 12 17:47:39 2012
       Checksum : e5c307f8 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


/dev/sdb5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
           Name : garm:1  (local to host garm)
  Creation Time : Fri Jul  1 20:02:44 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 5c645db4:15f5123c:54736b86:201f0767

    Update Time : Thu Apr 12 17:47:39 2012
       Checksum : 5482cd74 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


/dev/sdg5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
           Name : garm:1  (local to host garm)
  Creation Time : Fri Jul  1 20:02:44 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
     Array Size : 11721068256 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907022752 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0ec23618:69bcb467:20fe2b20:5dedf2d6

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Apr 12 17:14:54 2012
       Checksum : edbcd80f - correct
         Events : 21215

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)


/dev/sdh5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
           Name : garm:1  (local to host garm)
  Creation Time : Fri Jul  1 20:02:44 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : ff352ee9:4f8d881c:e5408fde:e6234761

    Update Time : Thu Apr 12 17:47:39 2012
       Checksum : bc2d09a6 - correct
         Events : 2


   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


/dev/sdl5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 610fb4f8:02dab3e7:e2fbd8a5:4828a4b0
           Name : garm:1  (local to host garm)
  Creation Time : Fri Jul  1 20:02:44 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907023024 (1863.01 GiB 2000.40 GB)
     Array Size : 11721068256 (5589.04 GiB 6001.19 GB)
  Used Dev Size : 3907022752 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bdf903e3:88296c06:e340658c:4378ac7b

Internal Bitmap : 2 sectors from superblock
    Update Time : Sun Apr  8 20:44:46 2012
       Checksum : 682f35bb - correct
         Events : 21215

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : spare
   Array State : AAAA ('A' == active, '.' == missing)

Thanks in advance,

Martin Wegner
