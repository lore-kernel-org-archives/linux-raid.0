From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 code ok with 2TB + ? NEGATIVE :(
Date: Sun, 28 Nov 2004 21:17:48 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411282110300.19614@adsl.a2000.nu>
References: <200411281819.iASIJmN00402@www.watkins-home.com>
 <41AA24EC.5020206@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41AA24EC.5020206@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

just tried creating a raid5
it was supposed to be 2180 GB
but mdadm -D /dev/md0 reports 131.81 GiB
looks like it's still not supported ?
(kernel 2.6.9-ac11 and mdadm 1.8.0)

]# mdadm --create /dev/md0 -c 256 -l 5 -n 14 /dev/sdb1 /dev/sdc1 /dev/sdd1 
/dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 
/dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1
<..>
Continue creating array? y
mdadm: array /dev/md0 started.
[root@storage etc]# cat /proc/mdstat
Personalities : [raid0] [raid5]
md0 : active raid5 sdo1[14] sdn1[12] sdm1[11] sdl1[10] sdk1[9] sdj1[8] 
sdi1[7] sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
       2285700352 blocks level 5, 256k chunk, algorithm 2 [14/13] 
[UUUUUUUUUUUUU_]
       [>....................]  recovery =  0.0% (56064/175823104) 
finish=156.6min speed=18688K/sec
unused devices: <none>
[root@storage etc]# mdadm -D /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Sun Nov 28 21:15:32 2004
      Raid Level : raid5
      Array Size : 138216704 (131.81 GiB 141.53 GB)
     Device Size : 175823104 (167.68 GiB 180.04 GB)
    Raid Devices : 14
   Total Devices : 14
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sun Nov 28 21:15:32 2004
           State : clean, degraded, recovering
  Active Devices : 13
Working Devices : 14
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 256K

  Rebuild Status : 0% complete

            UUID : 70c4df2b:2dc20e84:e555fa94:a57be873
          Events : 0.4

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       33        1      active sync   /dev/sdc1
        2       8       49        2      active sync   /dev/sdd1
        3       8       65        3      active sync   /dev/sde1
        4       8       81        4      active sync   /dev/sdf1
        5       8       97        5      active sync   /dev/sdg1
        6       8      113        6      active sync   /dev/sdh1
        7       8      129        7      active sync   /dev/sdi1
        8       8      145        8      active sync   /dev/sdj1
        9       8      161        9      active sync   /dev/sdk1
       10       8      177       10      active sync   /dev/sdl1
       11       8      193       11      active sync   /dev/sdm1
       12       8      209       12      active sync   /dev/sdn1
       13       0        0        -      removed

       14       8      225       13      spare rebuilding   /dev/sdo1
