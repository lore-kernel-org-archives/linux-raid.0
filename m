From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 13:59:46 +0000
Message-ID: <20130205135946.GB9299@cthulhu.home.robinhill.me.uk>
References: <20130205122048.GA417@nsrc.org>
 <20130205130237.GA9299@cthulhu.home.robinhill.me.uk>
 <20130205134014.GA587@nsrc.org>
 <20130205134907.GA622@nsrc.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130205134907.GA622@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Feb 05, 2013 at 01:49:07PM +0000, Brian Candler wrote:

> On Tue, Feb 05, 2013 at 01:40:14PM +0000, Brian Candler wrote:
> > On Tue, Feb 05, 2013 at 01:02:37PM +0000, Robin Hill wrote:
> > > > 1. The UUUU_ and [22/21] suggests that one disk is bad, but is that=
 true?
> > > > And if so which one?
> > > >=20
> > > No, that's normal. A RAID5 (or RAID6) array is created in a degraded
> > > form, then the last disk(s) are recovered (it's the quickest way of
> > > getting the array ready for use).
> >=20
> > Ah I see. Thank you.
>=20
> The odd thing is, if I make a RAID6 I get [UUUUU] with no underscores?
>=20
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [rai=
d4] [raid10]=20
> md127 : active raid6 sdy[23](S) sdx[22] sdw[21] sdv[20] sdu[19] sdt[18] s=
ds[17] sdr[16] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] sdl[10] sdk[9] sdj[8=
] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
>       61532835840 blocks super 1.2 level 6, 512k chunk, algorithm 2 [23/2=
3] [UUUUUUUUUUUUUUUUUUUUUUU]
>       [>....................]  resync =3D  0.0% (850232/2930135040) finis=
h=3D1607.7min speed=3D30365K/sec
>       bitmap: 22/22 pages [88KB], 65536KB chunk
>=20
> unused devices: <none>
>=20
Looks like my mistake. The mdadm manual page indicates that it's only
RAID5 that is done this way. RAID6 will just do a full resync to
generate the parity.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEREFIACgkQShxCyD40xBLScgCgie7OeIWh15jk7+xTz3k2KOVC
IfoAoNU2yxZdkN4S10oZ8WfPLa1w/B1p
=XZUm
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
