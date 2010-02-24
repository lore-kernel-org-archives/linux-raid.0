From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 17:09:51 +0000
Message-ID: <20100224170951.GC11039@cthulhu.home.robinhill.me.uk>
References: <4B853DB7.1060406@xunil.at>
 <4B854040.5080603@xunil.at>
 <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
 <4B85467C.5020008@xunil.at>
 <4B855621.5010000@xunil.at>
 <4B855987.1010605@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B855987.1010605@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 24, 2010 at 05:53:27PM +0100, Stefan G. Weichinger wrote:

> Am 24.02.2010 17:38, schrieb Stefan G. Weichinger:
>=20
> > I now have md4 on sda4 and sdb4 ... xfs_repaired ... and sync the data
> > to a plain new xfs-partition on sdc4 ... just to get current data out of
> > the way.
>=20
>=20
> Status now, after another reboot because of a failing md4:
>=20
> why degraded? How to get out of that and re-add sdc4 or sdd4 ?
> What about that device 2 down there??
>=20
>=20
> server-gentoo ~ # mdadm -D /dev/md4
> /dev/md4:
>         Version : 00.90.03
>   Creation Time : Tue Aug  5 14:14:16 2008
>      Raid Level : raid5
>      Array Size : 291820544 (278.30 GiB 298.82 GB)
>   Used Dev Size : 145910272 (139.15 GiB 149.41 GB)
>    Raid Devices : 3
>   Total Devices : 2
> Preferred Minor : 4
>     Persistence : Superblock is persistent
>=20
>     Update Time : Wed Feb 24 17:41:15 2010
>           State : clean, degraded
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>            UUID : d4b0e9c1:067357ce:2569337e:e9af8bed
>          Events : 0.198
>=20
>     Number   Major   Minor   RaidDevice State
>        0       8        4        0      active sync   /dev/sda4
>        1       8       20        1      active sync   /dev/sdb4
>        2       0        0        2      removed
>=20
It's degraded because you only have 2 disks in the array, presumably the
event count on the other disks doesn't match up.  If you've replaced sdc
and sdd never got rebuilt onto, then you only have the two disks
available for the array anyway.

If these are the only disks with up-to-date data, and sda4 is still
failing, I can only suggest stopping the array and using dd/dd_rescue to
copy sda4 onto a working disk.  You should then be able to reassemble
the array with sdb4 and the new disk, then add in a hot spare to
recover.

Alternately, bite the bullet, recreate the array and restore.

Either way, it looks like you ought to be running regular checks on the
array to try to pick up/fix these background failures.

Cheers,
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
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuFXV4ACgkQShxCyD40xBImQgCgtCOVdfG1kPLzlgGQuJDh6FdV
WEwAmgM70qNhEGXP2HrwkFMJey4OznO0
=MwRu
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
