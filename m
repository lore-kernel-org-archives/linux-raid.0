From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 13:02:37 +0000
Message-ID: <20130205130237.GA9299@cthulhu.home.robinhill.me.uk>
References: <20130205122048.GA417@nsrc.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130205122048.GA417@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Feb 05, 2013 at 12:20:48PM +0000, Brian Candler wrote:

> (Ubuntu 12.04.2, kernel 3.2.0-37-generic)
>=20
> I created a RAID5 array with 22 data disks and 2 hot spares, like this:
>=20
>     # mdadm --create /dev/md/dbs -l raid5 -n 22 -x 2 -c 512 -b internal /=
dev/sd{b..y}
>=20
> However I'm having difficultly understanding the mdstat output.
>=20
>     # cat /proc/mdstat
>     Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4] [raid10]=20
>     md127 : active raid5 sdw[24] sdy[23](S) sdx[22](S) sdv[20] sdu[19] sd=
t[18] sds[17] sdr[16] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] sdl[10] sdk[9=
] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>           61532835840 blocks super 1.2 level 5, 512k chunk, algorithm 2 [=
22/21] [UUUUUUUUUUUUUUUUUUUUU_]
>           [=3D>...................]  recovery =3D  6.0% (176470508/293013=
5040) finish=3D706.9min speed=3D64915K/sec
>           bitmap: 0/22 pages [0KB], 65536KB chunk
>=20
>     unused devices: <none>
>     #=20
>=20
> Problems:
>=20
> 1. The UUUU_ and [22/21] suggests that one disk is bad, but is that true?
> And if so which one?
>=20
No, that's normal. A RAID5 (or RAID6) array is created in a degraded
form, then the last disk(s) are recovered (it's the quickest way of
getting the array ready for use).

> Output from "dmesg | grep -3 sd" is at end of this mail, and it doesn't s=
how
> any errors.
>=20
> All the disks have the same event counter in the metadata:
>=20
> # for i in /dev/sd{b..y}; do mdadm --examine $i | grep Events; done | sor=
t | uniq -c
>      24          Events : 594
>=20
> 2. /proc/mdstat shows the member disks numbered 0..20 and 22..24, what
> happened to 21 ?
>=20
21 would (I think) be the "missing" one from the original array creation
(with 22..24 as the spares). The numbers themselves don't really signify
anything.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlERAu0ACgkQShxCyD40xBKRuACfQRTB/eIzMvFlQlpk8XHDSUWf
dtYAnAuq8Fot/XUMNyPwtQ2Ra7m/JxYh
=CVWM
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
