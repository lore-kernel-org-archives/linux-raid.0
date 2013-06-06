From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Import data from an array coming from another computer
Date: Thu, 6 Jun 2013 15:54:11 +0100
Message-ID: <20130606145411.GA26106@cthulhu.home.robinhill.me.uk>
References: <CAO5znavAuteVhzarkVEDHPOxs4RFx9j0tB51QXj5LUcREJbn=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAO5znavAuteVhzarkVEDHPOxs4RFx9j0tB51QXj5LUcREJbn=A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Michel <be.nicolas.michel@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jun 06, 2013 at 04:47:33PM +0200, Nicolas Michel wrote:

> Hello guys,
>=20
> I need some help to recover some data that resides on a disk that was
> part of an array in an Iomega device. I connected the disk with a
> SATA->USB connector to my computer. An mdadm --examine give me theses
> informations:
>=20
> ############################################################
> # $ mdadm --examine /dev/sdc1
> # /dev/sdc1:
> #           Magic : a92b4efc
> #         Version : 0.90.00
> #            UUID : 76fc436c:be43bed5:f0f41dd6:3e9e1b96
> #   Creation Time : Fri Jun  8 04:21:19 2012
> #     Raid Level : raid1
> #   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
> #     Array Size : 20980800 (20.01 GiB 21.48 GB)
> #   Raid Devices : 2
> #   Total Devices : 2
> #  Preferred Minor : 0
> #
> #    Update Time : Thu May 23 14:55:13 2013
> #          State : clean
> #  Active Devices : 1
> #  Working Devices : 2
> #  Failed Devices : 0
> #   Spare Devices : 1
> #        Checksum : b0ae04f1 - correct
> #          Events : 28935
> #
> #
> #       Number   Major   Minor   RaidDevice State
> # this     2       8        1        2      spare   /dev/sda1
> #
> #    0     0       0        0        0      removed
> #    1     1       8       17        1      active sync   /dev/sdb1
> #    2     2       8        1        2      spare   /dev/sda1
> ############################################################
>=20
> What I cannot achieve is to create a newly empty array and insert that
> existing disk inside of it, so I can backup the data elsewhere.
>=20
> I tried with mdadm --assemble /dev/sdc1 but it says:
>     mdadm: device /dev/sdc1 exists but is not an md array.
>=20
> I someone have an idea? It would be really really great :)
>=20
You need to specify the array name with --assemble, not just the member
name. Try "mdadm --assemble /dev/md0 /dev/sdc1"

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGwopEACgkQShxCyD40xBJq1wCg11JCqvMw5kMAXRwV3zel37D7
xPYAn1riDIcmBt7rCBkxqznFIK6q995m
=2cBP
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
