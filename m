From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Tue, 26 May 2020 01:01:16 +0200
Message-ID: <abbe29b4-0837-f8a0-93d3-aecbe7b19655@gmail.com>
References: <7d95da49-33d8-cd4d-fa3f-0f3d3074cb30@gmail.com>
 <5ECC09D6.1010300@youngman.org.uk>
 <ff4ea9cd-ab35-0990-5946-4a72d4021658@gmail.com>
 <5ECC1488.3010804@youngman.org.uk>
 <4891e1e8-aaee-b36b-4131-ca7deb34defd@gmail.com>
 <alpine.DEB.2.20.2005252132080.7596@uplift.swm.pp.se>
 <103b80fa-029f-ecdc-d470-5cc591dc8dd0@gmail.com>
 <e1a4a609-2068-b084-59a6-214c88798966@youngman.org.uk>
 <e1ad56b2-df70-bc6a-9a81-333230d558c2@gmail.com>
 <358e9f6b-a989-0e4a-04c4-6efe2666159f@youngman.org.uk>
 <b5e5c7af-9d1b-3eca-f3a1-f03f8d308015@gmail.com>
 <37636c91-9baf-4565-9849-f8aca54e392e@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37636c91-9baf-4565-9849-f8aca54e392e@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> So step 1, revert the reshape. Step 2, get the array back running. 
> Step 3, start the reshape again.

root@nas:~# mdadm --assemble /dev/md0 --force --verbose 
--update=revert-reshape --invalid-backup /dev/sda1 /dev/sdc1 /dev/sdd1 
/dev/sde1 /dev/sdf1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
mdadm: clearing FAULTY flag for device 4 in /dev/md0 for /dev/sdf1
mdadm: Marking array /dev/md0 as 'clean'
mdadm: added /dev/sdc1 to /dev/md0 as 1
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: added /dev/sdf1 to /dev/md0 as 4
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 4 drives and 1 spare.

=======================

WOW!

ok, let´s check the status again:

root@nas:~# mdadm -D /dev/md0
/dev/md0:
            Version : 1.2
      Creation Time : Sun May 17 00:23:42 2020
         Raid Level : raid5
         Array Size : 35156256768 (33527.62 GiB 36000.01 GB)
      Used Dev Size : 11718752256 (11175.87 GiB 12000.00 GB)
       Raid Devices : 4
      Total Devices : 5
        Persistence : Superblock is persistent

      Intent Bitmap : Internal

        Update Time : Mon May 25 16:05:38 2020
              State : clean, resyncing (PENDING)
     Active Devices : 4
    Working Devices : 5
     Failed Devices : 0
      Spare Devices : 1

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

               Name : nas:0  (local to host nas)
               UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
             Events : 38602

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        4       8       65        3      active sync   /dev/sde1

        5       8       81        -      spare   /dev/sdf1

===================================================

root@nas:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active (auto-read-only) raid5 sda1[0] sdf1[5](S) sde1[4] sdd1[2] 
sdc1[1]
       35156256768 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/4] [UUUU]
         resync=PENDING
       bitmap: 0/88 pages [0KB], 65536KB chunk

unused devices: <none>

==================================================

root@nas:~# mount /dev/md0 /mnt
mount: /mnt: wrong fs type, bad option, bad superblock on /dev/md0, 
missing codepage or helper program, or other error.
root@nas:~#


seems the filesystem got a hit. how to proceed now?
