From: Chris Murphy <lists@colorremedies.com>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 20:48:24 -0600
Message-ID: <CAJCQCtQyqH2eOmyqmpz0sZzD9ia4Q8RsA8eb+6inuDY6QP+Tyg@mail.gmail.com>
References: <20160823050947.GL32250@subspacefield.org> <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org> <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
 <e75dcc05-f0c2-2152-9d24-5ff42ea02657@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e75dcc05-f0c2-2152-9d24-5ff42ea02657@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 8:33 PM, Phil Turmel <philip@turmel.org> wrote:
> On 08/25/2016 06:32 PM, Chris Murphy wrote:
>
>>> It's possible, but why would you ever end up with a GPT in a partition?
>>
>> In every case I've seen, it was user error. I haven't heard of things
>> putting GPTs in partitions, and in a sense I'd say it's a bug if any
>> utility lets a user do that. Nesting GPT's in partitions, bad idea,
>> although it *should* be innocuous because it shouldn't be seen/honored
>> by anything that doesn't go looking for it because it doesn't belong
>> there.
>
> It is possible to run gdisk or parted on /dev/sdX1 accidentally instead
> of /dev/sdX.  Pretty simple user error.
>
> It is also possible and appropriate if using v0.90 or v1.0 metadata on
> an array and you partition the array itself.  Then it'll show up on
> member 0, any mirror of member 0, and possibly on a parity disk (if
> intervening blocks are zero).

Right, so something like GPT on /dev/sda and /dev/sdb to create sda1
and sdb1, then mdadm -C /dev/md0 --metadata=1.0 ... /dev/sda1
/dev/sdb1, and then create a GPT on /dev/md0. The result is /dev/md0,
/dev/sda1, and /dev/sda2 will all appear to have the same GPT on them.

I would say that's probably a bad idea, I know some tools allow it,
but it creates an ambiguity. It could be argued to be inconsistent
with the UEFI spec. The only nesting it describes is MBR on a GPT
partition, not GPT nested in a GPT partition. This is probably also
better done using LVM. Otherwise we get nutty things...


-- 
Chris Murphy
