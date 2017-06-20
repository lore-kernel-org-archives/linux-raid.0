From: Marc MERLIN <marc@merlins.org>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Tue, 20 Jun 2017 11:27:45 -0700
Message-ID: <20170620182745.rbufznqe4tuxqttq@merlins.org>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org>
 <87r2yxdazc.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87r2yxdazc.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 06, 2017 at 01:57:27PM +1000, NeilBrown wrote:
> Had you run "mdadm --examine-bitmap /dev/sdk1" before the re-add, it
> would have told you how many bits were set at that time.
> 
> That "x/y pages" information never should have appeared in /proc/mdstat
> - it is really just of interest to developers.  But it is there now, so
> removing it is awkward.

So, I got the problem again, re-added a drive that had just been missing
for maybe 2mn, and this time I'm getting a very long (but not full)
recovery:

gargamel:~# mdadm --examine-bitmap  /dev/sdh1
        Filename : /dev/sdh1
           Magic : 6d746962
         Version : 4
            UUID : 589f1176:8ee48905:d102340b:23f98ca1
          Events : 11588
  Events Cleared : 10625
           State : OK
       Chunksize : 64 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1953380928 (1862.89 GiB 2000.26 GB)
          Bitmap : 29807 bits (chunks), 267 dirty (0.9%)

0.9% dirty still gives me a 5H recovery?


md8 : active raid5 sdi1[5] sdd1[0] sdh1[3] sdg1[2] sdf1[1]
      7813523712 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
      [==>..................]  recovery = 12.4% (243429660/1953380928) finish=297.6min speed=95741K/sec
      bitmap: 5/15 pages [20KB], 65536KB chunk

gargamel:~# mdadm --query --detail /dev/md8
/dev/md8:
        Version : 1.2
  Creation Time : Sun May 14 08:59:13 2017
     Raid Level : raid5
     Array Size : 7813523712 (7451.56 GiB 8001.05 GB)
  Used Dev Size : 1953380928 (1862.89 GiB 2000.26 GB)
   Raid Devices : 5
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Jun 20 11:01:02 2017
          State : clean, degraded 
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : gargamel.svh.merlins.org:8  (local to host gargamel.svh.merlins.org)
           UUID : 589f1176:8ee48905:d102340b:23f98ca1
         Events : 11588

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       8       81        1      active sync   /dev/sdf1
       2       8       97        2      active sync   /dev/sdg1
       3       8      113        3      active sync   /dev/sdh1
       -       0        0        4      removed

This was the drive that got kicked out (shown before it was re-added):
gargamel:~# mdadm --examine-bitmap  /dev/sdi1
        Filename : /dev/sdi1
           Magic : 6d746962
         Version : 4
            UUID : 589f1176:8ee48905:d102340b:23f98ca1
          Events : 10630
  Events Cleared : 10625
           State : OK
       Chunksize : 64 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 1953380928 (1862.89 GiB 2000.26 GB)
          Bitmap : 29807 bits (chunks), 0 dirty (0.0%)


Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
