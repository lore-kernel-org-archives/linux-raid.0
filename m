From: NeilBrown <neilb@suse.de>
Subject: Re: [neilb@suse.de: Re: MD request counter broken on 4.0-rc5 RAID1]
Date: Wed, 1 Apr 2015 22:07:25 +1100
Message-ID: <20150401220725.53ee8f99@notabene.brown>
References: <20150325173346.GF8519@hostway.ca>
	<551BA0C3.7090004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YLxHiwn0E2XeBAu0TT+6yJw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <551BA0C3.7090004@cn.fujitsu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Simon Kirby <sim@hostway.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/YLxHiwn0E2XeBAu0TT+6yJw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Apr 2015 15:39:47 +0800 Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:

> Hi Neil,
> One question about md io stats account:
> I find that we just accounting disk_stats.sectors[rw] and disk_stats.ios[=
rw] at
> md_make_request, but I did not find accounting disk_stats.ticks[rw], do n=
ot we
> need it? or I missed something?

No, I don't think you are missing anything.  md doesn't track 'ticks' - and
no-one has ever complained.

NeilBrown


>=20
> Regards,
> Gu
>=20
> On 03/26/2015 01:33 AM, Simon Kirby wrote:
>=20
> > Hello!
> >=20
> > Please note the following.
> >=20
> > Thanks,
> >=20
> > Simon-
> >=20
> > ----- Forwarded message from NeilBrown <neilb@suse.de> -----
> >=20
> > Date: Wed, 25 Mar 2015 11:46:18 +1100
> > From: NeilBrown <neilb@suse.de>
> > To: Simon Kirby <sim@hostway.ca>
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: MD request counter broken on 4.0-rc5 RAID1
> > X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linu=
x-gnu)
> >=20
> > On Tue, 24 Mar 2015 17:04:03 -0700 Simon Kirby <sim@hostway.ca> wrote:
> >=20
> >> Hello :)
> >>
> >> I'm seeing "iostat -x -k 1" print this after a RAID1 rebuild on 4.0-rc=
5.
> >> It's not abnormal other than it's 3-disk, with one being SSD (sdc) and
> >> the other two being write-mostly:
> >>
> >> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgr=
q-sz avgqu-sz   await r_await w_await  svctm  %util
> >> sda               0.00     0.00    0.00    0.00     0.00     0.00     =
0.00     0.00    0.00    0.00    0.00   0.00   0.00
> >> sdb               0.00     0.00    0.00    0.00     0.00     0.00     =
0.00     0.00    0.00    0.00    0.00   0.00   0.00
> >> sdc               0.00     0.00    0.00    0.00     0.00     0.00     =
0.00     0.00    0.00    0.00    0.00   0.00   0.00
> >> md0               0.00     0.00    0.00    0.00     0.00     0.00     =
0.00   345.00    0.00    0.00    0.00   0.00 100.00
> >> md2               0.00     0.00    0.00    0.00     0.00     0.00     =
0.00 58779.00    0.00    0.00    0.00   0.00 100.00
> >> md1               0.00     0.00    0.00    0.00     0.00     0.00     =
0.00    12.00    0.00    0.00    0.00   0.00 100.00
> >>
> >> This was working on 3.18. Shall I bisect, or is it obvious?
> >=20
> > Almost certainly 18c0b223cf9901727ef3b02da6711ac930b4e5d4 in 3.19.
> >=20
> > It adds 'part_inc_in_flight' and never decrements it.
> >=20
> > Complain to the author.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >>
> >> It seems to just be leaking as the counters were going up gradually wh=
ile
> >> it was rebuilding.
> >>
> >> Personalities : [linear] [raid0] [raid1] [raid10]
> >> md1 : active raid1 sdb2[1](W) sda2[0](W) sdc2[2]
> >>       530048 blocks [3/3] [UUU]
> >>
> >> md2 : active raid1 sdb3[0](W) sdc3[2] sda3[1](W)
> >>       153613440 blocks [3/3] [UUU]
> >>
> >> md0 : active raid1 sdb1[0](W) sdc1[2] sda1[1](W)
> >>       2104384 blocks [3/3] [UUU]
> >>
> >> unused devices: <none>
> >>
> >> Simo-
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
> > ----- End forwarded message -----
> > .
> >=20
>=20


--Sig_/YLxHiwn0E2XeBAu0TT+6yJw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVRvRbTnsnt1WYoG5AQJnZBAAw/d4DkVMzvwxBFG8gXsgJrhcbTDneP5p
VvZQM1I7uXeRCXBEZMX5gDjDEDvnxlDU188VYsTS47dsMcR60rh34QMT1VZsb+1F
ErioC4ronA5K0W9XN3wac8BzCKoBPCvga3lB8DEmlLVCIkQy8hu8CiyV2BkWUj8N
fyu/HRv3BMCkvZbdeW0Fe/2BGYDQxdErTLBC9ptPvAiah3kTMuLlLrQn0El2Je9f
MQUQn41N3FOw3YE8uOXs7fu8PBRm1qi9pBfH14yvpkkLJgG440lLFgJWHWeDSEFy
jZdpPqA7lcFBfbsOjdJZlLPhXY21J8y4lyKpL1/MABBCcBEOuxxr4oT4t9sxHsB6
Ysvlb4pOdYl21AaVOQILHrd7VDqACXPPPRuem3QZ4GgQzaJVVtUdSxVcZI516p/c
lA26Sztu7wrzN14/cBGxfZMyqVkQmXTNNDFQzC+YThR1Ytobjy1m2H8ZbU/TyaCm
gi01K0JUJWtS7siM+7dVf1jy0Osh7pk815dhD1Omyy5N1TAT7CtXsJw+se8gDZdB
W8LS8vlpqB2oA0tllXD4pG+8i0MgI8O8cx4DSzj0UyW48OMUUMHYnZBHBA5JpMDL
xnAwb2c+haGPqEhcxv1vkHpuC3mcvVxcm8QiYpxRcOuNbAy2oQeF+8qhuDl8wA+i
/aXA5W7/QIk=
=N9Hv
-----END PGP SIGNATURE-----

--Sig_/YLxHiwn0E2XeBAu0TT+6yJw--
