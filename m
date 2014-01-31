From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Fri, 31 Jan 2014 10:25:52 +0000
Message-ID: <20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yorik <yoriks13@westnet.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 30, 2014 at 10:20:45pm +0800, Yorik wrote:

> Hello
>=20
> Sorry if double post had to remove some HTML.
>=20
> I've been using "mdadm" for about 8-9 years with a lot of success in
> different Array configurations. I am a huge fan of Software RAID. I
> recently suffered a failure that was very unfortunate and I now have
> an issue with differing Data Offset and other issues preventing my
> Array from rebuilding. A brief history follows:
>=20
> Array originally created as RAID5, 3x 3TB Drives in May 2011 on a
> (then) latest Fedora build.
> Added more drives in 2012 and 2013 with upgraded Fedora builds.
> Recently added another drive and changed to RAID6, 6x6TB Drives.
> Suffered a failure shortly after 2 more drives that kicked the last 2
> drives off and one of the 6 other that were previously running.
> During the RAID rebuild, my computer locked up and then suffered a
> Power Failure (having a bad day) that stopped my OS Disk (SSD) from
> allowing me to reboot. Eventually rebuilt the OS with Fedora 20,
> wiping the majority of the SSD and config files with it.
>=20
> The RAID6 does not start, stating that it only has 5 of the 8 drives
> required. Looking into this, the drives seem to be clean and check
> okay, but there is even differences (expected) and Data Offset
> difference between drives that I read (Neil Brown Blog date
> -20120615073245) was not necessarily good for rebuilding and that I
> should ask for a version of mdadm that can handle this as it's
> possible that creating with an older version, then adding new drives
> is causing an issue. Data Offsets of 2048 and 4096 exist.
>=20
> Also of note is that I have some drives that are on the Array without
> partitions as they would not add to the Array with partitions on them
> due to size when they were added. I think that I had version issue
> with fdisk, but it seemed to work okay until now.
>=20
> When I run the following command:
>=20
> mdadm --create --assume-clean --level=3D6 --raid-devices=3D8
> --size=3D2930263552 /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd
> /dev/sdi /dev/sde /dev/sdg /dev/sdf
>=20
> I get:
>=20
> mdadm: /dev/sda1 is smaller than given size. 2930134016K < 2930263552K
> + metadata
> mdadm: /dev/sdb1 is smaller than given size. 2930134016K < 2930263552K
> + metadata
> mdadm: /dev/sdc1 is smaller than given size. 2930134016K < 2930263552K
> + metadata
> mdadm: /dev/sdd is smaller than given size. 2930135040K < 2930263552K + m=
etadata
> mdadm: /dev/sdi is smaller than given size. 2930135040K < 2930263552K + m=
etadata
> mdadm: /dev/sde is smaller than given size. 2930135040K < 2930263552K + m=
etadata
> mdadm: /dev/sdg is smaller than given size. 2930135040K < 2930263552K + m=
etadata
> mdadm: /dev/sdf is smaller than given size. 2930135040K < 2930263552K + m=
etadata
> mdadm: create aborted
>=20
> Which makes me think that there are further issues. Should I be
> looking for an older version of mdadm or a different version? Can
> anyone offer some advice please or where to look next.
>=20
You don't mention having tried a force assemble, which should have been
done before resorting to re-creating the array. What's the output from
running "mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]"?

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlLrei8ACgkQShxCyD40xBKktQCfZrAAHSQvkavAUZOFouRa2SGN
OtYAn3E+hmsSyhHMOuSKHJEgwZSlI4CS
=R55R
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
