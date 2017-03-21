From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 12:03:51 +0100
Message-ID: <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 21.03.2017 um 11:54 schrieb Adam Goryachev:
> On 21/3/17 20:54, Reindl Harald wrote:
>> Am 21.03.2017 um 03:33 schrieb Jeff Allison:
>>> I don't have a spare SATA slot I do however have a spare USB carrier,
>>> is that fast enough to be used temporarily?
>>
>> USB3 yes, USB2 don't make fun because the speed of the array depends
>> on the slowest disk in the spindle
>>
>> and about RAID5/RAID6 versus RAID10: both RAID5 and RAID6 suffer from
>> the same problems - due rebuild you have a lot of random-IO load on
>> all remaining disks which leads in bad performance and make it more
>> likely that before the rebuild is finished another disk fails, RAID6
>> produces even more random IO because of the double parity and if you
>> have a Unrecoverable-Read-Error on RAID5 you are dead, RAID6 is not
>> much better here and the probability of a URE becomes more likely with
>> larger disks
>>
>> RAID10: less to zero performance impact due rebuild and no random-IO
>> caused by the rebuild, it's just "read a disk from start to end and
>> write the data on another disk linear" while the only head moves on
>> your disks is the normal workload on the array
>>
>> with disks 2 TB or larger you can make the conclusion "do not use
>> RAID5/6 anymore and when you do be prepared that you won't survive a
>> rebuild caused by a failed disk"
>>
> I can't say I'm an expert in this, but in actual fact, I disagree with
> both your arguments against RAID6...
> You say recovery on a RAID10 is a simple linear read from one drive (the
> surviving member of the RAID1 portion) and a linear write on the other
> (the replaced drive). You also declare that there is no random IO with
> normal work load + recovery. I think you have forgotten that the "normal
> workload" is probably random IO, but certainly once combined with the
> recovery IO then it will be random IO.

but the point is that with RAID5/6 the recovery itself is *heavy random 
IO* and that get *combined* with the random IO auf the normal workload 
and that means *heavy load on the disks*

> In addition, you claim that a drive larger than 2TB is almost certainly
> going to suffer from a URE during recovery, yet this is exactly the
> situation you will be in when trying to recover a RAID10 with member
> devices 2TB or larger. A single URE on the surviving portion of the
> RAID1 will cause you to lose the entire RAID10 array. On the other hand,
> 3 URE's on the three remaining members of the RAID6 will not cause more
> than a hiccup (as long as no more than one URE on the same stripe, which
> I would argue is ... exceptionally unlikely).

given that when your disks have the same age errors on another disk 
become more likely when one failed and the heavy disk IO due recovery of 
a RAID6 with takes *many hours* where you have heavy IO on *all disks* 
compared with a way faster restore of RAID1/10 guess in which case a URE 
is more likely

additionally why should the whole array fail just because a single block 
get lost? the is no parity which needs to be calculated, you just lost a 
single block somewhere - RAID1/10 are way easier in their implementation

> In addition, with a 4 disk RAID6 you have a 100% chance of surviving a 2
> drive failure without data loss, yet with 4 disk RAID10 you have a 50%
> chance of surviving a 2 drive failure.

yeah and you *need that* when it takes many hours ot a few days until 
your 8 TB RAID6 is resynced while the whole time *all disks* are under 
heavy stress

> Sure, there are other things to consider (performance, cost, etc) but on
> a reliability point, RAID6 seems to be the far better option

*no* - it takes twice as long to recalculate from parity and stresses 
the remaining disks twice as hard as RAID5 and so you pretty soon end 
with lost both of the disk you can lose without the array goes down 
while you still have many hours remaining recovery time

here you go: http://www.zdnet.com/article/why-raid-6-stops-working-in-2019/
