From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 19:21:50 +0200
Message-ID: <20080702172150.GB12081@rap.rap.dk>
References: <20080702155603.GA11156@rap.rap.dk> <alpine.DEB.1.10.0807021241350.5166@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0807021241350.5166@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 12:43:40PM -0400, Justin Piszcz wrote:
>=20
>=20
> On Wed, 2 Jul 2008, Keld J=F8rn Simonsen wrote:
>=20
> >The 66 MHz 64-bit PCI bus is capable of handling about 4 Gbit/s, or
> >about 500 MB/s. This can also be a bottleneck with bigger arrays, eg=
 a 6
> >drive array will be able to deliver about 500 MB/s, and maybe you wa=
nt
> >also to feed a gigabyte ethernet card - 125 MB/s, totalling potentia=
lly
> >625 MB/s on the PCI bus.
> >
> >The PCI-Express bus v1.1 has a limit of 250 MB/s per lane per dircti=
on,
> >and that limit can easily be hit eg by a 4-drive array.

> Correction, can easily be hit with two veliciraptors.

OK, I added that information.=20

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
