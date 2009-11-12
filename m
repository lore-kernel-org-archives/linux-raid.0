From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Using 2.6.31 liveCD to grow (reshape) raid5 into raid6, then
 bacck to old kernel?
Date: Thu, 12 Nov 2009 21:14:56 +0000
Message-ID: <20091112211456.GB983@cthulhu.home.robinhill.me.uk>
References: <20091112220351.22a2ad1b@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091112220351.22a2ad1b@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 12, 2009 at 10:03:51PM +0100, Janek Kozicki wrote:

> Hi,
>=20
> I have an old debian etch backup server. It has 5 drives in raid4.
> I want to add a sixth drive to jump to raid6. I don't want to upgrade
> debian etch, because the server is working real fine, and doing an
> upgrade would be too much problems.
>=20
> And so my plan is to get some liveCD with 2.6.31 (or maybe 2.6.32 ?).
> Connect the sixth drive, boot liveCD, perform the migration:
>=20
> mdadm --add /dev/md2 /dev/sdd3
> mdadm --grow /dev/md2 --level=3Draid6 --raid-disks=3D6
>=20
> Then reboot back into linux 2.6.24.
>=20
> Will this work?
>=20
> Will 2.6.24 understand such raid6 ?
>=20
I don't think so, no.  It's not a standard RAID6 (as all the Q parity is
on a single disk) so I think you need the newer kernel to understand it.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkr8es8ACgkQShxCyD40xBIhGACfbjaQALAwmmd3iXnO236zUcct
XykAnjy45QZmu7zXRlNOUQVvbIX5WLAQ
=vo0I
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
