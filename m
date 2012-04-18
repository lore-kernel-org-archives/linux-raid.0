From: David Brown <david@westcontrol.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Wed, 18 Apr 2012 22:20:03 +0200
Message-ID: <4F8F21F3.5060108@westcontrol.com>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com> <4F8D228D.8060005@westcontrol.com> <20120417171609.GA2859@lazy.lzy> <4F8DD02F.1060504@westcontrol.com> <20120418182201.GA2733@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418182201.GA2733@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/04/12 20:22, Piergiorgio Sartor wrote:
> Hi David,
>
> On Tue, Apr 17, 2012 at 10:18:55PM +0200, David Brown wrote:
> [...]
>
>> For quad parity, we can try g3 =3D 8 as the obvious next choice in t=
he
>> pattern.  Unfortunately, we start hitting conflicts.  To recover
>
> you should not use 8, because this is not a generator
> of GF(256) with polynomial 285, the standard for the
> RAID-5/6 setup.
>
> This means than 8^k does not cover the complete field
> for k in [0 254], thus having cycles and, consequently,
> creating conflicts.
>
> Some generators could be:
>
> 2, 4, 6, 9 13, 14, 16...
>
> but not 32 nor 64.
>
> I know that powers of two are nice, but if you want to
> have generic RAID, you must use other values.
>

I know that 8 is not a generator, and therefore you cannot expect to ge=
t=20
a full set of (256 - noOfParities) disks.  But picking another generato=
r=20
(such as 16) is not enough to guarantee you the full range - it is a=20
requirement, but not sufficient.  The generators need to be independent=
=20
of each other, in the sense that all the simultaneous equations for all=
=20
the combinations of failed disks need to be soluble.

It turns out that if you pick 16 as the forth parity generator here (1,=
=20
2, 4, 16), then you can only have 5 data disks.  In fact, there are no=20
other values for g3 that give significantly more than 21 data disks in=20
combination with (1, 2, 4), whether or not they happen to be a generato=
r=20
for all of GF(2=E2=81=B8).

> The log/exp tables, are, of course, always valid.
>
> BTW, the GF(256) with polynomial 285 has exactly 128
> generators, so it would be possible to have up to 129
> parity disk (1 is not a generator), for, I guess, a
> max of 256 disks (or maybe 255?).
>
> Hope this helps,
>
> bye,
>

When I started out with this, I thought it was as simple as you are=20
suggesting.  But it is not - picking a set of generators for GF(2=E2=81=
=B8) is=20
not enough.  You have to check that all the solution matrices are=20
invertible for all combinations of failed disks.

In fact, it is a little surprising that (1, 2, 4) works so well for=20
triple parity.  I don't know whether it is just luck, or genius in Pete=
r=20
Anvin's choice of the multiply operation.

mvh.,

David
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
