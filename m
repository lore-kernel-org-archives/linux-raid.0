From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 to utilize upto 8 cores
Date: Fri, 17 Aug 2012 02:15:55 -0500
Message-ID: <502DEFAB.3060206@hardwarefreak.com>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com> <502CA6CE.1080105@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502CA6CE.1080105@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: vincent Ferrer <vincentchicago1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/16/2012 2:52 AM, David Brown wrote:
> On 16/08/2012 07:58, Stan Hoeppner wrote:
>> On 8/15/2012 9:56 PM, vincent Ferrer wrote:
>>
>>> - My  storage server  has upto 8 cores  running linux kernel 2.6.32.27.
>>> - I created  a raid5 device of  10  SSDs .
>>> -  It seems  I only have single raid5 kernel thread,  limiting  my
>>> WRITE  throughput  to single cpu  core/thread.
>>
>> The single write threads of md/RAID5/6/10 are being addressed by patches
>> in development.  Read the list archives for progress/status.  There were
>> 3 posts to the list today regarding the RAID5 patch.
>>
>>> Question :   What are my options to make  my raid5 thread use all the
>>> CPU cores ?
>>>                    My SSDs  can do much more but  single raid5 thread
>>> from mdadm   is becoming the bottleneck.
>>>
>>> To overcome above single-thread-raid5 limitation (for now)  I 
>>> re-configured.
>>>       1)  I partitioned  all  my  10 SSDs into 8  partitions:
>>>       2)  I created  8   raid5 threads. Each raid5 thread having
>>> partition from each of the 8 SSDs
>>>       3)  My WRITE performance   quadrupled  because I have 8 RAID5
>>> threads.
>>> Question: Is this workaround a   normal practice  or may give me
>>> maintenance problems later on.
>>
>> No it is not normal practice.  I 'preach' against it regularly when I
>> see OPs doing it.  It's quite insane.  The glaring maintenance problem
>> is that when one SSD fails, and at least one will, you'll have 8 arrays
>> to rebuild vs one.  This may be acceptable to you, but not to the
>> general population.  With rust drives, and real workloads, it tends to
>> hammer the drive heads prodigiously, increasing latency and killing
>> performance, and decreasing drive life.  That's not an issue with SSD,
>> but multiple rebuilds is.  That and simply keeping track of 80
>> partitions.
>>
> 
> The rebuilds will, I believe, be done sequentially rather than in
> parallel.  And each rebuild will take 1/8 of the time a full array
> rebuild would have done.  So it really should not be much more time or
> wear-and-tear for a rebuild of this monster setup, compared to a single
> raid5 array rebuild.  (With hard disks, it would be worse due to head
> seeks - but still not as bad as you imply, if I am right about the
> rebuilds being done sequentially.)
> 
> However, there was a recent thread here about someone with a similar
> setup (on hard disks) who had a failure during such a rebuild and had
> lots of trouble.  That makes me sceptical to this sort of multiple array
> setup (in addition to Stan's other points).
> 
> And of course, all Stan's other points about maintenance, updates to
> later kernels with multiple raid5 threads, etc., still stand.
> 
>> There are a couple of sane things you can do today to address your
>> problem:
>>
>> 1.  Create a RAID50, a layered md/RAID0 over two 5 SSD md/RAID5 arrays.
>>   This will double your threads and your IOPS.  It won't be as fast as
>> your Frankenstein setup and you'll lose one SSD of capacity to
>> additional parity.  However, it's sane, stable, doubles your
>> performance, and you have only one array to rebuild after an SSD
>> failure.  Any filesystem will work well with it, including XFS if
>> aligned properly.  It gives you an easy upgrade path-- as soon as the
>> threaded patches hit, a simple kernel upgrade will give your two RAID5
>> arrays the extra threads, so you're simply out one SSD of capacity.  You
>> won't need to, and probably won't want to rebuild the entire thing after
>> the patch.  With the Frankenstein setup you'll be destroying and
>> rebuilding arrays.  And if these are consumer grade SSDs, you're much
>> better off having two drives worth of redundancy anyway, so a RAID50
>> makes good sense all around.
>>
>> 2.  Make 5 md/RAID1 mirrors and concatenate them with md/RAID linear.
>> You'll get one md write thread per RAID1 device utilizing 5 cores in
>> parallel.  The linear driver doesn't use threads, but passes offsets to
>> the block layer, allowing infinite core scaling.  Format the linear
>> device with XFS and mount with inode64.  XFS has been fully threaded for
>> 15 years.  Its allocation group design along with the inode64 allocator
>> allows near linear parallel scaling across a concatenated device[1],
>> assuming your workload/directory layout is designed for parallel file
>> throughput.
>>
>> #2, with a parallel write workload, may be competitive with your
>> Frankenstein setup in both IOPS and throughput, even with 3 fewer RAID
>> threads and 4 fewer SSD "spindles".  It will outrun the RAID50 setup
>> like it's standing still.  You'll lose half your capacity to redundancy
>> as with RAID10, but you'll have 5 write threads for md/RAID1, one per
>> SSD pair.  One core should be plenty to drive a single SSD mirror, with
>> plenty of cycles to spare for actual applications, while sparing 3 cores
>> for apps as well.  You'll get unlimited core scaling with both md/linear
>> and XFS.  This setup will yield the best balance of IOPS and throughput
>> performance for the amount of cycles burned on IO, compared to
>> Frankenstein and the RAID50.
> 
> For those that don't want to use XFS, or won't have balanced directories
> in their filesystem, or want greater throughput of larger files (rather
> than greater average throughput of multiple parallel accesses), you can
> also take your 5 raid1 mirror pairs and combine them with raid0.  You
> should get similar scaling (the cpu does not limit raid0).  For some
> applications (such as mail server, /home mount, etc.), the XFS over a
> linear concatenation is probably unbeatable.  But for others (such as
> serving large media files), a raid0 over raid1 pairs could well be
> better.  As always, it depends on your load - and you need to test with
> realistic loads or at least realistic simulations.

Sure, a homemade RAID10 would work as it avoids the md/RAID10 single
write thread.  I intentionally avoided mentioning this option for a few
reasons:

1.  Anyone needing 10 SATA SSDs obviously has a parallel workload
2.  Any thread will have up to 200-500MB/s available (one SSD)
    with a concat, I can't see a single thread needing 4.5GB/s of B/W
    If so, md/RAID isn't capable, not on COTS hardware
3.  With a parallel workload requiring this many SSDs, XFS is a must
4.  With a concat, mkfs.xfs is simple, no stripe aligning, etc
    ~$ mkfs.xfs /dev/md0

-- 
Stan

