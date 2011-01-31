From: Denis <denismpa@gmail.com>
Subject: Re: raid over ethernet
Date: Mon, 31 Jan 2011 06:42:44 -0200
Message-ID: <AANLkTi=E_f2XYd432rpM2-hzXMAA2ntjYv2nS_SGu0OF@mail.gmail.com>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se> <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
 <20110129133457.GB15784@mordor.angband.thangorodrim.de> <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com>
 <20110129210815.GC15784@mordor.angband.thangorodrim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110129210815.GC15784@mordor.angband.thangorodrim.de>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Schreiber <als@thangorodrim.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, Mikael Abrahamsson <swmike@swm.pp.se>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/1/29 Alexander Schreiber <als@thangorodrim.de>:
> On Sat, Jan 29, 2011 at 12:23:14PM -0200, Denis wrote:
>> 2011/1/29 Alexander Schreiber <als@thangorodrim.de>
>>
>> >
>> > plain disk performance for writes, while reads should be reasonabl=
y
>> > close to the plain disk performance - drbd optimizes reads by just=
 reading
>> > from the local disk if it can.
>> >
>> >
>> =A0However, I have not used it with active-active fashion. Have you?=
 if yes,
>> what is your overall experience?
>
> We are using drbd to provide mirrored disks for virtual machines runn=
ing
> under Xen. 99% of the time, the drbd devices run in primary/secondary
> mode (aka active/passive), but they are switched to primary/primary
> (aka active/active) for live migrations of domains, as that needs the
> disks to be available on both nodes. From our experience, if the drbd
> device is healthy, this is very reliable. No experience with running
> drbd in primary/primary config for any extended period of time, thoug=
h
> (the live migrations are usually over after a few seconds to a minute=
 at
> most, then the drbd devices go back to primary/secondary).

What filesystem are you using to enable the primary-primary mode? Have
you evaluated it against any other available option?
>
> Kind regards,
> =A0 =A0 =A0 =A0 =A0Alex.
> --
> "Opportunity is missed by most people because it is dressed in overal=
ls and
> =A0looks like work." =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0-- Thomas A. Edison
>

cheers!

--=20
Denis Anjos,
www.versatushpc.com.br
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
