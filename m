From: Thomas Grawert <thomasgrawert0282@gmail.com>
Subject: Re: help requested for mdadm grow error
Date: Tue, 26 May 2020 01:15:41 +0200
Message-ID: <333a650e-2345-0e09-b53e-57b6f2e6cc68@gmail.com>
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

root@nas:~# mdadm --readwrite /dev/md0
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

        Update Time : Tue May 26 01:13:08 2020
              State : clean
     Active Devices : 4
    Working Devices : 5
     Failed Devices : 0
      Spare Devices : 1

             Layout : left-symmetric
         Chunk Size : 512K

Consistency Policy : bitmap

               Name : nas:0  (local to host nas)
               UUID : d7d800b3:d203ff93:9cc2149a:804a1b97
             Events : 38605

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        4       8       65        3      active sync   /dev/sde1

        5       8       81        -      spare   /dev/sdf1
root@nas:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sda1[0] sdf1[5](S) sde1[4] sdd1[2] sdc1[1]
       35156256768 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/4] [UUUU]
       bitmap: 0/88 pages [0KB], 65536KB chunk

unused devices: <none>

=================================

ok, got a bit too scared :)

it´s now working again. so I can plugin a UPS and restart grow.

guys, thank you all very much for your help.
