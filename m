From: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Subject: Re: raid issues after power failure
Date: Fri, 30 Jun 2006 11:25:02 +0200 (CEST)
Message-ID: <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
    <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francois,

Thank you for the very swift response.

> First, what is your mdadm version ?

# mdadm --version
mdadm - v1.12.0 - 14 June 2005

>
> Then, could you please show us the result of :
>
> mdadm -E /dev/sd[abcd]1


# mdadm -E /dev/sd[abcd]1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8a66d568:0be5b0a0:93b729eb:6f23c014
  Creation Time : Tue Apr 25 16:17:14 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Jun 29 09:10:39 2006
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e2b8644f - correct
         Events : 0.2701790

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8a66d568:0be5b0a0:93b729eb:6f23c014
  Creation Time : Tue Apr 25 16:17:14 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon Jun 26 20:27:44 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2db6503 - correct
         Events : 0.2607131

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8a66d568:0be5b0a0:93b729eb:6f23c014
  Creation Time : Tue Apr 25 16:17:14 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Jun 29 09:10:39 2006
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e2b86473 - correct
         Events : 0.2701790

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 8a66d568:0be5b0a0:93b729eb:6f23c014
  Creation Time : Tue Apr 25 16:17:14 2006
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Thu Jun 29 09:10:39 2006
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e2b86485 - correct
         Events : 0.2701790

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1




what I see is that /dev/sdb1 is signaled as faulty (though it was known to
be not fault before the power failure), and that the whole array is dirty
because of the power failure - thus it can't resync.

but even if I hot-add /dev/sdb1 after starting the array, it will say that
it's resyncing, but actually nothing will happen (no disk activity
according to vmstat, no CPU load, etc.)


Akos

