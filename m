From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Wed, 19 Dec 2007 21:59:48 +0000
Message-ID: <20071219215948.GA7129@cthulhu.home.robinhill.me.uk>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Dec 19, 2007 at 09:50:16AM -0500, Justin Piszcz wrote:

> The (up to) 30% percent figure is mentioned here:
> http://insights.oetiker.ch/linux/raidoptimization.html
>
That looks to be referring to partitioning a RAID device - this'll only
apply to hardware RAID or partitionable software RAID, not to the normal
use case.  When you're creating an array out of standard partitions then
you know the array stripe size will align with the disks (there's no way
it cannot), and you can set the filesystem stripe size to align as well
(XFS will do this automatically).

I've actually done tests on this with hardware RAID to try to find the
correct partition offset, but wasn't able to see any difference (using
bonnie++ and moving the partition start by one sector at a time).

> # fdisk -l /dev/sdc
>
> Disk /dev/sdc: 150.0 GB, 150039945216 bytes
> 255 heads, 63 sectors/track, 18241 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Disk identifier: 0x5667c24a
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1       18241   146520801   fd  Linux raid=20
> autodetect
>
This looks to be a normal disk - the partition offsets shouldn't be
relevant here (barring any knowledge of the actual physical disk layout
anyway, and block remapping may well make that rather irrelevant).

That's my take on this one anyway.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHaZRTShxCyD40xBIRAvOsAJ9zQNbvqF4ATKiXn0eOCogH92rOmACgslVt
IwIYUm1Ruy3ucridiipoogg=
=sqe8
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
