From: Curtis J Blank <curt@curtronics.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Tue, 30 Oct 2012 09:29:30 -0500
Message-ID: <508FE44A.3040507@curtronics.com>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508FA2C6.2050800@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/30/12 04:49, David Brown wrote:
> On 28/10/2012 19:59, Curtis J Blank wrote:
>> I've got two new SSD's that I want to set up as RAID1 and use strictly
>> for the OS and MySQL DB's partitioned accordingly.
>>
>> I'll be using the 3.4.6 kernel for now in openSuSE 12.2 with ext4. So
>> after a lot of Google'n and reading it is my understanding that discard
>> is not sent to the devices via the raid drivers. I am aware of Shaohua
>> Li's patches to make it work but am not inclined to use them due to
>> openSuSE's Online Update replacing the kernel. I'm not against patching
>> and gen'ing a kernel, that used to be SOP, but just don't want deal with
>> that overhead. Of course unless I really need to.
>>
>> So I've read, and if I understand things correctly, I can use LVM and
>> RAID1 and the the discard commands will be sent to the devices. Is that
>> correct and currently the only way or is/are there other ways?
>>
>> I've also read that a lot of people are saying TRIM isn't needed because
>> the SSD's garbage collection is so good now TRIM isn't needed. But I
>> don't see how that could work because the SSD's don't have access to the
>> file system so they don't know which pages in the blocks are marked
>> unused to do any consolidation and erasing. And using TRIM is suggested
>> in a OCZ document I read and who's drives these are. Unless, the SDD
>> when it has to change a page moves the whole block then erases the old
>> block? But without TRIM in could be moving invalid data too because it
>> doesn't know that and that to me sure doesn't sound efficient and this
>> operation would be a perfect time to get rid of the invalid data if it
>> did know.
>>
>
> TRIM is not necessary.
>
> In some situations, TRIM can improve speed - in other cases, it can make
> the system significantly slower.  And it is only ever a help until the
> disk is getting fairly full.
>
> Before deciding about TRIM, it is important to understand what it does,
> and how it works.  TRIM lets the filesystem tell the SSD that a
> particular logical disk block is no longer in use.  The SSD can then
> find the physical flash block associated with that logical block, and
> mark it for garbage collection.
>
> If TRIM had been specified /properly/ for SATA (as it is for SCSI/SAS),
> then it would have been quite useful.  But it has two huge failings -
> there is no specification as to what the host will get if it tries to
> read the trimmed logical block (this is what makes it terrible for RAID
> systems), and it causes a pipeline flush and stall (which is what makes
> TRIM so slow).  The pipeline flushing and stalling will cause particular
> problems if you have a lot of metadata changes or small reads and writes
> in parallel - the sort of accesses you get with database servers.  So
> enabling TRIM will make databases significantly slower.
>
> And what do you lose if you /don't/ enable TRIM?  When a filesystem
> deletes a file, it knows the logical blocks are free, but the SSD keeps
> them around.  When the filesystem re-uses them for new data, the SSD
> then knows that the old physical blocks can be garbage-collected and
> re-used.  So all you are really doing by not using TRIM is delaying the
> collection of unneeded blocks.  As long as the SSD has plenty of spare
> blocks (and this is one of the reasons why any half-decent SSD has
> over-provisioning), TRIM gains you nothing at all here.  (If you have a
> very old SSD, or a very small one, or a very cheap one, then you will
> have poor over-provisioning and poor garbage collection - TRIM might
> then improve the SSD speed as long as the disk is mostly empty.)
>
> It is possible that blocks that could have been TRIMMED will get
> unnecessarily copied as part of a wear-levelling pass - but the effect
> of this is going to be completely negligible on the SSD's lifetime.
>
>
> So TRIM complicates RAID, limits your flexibility for how to set up your
> disks and arrays, and slows down your metadata transactions and small
> accesses.
>
>
> TRIM /did/ have a useful role for early SSDs - in particular, it
> improved the artificial benchmarks used by testers and reviewers.  So it
> has ended up being seen as a "must have" feature for both the SSD
> itself, and the software and filesystems accessing them.
>
>

Thanks for the explanation, makes a lot of sense, has me leaning towards 
not using TRIM.

But your explanation focused on blocks, leaving out pages. Does TRIM 
info sent to the device only do that on the block level or does it do it 
at the page level? I was thinking that if it did it at the page level 
the SSD's garbage collection would consolidate blocks by removing unused 
pages (akin to defragmenting) then erasing those pages thus making them 
ready to be written.

