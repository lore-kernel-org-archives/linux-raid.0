From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] Plugging changes for blk/md/umem
Date: Tue, 31 Jul 2012 18:44:25 +1000
Message-ID: <20120731184425.389515ed@notabene.brown>
References: <20120726025650.32180.65163.stgit@notabene.brown>
	<50178487.4090302@kernel.dk>
	<20120731172539.4feea95e@notabene.brown>
	<50178A4F.8010806@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dj7OoBBLcDhtKmnT_V6TpX4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50178A4F.8010806@kernel.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--Sig_/Dj7OoBBLcDhtKmnT_V6TpX4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 09:33:35 +0200 Jens Axboe <axboe@kernel.dk> wrote:

> On 07/31/2012 09:25 AM, NeilBrown wrote:
> > On Tue, 31 Jul 2012 09:08:55 +0200 Jens Axboe <axboe@kernel.dk> wrote:
> >=20
> >> On 07/26/2012 04:58 AM, NeilBrown wrote:
> >>> Hi Jens,
> >>>  the following series makes a number of changes to plugging, moving
> >>>  common code from md and umem into block, and modifying it to allow
> >>>  md to get more value out of it.
> >>>  They've been sitting in -next for a while.
> >>>  Are you OK with me forwarding them to Linus, or would you rather they
> >>>  went though your tree?
> >>
> >> Thanks Neil, looks good. I will apply them to my tree and do some basic
> >> testing, too, then push it off for this round (where I haven't pushed
> >> out yet).
> >>
> >=20
> > Thanks Jens,
> >  However I've just today discovered that the very first patch causes a =
real
> >  regression in throughput for RAID5 and while I'm sure I can fix it wit=
h a
> >  subsequent patch (once I figure out exactly what it happening) it migh=
t make
> >  sense to hold them all back for 3.7.
> >=20
> >  However if you would like to take them now and fix up later (it is onl=
y a
> >  performance regression so it won't really affect bisection) I can work=
 with
> >  that.
>=20
> If you're confident we can fix it in this cycle (sounds like it, if you
> have a grasp on the situation), then I don't think that should stop us.
>=20

Sounds like a plan.
I have a few md patches queue which depend on those plugging patches, so if
you could cc me when you send you pull request (which Linus is keen for "by
Wedneday at the latest" I gather), I'll sort my tree out and send my pull
request.

Thanks,
NeilBrown

--Sig_/Dj7OoBBLcDhtKmnT_V6TpX4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBea6Tnsnt1WYoG5AQLgLhAAjBb0Y88YmrLko9hsw6mLc4A0qBy1F+tJ
1M0lHHWkjYuLdI1FdkHpNBrwpuiIRuhEQmB6QcjeBmG4Sxb+O9G2lWUJqrmQf0Fj
8yDpeJxFVQdQzNBLA4lMqgtEKCESqDhuAz2276hKDDLYrwRI9uXse3aeTuw4+UAL
GArHuTDihdfLg7Jd0k70bknPpXRf3gJ6j+RMjoilNtPluP1C6UWOrdJ5s9kYY8K3
jGPkK2x6SDhteUHPzXiMac+oLtpfnx718zm2VI/ji/BUFZyWkBFkoLuN3nShlWcN
e2bvn3vuvLwo1cRAf2JWHy//HfrExIi8oP5uJzoDEahMUd6J8Ws/vO+6EfhxYiQ3
wcKm3BklsPOGbNtH38PLYAlisEP+elOS2iLhfLAaG/LPdZlngsdqkA7ShypSE9Yc
VHUQqL32Xwhf+mZzi3ZlTzQ8ZvZf73mNxpwjMw0xu5VcoB8AwW3i4yDYDAFRboTz
UDQU01FpX9gJ6ITBz2m4nCxyzg2pby6ewlOUyPfBaerKacpSmsi2eci2TypCMo4P
5CxPG9WPdJ7tjq132byM+QNeq9Ex48EbKiBxDoqSIUB8pSt6O/LO4AGlnknXTp4G
8Bw8483+nIzOZ2xU52+b6D/b67idP7bMRiC5MebSJi+/DQ0+e2U8AXLcIVLszRG6
g4kyhb3bWTI=
=Y5UB
-----END PGP SIGNATURE-----

--Sig_/Dj7OoBBLcDhtKmnT_V6TpX4--
