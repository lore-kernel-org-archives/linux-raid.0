From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Software Raid 5 work on ROOT ?
Date: Fri, 4 Sep 2009 11:32:45 +0100
Message-ID: <20090904103244.GB14649@cthulhu.home.robinhill.me.uk>
References: <1252059563.4aa0e9ab25de3@imp.free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1252059563.4aa0e9ab25de3@imp.free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 04, 2009 at 12:19:23PM +0200, lfmarante@free.fr wrote:

> Hello every body.
>=20
> I have a question in regard of booting linux under a raid 5. It is possib=
le ?
> All the guides that I found on the net say to have a /boot not stripped, =
(raid1
> is ok). [EX: http://www.gentoo.org/doc/en/gentoo-x86+raid+lvm2-quickinsta=
ll.xml
> ]
>=20
That's correct, yes.  Grub looks at the individual partition, so needs to s=
ee
a full filesystem on there.

> They say to have / not stripped too. And these guide show to have an raid=
 1 boot
> and / and create a LVM volume for /usr /opt /var /whatever that can be ra=
id 5.
> It is not easiest to have directly / in raid 5 format ?
> If it's possible I would prefere to have raid 5 /
>
There's certainly no problem with / being RAID-5 (or any other RAID
format).  You'll need the necessary RAID modules either built into the
kernel or in the initrd of course.

> There any particular configuration for grub to boot it?
>=20
Not for RAID-1, no.  You just point grub at the raw partition (rather
than the array) and it'll treat it as a non-RAID disk and be quite
happy.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkqg7MwACgkQShxCyD40xBLK4QCcD80XdMFiK6quycCgt58vfivI
g7gAoNy7vklCOvdVOlmYRLo63bWfoYSc
=xwKT
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
