From: Jean-Rene Cormier <jean-rene.cormier@cipanb.ca>
Subject: Re: Moving RAID 1 array to new server
Date: 12 Nov 2003 19:37:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1068680238.5087.4.camel@localhost.localdomain>
References: <news2mail-bordad$avv$1@cartman.spoiled.org>
	 <1068509010.907.4.camel@forbidden.jrc.net>
	 <news2mail-bordad$avv$1@cartman.spoiled.org>
	 <1068603164.908.6.camel@forbidden.jrc.net> <3015.3fb20027.f253c@altium.nl>
	 <news2mail-bou3ck$q2i$1@cartman.spoiled.org>
	 <1068667243.1477.35.camel@forbidden.cipanb.ca>
	 <news2mail-bou3rq$q2i$2@cartman.spoiled.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <news2mail-bou3rq$q2i$2@cartman.spoiled.org>
To: Juri Haberland <juri@koschikode.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-11-12 at 16:06, Juri Haberland wrote:
> Jean-Rene Cormier <jean-rene.cormier@cipanb.ca> wrote:
> > On Wed, 2003-11-12 at 15:58, Juri Haberland wrote:
> 
> > I use 2.4.22 so I guess this patch is not for me. When I get home
> > tonight I'll try to re-add the disk to the array and see what it does.
> 
> If it doesn't work please also post the relevant part of /proc/mdstat.


Well I re-added the drive and it marked it as a spare.

Here's the output of mdadm --detail /dev/md0:

/dev/md0:
        Version : 00.90.00
  Creation Time : Sat Mar  1 22:55:38 2003
     Raid Level : raid1
     Array Size : 60051456 (57.27 GiB 61.49 GB)
    Device Size : 60051456 (57.27 GiB 61.49 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Nov 12 22:33:37 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 2


    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1       0        0        1      faulty removed
       2      34        1        2      spare   /dev/hdg1
           UUID : 97cdd679:0b676ca4:3d889120:566d5967
         Events : 0.30

And here's my /proc/mdstat:

Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 hdg1[2] hde1[0]
      60051456 blocks [2/1] [U_]
      [=>...................]  recovery =  6.9% (4162176/60051456)
finish=30.2min speed=30762K/sec
unused devices: <none>

It seems to be rebuilding but will it stay marked as a spare drive or
will it take over the main faulty drive after it's done rebuilding?

Thanks

Jean-Rene Cormier


