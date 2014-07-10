From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/2]RAID5: make stripe size configurable
Date: Thu, 10 Jul 2014 15:39:36 +1000
Message-ID: <20140710153936.6f042277@notabene.brown>
References: <20140708010018.GA8941@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NVfb.Z_Z5xaRfM.TIVakWnn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140708010018.GA8941@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NVfb.Z_Z5xaRfM.TIVakWnn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Jul 2014 09:00:18 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> stripe size is 4k default. Bigger stripe size is considered harmful, beca=
use if
> IO size is small, big stripe size can cause a lot of unnecessary IO/parity
> calculation. But if upper layer always sends full stripe write to RAID5 a=
rray,
> this drawback goes away. And bigger stripe size can improve performance
> actually in this case because of bigger size IO and less stripes to handl=
e. In
> my full stripe write test case, 16k stripe size can improve throughput 40=
% -
> 120% depending on RAID5 configuration.

Hi,
 certainly interesting.
 I'd really like to see more precise numbers though.  What config gives 40%,
 what config gives 120% etc.

 I'm not keen on adding a number that has to be tuned though.  I'd really
 like to understand exactly where the performance gain comes from.
 Is it that the requests being sent down are larger, or just better managed=
 -
 or is it some per-stripe_head overhead that is being removed.

 e.g. if we sorted the stripe_heads and handled them in batches of adjacent
 addresses, might that provide the same speed up?

 I'm certain there  is remove for improving the scheduling of the
 stripe_heads, I'm just not sure what the right approach is though.
 I'd like to explore that more before make the stripe_heads bigger.

 Also I really don't like depending on multi-page allocations.  If we were
 going to go this way I think I'd want an array of single pages, not a
 multi-page.


Thanks,
NeilBrown


--Sig_/NVfb.Z_Z5xaRfM.TIVakWnn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU74nGDnsnt1WYoG5AQJPBhAAuqgE6w4ypfVJJ1ni3AxmACmGWCnivHX9
oKuQV2xhmvACwTMd9dgbohjViLFj1sV2nr4jQm2OAPJqVPrHXdnSO/0NWOxhx4DZ
pUIhrnpBd/NkMrTq9/orUVLEmKL0i+VnOPIBe876GXJf++M4JLGLCvtbP0eLvMG2
vW/nUYraSTVKXUDJ/GVBqJXwBQDzqHgO8NdvqmrtgT0JTdYfLAw3agnZ38xBK1Iq
7DWpp+xc4TLAUWsZWqeAtmbx/OIRQs2sqZAaBX1PpaoZl/g30S3SMikIfM51gH2h
R56ZtpV2UktyGOl/p4SZle+OoUr73FY8noFZMtmqVmelxkL540EmH8v/k4kuqFYq
X7fsZLfytC8KxQwL4hF0/Ot2ck7GgmIRCBF0vArFuCF1ADsmoizHiY+fZ+KglMRs
nJpJfTdO30PWmfWunf3G2Vu5NKCn6r6WluE0oQPNlK4729XN41IEOWoVZNnBRTiU
NsitvZVJC1drJWNb7cXvN8QLLZOgixBGo4x+FXF4pPCVYsfzSTKS7I74EvIX3UJD
sdWIPhLipWwmX7PYUAvEqSLTQfUNcbW+W9qJoioa2qHMXybTROJQuxQMIn7QK3tc
YPq8iq022RWUXVe+FJ8L61wiVYwvygJko/GVMl1beGxnYIFqqZ5mOnax8MxSL15U
zyTRMX5+yb4=
=eyIb
-----END PGP SIGNATURE-----

--Sig_/NVfb.Z_Z5xaRfM.TIVakWnn--
