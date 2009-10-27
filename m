From: John P Poet <jppoet@gmail.com>
Subject: RAID5: *all* of my drives are now spares
Date: Mon, 26 Oct 2009 19:45:21 -0600
Message-ID: <2c2a4e250910261845w7e62274es63b5fcebdfce034e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After rebooting my computer, one of my RAID5 arrays would not
assemble.  Only two of the four disks were showing as valid.  I tried
to force the issue, but that did not work:

# mdadm --assemble --metadata=1.2 --force /dev/md3 /dev/sdk /dev/sdj
/dev/sdg /dev/sdf
mdadm: /dev/md3 assembled from 2 drives - not enough to start the array.

Then I noticed that /proc/mdstat was indicating that ALL of the drives
where spares:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md3 : inactive sdk[0](S) sdf[1](S) sdg[2](S) sdj[4](S)
      7814056960 blocks super 1.2
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If I examine each drive, they seem to be clean:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mdadm --examine /dev/sd[kfgj]
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a49556f3:94cb1a5b:c8c89193:cf239a80
           Name : 3
  Creation Time : Tue Aug 18 20:28:47 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 11721085440 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 3907028480 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d2d0b8f1:e61e13c0:3720381b:b4f85e0d

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Oct 26 14:59:53 2009
       Checksum : 4d5badd6 - correct
         Events : 99508

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : spare
   Array State : A..A ('A' == active, '.' == missing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a49556f3:94cb1a5b:c8c89193:cf239a80
           Name : 3
  Creation Time : Tue Aug 18 20:28:47 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 11721085440 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 3907028480 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a3933e58:9793d274:88dbe01d:18f99a18

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Oct 26 14:59:53 2009
       Checksum : 7693f3bb - correct
         Events : 1038178

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : spare
   Array State : A..A ('A' == active, '.' == missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a49556f3:94cb1a5b:c8c89193:cf239a80
           Name : 3
  Creation Time : Tue Aug 18 20:28:47 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 11721085440 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 3907028480 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 281a89c6:38ab1202:73deb60e:f49feb3e

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Oct 26 14:59:53 2009
       Checksum : 89453bae - correct
         Events : 1038182

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : spare
   Array State : A..A ('A' == active, '.' == missing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : a49556f3:94cb1a5b:c8c89193:cf239a80
           Name : 3
  Creation Time : Tue Aug 18 20:28:47 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 11721085440 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 3907028480 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4b6b6942:ed50c78c:a6ec918c:bac5d970

Internal Bitmap : 8 sectors from superblock
    Update Time : Mon Oct 26 14:59:53 2009
       Checksum : 3fa3667c - correct
         Events : 1038182

         Layout : left-symmetric
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : A..A ('A' == active, '.' == missing)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/dev/sdk does not actually say "Device Role : spare".

I tried to re-add the drives, but that also fails:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# mdadm --re-add /dev/md3 /dev/sdj
mdadm: cannot get array info for /dev/md3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Is there any way to recover the data?

Thanks,

John
-- 
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
