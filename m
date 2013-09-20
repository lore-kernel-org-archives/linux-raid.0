From: Sachin Garg <sgarg.bugreporter@gmail.com>
Subject: Unable to start RAID5 array
Date: Thu, 19 Sep 2013 23:37:55 -0400
Message-ID: <523BC313.8000104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have a RAID5 array comprised of 4 devices (partitions). On top of the
RAID, I have an LVM volume which contains my /home. Recently, I started
getting a lot of SATA errors relating to one of my hard drives and I
decided to remove it from the array. I do not know what I did, but after
marking the device as failed, the RAID array would not assemble and
drops me to a root shell.

I am running ArchLinux and have whatever are the latest packages
available - don't have the machine at hand, hence unable to specify
exact versions.

This is what I see when I run the various commands. It should be noted
that the array to be assembled is actually /dev/md127. The array was
actually created using SystemRescueCD.

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : inactive sdc2[1](S) sda2[0](S) sdb1[4](S)
      480215144 blocks super 1.2

unused devices: <none>

# mdadm -E --scan -v
ARRAY /dev/md/0  level=raid5 metadata=1.2 num-devices=4
UUID=01b153ea:a93c7325:c13bf9cf:3195666f name=sysresccd:0
   devices=/dev/sdc2,/dev/sdb1,/dev/sda2

# mdadm -E /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 01b153ea:a93c7325:c13bf9cf:3195666f
           Name : sysresccd:0
  Creation Time : Sat Mar  2 11:03:45 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 312570400 (149.05 GiB 160.04 GB)
     Array Size : 468475392 (446.77 GiB 479.72 GB)
  Used Dev Size : 312316928 (148.92 GiB 159.91 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 3a44949c:aba25c05:76fb0146:3192a757

    Update Time : Thu Sep 12 19:16:14 2013
       Checksum : dacd122 - correct
         Events : 118427

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.A ('A' == active, '.' == missing)

# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 01b153ea:a93c7325:c13bf9cf:3195666f
           Name : sysresccd:0
  Creation Time : Sat Mar  2 11:03:45 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 312317616 (148.92 GiB 159.91 GB)
     Array Size : 468475392 (446.77 GiB 479.72 GB)
  Used Dev Size : 312316928 (148.92 GiB 159.91 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 73aaeb8f:9e33caf5:7837c9f5:f3ac36ab

    Update Time : Thu Sep 12 19:16:14 2013
       Checksum : f4c83ba7 - correct
         Events : 118427

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AA.A ('A' == active, '.' == missing)

# mdadm -E /dev/sdc2
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 01b153ea:a93c7325:c13bf9cf:3195666f
           Name : sysresccd:0
  Creation Time : Sat Mar  2 11:03:45 2013
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 335542272 (160.00 GiB 171.80 GB)
     Array Size : 468475392 (446.77 GiB 479.72 GB)
  Used Dev Size : 312316928 (148.92 GiB 159.91 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 3da52be1:5dbcb8f2:90e0904b:1150045d

    Update Time : Thu Sep 12 19:16:14 2013
       Checksum : 4bea74b3 - correct
         Events : 118427

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.A ('A' == active, '.' == missing)

# mdadm -Avf /dev/md127
mdadm: looking for devices for /dev/md127
mdadm: no RAID superblock on /dev/dm-6
mdadm: no RAID superblock on /dev/dm-5
mdadm: no RAID superblock on /dev/dm-4
mdadm: no RAID superblock on /dev/dm-3
mdadm: no RAID superblock on /dev/dm-2
mdadm: no RAID superblock on /dev/dm-1
mdadm: no RAID superblock on /dev/dm-0
mdadm: /dev/sdc2 is busy - skipping
mdadm: no RAID superblock on /dev/sdc1
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdb1 is busy - skipping
mdadm: no RAID superblock on /dev/sdb
mdadm: no RAID superblock on /dev/sda3
mdadm: /dev/sda2 is busy - skipping
mdadm: no RAID superblock on /dev/sda1
mdadm: no RAID superblock on /dev/sda

Now, the question that arises is why are the devices:  /dev/sda2,
/dev/sdb1 and /dev/sdc2 busy, even though the RAID has not been
assembled? How can I fix this? How can I fix "mdadm -E --scan -v" so
that it shows the device as /dev/md127. If nothing else, how can I
recover the data and recreate the RAID array?

Have been struggling with this for some time. Any help would be
gleefully accepted.

Thanks,
Sachin
