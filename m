From: Andy Smith <andy@lug.org.uk>
Subject: RAID-10 with odd number of disks (was Re: Software RAID 0+1 with mdadm.)
Date: Thu, 27 Jan 2005 16:19:27 +0000
Message-ID: <20050127161927.GK82728@caffreys.strugglers.net>
References: <Pine.LNX.4.61.0501270801560.21209@diagnostix.dwd.de> <200501271548.j0RFml910827@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NLzDv8tv2umAfrXO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501271548.j0RFml910827@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--NLzDv8tv2umAfrXO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 27, 2005 at 10:50:43AM -0500, Guy wrote:
> RAID10 will work with an odd number of disks!  If really is cool!

It will?  How?  Does it just make the last mirror "pair" have 3
disks or what?

If so then wouldn't it be better just to not have that disk under
md and use it for someting else?

--=20
> > > The optimum programming team size is 1.
Has Jurassic Park taught us nothing?
 -- pfilandr

--NLzDv8tv2umAfrXO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFB+RSPIJm2TL8VSQsRAgtpAKD9SlD9/bkBV3rEGtwyM4C5dKhFdwCgiXD0
gAx2fO2skubWa78cbDOvZY0=
=F1x/
-----END PGP SIGNATURE-----

--NLzDv8tv2umAfrXO--
