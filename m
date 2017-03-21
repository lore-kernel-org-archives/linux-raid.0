From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: proactive disk replacement
Date: Tue, 21 Mar 2017 22:56:45 +1100
Message-ID: <40485bef-feba-a0ae-5e90-3fc51795c29d@websitemanagers.com.au>
References: <3FA2E00F-B107-4F3C-A9D3-A10CA5F81EC0@allygray.2y.net>
 <11c21a22-4bbf-7b16-5e64-8932be768c68@websitemanagers.com.au>
 <CAPrpM6wtQe=h1AE-PbFr0-DyZ_wRN7gvibjfn86W0mQz77xnLg@mail.gmail.com>
 <f0916e66-8ea7-3363-3600-1d2cd68e85af@thelounge.net>
 <02316742-3887-b811-3c77-aad29cda4077@websitemanagers.com.au>
 <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <583576ca-a76c-3901-c196-6083791533ee@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, Jeff Allison <jeff.allison@allygray.2y.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, but I'm just seeing scaremongering and things that don't compute. 
Possibly I'm just not seeing it, but I don't see your advise being given 
by a majority of "experts" either on this list or elsewhere. I'll try to 
refrain from responding beyond this one, and return to lurking and 
hopefully learning more.

Also, please note that the quoting / attribution seems to be wrong 
(inverted).

On 21/3/17 22:03, Reindl Harald wrote:
>
> Am 21.03.2017 um 11:54 schrieb Adam Goryachev:
>> On 21/3/17 20:54, Reindl Harald wrote:
>>> and about RAID5/RAID6 versus RAID10: both RAID5 and RAID6 suffer from
>>> the same problems - due rebuild you have a lot of random-IO load on
>>> all remaining disks which leads in bad performance and make it more
>>> likely that before the rebuild is finished another disk fails, RAID6
>>> produces even more random IO because of the double parity and if you
>>> have a Unrecoverable-Read-Error on RAID5 you are dead, RAID6 is not
>>> much better here and the probability of a URE becomes more likely with
>>> larger disks
>>>
>>> RAID10: less to zero performance impact due rebuild and no random-IO
>>> caused by the rebuild, it's just "read a disk from start to end and
>>> write the data on another disk linear" while the only head moves on
>>> your disks is the normal workload on the array
>>>
>>> with disks 2 TB or larger you can make the conclusion "do not use
>>> RAID5/6 anymore and when you do be prepared that you won't survive a
>>> rebuild caused by a failed disk"
>>>
>> I can't say I'm an expert in this, but in actual fact, I disagree with
>> both your arguments against RAID6...
>> You say recovery on a RAID10 is a simple linear read from one drive (the
>> surviving member of the RAID1 portion) and a linear write on the other
>> (the replaced drive). You also declare that there is no random IO with
>> normal work load + recovery. I think you have forgotten that the "normal
>> workload" is probably random IO, but certainly once combined with the
>> recovery IO then it will be random IO.
>
> but the point is that with RAID5/6 the recovery itself is *heavy 
> random IO* and that get *combined* with the random IO auf the normal 
> workload and that means *heavy load on the disks*
random IO is the same as random IO, regardless of the "cause" of making 
the IO random.
In most systems, you won't be running anywhere near the IO limits, so 
allowing your recovery some portion of IO is not an issue.
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
> become more likely when one failed and the heavy disk IO due recovery 
> of a RAID6 with takes *many hours* where you have heavy IO on *all 
> disks* compared with a way faster restore of RAID1/10 guess in which 
> case a URE is more likely
>
URE's are based on amount of data read, and that isn't cumulative, every 
block read starts again with the same chance. If winning lottery is a 
chance of 100:1 it doesn't mean you will win at least once if you buy 
100 tickets. So reading 200,000,000 blocks also doesn't ensure you will 
see a URE (equally, you just might be lucky and win the lottery more 
than once, and get more than one URE).
In any case, if you only have a single source of data, then you are more 
likely to lose it (this is one of the reasons for RAID and backups). So 
RAID6 which stores your data in more than one location (during a drive 
failure event) is better.
BTW, just because you say that you will suffer a URE under heavy load 
doesn't make it true. The load factor doesn't change the frequency of a 
URE (even though it sounds possible).
> additionally why should the whole array fail just because a single 
> block get lost? the is no parity which needs to be calculated, you 
> just lost a single block somewhere - RAID1/10 are way easier in their 
> implementation
Equally, worst case, you have multiple URE on the same stripe on RAID6 
only loses a single stripe (ok, a stripe is bigger than a block, but 
still much less likely to occur anyway).
>
>> In addition, with a 4 disk RAID6 you have a 100% chance of surviving a 2
>> drive failure without data loss, yet with 4 disk RAID10 you have a 50%
>> chance of surviving a 2 drive failure.
>
> yeah and you *need that* when it takes many hours ot a few days until 
> your 8 TB RAID6 is resynced while the whole time *all disks* are under 
> heavy stress
Why are all disks under heavy stress? Again, you don't operate (under 
normal conditions) at a heavy stress level, you need room to grow, and 
also peak load is going to be higher but for short duration. Normal 
activity might be 50% of maximum, degraded performance together with 
recovery might push that to 80%, but disks (decent ones) are not going 
to have a problem doing simple read/write activity, that is what they 
are designed for right?
>
>> Sure, there are other things to consider (performance, cost, etc) but on
>> a reliability point, RAID6 seems to be the far better option
>
> *no* - it takes twice as long to recalculate from parity and stresses 
> the remaining disks twice as hard as RAID5 and so you pretty soon end 
> with lost both of the disk you can lose without the array goes down 
> while you still have many hours remaining recovery time
>
> here you go: 
> http://www.zdnet.com/article/why-raid-6-stops-working-in-2019/
That was written in 2010, 2019 is only 2 years away, (unless you meant 
2029 and it was a typo) and I don't see evidence of that being true nor 
becoming true in such a short time. We don't see many (any?) people 
trying to recover their RAID6 arrays with double URE failures.

You say it takes twice as long to recalculate from parity for RAID6 
compared to RAID5, but with CPU performance, this is still faster than 
the drive speed (unless you have NVMe or some SSD's, but then I assume 
the whole URE issue is different there anyway). Also, why do you think 
it stresses the disks twice as hard as RAID5? To recover a RAID5 you 
need a full read of all surviving drives, that's 100% read. To recover a 
RAID6 you need a full read of all remaining drives minus one, so that is 
less than 100% read. So why are you "stressing the remaining disks twice 
as hard"? Also, why does a URE equal losing a disk, all you do is read 
that block from another member in the array, and fix the URE at the same 
time.

If anything, you might suggest triple mirror RAID (what is that called? 
RAID110?)
If I was to believe you, then that is the only sensible option, with 
triple mirror, when you lose any one drive, then you may recover by 
simply reading from the surviving members, and you are no worse off 
under any scenario. Even losing any two drives and you are still 
protected, potentially you can lose up to 4 drives without data loss 
(assuming a minimum of 6 drives). However, cost is a factor here.

Finally, other than RAID110 (really, what is this called?) do you have 
any other sensible suggestions? RAID10 just doesn't seem to be it, and 
zfs doesn't seem to be mainstream enough either, same with btrfs and 
other FS's which can do various checksum/redundant data storage.

PS, In case you are wondering, I am still running 8 drive RAID5 in real 
life workloads, and don't have any problems with data loss (albeit, I do 
use DRBD to replicate the data between two systems with RAID5 each, so 
you can call that RAID51 perhaps, but the point remains, I've never 
(yet) lost an entire RAID5 array due to multiple drive failure or URE's).

