From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Subject: Re: raid issues after power failure
Date: Mon, 03 Jul 2006 10:54:32 +0200
Message-ID: <44A8DB48.8080905@tyrell.hu>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>	 <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>	 <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>	 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>	 <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>	 <Pine.LNX.4.63.0606300827570.30060@turos>	 <fd8d0180606300540r3c957a7duf0c831917f55be7f@mail.gmail.com>	 <Pine.LNX.4.63.0606300842430.30060@turos>	 <17573.44678.188170.409349@cse.unsw.edu.au>	 <44A69496.9030109@tyrell.hu> <fd8d0180607020114m5e02e1ek553e5da2941eb6dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180607020114m5e02e1ek553e5da2941eb6dd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Francois Barre wrote:
> Well, Neil, I'm wondering,
> It seemed to me that Akos' description of the problem was that
> re-adding the drive (with mdadm not complaining about anything) would
> trigger a resync that would not even start.
> But as your '--force' does the trick, it implies that the resync was
> not really triggered after all without it... Or did I miss a bit of
> log Akos provided that did say so ?
> Could there be a place here for an error message ?

well, thing is it's still not totally OK. after doing an

# mdadm -A --force /dev/md0
# mdadm /dev/md0 -a /dev/sdb1

it starts to re-assemble the array. it takes a lot of time (like about 4
hours), which is OK. after the re-assembly is ready, all seems fine:

# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdb1[1] sda1[0] sdd1[3] sdc1[2]
      1172126208 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
# mdadm --query /dev/md0
/dev/md0: 1117.83GiB raid5 4 devices, 0 spares. Use mdadm --detail for
more detail.
# mdadm --query --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Apr 25 16:17:14 2006
     Raid Level : raid5
     Array Size : 1172126208 (1117.83 GiB 1200.26 GB)
    Device Size : 390708736 (372.61 GiB 400.09 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jul  3 00:16:39 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 8a66d568:0be5b0a0:93b729eb:6f23c014
         Events : 0.2701837

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
#

right? checking with

# mdadm -E /dev/sb[a-d]1

will also show that all drives have the same event count, etc.

but, just doing a

# mdadm --stop /dev/md0
# mdadm -A /dev/md0

will result in the array started with 3 drives out of 4 again. what am I
doing wrong?


Akos
