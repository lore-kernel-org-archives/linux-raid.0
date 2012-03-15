From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Thu, 15 Mar 2012 00:38:02 -0500
Message-ID: <4F61803A.60009@hardwarefreak.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/14/2012 7:30 PM, Jessie Evangelista wrote:
> I want to create a raid10,n2 using 3 1TB SATA drives.
> I want to create an xfs filesystem on top of it.
> The filesystem will be used as NFS/Samba storage.
> 
> mdadm --zero /dev/sdb1 /dev/sdc1 /dev/sdd1
> mdadm -v --create /dev/md0 --metadata=1.2 --assume-clean
> --level=raid10 --chunk 256 --raid-devices=3 /dev/sdb1 /dev/sdc1
> /dev/sdd1

Why 256KB for chunk size?


Looks like you've been reading a very outdated/inaccurate "XFS guide" on
the web...

What kernel version?  This can make a significant difference in XFS
metadata performance.  You should use 2.6.39+ if possible.  What
xfsprogs version?

> mkfs -t xfs -l lazy-count=1,size=128m -f /dev/md0

lazy-count=1 is currently the default with recent xfsprogs so no need to
specify it.  Why are you manually specifying the size of the internal
journal log file?  This is unnecessary.  In fact, unless you have
profiled your workload and testing shows that alternate XFS settings
perform better, it is always best to stick with the defaults.  They
exist for a reason, and are well considered.

> mount -t xfs -o barrier=1,logbsize=256k,logbufs=8,noatime /dev/md0
> /mnt/raid10xfs

Barrier has no value, it's either on or off.  XFS mounts with barriers
enabled by default so remove 'barrier=1'.  You do not have a RAID card
with persistent write cache (BBWC), so you should leave barriers
enabled.  Barriers mitigate journal log corruption due to power failure
and crashes, which seem seem to be of concern to you.

logbsize=256k and logbufs=8 are the defaults in recent kernels so no
need to specify them.  Your NFS/Samba workload on 3 slow disks isn't
sufficient to need that much in memory journal buffer space anyway.  XFS
uses relatime which is equivalent to noatime WRT IO reduction
performance, so don't specify 'noatime'.

In fact, it appears you don't need to specify anything in mkfs.xfs or
fstab, but just use the defaults.  Fancy that.  And the one thing that
might actually increase your performance a little bit you didn't
specify--sunit/swidth.  However, since you're using mdraid, mkfs.xfs
will calculate these for you (which is nice as mdraid10 with odd disk
count can be a tricky calculation).  Again, defaults work for a reason.

> Will my files be safe even on sudden power loss?

Are you unwilling to purchase a UPS and implement shutdown scripts?  If
so you have no business running a server, frankly.  Any system will lose
data due to power loss, it's just a matter of how much based on the
quantity of inflight writes at the time the juice dies.  This problem is
mostly filesytem independent.  Application write behavior does play a
role.  UPS with shutdown scripts, and persistent write cache prevent
this problem.  A cheap UPS suitable for this purpose is less money than
a 1TB 7.2k drive, currently.

You say this is an NFS/Samba server.  That would imply that multiple
people or other systems directly rely on it.  Implement a good UPS
solution and eliminate this potential problem.

> Is barrier=1 enough?
> Do i need to disable the write cache?
> with: hdparm -W0 /dev/sdb /dev/sdc /dev/sdd

Disabling drive write caches does decrease the likelihood of data loss.

> I tried it but performance is horrendous.

And this is why you should leave them enabled and use barriers.  Better
yet, use a RAID card with BBWC and disable the drive caches.

> Am I better of with ext4? Data safety/integrity is the priority and
> optimization affecting it is not acceptable.

You're better off using a UPS.  Filesystem makes little difference WRT
data safety/integrity.  All will suffer some damage if you throw a
grenade at them.  So don't throw grenades.  Speaking of which, what is
your backup/restore procedure/hardware for this array?

> Thanks and any advice/guidance would be appreciated

I'll appreciate your response stating "Yes, I have a UPS and
tested/working shutdown scripts" or "I'll be implementing a UPS very
soon." :)

-- 
Stan

