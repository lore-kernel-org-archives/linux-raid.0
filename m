From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 10:22:29 +0000
Message-ID: <AANLkTi=e_uuPpR9pxNd2Eup9CLROr84g9k60T26Exq1f@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<20110131101409.GA7861@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131101409.GA7861@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 January 2011 10:14, Robin Hill <robin@robinhill.me.uk> wrote:
> On Mon Jan 31, 2011 at 09:41:43AM +0000, Mathias Bur=C3=A9n wrote:
>
>> Hi,
>>
>> RAID10 is (could be) setup in this way, correct?
>>
>> 2 devices in a RAID1
>> 2 devices in another RAID1
>>
>> Then you run RAID0 on top of them. If you're lucky you can lose 2
>> devices at most (1 in each RAID1).
>>
> It could be, yes, or you could just use the RAID10 mode in md, which
> simplifies the process and offers you a selection of different physic=
al
> layouts (some of which can offer significant performance benefits,
> depending on usage).
>
>> If you have, say 6 HDDs, would you create 3 RAID1 volumes? Then crea=
te
>> a RAID0 on top of them?
>>
> Yes.
>
>> How would one go about expanding a 4 HDD RAID10 into a 6 HDD RAID10?
>> Is it "just" a matter of creating a new RAID1 array of the 2 new HDD=
s,
>> then adding them to the RAID0, then expanding whatever is on that
>> (lvm, xfs, ext4)?
>>
> Expansion of RAID0 (or RAID10) is not currently implemented, though
> there is a workaround for RAID0. =C2=A0The basic steps are to convert=
 to
> RAID4 with missing parity disk, expand, then convert back to RAID0.
> It's a bit more complex though as you need to prevent md from recover=
ing
> the RAID4 array first - the full command process was posted a few day=
s
> ago though, so a dig through the archives should find them. =C2=A0Pro=
per
> RAID0 expansion should be in a forthcoming (next?) mdadm release, not
> sure about RAID10 expansion though.
>
> Otherwise, yes, those are the correct steps needed for expanding the
> array and filesystem.
>
> Cheers,
> =C2=A0 =C2=A0Robin
> --
> =C2=A0 =C2=A0 ___
> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in =
de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>

Ah, good to know. Because of money and physical space vs usable
storage amount, I'm probably going with RAID5 again or RAID6 for my
future box.

Cheers,
// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
