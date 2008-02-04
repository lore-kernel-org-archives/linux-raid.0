From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  raid1 or raid10 for /boot
Date: Mon, 4 Feb 2008 11:48:39 +0000
Message-ID: <20080204114839.GD30156@cthulhu.home.robinhill.me.uk>
References: <20080204063454.GA31046@rap.rap.dk> <20080204091735.GA30156@cthulhu.home.robinhill.me.uk> <20080204112140.GB20876@rap.rap.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qGV0fN9tzfkG3CxV"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080204112140.GB20876@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--qGV0fN9tzfkG3CxV
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Feb 04, 2008 at 12:21:40PM +0100, Keld J=F8rn Simonsen wrote:

> On Mon, Feb 04, 2008 at 09:17:35AM +0000, Robin Hill wrote:
> > On Mon Feb 04, 2008 at 07:34:54AM +0100, Keld J=F8rn Simonsen wrote:
> >=20
> > > I understand that lilo and grub only can boot partitions that look li=
ke
> > > a normal single-drive partition. And then I understand that a plain
> > > raid10 has a layout which is equivalent to raid1. Can such a raid10
> > > partition be used with grub or lilo for booting?
> > > And would there be any advantages in this, for example better disk
> > > utilization in the raid10 driver compared with raid?
> > >=20
> > A plain RAID-10 does _not_ have a layout equivalent to RAID-1 and
> > _cannot_ be used for booting (well, possibly a 2-disk RAID-10 could -
> > I'm not sure how that'd be layed out).  RAID-10 uses striping as well as
> > mirroring, and the striping breaks both grub and lilo (and, AFAIK, every
> > other boot manager currently out there).
>=20
> Yes, it is understood that raid10,f2 uses striping, but a raid10,near=3D2,
> far=3D1 does not use striping, anfd this is what you get if you just make
> a    mdadm --create /dev/md0 -l 10 -n 2 /dev/sda1 /dev/sdb1
>=20
Well yes, if you do a two-disk RAID-10 then (as I said above) you
probably end up with a RAID-1 (as you do with a two-disk RAID-5).  I
don't see how this would work any differently (or better) than a RAID-1
though (and only serves to confuse things).

If you have more than two disks then RAID-10 will _always_ stripe (no
matter whether you use near, far or offset layout - these affect only
where the mirrored chunks are put) and grub/lilo will fail to work.

Cheers,
        Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--qGV0fN9tzfkG3CxV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHpvuWShxCyD40xBIRAgUxAKDWSYi/3hXYcGka6C/BEQF/fqnWIwCfaWih
4DIfDWawmDyE+Tkj9GIadd0=
=7f7w
-----END PGP SIGNATURE-----

--qGV0fN9tzfkG3CxV--
