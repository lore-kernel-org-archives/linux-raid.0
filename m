From: David Brown <david@westcontrol.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Fri, 17 Feb 2012 15:57:31 +0100
Message-ID: <4F3E6ADB.2040005@westcontrol.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org> <4F39D9B2.3050305@hardwarefreak.com> <20120214113832.GA6157@www5.open-std.org> <4F3AEDEF.2000608@hardwarefreak.com> <20120215083058.GA8821@cthulhu.home.robinhill.me.uk> <4F3BB385.4000608@hardwarefreak.com> <4F3BD1F6.8080309@westcontrol.com> <4F3E5325.3060001@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3E5325.3060001@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: keld@keldix.com, CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/02/2012 14:16, Stan Hoeppner wrote:
> On 2/15/2012 9:40 AM, David Brown wrote:
>
>> Like Robin said, and like I said in my earlier post, the second copy is
>> on a different disk.
>
> We've ended up too deep in the mud here.  Keld's explanation didn't make
> sense resulting in my "huh" reply.  Let's move on from there back to the
> real question.
>
> You guys seem to assume that since I asked a question about the near,far
> layouts that I'm ignorant of them.  These layouts are the SNIA
> integrated adjacent stripe and offset stripe mirroring.  They are well
> known.  This is not what I asked about.
>

As far as I can see (from the SNIA DDF Technical Position v. 2.0), md 
raid10,n2 is roughly SNIA RAID-1E "integrated adjacent stripe 
mirroring", while raid10,o2 (offset layout) is roughly SNIA RAID-1E 
"Integrated offset stripe mirroring".  I say roughly, because I don't 
know if SNIA covers raid10 with only 2 disks, and I am not 100% sure 
about whether the choice of which disk mirrors which other disk is the same.

I can't see any SNIA level that remotely matches md raid10,far layout.

>> As far as I can see, you are the only one in this thread who doesn't
>> understand this.  I'm not sure where the problem lies, as several people
>> (including me) have given you explanations that seem pretty clear to me.
>>   But maybe there is some fundamental point that we are assuming is
>> obvious, but you don't get - hopefully it will suddenly click in place
>> for you.
>
> Again, the problem is you're assuming I'm ignorant of the subject, and
> are simply repeating the boiler plate.
>
>> Forget writes for a moment.[snip]
>
> This saga is all about writes.  The fact you're running away from writes
> may be part of the problem.
>

The whole point of raid10,far is to improve read speed compared to other 
layouts - even though it is slower for writes.  Obviously you /can/ do 
writes, and obviously they are safe and mirrored - but for this 
read-heavy application the speed of writes should not be the main issue. 
  The point is that raid10,far will give faster /reads/ than other 
layouts.  No one is "running away" from writes - I am just putting them 
aside to help the explanation.

> Back to the original issue.  Coolcold and I were trying to figure out
> what the XFS write stripe alignment should be for a 7 disk mdraid10 near
> layout array.
>

That is certainly one issue - and it's something you know a lot more 
about than me.  So I am not getting involved in that (but I am listening 
in and learning).

But I can't sit by idly while you discuss details of the xfs striping 
over raid10,near when I believe a change to raid10,far will make a lot 
bigger difference to this read-heavy application.

> After multiple posts from David, Robin, and Keld attempting to 'educate'
> me WRT the mdraid driver read tricks which yield an "effective RAID0
> stripe", nobody has yet answered my question:
>
> What is the stripe spindle width of a 7 drive mdraid near array?

With "near" layout, it is basically 3.5 spindles.  raid10,n2 is the same 
layout as normal raid10 if the number of disks is a multiple of 2.  (See 
later before you react to the "3.5 spindles".)

With "far" or "offset" layout it is clearly 7 spindles.

As you say, md raid10 gives an "effective raid0 stripe" for offset and 
far layouts.

The difference with raid10,far compared to raid10,offset is that each of 
these raid0 stripe reads comes from the fastest half of the disk, with 
minimal head movement (while reading), and with better use of disk 
read-ahead.

>
> Do note that stripe width is specific to writes.  It has nothing to do
> with reads, from the filesystem perspective anyway.  For internal array
> operations it will.
>

I don't understand that at all.

To my mind, stripe width applies to reads and writes.  For reads, it is 
the number of spindles that are used in parallel while reading larger 
blocks of data.  For writes, it is in addition the width of a parity 
stripe for raid5 or raid6.

Normally, the filesystem does not care about stripe widths, either for 
reading or writing, just as it does not care whether you have one disk, 
an array, local disks, iSCSI disks, or whatever.  Some filesystems care 
a /little/ about stripe width in that they align certain structures to 
stripe boundaries to make accesses more efficient.

> So lets take a look at two 4 drive RAIDs, a standard RAID10 and a
> RAID10,n/f.  The standard RAID10 array has a stripe across two drives.
> Each drive has a mirror.  Stripe writes are two device wide.  There are
> a total of 4 write operations to the drives, 2 data and two mirror data.
>   Stripe width concerns only data.
>

Fine so far.  In pictures, we have this:

Given data blocks 0, 1, 2, 3, ...., with copies "a" and "b", you have:

Standard raid10:

disk0 = 0a 2a 4a 6a 8a
disk1 = 0b 2b 4b 6b 8b
disk2 = 1a 3a 5a 7a 9a
disk3 = 1b 3b 5b 7b 9b

The stripe width is 2 - if you try to do a large read, you will get data 
from two drives in parallel.

Small writes (a single chunk) will involve 2 write operations - one to 
the "a" copy, and one to the "b" copy of each block, and will be done in 
parallel as they are on different disks.  Large writes will also be two 
copies, and will go to all disks in parallel.

"raid10,n2" layout is exactly the same as standard "raid10" - i.e., a 
stripe of mirrors - when there is a multiple of 2 disks.  For seven 
disks, the layout would be:

disk0 = 0a 3b 7a
disk1 = 0b 4a 7b
disk2 = 1a 4b 8a
disk3 = 1b 5a 8b
disk4 = 2a 5b 9a
disk5 = 2b 6a 9b
disk6 = 3a 6b 10a


> The n,r rotate the data and mirror data writes around the 4 drives.  So
> it is possible, and I assume this is the case, to write data and mirror
> data 4 times, making the stripe width 4, even though this takes twice as
> many RAID IOs compared to the standard RAID10 lyout.  If this is the
> case this is what we'd tell mkfs.xfs.  So in the 7 drive case it would
> be seven.  This is the only thing I'm unclear about WRT the near/far
> layouts, thus my original question.  I believe Neil will be definitively
> answering this shortly.
>

I think you are probably right here - it doesn't make sense to talk 
about a "3.5" spindle width.  If you call it 7, then it should work well 
even though each write takes two operations.


Let me draw the pictures of 4 and 7 disk layouts for raid10,f2 (far) and 
raid10,o2 (offset) to show what is going on:


Raid10,offset:

disk0 = 0a 3b 4a 7b 8a  11b
disk1 = 1a 0b 5a 4b 9a  8b
disk2 = 2a 1b 6a 5b 10a 9b
disk3 = 3a 2b 7a 6b 11a 10b

disk0 = 0a 6b 7a  13b
disk1 = 1a 0b 8a  7b
disk2 = 2a 1b 9a  8b
disk3 = 3a 2b 10a 9b
disk4 = 4a 3b 11a 10b
disk5 = 5a 4b 12a 11b
disk6 = 6a 5b 13a 12b

As you can guess, this gives good read speeds (7 spindles in parallel, 
though not ideal read-ahead usage), and writes speeds are also good 
(again, all 7 spindles can be used in parallel, and head movement 
between the two copies is minimal).  This layout is faster than standard 
raid10 or raid10,n2 in most use cases, though for lots of small parallel 
accesses (where striped reads don't occur) there will be no difference.


Raid10,far:

disk0 = 0a 4a 8a  ... 3b 7b 11b ...
disk1 = 1a 5a 9a  ... 0b 4b 8b  ...
disk2 = 2a 6a 10a ... 1b 5b 9b  ...
disk3 = 3a 7a 11a ... 2b 6b 10b ...

disk0 = 0a 7a  ... 6b 13b ...
disk1 = 1a 8a  ... 0b 7b  ...
disk2 = 2a 9a  ... 1b 8b  ...
disk3 = 3a 10a ... 2b 9b  ...
disk4 = 4a 11a ... 3b 10b ...
disk5 = 5a 12a ... 4b 11b ...
disk6 = 6a 13a ... 5b 12b ...

This gives optimal read speeds (7 spindles in parallel, ideal read-ahead 
usage, and all data taken from the faster half of the disks).  Writes 
speeds are not bad (again, all 7 spindles can be used in parallel, but 
you have large head movements between writing each copy of the data). 
For reads, this layout is faster than standard raid10, raid10,n2, 
raid10,o2, and even standard raid0 (since the average bandwidth is 
higher on the outer halves, and the average head movement during read 
seeks is lower).  But writes have longer latencies.


When you are dealing with multiple parallel small reads, much of the 
differences here disappear.  But there is still nothing to lose by using 
raid10,far if you have read-heavy applications - and the shorter head 
movements will still make it faster.  If the longer write operations are 
a concern, raid10,offset may be a better compromise - it is certainly 
still better than raid10,near.


> There is a potential problem with this though, if my assumption about
> write behavior of n/f is correct.  We've now done 8 RAID IOs to the 4
> drives in a single RAID operation.  There should only be 4 RAID IOs in
> this case, one to each disk.  This tends to violate some long accepted
> standards/behavior WRT RAID IO write patterns.  Traditionally, one RAID
> IO meant only one set of sector operations per disk, dictated by the
> chunk/strip size.  Here we'll have twice as many, but should
> theoretically also be able to push twice as much data per RAID write
> operation since our stripe width would be doubled, negating the double
> write IOs.  I've not tested these head to head myself.  Such results
> with a high IOPS random write workload would be interesting.
>

Most of my comments here are based on understanding the theory, rather 
than the practice - it's been a while since I did any benchmarking with 
different layouts and that was not very scientific testing.  I certainly 
agree it would be interesting to see test results.

I can't say if the extra writes will be an issue - it may conceivably 
affect speeds if the filesystem is optimised on the assumption that a 
write to 7 spindles means only 7 head movements and 7 write operations. 
  But this is the same issue as you always get with layered raid - 
logically speaking, Linux raid10 (regardless of layout) appears as a 
stripe of mirrors just like traditional layered raid10.

mvh.,

David
