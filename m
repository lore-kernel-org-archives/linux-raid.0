From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Bit-Rot
Date: Sat, 4 Mar 2017 23:01:52 -0700
Message-ID: <CAJCQCtTO0A9BKKz1qGNBM3uiPLHsaf+uMGSrHABaKRhf3z2dVA@mail.gmail.com>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
 <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk> <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
 <dce0bbfd-ea6b-4ed8-668a-c883c2380aca@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dce0bbfd-ea6b-4ed8-668a-c883c2380aca@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 3, 2017 at 3:16 PM, Anthony Youngman
<antlists@youngman.org.uk> wrote:
>
>
> On 03/03/17 21:54, Gandalf Corvotempesta wrote:
>>
>> 2017-03-03 22:41 GMT+01:00 Anthony Youngman <antlists@youngman.org.uk>:
>>>
>>> Isn't that what raid 5 does?
>>
>>
>> nothing to do with raid-5
>>
>>> Actually, iirc, it doesn't read every stripe and check parity on a read,
>>> because it would clobber performance. But I guess you could have a switch
>>> to
>>> turn it on. It's unlikely to achieve anything.
>>>
>>> Barring bugs in the firmware, it's pretty near 100% that a drive will
>>> either
>>> return what was written, or return a read error. Drives don't return dud
>>> data, they have quite a lot of error correction built in.
>>
>>
>> This is wrong.
>> Sometimes drives return data differently from what was stored, or,
>> store data differently from the original.
>> In this case, if real data is "1" and you store "0", when you read
>> "0", no read error is made, but data is still corrupted.
>
>
> Do you have any figures? I didn't say it can't happen, I just said it was
> very unlikely.

Torn and misdirected writes do happen. There are a bunch of papers on
this problem indicating it's real. This and various other sources of
silent corrupt are why ZFS and Btrfs exist.


>>
>>
>> With a bit-rot prevention this could be fixed, you checksum "1" from
>> the source, write that to disks and if you read back "0", the checksum
>> would be invalid.
>
>
> Or you just read the raid5 parity (which I don't think, by default, is what
> happens). That IS your checksum. So if you think the performance hit is
> worth it, write the code to add it, and turn it on. Not only will it detect
> a bit-flip, but it will tell you which bit flipped, and let you correct it.

Parity isn't a checksum. Using it in this fashion is expensive because
it means computing parity for all reads, and means you can't do
partial stripe reads anymore. Next, even once you get a mismatch it's
ambiguous which strip (mdadm chunk) is corrupt. That'd normally be
exposed by the drive reporting an explicit read error. Since that
doesn't exist you'd have to fake "fail" each strip, rebuild from
parity, and compare.


>>
>>
>> This is what ZFS does. This is what Gluster does. This is what BRTFS does.
>> Adding this in mdadm could be an interesting feature.
>>
> Well, seeing as I understand btrfs doesn't do raid5, only raid1, then of
> course it needs some way of detecting whether a mirror is corrupt. I don't
> know about gluster or ZFS. (I believe raid5/btrfs is currently experimental,
> and dangerous.)

Btrfs supports raid1, 10, 5 and 6. It's reasonable to consider raid56
experimental because it has a number of gotchas, not least of which is
there are certain kinds of writes that are not COW, so the COW
safeguards don't always apply in a power failures. As for dangerous,
the opinions vary but probably something everyone can agree on is any
ambiguity with the stability of a file system is that it looks bad.

> But the question remains - is the effort worth it?

That's the central question. And to answer it, you'd need some sort of
rough design. Where are the csums going to be stored? Do you update
data strips before or after the csums? Either way, if this is now COW,
you have a moment of complete mismatching between data and csums, with
live data. So... that's a big problem actually. And if you have a
crash or power failure during writes, it's an even bigger problem. Do
you csum the party?


-- 
Chris Murphy
