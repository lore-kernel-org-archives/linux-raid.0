From: NeilBrown <neilb@suse.de>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Mon, 26 Sep 2011 21:10:10 +1000
Message-ID: <20110926211010.27f82a5e@notabene.brown>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
	<20110926193130.6377f5b9@notabene.brown>
	<4E8059AC.4060703@yazzy.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Qprdqb7GqtxpudBGxxv=RdX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E8059AC.4060703@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Qprdqb7GqtxpudBGxxv=RdX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Sep 2011 12:53:32 +0200 "Marcin M. Jessa" <lists@yazzy.org> wrot=
e:

> On 9/26/11 11:31 AM, NeilBrown wrote:

> > Nothing else I can suggest - sorry.
>=20
> Would it be worth a shot to use parted, create msdos label and then make=
=20
> a partition with a ext file system on top of it and run fsck?
>=20

I cannot imagine how doing that would actually improve your situation at
all.  It sounds like you are just corrupting things more.  But maybe I don't
understand what you are trying to do.

I really wouldn't write anything to any device until you had found out where
the data you want is.   However as I cannot suggest how to find the data (I
really think it is beyond repair - sorry) there is still nothing I can
suggest.

NeilBrown

--Sig_/Qprdqb7GqtxpudBGxxv=RdX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOgF2SG5fc6gV+Wb0RAgAEAKCW7x2v3bl3EOeWCpuw2MrmCv+y2QCgqjg+
7a1XmkPUUKph0dYnGYXUIcA=
=2m3q
-----END PGP SIGNATURE-----

--Sig_/Qprdqb7GqtxpudBGxxv=RdX--
