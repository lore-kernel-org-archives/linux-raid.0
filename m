From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Growing Array (More Devices) - new devices are slightly smaller
 than the existing drives, unable to shrink array
Date: Sat, 28 Sep 2013 16:28:57 +0100
Message-ID: <20130928152857.GA10073@cthulhu.home.robinhill.me.uk>
References: <BLU0-SMTP69424F8624CF692DCD2AD7812A0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BLU0-SMTP69424F8624CF692DCD2AD7812A0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Callaghan <matt_callaghan@sympatico.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat Sep 28, 2013 at 10:49:49AM -0400, Matt Callaghan wrote:

> Hello mdadm Linux-RAID experts;
>=20
> My Goal: Expand (grow) my array from 6xHDD (RAID6) to 8xHDD (RAID6)
>=20
> This is my root cause problem: when I went to try to add the new drive=20
> (already formatted for Linux RAID partition):
>=20
> fermulator@fermmy-server:~$ sudo mdadm --add /dev/md2000 /dev/sdq1
> mdadm: /dev/sdq1 not large enough to join array
>=20
> As I have researched and learned, I need to:
>   A) shrink the filesystem (ext4) -- done (shrunk by a generous 1.6GB)
>   B) shrink the array size -- incomplete (unable to proceed, the --grow=
=20
> command doesn't do anything)
>=20
> I've been following this guide:=20
> http://webapp5.rrz.uni-hamburg.de/SuSe-Dokumentation/manual/sles-manuals_=
en/manual/raidresize.html#resizedecrraid=20
>=20
>=20
> This pastebin shows my array details, the 'existing' drives (fdisk) and=
=20
> 'new' drives (fdisk) - http://pastebin.com/U04VJpE4
>=20
> Any ideas?
>=20
Firstly, your new drives are exactly the same size as the old ones:
    Disk /dev/sdk: 2000.4 GB, 2000398934016 bytes
    Disk /dev/sdq: 2000.4 GB, 2000398934016 bytes

Your partition sizes are different though, probably because newer
versions on fdisk default to a higher start point. You can replicate the
partitions from the old disks onto the new ones using sfdisk:
    sfdisk -d /dev/sdk | sfdisk /dev/sdq

You can do the same thing manually using fdisk - just make sure you set
the units to sectors (fdisk -u=3Dsectors) as the cylinder information
differs between the disks (and is obsolete and meaningless).

If you do want to stick with the partitions you have and continue with
shrinking the array, the value passed with the "-z" parameter is the
device size, not the array size. You're passing a value larger than the
disk size, so it's being ignored. It also needs to be a multiple of the
chunk size (64k in your case). So you need to take your 7812441960,
divide by the number of active disks (4) and round up to the nearest
64k. This gives you a new device size of 1953110528.

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlJG9bgACgkQShxCyD40xBIApgCeKvIYJ0Im+ySya75RK87Fum19
1XwAn0tPpwCXmxE71rZllqt6eCYh66ij
=+gdl
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
