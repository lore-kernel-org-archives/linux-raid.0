From: hansbkk@gmail.com
Subject: Re: RAID10 striping vs LVM striping over RAID1 (noob)
Date: Mon, 29 Nov 2010 16:54:45 +0700
Message-ID: <AANLkTinpWPgzsrtX95QtTNaFN3ynhuJvs1x+7jYY0o_+@mail.gmail.com>
References: <AANLkTinW4sxsii=g-4hG_qSMjvyLk92XQPb5HHtGFT94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinW4sxsii=g-4hG_qSMjvyLk92XQPb5HHtGFT94@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to all for the feedback.

To summarize: RAID6 advantages over RAID10
   - greater fault tolerance
   - greater space efficiency with >4 drives
   - apparently easier to recover

disadvantages - additional CPU overhead, reduced performance

I still like the simplicity and ease of recovery of RAID1 (my original
scenario B), with the performance advantages a bonus.

But I plan to play around a bit, both for the practice and if I have
time to do some benchmarking.


>> I hadn't considered RAID6, as my understanding has been that it's
>> usually implemented by specialized "enterprise-level" hardware, as
>> opposed to my "consumer level" stuff, and much larger sets of disks
>> than what I'm working with.
>
> Well, somewhat larger.  Unless one is just starting out and plans to grow a
> great deal, a RAID6 array of 4 drives is fairly inefficient, although no
> worse than RAID1.  A RAID6 array of 6 drives is fairly reasonable, though.
> Beyond 6 drives, I definitely recommend RAID6.  A hot spare is a good idea,
> too.  As far as requiring "enterprise grade" hardware, that's not the case,
> at all.  Indeed, given the relative frailty of "consumer grade" hardware,
> RAID6 is all that more attractive.  Sequential hard drive failiures are not
> at all uncommon, given the size of many modern volumes.
>

>> Thanks Mikael, yes simplicity is critical to "ease of recovery",
>> especially given my noobness. Are you saying RAID6 is "simpler" than
>> RAID10? Actually your reminder of KISS is nudging me to straight
>> RAID1, maybe even drop the LVM.
>
>        RAID6 allows for high reliability, allowing up to 2 random volume
> failures without taking the array offline.  RAID10 can suffer more volume
> failures, but only specific volumes can fail.  If it is the wrong pair of
> volumes, the array is toast.  RAID6 allows for easier expansion with minimal
> management from the admin.  For your purposes, you could employ RAID6 for
> your data volumes and then create RAID1 arrays of the RAID6 volumes for
> backup purposes.  You'll need to buy several more drives though.


>> Although performance isn't such a big issue for me, my (several
>> generations old now) CPU will already be handling all the disk I/O
>> discussed - plus the filer's going to be serving out a
>> yet-to-be-determined number of iSCSI LUNs, so I'm willing to trade off
>> space penalty for the performance and (even more important) the
>> simplicity of RAID1 or RAID10.
>>
>> Regarding the possibility (IMO slim) of the primary drive failing
>> during a straight-mirror rebuild, the first (smaller) RAID set is
>
>        It's not that slim, at all.
>


>> My understanding is that putting RAID10 on a single
>> pair of disks is A- in effect the same as RAID1 in the event one of
>> the drives fails but B- that there might be a performance boost  in
>> normal operations from the striping feature?
>>
>> And yes that's another question - feedback from anyone welcome. . .
>
> Yes.  But you may only loose 1.3 disks - if one disk fails, it's ok, but
> the second disk falure must happen at the right spot.  Which makes it an
> unsafe choice.
>


>> Thanks Mikael, yes simplicity is critical to "ease of recovery",
>> especially given my noobness. Are you saying RAID6 is "simpler" than
>> RAID10? Actually your reminder of KISS is nudging me to straight
>> RAID1, maybe even drop the LVM.
>
> From the user-side and the ease of recovery-side RAID6 is simpler to handle.
>
