From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Linux MD? Or an H710p?
Date: Sat, 26 Oct 2013 04:37:10 -0500
Message-ID: <526B8D46.5010506@hardwarefreak.com>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com> <52662849.1080003@hesbynett.no> <5266AE51.4050501@hardwarefreak.com> <526774B4.400@hesbynett.no> <5268BCD6.4000305@hardwarefreak.com> <5268CB88.9060002@hesbynett.no> <526A3B2C.8050800@hardwarefreak.com> <526A5908.4060301@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <526A5908.4060301@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Steve Bergman <sbergman27@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/25/2013 6:42 AM, David Brown wrote:
> On 25/10/13 11:34, Stan Hoeppner wrote:
...
>>>> Workloads that benefit from XFS over concatenated disks are those
>>>> that:
>>>>
>>>> 1.  Expose inherent limitations and/or inefficiencies of
>>>> striping, at the filesystem, elevator, and/or hardware level
>>>>
>>>> 2.  Exhibit a high degree of directory level parallelism
>>>>
>>>> 3.  Exhibit high IOPS or data rates
>>>>
>>>> 4.  Most importantly, exhibit relatively deterministic IO
>>>> patterns
...

> allocation groups are spread evenly across the parts of the concat
> so that logically (by number) adjacent AG's will be on different
> underlying disks.

This is not correct.  The LBA sectors are numbered linearly, hence teh
md name "linear", from the first sector of the first disk (or partition)
to the last sector of the last disk, creating one large virtual disk.
Thus mkfs.xfs divides the disk into equal sized AGs from beginning to
end.  So if you have 4 exactly equal sized disks in the concatenation
and default mkfs.xfs creates 8 AGs, then AG0/1 would be on the first
disk, AG2/3 would be on the second, and so on.  If the disks (or
partitions) are not precisely the same number of sectors you will end up
with portions of AGs laying across physical disk boundaries.  The AGs
are NOT adjacently interleaved across disks as you suggest.

> To my mind, this boils down to a question of balancing - concat
> gives lower average latencies with highly parallel accesses, but

That's too general a statement.  Again, it depends on the workload, and
the type of parallel access.  For some parallel small file workloads
with high DLP, then yes.  For a parallel DB workload with a single table
file, no.  See #2 and #4 above.

> sacrifices maximum throughput of large files.  

Not true.  There are large file streaming workloads that perform better
with XFS over concatenation than with striped RAID.  Again, this is
workload dependent.  See #1-4 above.

> If you don't have
> lots of parallel accesses, then concat gains little or nothing
> compared to raid0.

You just repeated #2-3.

> But I am struggling with point 4 - "most importantly, exhibit
> relatively deterministic IO patterns".  

It means exactly what is says.  In the parallel workload, the file
sizes, IOPS, and/or data rate to each AG needs to be roughly equal.
Ergo the IO pattern is "deterministic".  Deterministic means we know
what the IO pattern is before we build the storage system and run the
application on it.

Again, this is a "workload specific storage architecture".

> All you need is to have
> your file accesses spread amongst a range of directories.  If the
> number of (roughly) parallel accesses is big enough, you'll get a
> fairly even spread across the disks - and if it is not big enough
> for that, you haven't matched point 2.  

And if you aim a shotgun at a flock of geese you might hit a couple.
This is not deterministic.

> This is not really much
> different from raid0 - small accesses will be scattered across the
> different disks.  

It's very different.  And no they won't be scattered across the disks
with a striped array.  When aligned to a striped array, XFS will
allocate all files at the start of a stripe.  If the file is smaller
than sunit it will reside entirely on the first disk.  This creates a
massive IO hotspot.  If the workload consists of files that are all or
mostly smaller than sunit, all other disks in the striped array will sit
idle until the filesystem is sufficiently full that no virgin stripes
remain.  At this point all allocation will become unaligned, or aligned
to sunit boundaries if possible, with new files being allocated into the
massive fragmented free space.  Performance can't be any worse than this
scenario.

You can format XFS without alignment on a striped array and avoid the
single drive hotspot above.  However, file placement within the AGs and
thus on the stripe is non-deterministic, because you're not aligned.
XFS doesn't know where the chunk and stripe boundaries are.  So you'll
still end up with hot spots, some disks more active than others.

This is where a properly designed XFS over concatenation may help.  I
say "may" because if you're not hitting #2-3 it doesn't matter.  The
load may not be sufficient to expose the architectural defect in either
of the striped architectures above.

So, again, use of XFS over concatenation is workload specific.  And 4 of
the criteria to evaluate whether it should be used are above.

> The big difference comes when there is a large
> file access - with raid0, you will block /all/ other accesses for a
> time, while with concat (over three disks) you will block one third
> of the accesses for three times as long.

You're assuming a mixed workload.  Again, XFS over concatenation is
never used with a mixed, i.e. non-deterministic, workload.  It is used
only with workloads that exhibit determinism.

Once again:  "This is a very workload specific storage architecture"

How many times have I repeated this on this list?  Apparently not enough.

-- 
Stan

