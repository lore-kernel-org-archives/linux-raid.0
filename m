From: David Brown <david.brown@hesbynett.no>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 14:13:15 +0100
Message-ID: <58D126EB.7060707@hesbynett.no>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au> <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 12:03, Reindl Harald wrote:
> 
> 
> Am 21.03.2017 um 11:54 schrieb Adam Goryachev:
<snip>
> 
>> In addition, you claim that a drive larger than 2TB is almost certainly
>> going to suffer from a URE during recovery, yet this is exactly the
>> situation you will be in when trying to recover a RAID10 with member
>> devices 2TB or larger. A single URE on the surviving portion of the
>> RAID1 will cause you to lose the entire RAID10 array. On the other hand,
>> 3 URE's on the three remaining members of the RAID6 will not cause more
>> than a hiccup (as long as no more than one URE on the same stripe, which
>> I would argue is ... exceptionally unlikely).
> 
> given that when your disks have the same age errors on another disk
> become more likely when one failed and the heavy disk IO due recovery of
> a RAID6 with takes *many hours* where you have heavy IO on *all disks*
> compared with a way faster restore of RAID1/10 guess in which case a URE
> is more likely
> 
> additionally why should the whole array fail just because a single block
> get lost? the is no parity which needs to be calculated, you just lost a
> single block somewhere - RAID1/10 are way easier in their implementation

If you have RAID1, and you have an URE, then the data can be recovered
from the other have of that RAID1 pair.  If you have had a disk failure
(manual for replacement, or a real failure), and you get an URE on the
other half of that pair, then you lose data.

With RAID6, you need an additional failure (either another full disk
failure or an URE in the /same/ stripe) to lose data.  RAID6 has higher
redundancy than two-way RAID1 - of this there is /no/ doubt.

> 
>> In addition, with a 4 disk RAID6 you have a 100% chance of surviving a 2
>> drive failure without data loss, yet with 4 disk RAID10 you have a 50%
>> chance of surviving a 2 drive failure.
> 
> yeah and you *need that* when it takes many hours ot a few days until
> your 8 TB RAID6 is resynced while the whole time *all disks* are under
> heavy stress
> 
>> Sure, there are other things to consider (performance, cost, etc) but on
>> a reliability point, RAID6 seems to be the far better option
> 
> *no* - it takes twice as long to recalculate from parity and stresses
> the remaining disks twice as hard as RAID5 and so you pretty soon end
> with lost both of the disk you can lose without the array goes down
> while you still have many hours remaining recovery time

For RAID5 and RAID6, you read the same data - the full data stripe.  For
RAID5, you calculate and write a single parity block, while for RAID6
you calculate and write an additional parity block.  The disk reads are
the same in both cases, but you write out twice as many blocks.  You do
not stress the disks noticeably harder with RAID6 than with RAID5.

> 
> here you go: http://www.zdnet.com/article/why-raid-6-stops-working-in-2019/

This is an article heavily based on a Sun engineer trying to promote his
own alternative using scaremongering.

It is, however, correct in suggesting that RAID6 is more reliable than
RAID5.  And triple-parity raid (or additional layered RAID) is more
reliable than RAID6.  Nowhere does it suggest that RAID1 is more
reliable than RAID6.

It all boils down to the redundancy level.  Two-drive RAID1 pairs have a
single drive redundancy.  RAID5 has a single drive redundancy.  RAID6
has two drive redundancy - thus it is more reliable and will tolerate
more failures before losing data.  If this is not enough, and you don't
have triple parity RAID (it is not yet implemented in md - one day,
perhaps), you can use more mirrors on RAID1 or use layers such as a
RAID5 array built on RAID1 pairs.


