From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Speeding up chunk size change?
Date: Sat, 03 Mar 2012 15:42:38 -0600
Message-ID: <4F52904E.10203@hardwarefreak.com>
References: <4F5272C9.3010906@crc.id.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F5272C9.3010906@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/3/2012 1:36 PM, Steven Haigh wrote:
> Hi all,
> 
> I just wanted to run this past a few folk here as I want to make sure
> I'm doing it the Right Way(tm).
> 
> I've decided to experiment with using a 128Kb chunk size on my RAID6
> instead of a 64kb chunk. 

Why?  Does your target application(s) perform better with a larger
chunk, and therefore larger total stripe size?  If you're strictly after
larger dd copy numbers then you're wasting everyone's time, including
yours, as such has almost zero bearing on real world performance, as
most workloads are far more random than sequential.

And apparently you're not using XFS.  This reshape will screw up your
alignment, and you'll need to change your fstab mount to reflect the new
RAID geometry.  But my guess is you're not using.  If you were you'd
probably be experienced enough to know that doubling your chunk size
isn't going to make much difference, if any, in real world system usage.

> I set a few 'optimisations' that I believe should help:
> ## Tweak the RAIDs
> blockdev --setra 8192 /dev/sd[abcdefg]

Read-ahead is per file descriptor, and occurs at the filesystem level.
The read-ahead value used is that of the device immediately underlying
the filessytem.  So don't bother setting these above.

> blockdev --setra 8192 /dev/md0
> blockdev --setra 8192 /dev/md1
> blockdev --setra 16384 /dev/md2

This is fine.  You could theoretically set this to 1GB or more if you
always read entire files, with no ill effects, as read-ahead doesn't go
past EOF.  However if you do any mmap reads (many apps do) of portions
of large files, this will hammer performance, obviously, as you're
reading entire large files speculatively when not needed.  Play with
this at your own risk.

> echo 16384 > /sys/block/md2/md/stripe_cache_size
> 
> for i in sda sdb sdc sdd sde sdf; do
>         echo "Setting options for $i"
>         echo 256 > /sys/block/$i/queue/nr_requests
>         echo 4096 > /sys/block/$i/queue/read_ahead_kb
Eliminate this line ^^^^

>         echo 1 > /sys/block/$i/device/queue_depth
>         echo deadline > /sys/block/$i/queue/scheduler
> done
> 
> Just wondering if anyone knows of any possible way to speed up the
> reshape a little, or if (like I suspect) it will take ~2 days to
> complete the reshape.

Considering how expensive such operations are in both time and wear on
the disk drives, it's better to read everything available to you on the
subject and ask questions *before* performing expensive experiments on
your array.  If you currently have an performance problem you're trying
to solve, the cause lay somewhere other than your chunk size.

-- 
Stan
