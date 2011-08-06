From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: RAID6 check found different events, how should I proceed?
Date: Sat, 6 Aug 2011 14:23:24 +0100
Message-ID: <CADNH=7Eiqx0wCFypxqy-DSKWmr62L83MpP+V8XzjMEWJ3NE0yw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

First, thanks for this:

> The primary purpose of data scrubbing a RAID is to detect & correct
> read errors on any of the member devices; both check and repair
> perform this function.  Finding (and w/ repair correcting) mismatches
> is only a secondary purpose - it is only if there are no read errors
> but the data copy or parity blocks are found to be inconsistent that a
> mismatch is reported.  In order to repair a mismatch, MD needs to
> restore consistency, by over writing the inconsistent data copy or
> parity blocks w/ the correct data.  But, because the underlying member
> devices did not return any errors, MD has no way of knowing which
> blocks are correct, and which are incorrect; when it is told to do a
> repair, it makes the assumption that the first copy in a RAID1 or
> RAID10, or the data (non-parity) blocks in RAID4/5/6 are correct, and
> corrects the mismatch based on that assumption.
>
> That assumption may or may not be correct, but MD has no way of
> determining that reliably - but the user might be able to, by using
> additional knowledge or tools, so MD gives the user the option to
> perform data scrubbing either with (repair) or without (check) MD
> correcting the mismatches using that assumption.
>
>
> I hope that answers your question,
> Beolach

My RAID6 is currently degraded with one HDD (panic mail on the list),
and my weekly cron job kicked in doing the RAID6 check action. This is
the result:

DEV	EVENTS	REALL	PEND	UNCORR	CRC	RAW 	ZONE	END
sdb1	6239487	0		0		0		2	0		0
sdc1	6239487	0		0		0		0	0		0
sdd1	6239487	0		0		0		0	0		0
sde1	6239487	0		0		0		0	0		0
sdf1	6239490	0		0		0		0	49		6
sdg1	6239491	0		0		0		0	0		0
sdh1	(missing, on RMA trip)


(so the SMART is actually fine for all drives)

Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdf1[5] sdg1[0] sdd1[4] sde1[7] sdc1[3] sdb1[1]
      9751756800 blocks super 1.2 level 6, 64k chunk, algorithm 2
[7/6] [UUUUU_U]

unused devices: <none>


/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 6
    Persistence : Superblock is persistent

    Update Time : Sat Aug  6 14:13:08 2011
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 6239491

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       81        4      active sync   /dev/sdf1
       5       0        0        5      removed
       7       8       65        6      active sync   /dev/sde1

So sdf1 and sdg1 have a different event count. Does this mean the HDDs
have silently corrupted the data? I have no way of checking if the
data itself is corrupt or not, except for perhaps a fsck of the
filesystem? Does that make sense?

* Should I run a repair?
* Chould I run a check again, to see if the event count changes?
* Is it likely I've 2 more bad harddrives that will die soon?
* Is it wise to run another smartctl -t long on all devices?

Thanks,
Mathias
