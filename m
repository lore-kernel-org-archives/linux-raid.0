From: Curtis J Blank <curt@curtronics.com>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Wed, 31 Oct 2012 12:34:42 -0500
Message-ID: <50916132.3010405@curtronics.com>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com> <5090E239.9040302@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5090E239.9040302@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/31/12 03:32, David Brown wrote:
>
> There will always be pathological cases like this where TRIM could be a
> win.  But on the other hand, there are pathological cases where TRIM
> causes great slowdowns - such as deleting a lot of files (as sending
> TRIM commands is very slow).
>
> If you actually want to using your SSD in such a way, with lots of big,
> fast deletions and writings, then you can help it out by
> "short-stroking" it.  You take your new SSD (or newly "secure erased"
> SSD) and partition it to only use part of the space - leave some extra
> at the end.  This extra space increases the over-provisioning of the
> disk, and therefore increases the amount of free blocks you have at any
> given time.
>

I was planning, all the partitions i.e. mount points will be below 50% 
used, most way below that and I don't see them filling up. That is on 
purpose, theses SSD's are for the OS to gain performance and not a lot 
of data storage with the exception of mysql.

So, if I have unused space at the end of the SSD, say 60G out of the 
256G don't use it, don't partition it the SSD will use it for what ever? 
It will know that it can use it when in a RAID1 set? Or make the raidset 
only using cylinders to 196G and partition that leaving the rest unused?

Ok, the only areas that will have a lot of writes are /var/log, logs are 
moved to a dated directory every 24 hours then gzip'd tarballed after 14 
days and the tarball kept and the logs erased. Sounds like the normal 
filesystem reuse of blocks will negate the need for TRIM. Do want 
/var/log on the SSD's because a lot of logging is done and want the 
performance there so as to keep iowait as low as possible.

/home with user accounts, mine only really, getting email will cause a 
lot of activity so maybe /home doesn't need to be on the SSD. Don't 
really need SSD performance there. Same for /usr/local which is a MP and 
/usr/local/src is where I do all my code development.

/mysql where all my DB's are and are very active and I want on the SSD's 
for the performance. This a good idea or not? Two DB's are very active 
one doing mostly inserts and updates so not too bad there, another doing 
a real lot of inserts and deletes. If you're familiar with ZoneMinder 
and how events are saved then later deleted a real lot of activity there.

>
> I'd add a case 3 to your list:
>
> Case 3: A file is erased.  If you have TRIM, the data blocks used by the
> file can be marked as "unneeded" by the SSD.  Without TRIM, the SSD
> thinks they are still important.  But the OS/filesystem knows the LBAs
> are free, and will re-use them sooner or later.  As soon as they are
> re-used, the SSD will mark the old physical blocks as unneeded and can
> garbage-collect them.  Without TRIM, this collection is delayed - but it
> still happens, and as long as the SSD has other free blocks, the delay
> has no impact on performance.
>
>>
>>> As far as I understand TRIM, among other things, it allows the SSD
>>> to combine the invalid pages into a block so the block can be
>>> erased thus making the pages ready to be written individually and
>>> avoiding the read-erase-modify-write of the block when a page
>>> changes, i.e. write amplification.
>>
>> It will do this with or without TRIM. TRIM simply is a mechanism for
>> the file system to inform the SSD of this in advance, in the case of
>> file deletions, where it may be some time before the SSD is informed
>> those blocks are "free" when the file system decides to reuse those
>> sectors.
>>
>>> Even if it does a read-modify-write to a new block then acks the
>>> write and does the erase after in the background it's still
>>> overhead in the read-modify-write i.e. read a whole block, modify a
>>> page, write a whole block, instead of just being able to write a
>>> page.
>
> The SSD doesn't do that.  If make a change to data that is in a page in
> the middle of an erase block, it is only that page that is copied (for
> RMW) to another free page in the same or a different erase block.  The
> original page is marked "unneeded".  TRIM makes no difference to this
> process.  All it does is make it more likely that the other pages in the
> same block are marked "unneeded" at an earlier stage, so the whole old
> block can be recycled earlier.  But as I said above, doing this earlier
> or later makes no difference to performance.
>

Ok but what about making a change to a page in a block whose other pages 
are valid? The whole block gets moved then the old block is later 
erased? That's what I'm understanding which sounds ok.

I think I was over thinking this. If a page changes the only way to do 
that is read-modify-write of the block to where ever. So it might as 
well be to an already erased block. I was getting hung up on having 
erased pages in the blocks that can be immediately and just written. 
Period. But that only occurs when appending data to a file. Let the 
filesystem and SSD's do there thing...

I'm really thinking I don't need TRIM now. And when it is finally in the 
kernel I can maybe try it. I was worried that if I don't do it from the 
start it be too late later after the SSD's had been used for a while to 
get the full benefit of it.


>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

