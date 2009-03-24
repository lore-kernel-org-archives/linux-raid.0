From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: mdadm ignoring homehost?
Date: Tue, 24 Mar 2009 11:57:39 -0500
Message-ID: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a raid1 comprised of a local physical device (/dev/sda) and a
network block device (/dev/nbd0).
When the machine hosting the network block device comes up, however,
it creates /dev/md127.
Why?

On the machine hosting the network block device, /dev/sdb is what
backs /dev/nbd0.
This is physical storage for /dev/nbd0:

frank:~ # mdadm --examine /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x1
     Array UUID : cf24d099:9e174a79:2a2f6797:dcff1420
           Name : turnip:11
  Creation Time : Mon Dec 15 07:06:13 2008
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 160086384 (76.34 GiB 81.96 GB)
     Array Size : 156247976 (74.50 GiB 80.00 GB)
  Used Dev Size : 156247976 (74.50 GiB 80.00 GB)
   Super Offset : 160086512 sectors
          State : clean
    Device UUID : 01524a75:c309869c:6da972c9:084115c6

Internal Bitmap : 2 sectors from superblock
      Flags : write-mostly
    Update Time : Tue Mar 24 11:41:41 2009
       Checksum : 643e99c0 - correct
         Events : 111338


    Array Slot : 2 (failed, failed, empty, 1)
   Array State : _u 2 failed
frank:~ #


As you can see, the "Name" attribute is "turnip:11". The hostname is
"frank". Why did frank bring up the device?
The only thing in frank's /etc/mdadm.conf is "HOMEHOST frank" which I
didn't think was necessary anyway.



-- 
Jon
