From: Andy Smith <andy@lug.org.uk>
Subject: Re: RAID-10 with odd number of disks (was Re: Software RAID 0+1 with mdadm.)
Date: Thu, 27 Jan 2005 17:42:00 +0000
Message-ID: <20050127174200.GO82728@caffreys.strugglers.net>
References: <20050127161927.GK82728@caffreys.strugglers.net> <200501271714.j0RHEa911050@www.watkins-home.com> <20050127172700.GN82728@caffreys.strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hvMP/E6AsbbrbsKR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050127172700.GN82728@caffreys.strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--hvMP/E6AsbbrbsKR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 27, 2005 at 05:27:00PM +0000, Andy Smith wrote:
> On Thu, Jan 27, 2005 at 12:16:31PM -0500, Guy wrote:
> > It rotates the pairs!
> > Assume 3 disks, A, B and C.
> > Each stripe would be on these disks:
> > A+B
> > C+A
> > B+C
> > A+B
> > C+A
> > B+C
> > ...
>=20
> Hmm, difficult to visualise and comprehend if there are any
> differences as opposed to "normal" RAID-10.
>=20
> Is this anything like how RAID-1E works on IBM ServeRAID?

This seems relevant:

http://www.adaptec.com/worldwide/product/markeditorial.html?sess=3Dno&langu=
age=3DEnglish+US&prodkey=3Draid_10_alternatives&type=3DWhite%20Papers

--hvMP/E6AsbbrbsKR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB+SfoIJm2TL8VSQsRAt9bAJ4/O0iEJ0xuj8IWbiQ4hWmUq0oK1wCeJXUc
VYmUrrU5F3pkcyzNw6D6+DY=
=jTww
-----END PGP SIGNATURE-----

--hvMP/E6AsbbrbsKR--
