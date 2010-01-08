From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: when read error ,where do we rewrite?
Date: Thu, 7 Jan 2010 22:35:29 -0800
Message-ID: <4877c76c1001072235m2790209exe0601e410889d52f@mail.gmail.com>
References: <6c394cc31001070441r1287f635q9c58dc836ce488b7@mail.gmail.com>
	 <20100107131855.GA10915@cthulhu.home.robinhill.me.uk>
	 <6c394cc31001072054v7368cc05kb7005b39d00c1c07@mail.gmail.com>
	 <6c394cc31001072059t2669afa8l5fed42ff77b3c134@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c394cc31001072059t2669afa8l5fed42ff77b3c134@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: dong wu <dongwucs@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 7, 2010 at 8:59 PM, dong wu <dongwucs@gmail.com> wrote:
> In the source code of raid5,when write error,it faulty the disk,not r=
emap
> the block. why do it use "remap the block"?
>
> 2010/1/8, dong wu <dongwucs@gmail.com>:
>> If it is written to the same block,will it read error again?
>> when read error,the low-level attempts a write and remap the block i=
f
>> the write fails.
>> where does it remap?
>> Is there any spare block in the disk for remap when read or write er=
ror occurs?
>>
>> 2010/1/7, Robin Hill <robin@robinhill.me.uk>:
>> > On Thu Jan 07, 2010 at 08:41:20PM +0800, dong wu wrote:
>> >
>> > > when read error and can rewrite,where do we rewrite?
>> > > It can't be rewrited to the old block.
>> > > It should be rewrite to other place,where can we find the 'other=
 place'?
>> > > In the source code,I don't find the place that should be rewrite=
d to.
>> > >
>> > It's rewritten to the same block - it's up to the low-level device=
 (the
>> > disk) to attempt a write and transparently remap the block if the =
write
>> > fails.
>> >
>> > Cheers,
>> > =A0 =A0Robin
>> > --
>> > =A0 =A0 ___
>> > =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robi=
n@robinhill.me.uk> |
>> > =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> > =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!"
>> >
>> >
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Modern mass storage devices provide an /abstraction/ of a linear
storage device which needn't actually be so.  On most of them data
plus some extra parity for recovery are stored; if the drive has
unusual trouble reading the data back, it will try to get a good
read/repair and then use another, spare (reserved), area on the device
in place of the one that 'went bad'.  This is actually a major problem
for cryptographic/security concerns, and is one possible metric in
S.M.A.R.T. data that can indicate a failing drive.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
