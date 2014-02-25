From: NeilBrown <neilb@suse.de>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 19:35:01 +1100
Message-ID: <20140225193501.080a8e61@notabene.brown>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
	<530AA09B.3090708@fnarfbargle.com>
	<530AA460.602@eyal.emu.id.au>
	<530AAA55.2080508@fnarfbargle.com>
	<530ABF21.7030200@eyal.emu.id.au>
	<BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>
	<530BADF2.3090907@eyal.emu.id.au>
	<20140225141650.56b8dac4@notabene.brown>
	<530C4D18.4090403@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iIN1JMPmfXfc0gR+kVr/mMi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530C4D18.4090403@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/iIN1JMPmfXfc0gR+kVr/mMi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Feb 2014 18:58:16 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
wrote:

> BTW, Is there a monitoring tool to trace all i/o to a device? I could then
> log activity to /dev/sd[c-i]1 during a (short) 'check' and see if all sec=
tors
> are really read. Or does md have a debug facility for this?

blktrace will collect a trace, blkparse will print it out for you.
You need to trace the 'whole' device.

So something like

  blktrace /dev/sd[c-i]
  # run the test
  ctrl-C
  blkparse sd[c-i]*

blktrace creates several files, I think one for each device on each CPU.


NeilBrown

>=20
> Eyal
>=20
> On 02/25/14 14:16, NeilBrown wrote:
> > On Tue, 25 Feb 2014 07:39:14 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
> > wrote:
> >
> >> My main interest is to understand why 'check' does not actually check.
> >> I already know how to fix the problem, by writing to the location I
> >> can force the pending reallocation to happen, but then I will not have
> >> the test case anymore.
> >>
> >> The OP asks for a specific solution, but I think that the 'check' acti=
on
> >> should already correctly rewrite failed (i/o error) sectors. It does n=
ot
> >> always know which sector to rewrite when it finds a raid6 mismatch
> >> without an i/o error (with raid5 it never knows).
> >>
> >
> > I cannot reproduce the problem.  In my testing a read error is fixed by
> > 'check'.  For you it clearly isn't.  I wonder what is different.
> >
> > During normal 'check' or 'repair' etc the read requests are allowed to =
be
> > combined by the io scheduler so when we get a read error, it could be o=
ne
> > error for a megabyte of more of the address space.
> > So the first thing raid5.c does is arrange to read all the blocks again=
 but
> > to prohibit the merging of requests.  This time any read error will be =
for a
> > single 4K block.
> >
> > Once we have that reliable read error the data is constructed from the =
other
> > blocks and the new block is written out.
> >
> > This suggests that when there is a read error you should see e.g.
> >
> > [  714.808494] end_request: I/O error, dev sds, sector 8141872
> >
> > then shortly after that another similar error, possibly with a slightly
> > different sector number (at most a few thousand sectors later).
> >
> > Then something like
> >
> > md/raid:md0: read error corrected (8 sectors at 8141872 on sds)
> >
> >
> > However in the log Mikael Abrahamsson posted on 16 Jan 2014
> > (Subject: Re: read errors not corrected when doing check on RAID6)
> >
> > we only see that first 'end_request' message.  No second one and no "re=
ad
> > error corrected".
> >
> > This seems to suggest that the second read succeeded, which is odd (to =
say
> > the least).
> >
> > In your log posted 21 Feb 2014
> > (Subject: raid 'check' does not provoke expected i/o error)
> > there aren't even any read errors during 'check'.
> > The drive sometimes reports a read error and something doesn't?
> > Does reading the drive with 'dd' already report an error, and with 'che=
ck'
> > never report an error?
> >
> >
> >
> > So I'm a bit stumped.  It looks like md is doing the right thing, but m=
aybe
> > the drive is getting confused.
> > Are all the people who report this using the same sort of drive??
> >
> > NeilBrown
> >
>=20


--Sig_/iIN1JMPmfXfc0gR+kVr/mMi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwxVtTnsnt1WYoG5AQJxbBAAtJAKIz/GbC6n/a6ryE2jeng5Zr0BZUfl
k5WkfJzgSMBXQICOrWzAr+pj6JA9p/zZ1Lv9Nh/Sox0k+uxtIpjHoLhOJNWrC+pQ
mv2f1D2dsMQqH0VJa2csASAcBvA2AGqqwH43N6nZz0UF+9bht0Y9QcGLT/mVpjcY
sVxnFEJDjBWXYqVWLdaVV/stsZ+e/UzYqJyO6zLEXKkhYTBdOc8dmtCBhl+ZfRHL
UXWXsAdsQk2t3NFVGlKD/lQz15rBy+pcuhwxQkMoNP1zz8HTENlm0AupZYtvSq7I
17oI7lGPqTy3aSq61ZIKs5LmTarTChxFWaYLJs3a8wGToddOXDF/Lhe3Xrk0k4Pr
fUcYbP0fXztJ6n9G19NhHLDWqahIu8DawkH72Bjn2U/i5Cxb/X1LcILjIzWPVWQ4
e7YsItV/lXizelspA+0uOa5fwoVgs0BMIRDvbVR2x2LRSLlXTMr6c6jpHg1YUmVa
3gnfJmFCIJm4Mu2L2/2O2dNwzWOdg7WtfdF2MR++Cg7fXg4KR0ickB9zWG8V7Q2t
lq2bexGvDkw5tiyLiC37mhNkPqHxezD9GXPBCE/muv4CGWwerJUfUP0aZcBWTvx1
6qCn70IWPUCcoL2mejmiku7QYkVpPuz+VCM0Icowgg7HOH7qRaDvZR606BAglfOU
cz2rDLqJU1E=
=5KUl
-----END PGP SIGNATURE-----

--Sig_/iIN1JMPmfXfc0gR+kVr/mMi--
