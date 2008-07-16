From: thomas62186218@aol.com
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 13:08:57 -0400
Message-ID: <8CAB57DC49B9CE4-C68-3155@WEBMAIL-NG09.sysops.aol.com>
References: <1216130769.5633.318.camel@sam.localdomain>	 <487CC660.9030004@ziu.info> <1216179392.5633.348.camel@sam.localdomain> <487D7139.5050302@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487D7139.5050302@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: richard@sauce.co.nz, monkeyiq@users.sourceforge.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard,

Are you sure that the patch you reference below is actually in 2.6.26?=20
I checked the CHANGELOG and couldn't find anything about get priority=20
stripe in there (maybe its called something else now)?

Thanks
-Thomas


-----Original Message-----
=46rom: Richard Scobie <richard@sauce.co.nz>
To: Ben Martin <monkeyiq@users.sourceforge.net>
Cc: linux-raid@vger.kernel.org
Sent: Tue, 15 Jul 2008 8:55 pm
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup









Ben Martin wrote:=C2=A0
=C2=A0

> I have been meaning to ask for a while, why is the stripe_cache_size=C2=
=A0

> set so low by default if it has such an effect on performance? =C2=A0

I can't comment on the above, but looking at this:=C2=A0
=C2=A0

http://marc.info/?l=3Dlinux-raid&m=3D120668318422034&w=3D2=C2=A0
=C2=A0

with the 2.6.26 release, bumping up the stripe cache should no longer=20
be
necessary.=C2=A0
=C2=A0

Regards,=C2=A0
=C2=A0

Richard=C2=A0

--=C2=A0

To unsubscribe from this list: send the line "unsubscribe linux-raid"=20
in=C2=A0

the body of a message to majordomo@vger.kernel.org=C2=A0

More majordomo info at  http://vger.kernel.org/majordomo-info.html=C2=A0





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
