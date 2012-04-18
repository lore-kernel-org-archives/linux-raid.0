From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Wed, 18 Apr 2012 14:48:41 +1000
Message-ID: <20120418144841.04ce1a10@notabene.brown>
References: <20120417083552.483324288@kernel.org>
	<20120417084632.306032602@kernel.org>
	<CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
	<20120418062641.000e881c@notabene.brown>
	<4F8E11A6.7090305@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6DJZJjsg7IG=qBW9HRVIC/Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8E11A6.7090305@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-raid@vger.kernel.org, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

--Sig_/6DJZJjsg7IG=qBW9HRVIC/Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 08:58:14 +0800 Shaohua Li <shli@kernel.org> wrote:

> On 4/18/12 4:26 AM, NeilBrown wrote:
> > On Tue, 17 Apr 2012 07:46:03 -0700 Dan Williams<dan.j.williams@intel.co=
m>
> > wrote:
> >
> >> On Tue, Apr 17, 2012 at 1:35 AM, Shaohua Li<shli@kernel.org>  wrote:
> >>> Discard for raid4/5/6 has limitation. If discard request size is smal=
l, we do
> >>> discard for one disk, but we need calculate parity and write parity d=
isk.  To
> >>> correctly calculate parity, zero_after_discard must be guaranteed.
> >>
> >> I'm wondering if we could use the new bad blocks facility to mark
> >> discarded ranges so we don't necessarily need determinate data after
> >> discard.
> >>
> >> ...but I have not looked into it beyond that.
> >>
> >> --
> >> Dan
> >
> > No.
> >
> > The bad blocks framework can only store a limited number of bad ranges =
- 512
> > in the current implementation.
> > That would not be an acceptable restriction for discarded ranges.
> >
> > You would need a bitmap of some sort if you wanted to record discarded
> > regions.
> >
> > http://neil.brown.name/blog/20110216044002#5
>=20
> This appears to remove the unnecessary resync for discarded range after=20
> a crash
> or discard error, eg an enhancement. From my understanding, it can't=20
> remove the
> limitation I mentioned in the patch. For raid5, we still need discard a=20
> whole
> stripe (discarding one disk but writing parity disk isn't good).

It is certainly not ideal, but it is worse than not discarding at all?
And would updating some sort of bitmap be just as bad as updating the parity
block?

How about treating a DISCARD request as a request to write a block full of
zeros, then at the lower level treat any request to write a block full of
zeros as a DISCARD request.  So when the parity becomes zero, it gets
discarded.

Certainly it is best if the filesystem would discard whole stripes at a tim=
e,
and we should be sure to optimise that.  But maybe there is still room to do
something useful with small discards?

NeilBrown

--Sig_/6DJZJjsg7IG=qBW9HRVIC/Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT45HqTnsnt1WYoG5AQImNw/+IBpYgMxypRbpeTEzKEpxB+7WLEAB0+q7
yacZsD32vUMC0zJE8Mpeu7IAqXdBUwQwNgck/8kJKf6AXm/mMaGcxk1v1l6Emwfs
bsKbkKPKc7eWtbvczzN1RSn4BVVNkhZvswSBoJ06fdW9mOImF8HJramiIm70t1nm
EGQMkdPVm02boaKuGLGeo1tZyPWJHGt+2OU+IOZVqy1kBk8gTXPENog9BJw1q9NY
PeYYYXtj/b1jCyk2h7zXkDVfSX81PT++p/BGfYuCBPMG2d9z1AhpL2lqgKBA3U2c
esVU/ZIm2CjtzQsgRt3dr0YQf9pqgFAnTZJTjlTejPL61ZLoaQm0uijZ0hLGL5/P
acr1aqVSXAi3FhSS/HveGdjCM8UWSsTsxbqw6VgpmUHJv2kw2dY6ZmJJ2bPGvtYq
7BZwHFWFA6WW3UADy2GG0XTCOzoS4Yi8NUN1LTz1SRS3y8Y2ZRUam1HfNNErd0Yc
4s8cK3ks8aecSCfiFHHVLg+YcF3LUytv6LhDmMDb8e6PjWiZ8bpb824JZAGh8esl
5Gcziz2AZZUSv6m8agwwRa7FHxoxa11R4BIncw84NWsuaDfBUUJS2jklj8cczplM
RN0dPhoYL3msY8qOs8u1gtsz0rdJMRxID/lAjxDVbrS2E7B3iYnIw0f2jjywm0q4
3QNUJub2hwM=
=o5Cu
-----END PGP SIGNATURE-----

--Sig_/6DJZJjsg7IG=qBW9HRVIC/Z--
