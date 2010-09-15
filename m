From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Wed, 15 Sep 2010 17:25:02 -0500
Message-ID: <4C9147BE.60200@hardwarefreak.com>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org> <4C912F5D.5040305@hardwarefreak.com> <20100915214013.GA19900@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100915214013.GA19900@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen put forth on 9/15/2010 4:40 PM:
> These ports are connected to the
> south bridge often with 20 Tbit/s or more, while a controller on an
> 32 bit PCI only delivers 1 TBit.=20

Tbit/s for 32/33 PCI?  I think you're a little high.. by a factor of
1000, Keld. :)

The chipset to processor interface on modern systems is typically aroun=
d
8-16 GB/s, or 64-128 Gb/s.  That's still a factor of 10x lower than 1
Tbit/s, so you're high by a factor of 20x.

Why, may I ask, are you quoting serial data rates for parallel buses?
I've only seen inter-chip bandwidth quoted in serial rates on
communications gear.  Everyone else quotes parallel data rates for boar=
d
level communication paths-- Bytes/s not bits/sec.  You must work for
Ericsson. ;)

Regardless of bit rate values, we agree on the important part, for the
most part. :)

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
