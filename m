From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: BUG:write data to degrade raid5
Date: Fri, 19 Mar 2010 18:30:31 +0000
Message-ID: <20100319183031.GA799@cthulhu.home.robinhill.me.uk>
References: <de04351e1003190329l2f33447bhe37b963bd4b48c70@mail.gmail.com>
 <4BA3C07A.8030204@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BA3C07A.8030204@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Mar 19, 2010 at 07:20:42PM +0100, Joachim Otahal wrote:

> jin zhencheng schrieb:
> > hi;
> >
> > i use kernel is 2.6.26.2
> >
> > what i do as follow:
> >
> > 1, I create a raid5:
> > mdadm -C /dev/md5 -l 5 -n 4 /dev/sda /dev/sdb /dev/sdc  /dev/sdd
> > --metadata=3D1.0 --assume-clean
> >
> > 2, dd if=3D/dev/zero of=3D/dev/md5 bs=3D1M&
> >
> > write data to this raid5
> >
> > 3, mdadm --manage /dev/md5 -f /dev/sda
> >
> > 4 mdadm --manage  /dev/md5 -f /dev/sdb
> >
> > if i faild 2 disks ,then the OS kernel display OOP error and kernel down
> >
> > do somebody know why ?
> >
> > Is MD/RAID5 bug ?
> >   =20
>=20
> RAID5 can only tolerate ONE drive to fail of ALL members. If you want to=
=20
> be able to fail two drives you will have to use RAID6 or RAID5 with one=
=20
> hot-spare (and give it time to rebuild before failing the second drive).
> PLEASE read the documentation on raid levels, like on wikipedia.
>=20
Yes, but the kernel should _not_ OOPS if two drives fail.  However,
given that the kernel version used is 18 months old, I'm not sure the
bug report is particularly useful.  If it's a distro-specific kernel
then report the issue to them, otherwise try installing a more recent
kernel release.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkujwscACgkQShxCyD40xBL/2ACgri4AvJ1Ag+OLAn2c5S9JhBJS
WZ0An1jaOnEKbRf7s7RXg1FlAR27DXFu
=v75+
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
