From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: How do I tell which disk failed?
Date: Mon, 07 Jan 2013 22:59:11 -0800
Message-ID: <1357628351.16366.86.camel@corn.betterworld.us>
References: <1357610701.16366.13.camel@corn.betterworld.us>
	 <50EBAC5D.8080000@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50EBAC5D.8080000@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2013-01-07 at 23:19 -0600, Stan Hoeppner wrote:
> On 1/7/2013 8:05 PM, Ross Boylan wrote:
> > I see my array is reconstructing, but I can't tell which disk failed.
> 
> > md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
> >       96256 blocks [3/3] [UUU]
> > 
> > md1 : active raid1 sda3[0] sdc4[2] sdb4[1]
> >       730523648 blocks [3/3] [UUU]
> 
> Your two md/RAID1 arrays are built on partitions on the same set of 3
> disks.  You likely didn't have a disk failure, or md0 would be
> rebuilding as well.  Your failure, or hiccup, is of some other nature,
> and apparently only affected md1.
I assume something went wrong while accessing one of the partitions, and
that there is a problem with the disk that partition is on.

Phrased more carefully, which partition failed and is being resynced
into md1?  I can't tell. 

If I knew, would it be safe to mdadm -fail that partition in the midst
of the rebuild?  

Once the system starts md0 is almost never accessed (it's /boot).

> 
> >       [>....................]  resync =  0.4% (3382400/730523648) finish=14164.9min speed=855K/sec
> 
> Rebuilding a RAID1 on modern hardware should scream.  You're getting
> resync throughput of less than 1MB/s.  Estimated completion time is 9.8
> _days_ to rebuild a mirror partition.  This is insanely high.
Yes.  It seems to be doing better now:
# date; cat /proc/mdstat
Mon Jan  7 21:37:46 PST 2013
Personalities : [raid1]
md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
      96256 blocks [3/3] [UUU]

md1 : active raid1 sda3[0] sdc4[2] sdb4[1]
      730523648 blocks [3/3] [UUU]
      [===========>.........]  resync = 57.8% (422846976/730523648) finish=452.5min speed=11329K/sec

unused devices: <none>

This is more in line with what I remember when I originally synced the
partitions, which I remember as 4-6 hours (it's clearly still much
slower than that pace).

> 
> Either you've tweaked your resync throughput down to 1MB/s, or you have
> some other process(es) doing serious IO, robbing the resync of
> throughput.  
Isn't it possible there's a hardware problem, e.g., leading to a
failure/retry cycle?

> Consider running iotop to determine if another process(es)
> is eating IO bandwidth.
I did, though it's probably a little late.  Here's a fairly typical result (command line as shown on the
last line)
Total DISK READ: 99.09 K/s | Total DISK WRITE: 25.26 K/s
  PID USER      DISK READ  DISK WRITE   SWAPIN    IO    COMMAND
 4263 root           0 B/s       0 B/s  0.00 %  8.40 % [kjournald]
 1204 root       99.09 K/s       0 B/s  0.00 %  4.68 % [kcopyd]
 1193 root           0 B/s       0 B/s  0.00 %  4.68 % [kdmflush]
11874 root           0 B/s   25.26 K/s  0.00 %  0.00 % python /usr/bin/iotop -d 2 -n 20 -b

When I restarted the system had been effectively down for ~ 1.5 days,
and so I guess it's possible that lots of housekeeping operation was
going on.  However, top didn't show any noticeable use of CPU.

A more recent check show speed continuing to rise; it the value is an
average and it started slow that would explain it:
 date; cat /proc/mdstat
Mon Jan  7 22:56:23 PST 2013
Personalities : [raid1]
md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
      96256 blocks [3/3] [UUU]

md1 : active raid1 sda3[0] sdc4[2] sdb4[1]
      730523648 blocks [3/3] [UUU]
      [==================>..]  resync = 91.8% (670929280/730523648) finish=19.4min speed=51057K/sec

Ross


