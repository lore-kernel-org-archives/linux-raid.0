From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 10:58:24 +0200
Message-ID: <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
 <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
 <87inr880au.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87inr880au.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/28/2016 10:40 AM, NeilBrown wrote:
> On Mon, Nov 28 2016, Avi Kivity wrote:
>
>> On 11/28/2016 07:09 AM, NeilBrown wrote:
>>> On Mon, Nov 28 2016, Avi Kivity wrote:
>>>
>>>> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large
>>>> disk that supports TRIM/DISCARD (erase whichever is inappropriate).
>>>> That is because mkfs issues a TRIM/DISCARD (erase whichever is
>>>> inappropriate) for the entire partition. As far as I can tell, md
>>>> converts the large TRIM/DISCARD (erase whichever is inappropriate) into
>>>> a large number of TRIM/DISCARD (erase whichever is inappropriate)
>>>> requests, one per chunk-size worth of disk, and issues them to the RAID
>>>> components individually.
>>>>
>>>>
>>>> It seems to me that md can convert the large TRIM/DISCARD (erase
>>>> whichever is inappropriate) request it gets into one TRIM/DISCARD (erase
>>>> whichever is inappropriate) per RAID component, converting an O(disk
>>>> size / chunk size) operation into an O(number of RAID components)
>>>> operation, which is much faster.
>>>>
>>>>
>>>> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with
>>>> the operation taking about a quarter of an hour, continuously pushing
>>>> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests
>>>> to the disk. Linux 4.1.12.
>>> Surely it is the task of the underlying driver, or the queuing
>>> infrastructure, to merge small requests into large requests.
>> Here's a blkparse of that run.  As can be seen, there is no concurrency,
>> so nobody down the stack has any chance of merging anything.
> That isn't a valid conclusion to draw.

It's actually wrong, as I noted later.  The raid layer issues concurrent 
requests, but they are not merged.

> raid0 effectively calls the make_request_fn function that is registered
> by the underlying driver.
> If that function handles DISCARD synchronously, then you won't see any
> concurrency, and that is because the driver chose not to queue but to
> handle directly.
> I don't know if it actually does this though.  I don't know the insides
> of the nmve driver .... there seems to be a lightnvm thing and a scsi
> thing and a pci thing and it all confuses me.

NVMe only has queued TRIMs.  Of course, the driver could be issuing them 
synchronously, but that's doubtful, since NVMe is such a simple protocol.

What I guess is happening is that since the NVMe queue depth is so high, 
and request the driver receives is sent immediately to the disk and 
there is nothing to merge it to.  That could indicate the absence of 
plugging, or just a reluctance to merge TRIMs.

>
>>
>> No merging was happening.  This is an NVMe drive, so running with the
>> noop scheduler (which should still merge).   Does the queuing layer
>> merge trims?
> I wish I knew.  I once thought I understood about half of the block
> queuing code, but now with multi-queue, I'll need to learn it all
> again. :-(
>
>> I don't think it's the queuing layer's job, though.  At the I/O
>> scheduler you can merge to clean up sloppy patterns from the upper
>> layer, but each layer should try to generate the best pattern it can.
> Why?  How does it know what is best for the layer below?

A large request can be split at the lower layer without harming the 
upper layer (beyond the effort involved).  Merging many small requests 
at the lower layer can harm the upper layer, if it depends on the 
latency of individual requests.

In general in software engineering, when you destroy information, there 
is a potential for inefficiency.  In this case the information destroyed 
is that we are only interested when all of the range is TRIMmed, not any 
particular subrange, and the potential for inefficiency is indeed realized.

>
>> Large merges mean increased latency for the first request in the chain,
>> forcing the I/O scheduler to make a decision which can harm the
>> workload.  By generating merged requests in the first place, the upper
>> layer removes the need to make that tradeoff (splitting the requests
>> removes information: "we are interested only in when all of the range is
>> trimmed, not any particular request").
> If it is easy for the upper layer to break a very large request into a
> few very large requests, then I wouldn't necessarily object.

I can't see why it would be hard.  It's simple arithmetic.

> But unless it is very hard for the lower layer to merge requests, it
> should be doing that too.

Merging has tradeoffs.  When you merge requests R1, R2, ... Rn you make 
the latency request R1 sum of the latencies of R1..Rn.  You may gain 
some efficiency in the process, but that's not going to make up for a 
factor of n.  The queuing layer has no way to tell whether the caller is 
interested in the latency of individual requests.  By sending large 
requests, the caller indicates it's not interested in the latency of 
individual subranges.  The queuing layer is still free to internally 
split the request to smaller ranges, to satisfy hardware constraints, or 
to reduce worst-case latencies for competing request streams.

So I disagree that all the work should be pushed to the merging layer.  
It has less information to work with, so the fewer decisions it has to 
make, the better.

> When drivers/lightnvm/rrpc.c is providing rrpc_make_rq as the

This does not seem to be an NVMe driver.

> make_request_fn, it performs REQ_OP_DISCARD synchronously.  I would
> suggest that is a very poor design.  I don't know if that is affecting
> you (though a printk would find out).
>
> NeilBrown

