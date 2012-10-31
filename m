From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best way (only?) to setup SSD's for using TRIM
Date: Wed, 31 Oct 2012 09:32:57 +0100
Message-ID: <5090E239.9040302@hesbynett.no>
References: <508D808A.7040100@curtronics.com> <508FA2C6.2050800@hesbynett.no> <508FE44A.3040507@curtronics.com> <508FF85F.1030308@hesbynett.no> <Pine.LNX.4.64.1210301306470.20143@router.curtronics.com> <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B371ADF3-F328-4E1B-A6D2-87DE1974D8FF@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/10/2012 20:59, Chris Murphy wrote:
>
> On Oct 30, 2012, at 12:30 PM, Curt Blank <curt@curtronics.com>
> wrote:
>>
>> Right, and without TRIM to tell the SSD which page(s) are invalid
>> the garbage collection will never be able to do that so the
>> garbage collection will be carrying around and preserving invalid
>> page(s) when ever it does do something. Assuming there are invalid
>> pages in the blocks it is acting on. That to me seems inefficient
>> and for that reason says TRIM should be used?

That is correct - there will be unneeded data carried around that stops 
erase blocks from being garbage collected, and this unneeded data will 
occasionally be copied as part of compaction routines or wear-levelling 
functions.

There are a few things to note, however - there will /always/ be some 
unneeded data carried around, no matter how enthusiastic the filesystem 
is about issuing TRIMs (and filesystems /don't/ always issue a TRIM, 
especially in cases where the logical block will be re-used).

Also, the whole point of garbage collection (of TRIM'ed blocks or blocks 
whose logical sector has been overwritten) is so that when the host 
wants to write something, there are free blocks on the SSD already 
erased and waiting.  As long as the SSD has more than enough such free 
blocks at any given time, then it does not need any more - extra free 
blocks cannot improve the speed of the SSD.

Modern SSD's have over-provisioning - the disk claims to have "x" GB of 
space, and provides logical block number for "x" GB, but in fact it has 
something like "x + 15%" GB of actual flash space.  This extra 15% 
(actual values vary) provides two things - a safety margin for bad 
blocks, and a guarantee that there are enough pages that are known to be 
unneeded (even in the absence of TRIM), so that there can always be 
plenty of free erase blocks.  Since the host can only see "x" GB, then 
at most "x" GB of pages can be in use - at least "15% of x" GB pages are 
known to be free.  The SSD may need to re-arrange pages and blocks a bit 
("defragmenting"), but it can always do it.

There are pathological cases where TRIM could make a difference.  If you 
fill your disk with random data, then erase everything, then fill it 
again using very random writes, then your writes will be slowed as 
garbage collection has to put together new free erase blocks - while 
TRIM could have let the SSD erase blocks earlier.

>
> My understanding is that a modern consumer SSD works by copy-on-write
> for new or changed blocks, so this need for TRIM is not needed. The
> SSD is only writing data to "empty" or previously erased cells. The
> correlation between logical sectors and physical sectors is
> constantly adjusted, unlike on HDDs where this remapping tends to
> only occur with persistent write failures to a sector.

Correct.

>
> Case 1: A file is being overwritten, or modified in some way. The
> file system knows this file consumes, .e.g LBA's 5000 to 6000, and so
> it sends a write command to the SSD, in effect "write data to LBA
> 5000, 1000" ergo write a data stream starting at LBA 5000, for 1000
> (contiguous) sectors. Obviously a file system might break up this
> file into multiple fragments, so this is simplistic.
>
> The SSD doesn't actually do what it's told. It doesn't literally
> overwrite those LBA's, what it does is dereference them in its
> lookup. And remaps those LBA's to new empty cells, and writes your
> data there. Later, it can go back and do garbage college on those
> dereferenced cells when there are enough of them accumulated.

Exactly.  The SSD knows that the old physical blocks that used to be 
associated with LBA's 5000 to 6000 are now free, and can be garbage 
collected.  So for re-writing, TRIM is unnecessary.

>
> Case 2: A file is being newly written. The basic thing happens. It's
> possible the file system requests LBA's never before provisioned, or
> it requests LBA's from previously deleted files.

Yes.

>
> Either way, the SSD writes to empty cells. The case where it needs to
> write to occupied cells is if it runs out of empty ones, i.e. like
> David Brown said, in a case where the disk is getting full and poorly
> provisioned this could occur.
>
> It might also occur in some use cases where large files are being
> created/modified, destroyed, very frequently, such that the disk
> can't keep up with garbage collection. Maybe an example of this would
> be heavy VM usage with consumer SSDs. Why someone would do this I
> don't know but perhaps that's an example.

There will always be pathological cases like this where TRIM could be a 
win.  But on the other hand, there are pathological cases where TRIM 
causes great slowdowns - such as deleting a lot of files (as sending 
TRIM commands is very slow).

If you actually want to using your SSD in such a way, with lots of big, 
fast deletions and writings, then you can help it out by 
"short-stroking" it.  You take your new SSD (or newly "secure erased" 
SSD) and partition it to only use part of the space - leave some extra 
at the end.  This extra space increases the over-provisioning of the 
disk, and therefore increases the amount of free blocks you have at any 
given time.


I'd add a case 3 to your list:

Case 3: A file is erased.  If you have TRIM, the data blocks used by the 
file can be marked as "unneeded" by the SSD.  Without TRIM, the SSD 
thinks they are still important.  But the OS/filesystem knows the LBAs 
are free, and will re-use them sooner or later.  As soon as they are 
re-used, the SSD will mark the old physical blocks as unneeded and can 
garbage-collect them.  Without TRIM, this collection is delayed - but it 
still happens, and as long as the SSD has other free blocks, the delay 
has no impact on performance.


>
>
>> As far as I understand TRIM, among other things, it allows the SSD
>> to combine the invalid pages into a block so the block can be
>> erased thus making the pages ready to be written indiviually and
>> avoiding the read-erase-modify-write of the block when a page
>> changes, i.e. write amplification.
>
> It will do this with or without TRIM. TRIM simply is a mechanism for
> the file system to inform the SSD of this in advance, in the case of
> file deletions, where it may be some time before the SSD is informed
> those blocks are "free" when the file system decides to reuse those
> sectors.
>
>
>> Even if it does a read-modify-write to a new block then acks the
>> write and does the erase after in the background it's still
>> overhead in the read-modify-write i.e. read a whole block, modify a
>> page, write a whole block, instead of just being able to write a
>> page.

The SSD doesn't do that.  If make a change to data that is in a page in 
the middle of an erase block, it is only that page that is copied (for 
RMW) to another free page in the same or a different erase block.  The 
original page is marked "unneeded".  TRIM makes no difference to this 
process.  All it does is make it more likely that the other pages in the 
same block are marked "unneeded" at an earlier stage, so the whole old 
block can be recycled earlier.  But as I said above, doing this earlier 
or later makes no difference to performance.

>
>
> a.) Neglible.
 > b.) The file system does RWM at a block/cluster level
> anyway (typically this is 4KB).
>
>
> Chris Murphy--
 > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
>
>

