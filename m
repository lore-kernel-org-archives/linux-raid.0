From: David Brown <david.brown@hesbynett.no>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 15:15:52 +0100
Message-ID: <58D13598.50403@hesbynett.no>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net> <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au> <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com> <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net> <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au> <583576ca-a76c-3901-c196-6083791533ee@thelounge.net> <58D126EB.7060707@hesbynett.no> <09f4c794-8b17-05f5-10b7-6a3fa515bfa9@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <09f4c794-8b17-05f5-10b7-6a3fa515bfa9@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/03/17 14:24, Reindl Harald wrote:
> 
> 
> Am 21.03.2017 um 14:13 schrieb David Brown:
>> On 21/03/17 12:03, Reindl Harald wrote:
>>>
>>> Am 21.03.2017 um 11:54 schrieb Adam Goryachev:
>> <snip>
>>>
>>>> In addition, you claim that a drive larger than 2TB is almost certainly
>>>> going to suffer from a URE during recovery, yet this is exactly the
>>>> situation you will be in when trying to recover a RAID10 with member
>>>> devices 2TB or larger. A single URE on the surviving portion of the
>>>> RAID1 will cause you to lose the entire RAID10 array. On the other
>>>> hand,
>>>> 3 URE's on the three remaining members of the RAID6 will not cause more
>>>> than a hiccup (as long as no more than one URE on the same stripe,
>>>> which
>>>> I would argue is ... exceptionally unlikely).
>>>
>>> given that when your disks have the same age errors on another disk
>>> become more likely when one failed and the heavy disk IO due recovery of
>>> a RAID6 with takes *many hours* where you have heavy IO on *all disks*
>>> compared with a way faster restore of RAID1/10 guess in which case a URE
>>> is more likely
>>>
>>> additionally why should the whole array fail just because a single block
>>> get lost? the is no parity which needs to be calculated, you just lost a
>>> single block somewhere - RAID1/10 are way easier in their implementation
>>
>> If you have RAID1, and you have an URE, then the data can be recovered
>> from the other have of that RAID1 pair.  If you have had a disk failure
>> (manual for replacement, or a real failure), and you get an URE on the
>> other half of that pair, then you lose data.
>>
>> With RAID6, you need an additional failure (either another full disk
>> failure or an URE in the /same/ stripe) to lose data.  RAID6 has higher
>> redundancy than two-way RAID1 - of this there is /no/ doubt
> 
> yes, but with RAID5/RAID6 *all disks* are involved in the rebuild, with
> a 10 disk RAID10 only one disk needs to be read and the data written to
> the new one - all other disks are not involved in the resync at all

True...

> 
> for most arrays the disks have a similar age and usage pattern, so when
> the first one fails it becomes likely that it don't take too long for
> another one and so load and recovery time matters

False.  There is no reason to suspect that - certainly not to within the
hours or day it takes to rebuild your array.  Disk failure pattern shows
a peak within the first month or so (failures due to manufacturing or
handling), then a very low error rate for a few years, then a gradually
increasing rate after that.  There is not a very significant correlation
between drive failures within the same system, nor is there a very
significant correlation between usage and failures.  It might seem
reasonable to suspect that a drive is more likely to fail during a
rebuild since the disk is being heavily used, but that does not appear
to be the practice.  You will /spot/ more errors at that point - simply
because you don't see errors in parts of the disk that are not read -
but the rebuilding does not cause them.

And even if it /were/ true, then the key point is if there is an error
that causes data loss.  An error during reading for a RAID1 rebuild
means lost data.  An error during reading for a RAID6 rebuild means you
have to read an extra sector from another disk and correct the mistake.


