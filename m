From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Growing a RAID array
Date: Sat, 14 May 2011 02:17:27 -0500
Message-ID: <34.02.03125.28C2ECD4@cdptpa-omtalb.mail.rr.com>
References: <20110513112313.54fbb717@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110513112313.54fbb717@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Thursday, May 12, 2011 8:23 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Growing a RAID array
> 
> On Thu, 12 May 2011 20:02:01 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
> wrote:
> 
> >
> > 	I am shortly going to be growing a 10 drive RAID6 array with two
> > additional drives.  Can this be done in a single grow operation by
> setting
> > n=12, or do I have to grow it 1 drive at a time?
> >
> 
> Experiment with loop-back devices created on modest sized files.

	OK, I tried this, but for some reason the re-shape is failing, even
with 1 "disk".  I've grown arrays under mdadm any number of times, and I'm
not sure why this is failing.  I created 8 loop devices of 10M each.  I then
created a RAID6 array with 6 members and 2 spares.  When I try to add one or
both drives, I get an error:

RAID-Server:/RAID# mdadm -G /dev/md6 -n 8 --backup-file=/RAID/raid6.bak
mdadm: Need to backup 12288K of critical section..
mdadm: /dev/md6: Something wrong - reshape aborted

	Here is the reported layout:

RAID-Server:/RAID# mdadm -D /dev/md6
/dev/md6:
        Version : 1.2
  Creation Time : Fri May 13 23:15:39 2011
     Raid Level : raid6
     Array Size : 36864 (36.01 MiB 37.75 MB)
  Used Dev Size : 9216 (9.00 MiB 9.44 MB)
   Raid Devices : 6
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri May 13 23:23:04 2011
          State : active
 Active Devices : 6
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 1024K

           Name : RAID-Server:6  (local to host RAID-Server)
           UUID : 332f387c:6c301089:22904f6c:8089b9b4
         Events : 30

    Number   Major   Minor   RaidDevice State
       0       7        0        0      active sync   /dev/loop0
       1       7        1        1      active sync   /dev/loop1
       2       7        2        2      active sync   /dev/loop2
       3       7        3        3      active sync   /dev/loop3
       4       7        4        4      active sync   /dev/loop4
       5       7        5        5      active sync   /dev/loop5

       6       7        6        -      spare   /dev/loop6
       7       7        7        -      spare   /dev/loop7


	The mdadm version is 3.1.4 under kernel 2.6.32-5-amd64

