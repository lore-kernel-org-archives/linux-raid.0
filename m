From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: advice to low cost hardware raid (with mdadm)
Date: Thu, 16 Sep 2010 14:05:14 +0200
Message-ID: <20100916120514.GA28175@www2.open-std.org>
References: <00c6ed0254381567aff38d7a95d200c5.squirrel@fuckaround.org> <4C912F5D.5040305@hardwarefreak.com> <20100915214013.GA19900@www2.open-std.org> <4C9147BE.60200@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C9147BE.60200@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 15, 2010 at 05:25:02PM -0500, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 9/15/2010 4:40 PM:
> > These ports are connected to the
> > south bridge often with 20 Tbit/s or more, while a controller on an
> > 32 bit PCI only delivers 1 TBit.=20
>=20
> Tbit/s for 32/33 PCI?  I think you're a little high.. by a factor of
> 1000, Keld. :)

yes, you are right. I meant Gbit/s

> Why, may I ask, are you quoting serial data rates for parallel buses?
> I've only seen inter-chip bandwidth quoted in serial rates on
> communications gear.  Everyone else quotes parallel data rates for bo=
ard
> level communication paths-- Bytes/s not bits/sec.  You must work for
> Ericsson. ;)

because I have seen specs given in bit/s. Eg southbridge speeds, and=20
speeds of PCIe (2,5 Gbit/s per lane).  I agree that people probably wan=
t
speeds in MB/s.

> Regardless of bit rate values, we agree on the important part, for th=
e
> most part. :)

I think so, too.

keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
