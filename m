From: Chris Worley <worleys@gmail.com>
Subject: Re: RAID50, despite chunk setting, does everything in 4KB blocks
Date: Mon, 19 Dec 2011 16:56:16 -0700
Message-ID: <CANWz5fg9e9A_FZDY28m38_c+EZ=NdjCBcqYhbW+8Qyyc1=BRxg@mail.gmail.com>
References: <CANWz5fhEz20oi9fXVuxngywMu6mZQtghMKCBCAwm5uOVXOD__w@mail.gmail.com>
	<20111220102415.1bb30e78@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111220102415.1bb30e78@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 19, 2011 at 4:24 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 19 Dec 2011 15:43:13 -0700 Chris Worley <worleys@gmail.com> w=
rote:
>
>> It doesn't really matter what chunk sizes I set, but, for example, I
>> create=A0three RAID5's of 5 drives each with a chunk size of 32K, an=
d
>> create a RAID0 comprised of the three RAID5's with a chunk size of
>> 64K:
>>
>> md0=A0: active raid0 md27[2] md26[1] md25[0]
>> =A0 =A0 =A0 1885098048 blocks super 1.2 64k chunks
>>
>> If I write to one of the RAID5's, using:
>>
>> # dd of=3D/dev/md27 =A0if=3D/dev/zero bs=3D1024k oflag=3Ddirect
>>
>> ... then "iostat -dmx 2" shows the drives being written to in 32K
>> chunks (avgrq-sz=3D64), as you'd expect.
>>
>> But, writing to the RAID0 that's striping the RAID5's, shows
>> everything being written in 4KB chunks (iostat shows=A0avgrq-sz=3D8)=
 to
>> the RAID0 as well as to the RAID5's.
>
> When writing to a RAID5 it *always* submits request to the lower laye=
rs in
> PAGE sized units. =A0This makes it much easier to keep parity and dat=
a aligned.
>
> The queue on the underlying device should sort the requests and =A0gr=
oup them
> together and your evidence suggests that it does.
>
> When writing to the RAID5 through a RAID0 it will only see 64K at a t=
ime but
> that shouldn't won't make any difference to its behaviour and should =
change
> the way the requests finally get to the device.
>
> So I have no idea why you see a difference.
>
> I suspect lots of block-layer tracing, and lots of staring at code an=
d lots
> of head scratching would be needed to understand what is really going=
 in.

Note that "max_segments" for the raid0 =3D 1, and max_segment_size =3D
4096, which tells Linux that the md can only take a single 4KB page
per IO request.

The scheduler shouldn't be involved in the transaction between the
RAID0 and RAID5, as neither uses the scheduler, so it shouldn't merge
there, but it also shouldn't be fragmenting.

Not having the RAID0 send the larger chunks to the RAID5's may cause
more fragmentation than the drive's scheduler will be able to
re-merge.

Chris
>
>
>>
>> Why is that? =A0Note that this is true for reading too. =A0Note I do=
n't
>> see the same problem when using RAID10 (via striped RAID1's) or
>> RAID100 (via striped RAID10's).
>
> RAID1 and RAID10 don't split things into pages so I can imagine that =
they
> might life easier for the scheduler.
>
> But the scheduler should =A0still get it right for RAID5 ....
>
>
> So - its a mystery. =A0Sorry.
>
> NeilBrown
>
>
>>
>> ... this is on SLES11 using a=A02.6.32.43-0.5 kernel.
>>
>> Thanks,
>>
>> Chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
