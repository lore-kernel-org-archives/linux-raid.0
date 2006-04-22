From: Jonathan <jrs@abhost.net>
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 13:32:15 -0700
Message-ID: <444A92CF.70401@abhost.net>
References: <444A7C99.80006@abhost.net>	 <62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>	 <444A8D04.20809@abhost.net> <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0604221322k25c96c37q2bee9361a6316c1b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Well, the block sizes are back to 32k now, but I still had no luck 
mounting /dev/md0 once I created the array.  below is a record of what I 
just tried:

how safe should the following be?

mdadm --assemble /dev/md0 --uuid=8fe1fe85:eeb90460:c525faab:cdaab792 
/dev/etherd/e0.[01234]

I am *really* not interested in making my situation worse.

-- Jonathan

hazel /virtual # mdadm -C /dev/md0 -c 32 -n 4 -l 5 missing 
/dev/etherd/e0.[023]
mdadm: /dev/etherd/e0.0 appears to be part of a raid array:
    level=5 devices=4 ctime=Fri Apr 21 22:56:18 2006
mdadm: /dev/etherd/e0.2 appears to be part of a raid array:
    level=5 devices=4 ctime=Fri Apr 21 22:56:18 2006
mdadm: /dev/etherd/e0.3 appears to contain an ext2fs file system
    size=720300416K  mtime=Wed Oct  5 16:39:28 2005
mdadm: /dev/etherd/e0.3 appears to be part of a raid array:
    level=5 devices=4 ctime=Fri Apr 21 22:56:18 2006
Continue creating array? y
mdadm: array /dev/md0 started.
hazel /virtual # cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 etherd/e0.9[4] etherd/e0.8[3] etherd/e0.7[2] 
etherd/e0.6[1] etherd/e0.5[0]
      586082688 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

md0 : active raid5 etherd/e0.3[3] etherd/e0.2[2] etherd/e0.0[1]
      586082688 blocks level 5, 32k chunk, algorithm 2 [4/3] [_UUU]

unused devices: <none>
hazel /virtual # mount -t ext2 -r /dev/md0 /md0
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       or too many mounted file systems
hazel /virtual # mdadm -S /dev/md0
hazel /virtual # cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 etherd/e0.9[4] etherd/e0.8[3] etherd/e0.7[2] 
etherd/e0.6[1] etherd/e0.5[0]
      586082688 blocks level 5, 32k chunk, algorithm 0 [4/4] [UUUU]

unused devices: <none>
hazel /virtual # mdadm -E /dev/etherd/e0.[01234]
/dev/etherd/e0.0:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 518b5d59:44292ca3:6c358813:c6f00804
  Creation Time : Sat Apr 22 13:25:40 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sat Apr 22 13:25:40 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 6aaa56f - correct
         Events : 0.3493635

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     1     152        0        1      active sync   /dev/etherd/e0.0

   0     0       0        0        0      removed
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
/dev/etherd/e0.1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
  Creation Time : Mon Jan  3 03:16:48 2005
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Apr 21 14:03:12 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 1
       Checksum : 4cc991d7 - correct
         Events : 0.3493633

         Layout : left-asymmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     4     152       16        4      spare   /dev/etherd/e0.1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
   4     4     152       16        4      spare   /dev/etherd/e0.1
/dev/etherd/e0.2:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 518b5d59:44292ca3:6c358813:c6f00804
  Creation Time : Sat Apr 22 13:25:40 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sat Apr 22 13:25:40 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 6aaa591 - correct
         Events : 0.3493635

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     2     152       32        2      active sync   /dev/etherd/e0.2

   0     0       0        0        0      removed
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
/dev/etherd/e0.3:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : 518b5d59:44292ca3:6c358813:c6f00804
  Creation Time : Sat Apr 22 13:25:40 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sat Apr 22 13:25:40 2006
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 6aaa5a3 - correct
         Events : 0.3493635

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     3     152       48        3      active sync   /dev/etherd/e0.3

   0     0       0        0        0      removed
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
/dev/etherd/e0.4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 8fe1fe85:eeb90460:c525faab:cdaab792
  Creation Time : Mon Jan  3 03:16:48 2005
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr 20 21:07:50 2006
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 4cc84d59 - correct
         Events : 0.3482550

         Layout : left-asymmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0     152       64        0      active sync   /dev/etherd/e0.4

   0     0     152       64        0      active sync   /dev/etherd/e0.4
   1     1     152        0        1      active sync   /dev/etherd/e0.0
   2     2     152       32        2      active sync   /dev/etherd/e0.2
   3     3     152       48        3      active sync   /dev/etherd/e0.3
   4     4     152       16        4      spare   /dev/etherd/e0.1

