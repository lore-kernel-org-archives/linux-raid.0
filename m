From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Thu, 17 Jul 2008 18:26:03 +1000
Message-ID: <1216283163.10437.60.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <487E43D8.60106@hp.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bwOMvcu+NODz3UywnzHh"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <487E43D8.60106@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-bwOMvcu+NODz3UywnzHh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-16 at 14:54 -0400, Alan D. Brunelle wrote:
> Ben Martin wrote:
> > Hi,
> >   Apologies if posting this here is inappropriate but a recent article
> > of mine compares the Linux Kernel RAID code to an $800 hardware RAID
> > card and might be of interest to list members:
> >=20
> > http://www.linux.com/feature/140734
> >=20
>=20
> Hi Ben -
>=20
> Did you do any performance testing of running /multiple/ disks through
> the Adaptec card w/out HW RAID enabled - for example, comparing the 4
> ports on the mobo against 4 drives exported through the Adaptec card?

Good question, however I must admit that I didn't test this.
Being an 8 lane PCIe card it I thought that there would not be a huge
issue with the interface to the card and drives being a bottleneck.
http://www.adaptec.com/en-US/products/Controllers/Hardware/sas/value/SAS-31=
205/

Though it would be interesting to compare, once I move a few old drives
off the mobo SATA controller and get 4 ports free.

>=20
> I wonder if there are any potential bottleneck issues with the single
> adapter card handling 6 independent drives (when testing SW RAID) versus
> one exported "drive" (when testing HW RAID).
>=20
> Regards,
> Alan

--=-bwOMvcu+NODz3UywnzHh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh/AhsACgkQsIKOrI+5WvM+TQCgjRwQHxx1qH6KELPi6MXbgv6B
xioAoOlPHZ3ejeqA51AltVxZDDaLpiMJ
=yY4u
-----END PGP SIGNATURE-----

--=-bwOMvcu+NODz3UywnzHh--

