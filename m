From: David Brown <david.brown@hesbynett.no>
Subject: Re: LVM striping RAID volumes
Date: Thu, 26 Jan 2012 13:04:02 +0100
Message-ID: <4F214132.5070302@hesbynett.no>
References: <1327467050.3474.303.camel@slacker> <jfok2p$6vg$1@dough.gmane.org> <20256.2521.77580.864903@tree.ty.sabi.co.UK> <4F204231.6040701@hesbynett.no> <20120126034746.0D87428A6E@zebra.redhouse.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120126034746.0D87428A6E@zebra.redhouse.homelinux.net>
Sender: linux-raid-owner@vger.kernel.org
To: douglas-siebert@uiowa.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 26/01/2012 04:42, Douglas Siebert wrote:
> On Wed, 2012-01-25 at 18:56 +0100, David Brown wrote:
>> On 25/01/12 14:55, Peter Grandi wrote:
>>>>> 2) must support passing TRIM commands through the RAID layer
>>>>> (e.g. ext4->LVM->RAID->SSD) to avoid write amplification that
>>>>> reduces SSD lifetime and performance
>>>
>>>> That's not really necessary with modern SSD's - TRIM is
>>>> overrated. Garbage collection on current generations is so
>>>> much better than on earlier models that you generally don't
>>>> have to worry about TRIM.
>>>
>>> Unfortunately not necessarily just for write amplification, and
>>> the "cleaner" (aka garbage collector) is really helped by TRIM.
>>>
>>> The really big deal is that the FTL in the flash SSD cannot
>>> figure out which flash-pages are unused, and cannot use a simple
>>> heuristic like "it is all zeroes" because filesystem code do not
>>> zero unused logical sectors when they are released but writes
>>> them only much later when they are allocated. TRIM is just a a
>>> way to ''write'' a logical sector as unused without zero-filling
>>> it (or other implicit marks).
>>>
>>>> Dropping TRIM makes your life /much/ easier with SSD's,
>>>> especially when you want raid.  According to some benchmarks
>>>> I've seen, it also makes the disk measurably faster.
>>>
>>> While something like TRIM is really important, there is a bad
>>> reputation of TRIM, but it is due to SATA TRIM being specified
>>> badly, as it is specified to be synchronous (or cache-flushing
>>> or queue flushing).
>>>
>>
>> I've read about this in a few places - there are several failing points
>> in SATA TRIM that make it difficult to implement and much less useful
>> than it could be.
>>
>> One problem is that TRIM is synchronous, as you say.  That means if it
>> is used during deletes, it makes them much slower - potentially very
>> much slower.  Secondly, there is no consistency as to what is read back
>> from a trimmed sector.  Had it always been read as zero, it would suit
>> much better for raid.
>
>
> As far as Linux software RAID goes, end users would currently only care
> about TRIM when using using RAID with a pair of SSDs.  So in that case,
> require enabling the write intent bitmaps when enabling TRIM support.  I
> believe this would eliminate the concern about what gets read back from
> a trimmed sector.  I realize benchmarks show bitmaps to slow things down
> a lot, but I'm assuming that's because writing them to hard drives is
> the cause due to their slow seeks.  With SSDs no such concern would
> exist.
>

It is not the seek time that makes TRIM slow, it is the synchronous and 
non-queued nature of it - the flow of data onto and out of the SSD is 
blocked until the TRIM is issued and completed.

> Your point about TRIM potentially slowing things down due to the
> synchronous nature of the ATA 3.0 spec is well taken, but you don't have
> to mount your filesystems with -o discard.  You can just run fstrim out
> of cron daily.  That's exactly what I'm planning to do, and I think most
> people using TRIM are doing so until SSDs support the ATA 3.1 spec's
> asynchronous TRIM.
>

Currently, fstrim is the recommended way to do trimming on Linux.  I 
believe it only works for some filesystems (ext4 and xfs?).

The trim commands don't pass through the md layer - Neil Brown has 
explained on this list already that it is difficult to do efficiently, 
and is low priority for development.  The key problem is that because 
read-backs of trimmed blocks are not specified or consistent, you have 
to trim a whole stripe at a time.  That means you have to track and 
record the trims until you have got a whole stripe, then apply it.

I see a number of ways to improve the situation:

1. Hope that the ATA 3.1 specs make the asynchronous trim always "zero" 
the block.  Then at the md layer could implement it as a "write a block 
of zeros" as far as parity and stripe consistency are concerned.

2. Only track the last few trim commands at the md layer, and only in 
memory - don't try to record them in the metadata.  Combine the incoming 
trim commands if they are adjacent.  If a full stripe has been trimmed, 
then pass that on to the devices - if not, just forget about the partial 
trims.  This would not help anyone using "-o discard" mounts, but would 
fit perfectly with fstrim, and be far easier to implement in the md 
layer.  Because reading trimmed blocks gives unspecified data, the 
trimmed stripes would not necessarily be consistent - so this would have 
to wait until md implements tracking of synchronised and 
non-synchronised blocks.

3. Translate trims into pure "write zero block" commands, and even pass 
them out to the SSD as "write zero block".  Many modern SSD's compress 
the data, so that a "write zero block" will actually use very little 
flash space, and will free up used space.  Being a simple write, it 
should be easy to keep everything consistent.

4. Publish some benchmarks showing how little TRIM affects real-world 
performance (using a single SSD without md raid), comparing different 
SSD's and different overprovisioning.  There is no point in putting 
serious effort into solving this "problem" until it is clearly 
established that it /is/ a problem.  Conversely, if it can be clearly 
shown that that it is not a problem, then people can stop worrying about it.


>
>>
>>>
>>> Anyhow, apart from write amplification, the really big deal is
>>> maximum write latency (and relatedly read latency!). Consider
>>> this scary comparison:
>>>
>>>     http://www.storagereview.com/images/samsung_830_raid_256gb_write_latency.png
>>>
>>> as discussed in one of my many recent flash SSD blog entries:
>>>
>>>     http://www.sabi.co.uk/blog/12-one.html#120115
>>>
>>> Since erasing a flash-block can take a long time, it is very
>>> important for minimizing the highest write latency that the FTL
>>> have available a pool of pre-erased flash-blocks, so they can be
>>> written (OR'ed) to directly ("overprovisioning" in most flash
>>> SSDs is done to allow this too).
>>>
>>
>> Overprovisioning is the key here.  When the SSD has more flash space
>> than is visible to the OS, then that space is always guaranteed free -
>> though not necessarily in contiguous erase blocks.  The more such free
>> space there is, the higher the chances of their being free full blocks
>> when they are needed, and the more flexibility the SSD firmware has in
>> combining partly-written blocks to free up full erase blocks.
>>
>> So if you have sufficient free space due to overprovisioning, you quite
>> simply do not need TRIM, as TRIM is just an expensive way of increasing
>> this free space.
>>
>> How much overprovisioning you want depends on how much you want to
>> reduce the risk of unexpected latencies, and how much extra space you
>> are willing to pay for.  More expensive (or rather, higher quality)
>> SSD's have more overprovisioning.  You can also make your own
>> overprovisioning by simply not allocating all the disk when partitioning
>> it (or using a smaller "size" when using the whole disk in an mdadm
>> raid).  Since there is an area that is never written to, it is
>> effectively extra overprovisioned space.
>
>
> It sounds like you are saying TRIM is unnecessary because you can just
> allocate less space than you have on the device.  That may be true, but
> I can equally say that overprovisioning is unnecessary because you can
> just use TRIM!  Overprovisioning should only be required where it
> wouldn't happen naturally, such as using an SSD for raw volumes on a DB.
>
> Overprovisioning happens as a matter of course when used for a
> filesystem, since most filesystems maintain at least 5% free space, and
> sometimes more, to avoid fragmentation problems.  Unfortunately even if
> your filesystem always has 5% free space, after a while due to that
> fragmentation it is likely that all blocks have been written to at least
> once.  That's what TRIM fixes.  Overprovisioning beyond that is silly
> and wasteful, when a perfectly good fix exists.  Your argument is rather
> like saying that Linux shouldn't worry about being efficient in its
> operation, because you can always buy more CPU and memory than you need.
>

There is no point in a filesystem maintaining 5% free space, especially 
on an SSD - fragmentation is a non-issue on SSD's (and often overrated 
as a problem on HD's).  So rather than having 5% left on the filesystem, 
you have 5% left on the disk.  From the user viewpoint, you have lost 
nothing (or at least, nothing that you hadn't already lost!).

TRIM can only be of benefit when there are files being deleted from the 
filesystem - if you are relying on it, then your performance will 
plummet as you approach 95% full (using the same 5% example figure - 
actual values will vary by SSD, by usage patterns, and by disk size). 
So you have to ask yourself - do you want a filesystem that is painfully 
slow at 95% full, or do you want a filesystem that is 5% smaller but 
full speed all the time?

> One additional point.  TRIM is not just for SSDs.  SCSI/FC supports two
> commands similar in meaning to TRIM (and to each other, don't get me
> started...) that have usefulness way beyond SSDs.  EMC for example
> supports them in their high end VMAX arrays on both thin provisioned AND
> traditional "thick" LUNs.  Why on thick LUNs?  Because knowing that a
> block is no longer in use is very useful for stuff like copies,
> snapshots and especially when sending data between arrays over WAN
> links.  For exactly the same reasons, information about blocks no longer
> in use could be quite useful to the Linux device mapper layer.  It would
> be a shame if Linux mdadm raid became marginalized in the future due to
> lack of support for TRIM/discard semantics.
>

My knowledge of SCSI is limited, but I think this is a case where SCSI 
does the right thing while SATA is a poor copy (NCQ is the other example 
of a similar situation).  My understanding is that SCSI's equivalent of 
TRIM is asynchronous, queueable, and properly specified.  But I don't 
know whether md's lack of support here is an issue for such systems.

mvh.,

David
