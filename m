From: Andy Smith <andy@lug.org.uk>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Thu, 23 Jun 2005 13:17:43 +0000
Message-ID: <20050623131743.GF9385@strugglers.net>
References: <1119529907.5503.1.camel@localhost.localdomain> <200506231303.j5ND3e224877@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/If7Wv41KAW8wPhq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200506231303.j5ND3e224877@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--/If7Wv41KAW8wPhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 23, 2005 at 09:03:35AM -0400, Guy wrote:
> Also, a single RAID5 array on 24 disks would be high risk of a double
> failure.  I think I would build 2 RAID5 arrays of 12 disks each.  Or 2 RAID5
> arrays of 11 disks each, with 2 spares.

Just out of interest, why wouldn't you do RAID 10 of 12 pairs?
Because of getting only 50% capacity, or?

--/If7Wv41KAW8wPhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCurZ3IJm2TL8VSQsRAm6oAKD+V23YGB4q8DBuRg/qUU5u7aqGYwCfZetb
fcuRKQv/TIvlDqmYZA7uk+Q=
=Ntkv
-----END PGP SIGNATURE-----

--/If7Wv41KAW8wPhq--
