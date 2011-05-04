From: David Brown <david@westcontrol.com>
Subject: Re: Mirrored volume peformance questions
Date: Wed, 04 May 2011 09:42:40 +0200
Message-ID: <ipqvv6$ru1$1@dough.gmane.org>
References: <96B30EF4F3E17749BCFF7F1816090EDA02DCE41A87@EX-SEA31-B.ant.amazon.com> <BANLkTikcVPQwFEancNbOkKvdHTwdHDb=XA@mail.gmail.com> <20110503213430.GC24265@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110503213430.GC24265@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/05/2011 23:34, Keld J=F8rn Simonsen wrote:
> On Tue, May 03, 2011 at 04:52:07PM -0300, Roberto Spadim wrote:
>> 2011/5/3 Morad, Steve<morad@amazon.com>:
>>> I have a few questions about volume mirroring performance
>>> implications.
>>>
>>
>>> 2. Similarly, would a RAID10 configuration give me the same (or
>>> better) read behavior across these same disks, while providing
>>> twice the storage capacity of the above configuration?
>
> RAID10 and RAID1 gives the same storage capacity with the same
> disks.
>

Perhaps he meant a 4-drive RAID1 set?  That way reads for any data can=20
be taken for any drive.

> Linux MD RAID10 is actually just another way of doing raid1-like
> layouts.
>
>
>> in md world raid1+ raid0 !=3D raid10
>>
>> raid10 can use layouts raid1 can?t
>>
>> raid10 have diferent read_balance algorithms than raid1 raid10 with
>> far layout is better optimized for sequencial read (it?s like raid0
>> stripe) raid10 with near/offset layoute are better optimized for
>> multthread
>
> Hmm, raid10 near, offset and far are about the same for multithread,
> according to several benchmarks. Actually the far layout has
> significant better random read performance than the near layout in
> some thests, about 25 % better speed, and about 100 % bettter speed
> than raid1.
>

raid10,far is better for sequential reads - it gives better-than-raid0=20
performance on average since it will do striped reads from the faster=20
outer tracks.  And for multi-threaded reads, it should also be a little=
=20
faster than other raid10 layouts (and raid1, which is much the same as=20
raid10,near).  Since it prefers to get the data from the outer half, yo=
u=20
get the benefits of short-stroking your disks - faster transfer speeds=20
and less head movement.

The cost of raid10,far is greater head movement for writes - but that i=
s=20
not the OP's main concern.

If I interpreted correctly that the OP is considering a 4-way mirror,=20
then perhaps raid10,f4 is ideal - sequential reads will be taken from=20
all drives at once (in the outer quarter of the disks), and for=20
multi-thread reads all requested data can be found on any of the disks.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
