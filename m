From: Andy Smith <andy@lug.org.uk>
Subject: Re: 4 disks: RAID-6 or RAID-10 ..
Date: Fri, 17 Feb 2006 15:31:32 +0000
Message-ID: <20060217153132.GA32687@strugglers.net>
References: <Pine.LNX.4.56.0602171100420.22063@lion.drogon.net> <43F5B707.3030005@panix.com> <Pine.LNX.4.56.0602171153090.22063@lion.drogon.net> <fd8d0180602170407ib160644v@mail.gmail.com> <Pine.LNX.4.56.0602171445280.22063@lion.drogon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g0ROHtn9LWMmDMkC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0602171445280.22063@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--g0ROHtn9LWMmDMkC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2006 at 03:14:37PM +0000, Gordon Henderson wrote:
> Still scratching my head, trying to work out if raid-10 can withstand
> (any) 2 disks of failure though, although after reading md(4) a few times
> now, I'm begining to think it can't (unless you are lucky!) So maybe I'll
> just stick with Raid-6 as I know that!

RAID-10 cannot survive the failure of *any* two disks as if two
disks in one of the mirrors died then the whole mirror would be lost
which loses you a segment of the upper stripe.  *If* a second disk
dies, then with 4 didks total you have 50% chance of it being the
one you're relying on.

If you require to withstand the loss of *any* two disks then you
need RAID-6.

--=20
http://strugglers.net/wiki/Xen_hosting -- A Xen VPS hosting hobby
Encrypted mail welcome - keyid 0x604DE5DB

--g0ROHtn9LWMmDMkC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFD9exUIJm2TL8VSQsRAt5bAJ9AjosQrxOCr5aXuG1XuXvwQCoOAQCeJy2U
bCUtTPKaUxuWJXCp2BWHZWc=
=QW1m
-----END PGP SIGNATURE-----

--g0ROHtn9LWMmDMkC--
