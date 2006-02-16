From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Re: will mdadm work with a raid created using raidtools
Date: Thu, 16 Feb 2006 18:47:27 +0100
Message-ID: <20060216174727.GH8762@intoxicatedmind.net>
References: <43F37BFB.4030908@gmail.com> <17395.45134.227188.527148@cse.unsw.edu.au> <dt24uh$fv8$1@sea.gmane.org> <20060216171413.GG8762@intoxicatedmind.net> <dt2csr$gac$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tcC6YSqBgqqkz7Sb"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dt2csr$gac$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--tcC6YSqBgqqkz7Sb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16, 2006 at 11:31:06AM -0600, Andrew Nelson wrote:
> > It's probably not your fault - blame /dev/hde! This sounds like a bad
> > error on the disk - you should really get a new one, and try to copy
> > /dev/hde to the new disk (with dd_rescue for example). This _might_ save
> > the data.
> >=20
> > Then you can try to create the array with the new disk and hope that
> > it will work.
>=20
>=20
> I thought the whole idea of a raid 1 was that if one drive went bad I cou=
ld just
> plug a new drive in and the raid would rebuild without problems.

That is certainly right. I just wanted to tell you, that your /dev/hde
probably has a serious hardware error, and that you should replace it!

Of course you can just throw it out, put in a new drive, rebuild the
array with your other drive and the new one, and then resync. This
should work just fine.

I guess my first answer was quite confusing, sorry. It's absolutely not
necessary to copy the old hde with dd_rescue.


Greetings,
Frank

--tcC6YSqBgqqkz7Sb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD9Lqvcs96QQvy/noRAhhPAKDAgpph7+edCd1GOrRQKflyAzHi5ACfX0FU
Kpd/7NWCLMhzgr+sFy+lH88=
=r0D2
-----END PGP SIGNATURE-----

--tcC6YSqBgqqkz7Sb--
