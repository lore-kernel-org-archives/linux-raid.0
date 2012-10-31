From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Wed, 31 Oct 2012 21:04:02 +0100
Message-ID: <50918432.906@hesbynett.no>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no> <50916132.3010405@curtronics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50916132.3010405@curtronics.com>
Sender: linux-raid-owner@vger.kernel.org
To: Curtis J Blank <curt@curtronics.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/10/12 18:34, Curtis J Blank wrote:
> On 10/31/12 03:32, David Brown wrote:
>>
>> There will always be pathological cases like this where TRIM could be a
>> win.  But on the other hand, there are pathological cases where TRIM
>> causes great slowdowns - such as deleting a lot of files (as sending
>> TRIM commands is very slow).
>>
>> If you actually want to using your SSD in such a way, with lots of big,
>> fast deletions and writings, then you can help it out by
>> "short-stroking" it.  You take your new SSD (or newly "secure erased"
>> SSD) and partition it to only use part of the space - leave some extra
>> at the end.  This extra space increases the over-provisioning of the
>> disk, and therefore increases the amount of free blocks you have at any
>> given time.
>>
>
> I was planning, all the partitions i.e. mount points will be below 50%
> used, most way below that and I don't see them filling up. That is on
> purpose, theses SSD's are for the OS to gain performance and not a lot
> of data storage with the exception of mysql.
>
> So, if I have unused space at the end of the SSD, say 60G out of the
> 256G don't use it, don't partition it the SSD will use it for what ever?
> It will know that it can use it when in a RAID1 set? Or make the raidset
> only using cylinders to 196G and partition that leaving the rest unused?
>

If you want to leave extra space to improve the over-provisioning (it is 
typically not necessary with more high-end SSDs, but you might want to 
do it anyway), then it is important that the extra space is never 
written.  The easiest way to ensure that is to leave extra space during 
partitioning.  But be careful with raid - you have to use the 
partition(s) for your raid devices, not the disk, or else you will write 
to the entire SSD during the initial raid1 sync.

A typical arrangement would be to make a 1 GB partition at the start of 
each SSD, then perhaps a 4 GB partition, then a big partition of about 
200 GB in this case.  Make a raid1 with metadata 1.0 from the first 
partition of each disk for /boot, to make life easier for the 
bootloader.  Use the second partition of each disk for swap (no need for 
raid here unless you are really concerned about uptime in the face of 
disk failure and you actually expect to use swap significantly - in 
which case go for raid1 or raid10 if you have more than 2 disks).  Use 
the third partition for your main raid (such as raid1, or perhaps 
something else if you have more than two disks).

> Ok, the only areas that will have a lot of writes are /var/log, logs are
> moved to a dated directory every 24 hours then gzip'd tarballed after 14
> days and the tarball kept and the logs erased. Sounds like the normal
> filesystem reuse of blocks will negate the need for TRIM. Do want
> /var/log on the SSD's because a lot of logging is done and want the
> performance there so as to keep iowait as low as possible.
>

That sounds fine.

However, note that writing files like logs should not normally cause 
delays - no matter how slow the disks.  The writes will simply buffer up 
in ram and be written out when there is the opportunity - processes 
don't have to wait for the writes to complete.  Speed (and latency) is 
only really important for reads (since processes will typically have to 
wait for the read to complete), and synchronised writes (where the 
application waits until it is sure the data hits the platter).  Even 
reads are not an issue if they are re-reads of data in the cache, and 
you have plenty of memory.

Still, there is no harm in putting /var/log on an SSD.

> /home with user accounts, mine only really, getting email will cause a
> lot of activity so maybe /home doesn't need to be on the SSD. Don't
> really need SSD performance there. Same for /usr/local which is a MP and
> /usr/local/src is where I do all my code development.
>

Unless you have huge amounts of data, put it on the SSD anyway.

> /mysql where all my DB's are and are very active and I want on the SSD's
> for the performance. This a good idea or not? Two DB's are very active
> one doing mostly inserts and updates so not too bad there, another doing
> a real lot of inserts and deletes. If you're familiar with ZoneMinder
> and how events are saved then later deleted a real lot of activity there.

Put the DB's on the SSD.

As with all database applications, if you can get enough memory to have 
most work done without reading from disks, it will go faster.

With decent SSD's (and since you have quite big ones, I assume they are 
good quality), there is no harm in writing lots.  You can probably write 
at 30 MB/s continuously for years before causing any wearout on the disk.

>
>>
>> I'd add a case 3 to your list:
>>
>> Case 3: A file is erased.  If you have TRIM, the data blocks used by the
>> file can be marked as "unneeded" by the SSD.  Without TRIM, the SSD
>> thinks they are still important.  But the OS/filesystem knows the LBAs
>> are free, and will re-use them sooner or later.  As soon as they are
>> re-used, the SSD will mark the old physical blocks as unneeded and can
>> garbage-collect them.  Without TRIM, this collection is delayed - but it
>> still happens, and as long as the SSD has other free blocks, the delay
>> has no impact on performance.
>>
>>>
>>>> As far as I understand TRIM, among other things, it allows the SSD
>>>> to combine the invalid pages into a block so the block can be
>>>> erased thus making the pages ready to be written individually and
>>>> avoiding the read-erase-modify-write of the block when a page
>>>> changes, i.e. write amplification.
>>>
>>> It will do this with or without TRIM. TRIM simply is a mechanism for
>>> the file system to inform the SSD of this in advance, in the case of
>>> file deletions, where it may be some time before the SSD is informed
>>> those blocks are "free" when the file system decides to reuse those
>>> sectors.
>>>
>>>> Even if it does a read-modify-write to a new block then acks the
>>>> write and does the erase after in the background it's still
>>>> overhead in the read-modify-write i.e. read a whole block, modify a
>>>> page, write a whole block, instead of just being able to write a
>>>> page.
>>
>> The SSD doesn't do that.  If make a change to data that is in a page in
>> the middle of an erase block, it is only that page that is copied (for
>> RMW) to another free page in the same or a different erase block.  The
>> original page is marked "unneeded".  TRIM makes no difference to this
>> process.  All it does is make it more likely that the other pages in the
>> same block are marked "unneeded" at an earlier stage, so the whole old
>> block can be recycled earlier.  But as I said above, doing this earlier
>> or later makes no difference to performance.
>>
>
> Ok but what about making a change to a page in a block whose other pages
> are valid? The whole block gets moved then the old block is later
> erased? That's what I'm understanding which sounds ok.

No, the changed page will get re-mapped to a different page somewhere 
else - the unchanged data will remain where it was.  That data will only 
get moved if it makes sense for "defragmenting" to free up erase blocks, 
or as part of wear-levelling routines.

>
> I think I was over thinking this. If a page changes the only way to do
> that is read-modify-write of the block to where ever. So it might as
> well be to an already erased block. I was getting hung up on having
> erased pages in the blocks that can be immediately and just written.
> Period. But that only occurs when appending data to a file. Let the
> filesystem and SSD's do there thing...
>
> I'm really thinking I don't need TRIM now. And when it is finally in the
> kernel I can maybe try it. I was worried that if I don't do it from the
> start it be too late later after the SSD's had been used for a while to
> get the full benefit of it.
>


I think what you really want to use is "fstrim" - this walks through a 
filesystem metadata, identifies free blocks, and sends TRIM commands for 
each of them.  Obviously this can take a bit of time, and will slow down 
the disks while working, but you typically do it with a cron job in the 
middle of the night.

<http://www.vdmeulen.net/cgi-bin/man/man2html?fstrim+8>


I don't think the patches for passing TRIM through the md layer have yet 
made it to mainstream distro kernels, but once they do you can run fstrim.



Incidentally, have a look at the figures in this:

<https://patrick-nagel.net/blog/archives/337>

A sample size of 1 web page is not great statistically evidence, but the 
difference in the times for "sync" are quite large...



