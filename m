From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Tue, 13 Nov 2012 10:39:37 -0500
Message-ID: <50A269B9.1090208@redhat.com>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no> <CAJEsFnkM9w0kNbNd51ShP0uExvsZE6V9h3WKKs3nxWfncUCYJA@mail.gmail.com> <509131AF.2030400@hesbynett.no> <50A24D9B.8040002@redhat.com> <50A263A0.70502@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A263A0.70502@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Alexander Haase <mail.alexhaase@gmail.com>, Chris Murphy <lists@colorremedies.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/13/2012 10:13 AM, David Brown wrote:
> On 13/11/2012 14:39, Ric Wheeler wrote:
>> On 10/31/2012 10:11 AM, David Brown wrote:
>>> On 31/10/2012 14:12, Alexander Haase wrote:
>>>> Has anyone considered handling TRIM via an idle IO queue? You'd have to
>>>> purge queue items that conflicted with incoming writes, but it does get
>>>> around the performance complaint. If the idle period never comes, old
>>>> TRIMs can be silently dropped to lessen queue bloat.
>>>>
>>>
>>> I am sure it has been considered - but is it worth the effort and the
>>> complications?  TRIM has been implemented in several filesystems (ext4
>>> and, I believe, btrfs) - but is disabled by default because it
>>> typically slows down the system.  You are certainly correct that
>>> putting TRIM at the back of the queue will avoid the delays it causes
>>> - but it still will not give any significant benefit (except for old
>>> SSDs with limited garbage collection and small over-provisioning ),
>>> and you have a lot of extra complexity to ensure that a TRIM is never
>>> pushed back until after a new write to the same logical sectors.
>>
>> I think that you are vastly understating the need for discard support or
>> what your first hand experience is, so let me  inject some facts into
>> this thread from working on this for several years (with vendors) :)
>>
>
> That is quite possible - my experience is limited.  My aim in this discussion 
> is not to say that TRIM should be ignored completely, but to ask if it really 
> is necessary, and if its benefits outweigh its disadvantages and the added 
> complexity.  I am trying to dispel the widely held myths that TRIM is 
> essential, that SSDs are painfully slow without it, that SSDs do not work with 
> RAID because RAID does not support TRIM, and that you must always enable TRIM 
> (and "discard" mount options) to get the best from your SSDs.

It really is required, the question and challenge is how to use it correctly and 
how to use the right technique on the right device.

If you have an extremely light workload on any device (an SSD in a laptop used 
for web browsing?), this probably won't matter for a long time but also would 
not impact your performance much since you are not pushing a lot of IO :)

>
> Nothing makes me happier here than seeing someone with strong experience from 
> multiple vendors bringing in some facts - so thank you for your comments and 
> help here.
>
>> Overview:
>>
>> * In Linux, we have "discard" support which vectors down into the device
>> appropriate method (TRIM for S-ATA, UNMAP/WRITE_SAME+UNMAP for SCSI,
>> just discard for various SW only block devices)
>> * There is support for inline discard in many file systems (ext4, xfs,
>> btrfs, gfs2, ...)
>> * There is support for "batched" discard (still online) via tools like
>> fstrim
>>
>
> OK.
>
>> Every SSD device benefits from TRIM and the SSD companies test this code
>> with the upstream community.
>>
>> In our testing with various devices, the inline (mount -o discard) can
>> have a performance impact so typically using the batched method is better.
>>
>
> I am happy to see you confirm this.  I think fstrim is a much more practical 
> choice than inline trim for many uses (with SATA SSD's at least - SCSI/SAS 
> SSD's have better "trim" equivalents with less performance impact, since they 
> can be queued).  I also think fstrim will work better along with RAID and 
> other layered systems, since it will have fewer, larger TRIMs and allow the 
> RAID system to trim whole stripes at a time (and just drop any leftovers).

The basic observation - again important to note that this is for S-ATA devices, 
not all discard enabled devices - is that an ATA_TRIM command takes about the 
same time regardless of the size being trimmed. It is also currently a 
non-queued command, so we shut down NCQ (draining the queue for a S-ATA device 
on each command).

Basically a good idea for S-ATA to use fewer commands to minimize that impact.

The standards body T13 is thinking about fixing the non-queueable issue so this 
might improve.

Note again, there a loads of other device types where this is not such an impact.

As a footnote, if you want to see the various bits of capability we scrape out 
of devices, we put a lot of information into /sys/block/sda/queue (discard 
support, etc).

>
>> For SCSI arrays (less an issue here on this list), the discard allows
>> for over-provisioning of LUN's.
>>
>> Device mapper has support (newly added) for dm-thinp targets which can
>> do the same without hardware support.
>>
>>>
>>> It would be much easier and safer, and give much better effect, to
>>> make sure the block allocation procedure for filesystems emphasised
>>> re-writing old blocks as soon as possible (when on an SSD). Then
>>> there is no need for TRIM at all.  This would have the added benefit
>>> of working well for compressed (or sparse) hard disk image files used
>>> by virtual machines - such image files only take up real disk space
>>> for blocks that are written, so re-writes would save real-world disk
>>> space.
>>
>> Above you are mixing the need for TRIM (which allows devices like SSD's
>> to do wear levelling and performance tuning on physical blocks) with the
>> virtual block layout of SSD devices. Please keep in mind that the block
>> space advertised out to a file system is contiguous, but SSD's
>> internally remapped the physical blocks aggressively. Think of physical
>> DRAM and your virtual memory layout.
>
> I don't think I am mixing these concepts - but I might well be expressing 
> myself badly.
>
> Suppose the disk has logical blocks log000 to log499, and physical blocks 
> phy000 to phy599.  The filesystem sees 500 blocks, which the SSD's firmware 
> maps onto the 600 physical blocks as needed (20% overprovisioning).  We start 
> off with a blank SSD.
>
> The filesystem writes out a file to blocks log000 through log009. The SSD has 
> to map these to physical blocks, and picks phy000 through phy009.
>
> Then the filesystem deletes that file.  Logical blocks log000 to log009 are 
> now free for re-use by the filesystem.  But without TRIM, the SSD does not 
> know that - so it must preserve phy000 to phy009.
>
> Then the filesystem writes a new 10-block file.  If it picks log010 to log019 
> for the logical blocks, then the SSD will write them to phy010 through 
> phy019.  Everything works fine, but the SSD is carrying around these extra 
> physical blocks that it believes are important, because they are still mapped 
> to logical blocks log000 to log009, and the SSD does not know they are now 
> unused.
>
> But if instead the filesystem wrote the new file to log000 to log009, we would 
> have a different case.  The SSD would again allocate phy010 to phy019, since 
> it needs to use blank blocks. But now the SSD has changed the mapping for 
> log000 to phy010 instead of phy000, and knows that physical blocks phy000 to 
> phy009 are not needed - without a logical block mapping, they cannot be 
> accessed by the file system.  So these physical blocks can be re-cycled in 
> exactly the same manner as if they were TRIM'ed.
>
> In this way, if the filesystem is careful about re-using free logical blocks 
> (rather than aiming for low fragmentation and contiguous block allocation, as 
> done for hard disk speed), there is no need for TRIM. The only benefit of TRIM 
> is to move the recycling process to a slightly earlier stage - but I believe 
> that effect would be negligible with appropriate overprovisioning.
>
> That's my theory, anyway.

I think that any assumptions about the logical layout for an SSD mapping into 
the same physical layout is optimistic.

Still not clear to me why you are trying to combine the two concepts.

Putting things together (contiguous allocation) in your virtual address space 
(block space) is good since you can allocate larger IO's to get your file read 
from the device into DRAM.

Letting the target storage device know what is used/unused (discard) is totally 
unrelated. It allows the device to optimize/garbage collect/wear level/etc.

Not that simple allocation schemes are a bad idea for SSD's (why work harder 
than you need to, avoid wasting CPU cycles, etc), but it is not tied into 
discard or not.

If you want to see a lot of hard data on SSD's, there is a fairly solid body of 
work published at USENIX FAST conferences (www.usenix.org) including work on 
various firmware ideas, testing, etc.

>
>>
>> Doing a naive always allocate and reuse the lowest block would have
>> horrendous performance impact on certain devices. Even on SSD's where
>> seek is negligible, having to do lots of small IO's instead of larger,
>> contiguous IO's is much slower.
>
> Clearly the allocation algorithms would have to be different for SSDs and hard 
> disks (and I realise this complicates matters - an aim with the block device 
> system is to keep things device independent when possible.  There is always 
> someone who wants to make a three-way raid1 mirror from an SSD, a hard disk 
> partition, and a block of memory exported by iSCSI from a remote server - and 
> it is great that they can do so).  And clearly having lots of small IOs will 
> increase overheads and reduce any performance benefits.  But somewhere here is 
> the possibility to bias the filesystems' allocation schemes towards reuse, 
> giving most of the benefits of TRIM "for free".
>
> It may also be the case that filesystems already do this, and I am 
> recommending a re-invention of a wheel that is already optimised - obviously 
> you will know that far better than me.  I am just trying to come up with 
> helpful ideas.
>
> mvh.,
>
> David
>
>

It is unfortunately not just SSD's versus S-ATA spindles. We have SAS SSD's, 
PCI-e SSD's, enterprise arrays (SCSI luns), consumer S-ATA SSDs and software 
only discard enabled devices.

We do work hard to deduce the generic type of the device (again, see the 
/sys/block information) but we need to be careful not to spin into a ton of 
device specific algorithms :)

Ric


