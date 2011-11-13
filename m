From: Travis Brown <teb@jetcom.org>
Subject: raid 5 to raid 6 reshape gone bad
Date: Sat, 12 Nov 2011 21:56:56 -0500
Message-ID: <E427BB45-7AA7-422C-AAFE-9778286BF64C@jetcom.org>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was reshaping my 5 drive raid 5 with spare to a raid 6 array when the drive I was using for my backup went offline.  If that's not murphy's law, I don't know what is.  The array is still up and usable, but I'm afraid to reboot or doing anything to it, really.  Suggestions on getting this thing back to usable are very welcome. 

Thanks,
Travis

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md126 : active raid6 sde3[0] sdf3[3] sdb3[1] sdd3[4] sdc3[2]
      5856728064 blocks super 0.91 level 6, 512k chunk, algorithm 18 [5/4] [UUUU_]
      [>....................]  reshape =  0.9% (19267584/1952242688) finish=623878.3min speed=51K/sec

/dev/md126:
        Version : 0.91
  Creation Time : Wed Nov 10 20:19:03 2010
     Raid Level : raid6
     Array Size : 5856728064 (5585.41 GiB 5997.29 GB)
  Used Dev Size : 1952242688 (1861.80 GiB 1999.10 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 126
    Persistence : Superblock is persistent

    Update Time : Sat Nov 12 21:55:46 2011
          State : clean, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric-6
     Chunk Size : 512K

 Reshape Status : 0% complete
     New Layout : left-symmetric

           UUID : 3fd8b303:7727aa3b:c5d110f2:f9137e1d
         Events : 0.124051

    Number   Major   Minor   RaidDevice State
       0       8       67        0      active sync   /dev/sde3
       1       8       19        1      active sync   /dev/sdb3
       2       8       35        2      active sync   /dev/sdc3
       3       8       83        3      active sync   /dev/sdf3
       4       8       51        4      spare rebuilding   /dev/sdd3