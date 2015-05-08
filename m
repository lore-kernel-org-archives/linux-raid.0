From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: mdadm Raid level change from 1 to 5?
Date: Fri, 8 May 2015 11:47:22 +0100
Message-ID: <20150508104722.GA21989@cthulhu.home.robinhill.me.uk>
References: <554C7F74.5010404@hanswkraus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <554C7F74.5010404@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri May 08, 2015 at 11:18:44AM +0200, Hans Kraus wrote:

> Hi,
>=20
> I have a Raid 1 with 3 drives, the following layout (the internal
> bitmap is already removed):
> -----------------------------------------------------------------
> md20 : active raid1 sdj1[2] sdi1[1] sdn1[0]
>        732442432 blocks super 1.2 [3/3] [UUU]
> -----------------------------------------------------------------
> I tried to change it to Raid 5, but I'm getting aways an error.
> -----------------------------------------------------------------
> mdadm --grow /dev/md20 --level=3D5 --raid-devices=3D3 -c 32 \
>    --backup-file=3D/home/kraush/work/raidLevelChange
>=20
> Impossibly level change request for RAID1
> -----------------------------------------------------------------
> I tried it with various permutations (+/- raid-devices, c, ...).
>=20
> Is something in my command wrong or is the level change not
> possible?
> This is on Debian 7, mdadm - v3.3-65-g2167de7 - 11th March 2014
>=20
I think you'll need one of the disks to be spare first. Try reducing the
RAID1 to a 2-disk plus spare configuration, then rerunning the grow.
Alternately you'd need to add a new disk as a spare first, then grow to
a 4 disk RAID5.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlVMlDkACgkQShxCyD40xBKHGACgyGDt4pv3FwKpq3/YK7Rim6+4
AFUAnj1w1y2fOs9yBlzOyNthDf+X5mX5
=8xGD
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
