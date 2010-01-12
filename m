From: Andre Noll <maan@systemlinux.org>
Subject: Re: Minor mdadm fixes
Date: Tue, 12 Jan 2010 06:21:43 +0100
Message-ID: <20100112052143.GP21495@skl-net.de>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com> <20100112031027.GL7517@skl-net.de> <4B4BEE48.1000305@redhat.com> <20100112043933.GO21495@skl-net.de> <4B4BFEA8.7020607@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hZIELbchok2+JHy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B4BFEA8.7020607@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--+hZIELbchok2+JHy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23:46, Doug Ledford wrote:
> > Just out of interest: Why does mdmon need the restart at all?
>=20
> Because of the design and limitation of page cache.  If you start a long
> running program from the initramfs, then the page cache usage will pin
> the initramfs in memory.  You need to reexec the program from the hard
> drive so that the initramfs can be freed.  Of course, this is all
> because superblock handling for imsm superblocks is in user
> space...<grumble, grumble, grumble>.

You could copy the mdmon executable to /dev and execute it there :)

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--+hZIELbchok2+JHy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLTAbnWto1QDEAkw8RAhbtAJ9/KryTEiUBGtGJ5o8qjakYkfUYmwCfSvVS
aITQNff3lkMMEPBLu+Wv5sc=
=nGgm
-----END PGP SIGNATURE-----

--+hZIELbchok2+JHy--
