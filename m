From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid5 to utilize upto 8 cores
Date: Fri, 17 Aug 2012 13:47:49 +0200
Message-ID: <502E2F65.7040501@hesbynett.no>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com> <502CA6CE.1080105@hesbynett.no> <502DEFAB.3060206@hardwarefreak.com> <502DF2E8.4030207@hesbynett.no> <502E2253.9020409@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502E2253.9020409@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: vincent Ferrer <vincentchicago1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/08/2012 12:52, Stan Hoeppner wrote:
> On 8/17/2012 2:29 AM, David Brown wrote:
>> On 17/08/2012 09:15, Stan Hoeppner wrote:
>>> On 8/16/2012 2:52 AM, David Brown wrote:
>>>> For those that don't want to use XFS, or won't have balanced directories
>>>> in their filesystem, or want greater throughput of larger files (rather
>>>> than greater average throughput of multiple parallel accesses), you can
>>>> also take your 5 raid1 mirror pairs and combine them with raid0.  You
>>>> should get similar scaling (the cpu does not limit raid0).  For some
>>>> applications (such as mail server, /home mount, etc.), the XFS over a
>>>> linear concatenation is probably unbeatable.  But for others (such as
>>>> serving large media files), a raid0 over raid1 pairs could well be
>>>> better.  As always, it depends on your load - and you need to test with
>>>> realistic loads or at least realistic simulations.
>>>
>>> Sure, a homemade RAID10 would work as it avoids the md/RAID10 single
>>> write thread.  I intentionally avoided mentioning this option for a few
>>> reasons:
>>>
>>> 1.  Anyone needing 10 SATA SSDs obviously has a parallel workload
>>> 2.  Any thread will have up to 200-500MB/s available (one SSD)
>>>       with a concat, I can't see a single thread needing 4.5GB/s of B/W
>>>       If so, md/RAID isn't capable, not on COTS hardware
>>> 3.  With a parallel workload requiring this many SSDs, XFS is a must
>>> 4.  With a concat, mkfs.xfs is simple, no stripe aligning, etc
>>>       ~$ mkfs.xfs /dev/md0
>>>
>>
>> These are all good points.  There is always a lot to learn from your posts.
>>
>> My only concern with XFS over linear concat is that its performance
>> depends on the spread of allocation groups across the elements of the
>> concatenation (the raid1 pairs in this case), and that in turn depends
>> on the directory structure.  (I'm sure you'll correct me if I'm wrong in
>> this - indeed I would /like/ to be wrong!)  If you have large numbers of
>> top-level directories and a spread of access, then this is ideal.  But
>> if you have very skewed access with most access within only one or two
>> top-level directories, then as far as I understand XFS allocation
>> groups, access will then be concentrated heavily on only one (or a few)
>> of the concat elements.
>
> This depends on the allocator.  inode32, the default allocator, does
> RAID0 with files--each file being a chunk.  All inodes go in AG0, all
> files round robin'd across the other AGs.  Great for parallel streaming
> workloads on a mirror concat, obviously not metadata intensive
> workloads, as metadata is on the first spindle.
>
> The optional inode64 allocator spreads inodes and files across all AGs.
>   Every new dir is created in a different AG round robin, regardless of
> the on disk location of the parent dir.  File however always get created
> in their parent dir.  Much better for metadata workloads.  It's just as
> good with parallel streaming workloads if the user has read the XFS
> Users Guide and does some manual placement.
>

It sounds like I /have/ misunderstood things - at least regarding the 
inode64 allocator (which will surely be the best choice for a large 
array).  I had though that while directories "/a/" and "/b/" get 
different allocation groups, directories "/a/1/" and "/a/2/" would go in 
the same AG as "/a/".  What you are saying is that this is not correct - 
each of these four directories would go in a separate AG.  File "/a/1/x" 
would go in the same AG as "/a/1/", of course.  Assuming this is the 
case, XFS over linear concat sounds more appealing for a much wider set 
of applications than I had previously thought.

>> raid0 of the raid1 pairs may not be the best way to spread out access
>> (assuming XFS linear concat is not a good fit for the workload), but it
>> might still be an improvement.  Perhaps a good solution would be raid0
>> with a very large chunk size - that make most accesses non-striped (as
>> you say, the user probably doesn't need striping), thus allowing more
>> parallel accesses, while scattering the accesses evenly across all raid1
>> elements?
>
> No matter how anyone tries to slice it, striped RAID is only optimal for
> streaming writes/reads of large files.  This represents less than 1% of
> real world workloads.  The rest are all concurrent relatively small file
> workloads, and for these using an intelligent filesystem with an
> allocation group design (XFS, JFS) will yield better performance.
>
> The only real benefit of striped RAID over concat, for the majority of
> workloads, is $/GB.
>
>> Of course, we are still waiting to hear a bit about the OP's real load.
>
> It seems clear he has some hardware, real or fantasy, in need of a
> workload, so I'm not holding my breath.
>

