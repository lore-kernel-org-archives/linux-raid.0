From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Fwd: issues rebuilding raid array.
Date: Mon, 22 Oct 2007 13:54:55 +0100
Message-ID: <20071022125455.GA13559@cthulhu.home.robinhill.me.uk>
References: <8a16822a0710220445i3175a624g5b92535ca3797517@mail.gmail.com> <8a16822a0710220446y1d360965m2f705842e5940932@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8a16822a0710220446y1d360965m2f705842e5940932@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Oct 22, 2007 at 09:46:08PM +1000, Sam Redfern wrote:

> Greetings happy mdadm users.
>=20
> I have a little problem that after many hours of searching around I
> couldn't seem to solve.
>=20
> I have upgraded my motherboard and kernel (bad practice I know but the
> ICH9R controller needs  2.6.2*+) at the same time.
>=20
> The array was build using 2.6.18-7 Now i'm using  2.6.21-2
>=20
> I'm trying to recreate the raid array with the following command and
> this is the error I get:
>=20
> mca4:~# mdadm -Av /dev/md1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
> /dev/sdf /dev/sdg
> mdadm: looking for devices for /dev/md1
> mdadm: no RAID superblock on /dev/sdc
> mdadm: /dev/sdc has no superblock - assembly aborted
>=20
You're trying to assemble the array from 6 disks here and one looks to
be dodgy.  That's okay so far.

> So I figure, oh look the disk sdc has gone cactus, I'll just remove it
> from the list. One of the advantages of mdadm.
>=20
> mca4:~# mdadm -Av /dev/md1 /dev/sdb /dev/sdd /dev/sde /dev/sdf /dev/sdg
> mdadm: looking for devices for /dev/md1
> mdadm: /dev/sdb is identified as a member of /dev/md1, slot -1.
> mdadm: /dev/sdd is identified as a member of /dev/md1, slot 0.
> mdadm: /dev/sde is identified as a member of /dev/md1, slot 1.
> mdadm: /dev/sdf is identified as a member of /dev/md1, slot 5.
> mdadm: /dev/sdg is identified as a member of /dev/md1, slot 4.
> mdadm: added /dev/sde to /dev/md1 as 1
> mdadm: no uptodate device for slot 2 of /dev/md1
> mdadm: no uptodate device for slot 3 of /dev/md1
> mdadm: added /dev/sdg to /dev/md1 as 4
> mdadm: added /dev/sdf to /dev/md1 as 5
> mdadm: failed to add /dev/sdb to /dev/md1: Invalid argument
> mdadm: added /dev/sdd to /dev/md1 as 0
> mdadm: /dev/md1 assembled from 4 drives - not enough to start the array.
>=20
Now you're trying to assemble with 5 disks and getting 4 out of 6 in the
array, and one at slot -1 (i.e. a spare).

> If found this really difficult to understand considering that I can
> get the output of mdamd -E /dev/sdb (other disks included to overload
> you with information)
>=20
> mdadm -E /dev/sd[b-h]
>=20
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
>   Creation Time : Fri Oct  5 09:18:25 2007
>      Raid Level : raid5
>     Device Size : 312571136 (298.09 GiB 320.07 GB)
>      Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 1
>=20
>     Update Time : Tue Oct 16 20:03:13 2007
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 80d47486 - correct
>          Events : 0.623738
>=20
>          Layout : left-symmetric
>      Chunk Size : 64K
>=20
>       Number   Major   Minor   RaidDevice State
> this     6       8       16       -1      spare   /dev/sdb
>=20
>    0     0       8       80        0      active sync   /dev/sdf
>    1     1       8      128        1      active sync   /dev/.static/dev/=
sdi
>    2     2       8      144        2      active sync   /dev/.static/dev/=
sdj
>    3     3       8       16        3      active sync   /dev/sdb
>    4     4       8       64        4      active sync   /dev/sde
>    5     5       8       96        5      active sync   /dev/sdg
>
And here we see that the array has 6 active devices and a spare.  You
currently have 4 working active devices, a failed active device and the
spare.  What's happened to the other device?  You can't get the array
working with 4 out of 6 devices so you'll need to either find the other
active device (and rebuild onto the spare) or get the failed disk
working again.

HTH,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7-ecc0.1.6 (GNU/Linux)

iD8DBQFHHJ2fShxCyD40xBIRAmILAKCOvvPGICyPYi7Vu70ddFS/uETgCQCgm9u+
r2NutlIcw00Cb/3jECx/lcs=
=4NDe
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
