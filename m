From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Thu, 10 Jan 2013 18:18:19 -0600
Message-ID: <50EF5A4B.7000502@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301091141.52238.thomas@fjellstrom.ca> <4A81E770-60DD-4C5F-A341-B449BF2C381F@colorremedies.com> <201301100349.46794.thomas@fjellstrom.ca> <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6FD79D70-01A4-4DC9-9494-157773CD0F11@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/10/2013 3:36 PM, Chris Murphy wrote:
> 
> On Jan 10, 2013, at 3:49 AM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> 
>> A lot of it will be streaming. Some may end up being random read/writes. The 
>> test is just to gauge over all performance of the setup. 600MBs read is far 
>> more than I need, but having writes at 1/3 that seems odd to me.
> 
> Tell us how many disks there are, and what the chunk size is. It could be too small if you have too few disks which results in a small full stripe size for a video context. If you're using the default, it could be too big and you're getting a lot of RWM. Stan, and others, can better answer this.

Thomas is using a benchmark, and a single one at that, to judge the
performance.  He's not using his actual workloads.  Tuning/tweaking to
increase the numbers in a benchmark could be detrimental to actual
performance instead of providing a boost.  One must be careful.

Regarding RAID6, it will always have horrible performance compared to
non-parity RAID levels and even RAID5, for anything but full stripe
aligned writes, which means writing new large files or doing large
appends to existing files.

However, everything is relative.  This RAID6 may have plenty of random
and streaming write/read throughput for Thomas.  But a single benchmark
isn't going to inform him accurately.

> You said these are unpartitioned disks, I think. In which case alignment of 4096 byte sectors isn't a factor if these are AF disks. 
> 
> Unlikely to make up the difference is the scheduler. Parallel fs's like XFS don't perform nearly as well with CFQ, so you should have a kernel parameter elevator=noop. 

If the HBAs have [BB|FB]WC then one should probably use noop as the
cache schedules the actual IO to the drives.  If the HBAs lack cache,
then deadline often provides better performance.  Testing of each is
required on a system and workload basis.  With two identical systems
(hardware/RAID/OS) one may perform better with noop, the other with
deadline.  The determining factor is the applications' IO patterns.

> Another thing to look at is md/stripe_cache_size which probably needs to be higher for your application.
> 
> Another thing to look at is if you're using XFS, what your mount options are. Invariably with an array of this size you need to be mounting with the inode64 option.

The desired allocator behavior is independent of array size but, once
again, dependent on the workloads.  inode64 is only needed for large
filesystems with lots of files, where 1TB may not be enough for the
directory inodes.  Or, for mixed metadata/data heavy workloads.

For many workloads including databases, video ingestion, etc, the
inode32 allocator is preferred, regardless of array size.  This is the
linux-raid list so I'll not go into detail of the XFS allocators.

>> The reason I've selected RAID6 to begin with is I've read (on this mailing 
>> list, and on some hardware tech sites) that even with SAS drives, the 
>> rebuild/resync time on a large array using large disks (2TB+) is long enough 
>> that it gives more than enough time for another disk to hit a random read 
>> error,

> This is true for high density consumer SATA drives. It's not nearly as applicable for low to moderate density nearline SATA which has an order of magnitude lower UER, or for enterprise SAS (and some enterprise SATA) which has yet another order of magnitude lower UER.  So it depends on the disks, and the RAID size, and the backup/restore strategy.

Yes, enterprise drives have a much larger spare sector pool.

WRT rebuild time, this is one more reason to use RAID10 or a concat of
RAID1s.  The rebuild time is low, constant, predictable.  For 2TB drives
about 5-6 hours at 100% rebuild rate.  And rebuild time, for any array
type, with gargantuan drives, is yet one more reason not to use the
largest drives you can get your hands on.  Using 1TB drives will cut
that to 2.5-3 hours, and using 500GB drives will cut it down to 1.25-1.5
hours, as all these drives tend to have similar streaming write rates.

To wit, as a general rule I always build my arrays with the smallest
drives I can get away with for the workload at hand.  Yes, for a given
TB total it increases acquisition cost of drives, HBAs, enclosures, and
cables, and power consumption, but it also increases spindle count--thus
performance-- while decreasing rebuild times substantially/dramatically.

-- 
Stan

