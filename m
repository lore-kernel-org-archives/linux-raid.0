From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: dmraid - where is the raid done?
Date: Tue, 28 Oct 2008 07:49:07 -0400
Message-ID: <1225194547.16984.69.camel@pc.ilinx>
References: <1225120062.20830.34.camel@pc.ilinx>
	 <49064EF0.4080804@gmail.com> <1225154175.16984.16.camel@pc.ilinx>
	 <490666F0.4000306@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-51xNllKqnwuu7PSzZsBf"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <490666F0.4000306@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-51xNllKqnwuu7PSzZsBf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 20:12 -0500, Roger Heflin wrote:
>=20
> If it is an out-of-kernel driver, then the work is being done in the=20
> manufacturer's driver.

I see.

> If it is dmraid it is being done in the dmraid driver.

Ahhh.  So in the above "out of kernel driver" instance that is a case
where dmraid is not handling it, yes?

> If there is no underlying hardware to run the raid on then everything has
> to be done in the OS.

Indeed.  I had just wondered if these "fakeraid" solutions where at
least fanning out the copy (in the case of mirror) themselves, saving
the doubling of PCI bus traffic.

> All of the real raid cards have at least a
> really basic microprocesser on the card that takes care of things.

Yeah, I'm fairly familiar with the concepts of real RAID hardware.  It
was this new fakeraid I was wondering about.

Thanx for the enlightenment though.  The one last value that I had hope
for in the fakeraid arena seems to be invalid so I have to start to
agree with the documentation I've read and really have to wonder the
value of the fakeraid, especially and until the on-disk formats are
standardized.  Not being able to move fakeraid disks from one
manufacturer to another is a real impediment in my mind.

b.


--=-51xNllKqnwuu7PSzZsBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkG/DMACgkQl3EQlGLyuXAT1gCfUWe13xLh7t4jrBh7XLstb/fl
SLAAoJ0orejGvD52UCOLh1EoiE59IO8O
=BQzx
-----END PGP SIGNATURE-----

--=-51xNllKqnwuu7PSzZsBf--

