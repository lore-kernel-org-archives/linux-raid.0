From: NeilBrown <neilb@suse.de>
Subject: Re: potentially lost largeish raid5 array..
Date: Sun, 25 Sep 2011 19:37:47 +1000
Message-ID: <20110925193747.074d965b@notabene.brown>
References: <201109221950.36910.tfjellstrom@shaw.ca>
	<201109230209.36209.thomas@fjellstrom.ca>
	<20110923191539.110b7be1@notabene.brown>
	<201109231026.53770.thomas@fjellstrom.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qyvdUz7gHFu4V9XVuHEYh1d"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201109231026.53770.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qyvdUz7gHFu4V9XVuHEYh1d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Sep 2011 10:26:53 -0600 Thomas Fjellstrom <thomas@fjellstrom.ca>
wrote:

> On September 23, 2011, NeilBrown wrote:
> > On Fri, 23 Sep 2011 02:09:36 -0600 Thomas Fjellstrom <thomas@fjellstrom=
.ca>
> >=20
> > wrote:
> > > I forgot to say, but: Thank you very much :) for the help, and your
> > > tireless work on md.
> >=20
> > You've very welcome .... but I felt I needed to respond to that word
> > "tireless".
> > The truth is that I am getting rather tired of md .... if anyone knows
> > anyone who wants to get into kernel development and is wondering where =
to
> > start - please consider whispering 'the md driver' in their ear.  Plenty
> > to do, great mentoring possibilities, and competent linux kernel engine=
ers
> > with good experience are unlikely to have much trouble finding a job ;-)
> >=20
> > NeilBrown
>=20
> Very tempting. How much work do you think it would be to add in full raid=
10=20
> reshape support? ;D (not that I'm volunteering, I don't think I could=20
> comprehend a lot of the raid code, at least not at this point in time =20
> (extenuating circumstances)).
>=20

RAID10 reshape is more complicated than RAID5/6 reshape because there are
more options - more combinations.

So you would probably implement a subset of possible reshapes.  And then
maybe implement another subset.

Providing you have:
  - a clear understanding of the intermediate state and a way to record
    that state in the metadata
  - a way to tell if a given block is in the 'old' layout or the 'new' layo=
ut
    or 'being reshaped'
  - somewhere in memory to store all the blocks that are 'being reshaped'

it should be fairly easy.  RAID5/6 has a stripe-cache so the last point is
trivial.  Handling that in RAID10 is probably the biggest single part of the
task.

So: not a trivial task, but not an enormous task either.... which doesn't
narrow it down very much I guess.

NeilBrown

--Sig_/qyvdUz7gHFu4V9XVuHEYh1d
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfvZrG5fc6gV+Wb0RAiGRAJ9GzrX5bP5InkXXkxSMyJdB2G/gGQCgt8mm
HHwRi3QavxIOxC/kFLJET20=
=9dBp
-----END PGP SIGNATURE-----

--Sig_/qyvdUz7gHFu4V9XVuHEYh1d--
