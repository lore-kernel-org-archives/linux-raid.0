From: Andy Smith <andy@lug.org.uk>
Subject: Re: raid5 - failed disks
Date: Fri, 1 Apr 2005 10:55:39 +0000
Message-ID: <20050401105538.GI82728@caffreys.strugglers.net>
References: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fBy7zs94GxxmWtjp"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--fBy7zs94GxxmWtjp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 01, 2005 at 02:08:21AM -0800, Alvin Oga wrote:
>=20
> hi ya raiders ..
>=20
> we(they) have 14x 72GB scsi disks config'd as raid5,
> ( no hot spare .. )

This seems like an awful lot of disks to have in a raid 5 with no
hot spares, to me, but then I am fairly new to RAID issues so maybe
I am wrong.. but I would much rather have raid 10.

> - if 1 disk dies, no problem ... ez to recover
>=20
> - my dumb question is,
> 	- if 2 disks dies at the same time, i
> 	assume the entire raid5 is basically hosed=20
> 	if it won't reassemble and resync from
> 	the point where it last was before the crash ??

Technically it's screwed but it could be possible to recover it with
some losses.. I've fortunately never yet had to do that, maybe
someone who has could answer more fully.

> - i think 4x 300GB ide disks is better ( less likely to fail ?? )

Hard to say.. the typical IDE disk is usually regarded as less
reliable than the typical SCSI disk, and also there are then less
spindles per array so the performance may be worse.

I think I would still be happier with 14x72GB SCSI in a RAID-10
(504GB usable) than 14x72GB in RAID-5, although the RAID-10 would
give only a bit more than half the capacity.  Also if I felt I
needed the performance of a 14 disk SCSI RAID-5 then I probably
wouldn't want to go down to a 4 disk IDE RAID-5.

> 	and yes it has already crashed twice with
> 	2 different disks running at 78F at nights
> 	and weekends when the air conditioning is off

If you're running the disks in an environment that is too hot for
them then I think you are wasting money by just throwing more disks
(of any sort) at it.

--fBy7zs94GxxmWtjp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (FreeBSD)

iD8DBQFCTSiqIJm2TL8VSQsRAttGAJ9EqOBGB2M5rSTj4HM0yhDaaqklGwCfe4gX
9x/YkHqsK3Ag5zjuBPiuPKY=
=gAEl
-----END PGP SIGNATURE-----

--fBy7zs94GxxmWtjp--
