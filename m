From: NeilBrown <neilb@suse.de>
Subject: Re: Shrinking number of devices on a RAID-10 (near 2) array
Date: Fri, 29 Aug 2014 13:53:12 +1000
Message-ID: <20140829135312.5a6e78bc@notabene.brown>
References: <20140823163110.GE11855@bitfolk.com>
	<20140824130939.461501b4@notabene.brown>
	<20140824143944.GC19874@bitfolk.com>
	<20140825103234.GH11855@bitfolk.com>
	<20140825212614.5be558c9@notabene.brown>
	<20140825113402.GF19874@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/p35UkYjtlWc6w2wGRA.AMUl"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140825113402.GF19874@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/p35UkYjtlWc6w2wGRA.AMUl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Aug 2014 11:34:03 +0000 Andy Smith <andy@strugglers.net> wrote:

> Hi Neil,
>=20
> On Mon, Aug 25, 2014 at 09:26:14PM +1000, NeilBrown wrote:
> > What does "mdadm --examine" on one of the devices report now that it is=
 v1.0?
> >=20
> > Particularly interested in the "Unused Space :" line.
>=20
> /dev/sda3:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : 3905b303:ca604b72:be5949c4:ab051b7a
>            Name : 2
>   Creation Time : Sun Jun  4 08:18:59 2006
>      Raid Level : raid10
>    Raid Devices : 6
>=20
>  Avail Dev Size : 618726528 (295.03 GiB 316.79 GB)
>      Array Size : 928089792 (885.10 GiB 950.36 GB)
>    Super Offset : 618727392 sectors
>    Unused Space : before=3D0 sectors, after=3D864 sectors
>           State : active
>     Device UUID : e30176be:81a57e84:1f2aa206:9515150f
>=20
>     Update Time : Sun Aug 24 14:29:15 2014
>        Checksum : bd599c72 - correct
>          Events : 1
>=20
>          Layout : near=3D2
>      Chunk Size : 64K
>=20
>    Device Role : Active device 5
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
>=20
> All other devices report same (apart from UUID/checksum/role).

'after=3D864' should be plenty.

mdadm writes '128' to 'new_offset'
This is bigger than 'data_offset' (which must be zero, or it would have been
reported), mddev->dev_sectors is 618726528 while rdev->sectors is 618727392
(difference is 864), so=20
		if (new_offset - rdev->data_offset
		    + mddev->dev_sectors > rdev->sectors)
cannot return 'true'.  Yet it seems that it does.

Ahh.. somewhere else returns -E2BIG:

	if (mddev->pers && mddev->persistent &&
	    !super_types[mddev->major_version]
	    .allow_new_offset(rdev, new_offset))
		return -E2BIG;

But super_1_allow_new_offset always succeeds if new_offset >
rdev->data_offset, so that cannot be the problem.


I know.  rdev->sectors isn't "Super Offset", it is only "Avail Dev Size".
You need to
  echo 618727392 > /sys/block/md2/md/dev-sda3/size
and same for the other devices.

I looks like I need to get mdadm to be more clever when it gets -E2BIG.
Can you check that the above works?

Thanks,
NeilBrown


--Sig_/p35UkYjtlWc6w2wGRA.AMUl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU//5KDnsnt1WYoG5AQKICw//ZgBrHX32b+0nKjr5kiHuMnQflBpmv4Y4
mF2DwNQR8XWl4Y9drcn7HaBkc841Zo4PYU/54Ml0xQ6ETGtXpra1hIMi4xR9NrmU
WcBd5hmPnKdoWFZu8YfMFKLPqxztmX1pnOX+GwVWTf+Nr+7OXBGH5kN2dcQiMi1S
mYQidjOigAytn2tPpl7BNPzCSfgmubTvAjdPIqesm3v8a2VXODWv9mo3aNSYMCnU
kNzFsFAop3P625eVKu3ZRs17vBz/3BG4CTZ5cX7mlN3SAgUPGz260gNpPFXVIaRL
4UCcC52hB18wpx4Kx2dsfxVWOELO44I45kpGkEy6Ncw6J8L28jpJ5LsHLXw16Owt
095YGItFvBThgS5h2NYpA+ajUwwv/ZmP9KhHwsp7RhTfw0YI9ML3GdgBS2b3lbPI
V0dkkkhf5vppHL1NS+LSIMGXDS5nU1WW0TNp37G47hKvgZdXTmxWIKesTPm8XjJI
qv0BCOWcfESU38NUE4IRDtw809zEtZw5OASEa9xiowTvzvvkItJc7cno+0BtFWJY
Lr3+QARtRI7/VAiLdVlIEHShNl6dOkJaf5GpKjqCuH2x6AxRQdy91TUvF5A6h6rW
j7WOE7tTWi+xRBYZ9cGt9musaygvuZAKN7paEymvxb9uqcavNdjfdpBkdagfCdRE
O0LizQVfvqY=
=AIA4
-----END PGP SIGNATURE-----

--Sig_/p35UkYjtlWc6w2wGRA.AMUl--
