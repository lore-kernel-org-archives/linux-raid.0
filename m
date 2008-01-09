From: CaT <cat@zip.com.au>
Subject: Re: raid5 stuck in degraded, inactive and dirty mode
Date: Wed, 9 Jan 2008 19:16:34 +1100
Message-ID: <20080109081634.GS3940@zip.com.au>
References: <20080109055544.GR3940@zip.com.au> <18308.28489.479077.86397@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18308.28489.479077.86397@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 09, 2008 at 05:52:57PM +1100, Neil Brown wrote:
> On Wednesday January 9, cat@zip.com.au wrote:
> > 
> > I'd provide data dumps of --examine and friends but I'm in a situation
> > where transferring the data would be a right pain. I'll do it if need
> > be, though.
> > 
> > So, what can I do? 
> 
> Well, providing the output of "--examine" would help a lot.

Here's the output of the 3 remaining drives, the array and mdstat.

/proc/mdstat:
Personalities : [raid1] [raid6] [raid5] [raid4] 
...
md3 : inactive sdf1[0] sde1[2] sdd1[1]
      1465151808 blocks
...
unused devices: <none>

/dev/md3:
        Version : 00.90.03
  Creation Time : Thu Aug 30 15:50:01 2007
     Raid Level : raid5
    Device Size : 488383936 (465.76 GiB 500.11 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Jan  3 08:51:00 2008
          State : active, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : f60a1be0:5a10f35f:164afef4:10240419
         Events : 0.45649

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       1       8       49        1      active sync   /dev/sdd1
       2       8       65        2      active sync   /dev/sde1
       3       0        0        -      removed

/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f60a1be0:5a10f35f:164afef4:10240419
  Creation Time : Thu Aug 30 15:50:01 2007
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Thu Jan  3 08:51:00 2008
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : cb259d08 - correct
         Events : 0.45649

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/sdd1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       33        3      active sync   /dev/sdc1

/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f60a1be0:5a10f35f:164afef4:10240419
  Creation Time : Thu Aug 30 15:50:01 2007
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Thu Jan  3 08:51:00 2008
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : cb259d1a - correct
         Events : 0.45649

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       33        3      active sync   /dev/sdc1

/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : f60a1be0:5a10f35f:164afef4:10240419
  Creation Time : Thu Aug 30 15:50:01 2007
     Raid Level : raid5
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3

    Update Time : Thu Jan  3 08:51:00 2008
          State : active
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : cb259d26 - correct
         Events : 0.45649

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       81        0      active sync   /dev/sdf1

   0     0       8       81        0      active sync   /dev/sdf1
   1     1       8       49        1      active sync   /dev/sdd1
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       33        3      active sync   /dev/sdc1


> But I suspect that "--assemble --force" would do the right thing.
> Without more details, it is hard to say for sure.

I suspect so aswell but throwing caution into the wind erks me wrt this
raid array. :)

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
