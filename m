From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Tue, 13 Nov 2012 16:13:36 +0100
Message-ID: <50A263A0.70502@hesbynett.no>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no> <CAJEsFnkM9w0kNbNd51ShP0uExvsZE6V9h3WKKs3nxWfncUCYJA@mail.gmail.com> <509131AF.2030400@hesbynett.no> <50A24D9B.8040002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A24D9B.8040002@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Alexander Haase <mail.alexhaase@gmail.com>, Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/11/2012 14:39, Ric Wheeler wrote:
> On 10/31/2012 10:11 AM, David Brown wrote:
>> On 31/10/2012 14:12, Alexander Haase wrote:
>>> Has anyone considered handling TRIM via an idle IO queue? You'd have to
>>> purge queue items that conflicted with incoming writes, but it does get
>>> around the performance complaint. If the idle period never comes, old
>>> TRIMs can be silently dropped to lessen queue bloat.
>>>
>>
>> I am sure it has been considered - but is it worth the effort and the
>> complications?  TRIM has been implemented in several filesystems (ext4
>> and, I believe, btrfs) - but is disabled by default because it
>> typically slows down the system.  You are certainly correct that
>> putting TRIM at the back of the queue will avoid the delays it causes
>> - but it still will not give any significant benefit (except for old
>> SSDs with limited garbage collection and small over-provisioning ),
>> and you have a lot of extra complexity to ensure that a TRIM is never
>> pushed back until after a new write to the same logical sectors.
>
> I think that you are vastly understating the need for discard support or
> what your first hand experience is, so let me  inject some facts into
> this thread from working on this for several years (with vendors) :)
>

That is quite possible - my experience is limited.  My aim in this 
discussion is not to say that TRIM should be ignored completely, but to 
ask if it really is necessary, and if its benefits outweigh its 
disadvantages and the added complexity.  I am trying to dispel the 
widely held myths that TRIM is essential, that SSDs are painfully slow 
without it, that SSDs do not work with RAID because RAID does not 
support TRIM, and that you must always enable TRIM (and "discard" mount 
options) to get the best from your SSDs.

Nothing makes me happier here than seeing someone with strong experience 
from multiple vendors bringing in some facts - so thank you for your 
comments and help here.

> Overview:
>
> * In Linux, we have "discard" support which vectors down into the device
> appropriate method (TRIM for S-ATA, UNMAP/WRITE_SAME+UNMAP for SCSI,
> just discard for various SW only block devices)
> * There is support for inline discard in many file systems (ext4, xfs,
> btrfs, gfs2, ...)
> * There is support for "batched" discard (still online) via tools like
> fstrim
>

OK.

> Every SSD device benefits from TRIM and the SSD companies test this code
> with the upstream community.
>
> In our testing with various devices, the inline (mount -o discard) can
> have a performance impact so typically using the batched method is better.
>

I am happy to see you confirm this.  I think fstrim is a much more 
practical choice than inline trim for many uses (with SATA SSD's at 
least - SCSI/SAS SSD's have better "trim" equivalents with less 
performance impact, since they can be queued).  I also think fstrim will 
work better along with RAID and other layered systems, since it will 
have fewer, larger TRIMs and allow the RAID system to trim whole stripes 
at a time (and just drop any leftovers).

> For SCSI arrays (less an issue here on this list), the discard allows
> for over-provisioning of LUN's.
>
> Device mapper has support (newly added) for dm-thinp targets which can
> do the same without hardware support.
>
>>
>> It would be much easier and safer, and give much better effect, to
>> make sure the block allocation procedure for filesystems emphasised
>> re-writing old blocks as soon as possible (when on an SSD).  Then
>> there is no need for TRIM at all.  This would have the added benefit
>> of working well for compressed (or sparse) hard disk image files used
>> by virtual machines - such image files only take up real disk space
>> for blocks that are written, so re-writes would save real-world disk
>> space.
>
> Above you are mixing the need for TRIM (which allows devices like SSD's
> to do wear levelling and performance tuning on physical blocks) with the
> virtual block layout of SSD devices. Please keep in mind that the block
> space advertised out to a file system is contiguous, but SSD's
> internally remapped the physical blocks aggressively. Think of physical
> DRAM and your virtual memory layout.

I don't think I am mixing these concepts - but I might well be 
expressing myself badly.

Suppose the disk has logical blocks log000 to log499, and physical 
blocks phy000 to phy599.  The filesystem sees 500 blocks, which the 
SSD's firmware maps onto the 600 physical blocks as needed (20% 
overprovisioning).  We start off with a blank SSD.

The filesystem writes out a file to blocks log000 through log009.  The 
SSD has to map these to physical blocks, and picks phy000 through phy009.

Then the filesystem deletes that file.  Logical blocks log000 to log009 
are now free for re-use by the filesystem.  But without TRIM, the SSD 
does not know that - so it must preserve phy000 to phy009.

Then the filesystem writes a new 10-block file.  If it picks log010 to 
log019 for the logical blocks, then the SSD will write them to phy010 
through phy019.  Everything works fine, but the SSD is carrying around 
these extra physical blocks that it believes are important, because they 
are still mapped to logical blocks log000 to log009, and the SSD does 
not know they are now unused.

But if instead the filesystem wrote the new file to log000 to log009, we 
would have a different case.  The SSD would again allocate phy010 to 
phy019, since it needs to use blank blocks.  But now the SSD has changed 
the mapping for log000 to phy010 instead of phy000, and knows that 
physical blocks phy000 to phy009 are not needed - without a logical 
block mapping, they cannot be accessed by the file system.  So these 
physical blocks can be re-cycled in exactly the same manner as if they 
were TRIM'ed.

In this way, if the filesystem is careful about re-using free logical 
blocks (rather than aiming for low fragmentation and contiguous block 
allocation, as done for hard disk speed), there is no need for TRIM. 
The only benefit of TRIM is to move the recycling process to a slightly 
earlier stage - but I believe that effect would be negligible with 
appropriate overprovisioning.

That's my theory, anyway.

>
> Doing a naive always allocate and reuse the lowest block would have
> horrendous performance impact on certain devices. Even on SSD's where
> seek is negligible, having to do lots of small IO's instead of larger,
> contiguous IO's is much slower.

Clearly the allocation algorithms would have to be different for SSDs 
and hard disks (and I realise this complicates matters - an aim with the 
block device system is to keep things device independent when possible. 
  There is always someone who wants to make a three-way raid1 mirror 
from an SSD, a hard disk partition, and a block of memory exported by 
iSCSI from a remote server - and it is great that they can do so).  And 
clearly having lots of small IOs will increase overheads and reduce any 
performance benefits.  But somewhere here is the possibility to bias the 
filesystems' allocation schemes towards reuse, giving most of the 
benefits of TRIM "for free".

It may also be the case that filesystems already do this, and I am 
recommending a re-invention of a wheel that is already optimised - 
obviously you will know that far better than me.  I am just trying to 
come up with helpful ideas.

mvh.,

David


>
> Regards,
>
> Ric
>
>
>>
>>> As far as parity consistency, bitmaps could track which stripes( and
>>> blocks within those stripes) are expected to be out of parity( also
>>> useful for lazy device init ). Maybe a bit-per-stripe map at the logical
>>> device level and a bit-per-LBA bitmap at the stripe level?
>>
>> Tracking "no-sync" areas of a raid array is already high on the md
>> raid things-to-do list (perhaps it is already implemented - I lose
>> track of which features are planned and which are implemented). And
>> yes, such no-sync tracking would be useful here.  But it is
>> complicated, especially for raid5/6 (raid1 is not too bad) - should
>> TRIMs that cover part of a stripe be dropped? Should the md layer
>> remember them and coalesce them when it can TRIM a whole stripe?
>> Should it try to track partial synchronisation within a stripe?
>>
>> Or should the md developers simply say that since supporting TRIM is
>> not going to have any measurable benefits (certainly not with the sort
>> of SSD's people use in raid arrays), and since TRIM slows down some
>> operations, it is better to keep things simple and ignore TRIM
>> entirely?  Even if there are occasional benefits to having TRIM, is it
>> worth it in the face of added complication in the code and the risk of
>> errors?
>>
>> There /have/ been developers working on TRIM support on raid5.  It
>> seems to have been a complicated process.  But some people like a
>> challenge!
>>
>>>
>>> On the other hand, does it hurt if empty blocks are out of parity( due
>>> to TRIM or lazy device init)? The parity recovery of garbage is still
>>> garbage, which is what any sane FS expects from unused blocks. If and
>>> when you do a parity scrub, you will spend a lot of time recovering
>>> garbage and undo any good TRIM might have done, but usual drive
>>> operation should quickly balance that out in a write-intensive
>>> environment where idle TRIM might help.
>>>
>>
>> Yes, it "hurts" if empty blocks are out of sync.  On obvious issue is
>> that you will get errors when scrubbing - the md layer has no way of
>> knowing that these are unimportant (assuming there is no no-sync
>> tracking), so any real problems will be hidden by the unimportant ones.
>>
>> Another issue is for RMW cycles on raid5.  Small writes are done by
>> reading the old data, reading the old parity, writing the new data and
>> the new parity - but that only works if the parity was correct across
>> the whole stripe.  Even if raid5 TRIM is restricted to whole stripes,
>> a later small write to that stripe will be a disaster if it is not in
>> sync.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

