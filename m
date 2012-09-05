From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Fix comparison of index and quantity for
 "rebuild" parameter
Date: Thu, 6 Sep 2012 06:22:40 +1000
Message-ID: <20120906062240.23b224f9@notabene.brown>
References: <1346860400.10156.50.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4SKrvtxRME4EHh+A2n+h=qs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1346860400.10156.50.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4SKrvtxRME4EHh+A2n+h=qs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 05 Sep 2012 10:53:20 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> DM RAID: Fix comparison of index and quantity for "rebuild" parameter
>=20
> The "rebuild" parameter takes an index argument that starts counting from
> zero.  The conditional used to validate the index was using '>' rather th=
an
> '>=3D', leaving the door open for an index value that would be 1 too larg=
e.
>=20
> Reported-by: Neil Brown <neilb@suse.de>
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
>=20
> Index: linux-upstream/drivers/md/dm-raid.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-upstream.orig/drivers/md/dm-raid.c
> +++ linux-upstream/drivers/md/dm-raid.c
> @@ -539,7 +539,7 @@ static int parse_raid_params(struct raid
> =20
>  		/* Parameters that take a numeric value are checked here */
>  		if (!strcasecmp(key, "rebuild")) {
> -			if (value > rs->md.raid_disks) {
> +			if (value >=3D rs->md.raid_disks) {
>  				rs->ti->error =3D "Invalid rebuild index given";
>  				return -EINVAL;
>  			}
>=20

Applied, thanks.

NeilBrown

--Sig_/4SKrvtxRME4EHh+A2n+h=qs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEe0kDnsnt1WYoG5AQLp7xAAoWk4zaqWl5/kAv0T//maEIIslTQK8WXh
lyrG24muKHG/FcLm/EIYJpjNI2f+HY3z1NdsiNqKswUnjihUMOd1uwDqtOADJhSK
G9yrDcL5GEDV4jxEYtYaf0um3+edBOKew7hj/kWGCSX9QuIGP7eDPlZkafS7lJU+
/aO9W0rSoAKT2aamgFdKZfdjj7pXE3mAkVBdXRoTY6XxWgKSkMaRyDI+kzH71ZDv
TmnXTIF/ltLbXxr0Nn+RbIAga1aADgzSDWtbsZHuDU+0xeDI9EOmrJSTBeHBVLvS
3U+1xL7XkGdInBERmGvTss+Zns15pqRyiPBTipQAAraB13Gin0mkRJ97BI1hkosk
nr2f4k1HbGZave2kF5F0i4sZqOZTzRwfIte7eC91oXV2v9gc8kNO07OIGtgJocMO
UyJKAVUckT0uW1EXdGGvv2c67akZq9Stux3Z78Q6ErPmd4rErD+K4L7lD4AWIbG2
p3/IqstAaucAlnkDDxM/dPwWhD33vJV/pr8U94RVhRFQlEC9q2dkKndm7Ux3tVOK
TFCYl6nwoUASvS/kvo7iJ76A7Jcjho2mYFE1xnxxdcWSrWYH5jfumE3ijuS9NxT9
4RtyjViOcVD5fHocUe2I9Wohwcbz8B3zbnUio8rxbOTIwRysyoKSzpdqZHA2XMxH
kzRes5m5F88=
=MLUT
-----END PGP SIGNATURE-----

--Sig_/4SKrvtxRME4EHh+A2n+h=qs--
