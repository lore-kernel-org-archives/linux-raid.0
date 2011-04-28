From: Phil Turmel <philip@turmel.org>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Wed, 27 Apr 2011 21:12:30 -0400
Message-ID: <4DB8BEFE.3020009@turmel.org>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>	<BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>	<BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>	<4DB71F3E.3040003@turmel.org> <BANLkTinpDOuTDu7fhbXNYwtvToUaCM=cmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinpDOuTDu7fhbXNYwtvToUaCM=cmQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mark,

On 04/27/2011 08:38 PM, Mark Knecht wrote:
> On Tue, Apr 26, 2011 at 12:38 PM, Phil Turmel <philip@turmel.org> wrote:
>> Hi Mark,
>>
>> On 04/26/2011 01:22 PM, Mark Knecht wrote:
>>> On Mon, Apr 25, 2011 at 6:30 PM, Mark Knecht <markknecht@gmail.com> wrote:
>> [trim /]
>>
>>> OK, I don't know exactly what I'm looking for a problem here. I ran
>>> the repair, then rebooted. Mismatch count was zero. It seemed the
>>> repair had worked.
>>>
>>> I then used the system for about 4 hours. After 4 hours I did another
>>> check and found the mismatch count had increased.
>>>
>>> What I need to get a handle on is:
>>>
>>> 1) Is this serious? (I assume yes)
>>
>> Maybe.  Are you using a file in this filesystem as swap in lieu of a dedicated swap partition?
>>
> 
> No, swap is on 3 drives as 3 partitions. The kernel runs swap and it
> has nothing to do with RAID other than it shares a portion of the
> drives.

OK.

>> I vaguely recall reading that certain code paths in the swap logic can abandon queued writes (due to the data no longer being needed by the VM), such that one or more raid members are left inconsistent.  Supposedly only affecting mirrored raid, and only for swap files/partitions.
>>
>> I don't know if this was ever fixed.  or even if anyone tried to fix it.
>>
> 
> md126 is the main 3-drive RAID1 root partition of a Gentoo install.
> Kernel is 2.6.38-gentoo-r1 and I'm using mdadm-3.1.4.
> 
> Nothing I do with echo repair seems to stick very well. For a few
> moments mismatch_cnt will read 0, but as far as I can tell if I do
> another echo check then I Get another high mismatch_cnt again.

Hmmm.  Since its not swap, this would make me worry about the hardware.  Have you considered shuffling SATA port assignments to see if a pattern shows up?  Also consider moving some of the drive power load to another PS.

> Once thing I'm wondering about is whether repair even works on a
> 3-disk RAID1? I've seen threads out there that suggest it doesn't and
> that possibly it's just bypassing the actual repair operation?

I've not heard of such.  But repair does *not* mean "pick the matching data and write to the third", but rather, "unconditionally write whatever is in the first mirror to the other two, if there's any mismatch".

One of Neil's links explains why, but it boils down to the lack of knowledge about the order writes occurred before the interruption (or bug) that caused the mismatch.

http://neil.brown.name/blog/20100211050355

>>> 2) How do I figure out which drive(s) of the 3 is having trouble?

After messing with hardware (one change at a time), brute-force is next:

Image the drives individually to new drives, or loop-mountable files on other storage, then assemble the copies as degraded arrays, one at a time.  For each, compute file-by-file checksums, and compare to each other and to backups or other external reference (you *do* have backups... ?).

Others may have better suggestions.  I've never had to do this.

>> Don't know.  Failing drives usually give themselves away with warnings in dmesg, and/or ejection from the array.  There's nothing in the kernel or mdadm that'll help here.  You'd have to do three-way voting comparison of all blocks on the member partitions.
>>
>>> 3) If there is a specific drive, what is the process to swap it out?
>>
>> mdadm /dev/mdX --fail /dev/sdXY
>> mdadm /dev/mdX --remove /dev/sdXY
>>
>> (swap drives)
>>
>> mdadm /dev/mdX --add /dev/sdZY
>>
> 
> I will have some additional things to figure out. There are 5 drives
> in this box with a mixture of 3-drive RAID1 & 5-drive RAID6 across
> them. If I pull a drive then I need to ensure that all four RAIDs are
> going to get rebuilt correctly. I suspect they will, but I'll want to
> be careful.

Paranoia is good.  Backups are better.

> Still, if I haven't a clue which drive is causing the mismatch then I
> cannot know which one to pull..

This is really a file system problem, and effort are underway to solve it.  Btrfs in particular, although it is still experimental.  I'm looking forward to that status changing.

> Thanks for your inputs!
> 
> Cheers,
> Mark

Regards,

Phil
