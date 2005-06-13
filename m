From: Andy Smith <andy@lug.org.uk>
Subject: Re: RAID 5 of RAID 5's?
Date: Mon, 13 Jun 2005 10:03:39 +0000
Message-ID: <20050613100339.GO750@strugglers.net>
References: <1118187572.15459.96.camel@seki.nac.uci.edu> <42A93D30.6080900@apartia.fr> <1118436219.25226.252.camel@seki.nac.uci.edu> <42AD329B.4080103@apartia.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kcP3xCD2XyuzODov"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42AD329B.4080103@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--kcP3xCD2XyuzODov
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 13, 2005 at 09:15:39AM +0200, Laurent CARON wrote:
> Dan Stromberg a ?crit :
> >>>Has anyone constructed a RAID 5 of RAID 5's using mdadm on a linux
> >>>system?
> >>>
> >>>Was it reliable?
> >>>
> >>>How large was it?
> >
> RAID 10 is IMHO a bit more efficient.
>=20
> Raid 5 means at least 9 disks:
> Usable capacity: 4 Disks
> Read speed: Good
> Write speed: poor

With a low number of disks, you would indeed get the same or less
capacity with RAID 5 + RAID 5 as compared to RAID 10, but as the
number of disks gets higher, doesn't the capacity of RAID 5 on top
of RAID 5 (we need a name for this, is RAID 55 technically correct?)
get better?

For example, 30 disks, organised as 10 3-disk RAID 5s, have 9*2 or
18 disks of capacity, whereas a RAID 10 of same would be 15 disks.

The write performance seems bad though, and maybe the rebuild time
as well.

--kcP3xCD2XyuzODov
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCrVn7IJm2TL8VSQsRAsKrAJ0WLJq5F672YEk1dxON+3h4iVtuOwCeLJKE
Tylqv0xlHvjXmkdO7xi49sU=
=2RIp
-----END PGP SIGNATURE-----

--kcP3xCD2XyuzODov--
