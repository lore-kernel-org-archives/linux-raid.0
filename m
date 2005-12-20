From: Neil Brown <neilb@suse.de>
Subject: Re: Raid sync observations
Date: Wed, 21 Dec 2005 08:27:28 +1100
Message-ID: <17320.30528.417691.57401@cse.unsw.edu.au>
References: <E1Eol86-0008Ju-3J@highlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian Kuzminsky on Tuesday December 20
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Kuzminsky <seb@highlab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 20, seb@highlab.com wrote:
> I just created a RAID array (4-disk RAID-6).  When "mdadm -C" returned,
> /proc/mdstat showed it syncing the new array at about 17 MB/s.  "vmstat 1"
> showed hardly any blocks in or out, and an almost completely idle cpu.
> 
> 
> Question 1: Why didnt the raid sync I/O show up with vmstat?

Because resync does use the 'vm' subsystem.  It uses a private memory
pool.  So it doesn't page-in or page-out.
As has been noted, the IO it appears in iostat.

> 
> 
> Question 2: Why was it limited to 17 MB per second?  The maximum was
> left at the default, 200 MB/s.  The min was also at the default, 1 MB/s.
> I get 60 MB/s per disk with "hdparm -tT" (that's using one disk at a time,
> but still).  The checksumming code does > 3 GB/s.
> 

This has been at least partially answered already, however...

 When doing resync, raid6 will read all the data blocks, calculate the
 P and Q syndromes, and then write those out.  
 If you think about head movement remembering that the devices holding
 P and Q differs for each stripe, you will realise that the drives are
 not streaming, so you will miss out on some speed.

 You can get better speed on creation with
   mdadm -C -l6 -n4 -x2 /dev/sd[ab] missing missing /dev/sd[cd]

 i.e. create with 2 missing devices and 2 spares.  Recovery onto the
 spares will do purely sequential IO on all devices and so will go
 much faster.
 Doing this requires regenerating datablocks which is more cpu
 intensive that generating P and Q, so there might be some CPU
 overhead, but the disk throughput is still much faster.

 In 2.6.16, raid6 resync has been improved somewhat.  This will not
 affect the initial sync, but resync after a crash will only write
 P/Q blocks which are wrong and there are usually very few of those.
 This means that it will mostly to sequential reads on all drives, so
 you get full device speed.

NeilBrown

