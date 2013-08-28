From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/6] DDF: ddf_activate_spare: fix gcc -O2 uninitialized
 warning
Date: Wed, 28 Aug 2013 14:57:57 +1000
Message-ID: <20130828145757.0baad436@notabene.brown>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
	<1376677320-12816-2-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/V.xYrFJYoX/RBfWvUhDVX.."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1376677320-12816-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/V.xYrFJYoX/RBfWvUhDVX..
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Aug 2013 20:21:55 +0200 mwilck@arcor.de wrote:

> The warning is spurious, but will break compilation with -O2.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>
> ---
>  super-ddf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index e3b3dca..95972ad 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -4779,7 +4779,7 @@ static struct mdinfo *ddf_activate_spare(struct act=
ive_array *a,
>  	struct ddf_super *ddf =3D a->container->sb;
>  	int global_ok =3D 0;
>  	struct mdinfo *rv =3D NULL;
> -	struct mdinfo *di;
> +	struct mdinfo *di =3D NULL;
>  	struct metadata_update *mu;
>  	struct dl *dl;
>  	int i;

I fixed this differently as below.
Thanks,
NeilBrown

=46rom bb925ff08beda785d42f5ff8a0f082d91c5caad4 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 16 Aug 2013 20:21:55 +0200
Subject: [PATCH] DDF: ddf_activate_spare: fix gcc -O2 uninitialized warning

At this point 'di' and 'rv' both have the same value.  gcc doesn't
realise that and a human reader might not either.
'rv' makes more sense too, so use that.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super-ddf.c b/super-ddf.c
index e3b3dca..ee6499a 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4959,7 +4959,7 @@ static struct mdinfo *ddf_activate_spare(struct activ=
e_array *a,
 	 * Create a metadata_update record to update the
 	 * phys_refnum and lba_offset values
 	 */
-	vc =3D find_vdcr(ddf, a->info.container_member, di->disk.raid_disk,
+	vc =3D find_vdcr(ddf, a->info.container_member, rv->disk.raid_disk,
 		       &n_bvd, &vcl);
 	if (vc =3D=3D NULL)
 		return NULL;

--Sig_/V.xYrFJYoX/RBfWvUhDVX..
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUh2DVTnsnt1WYoG5AQJ/tQ//Sqp4O0rlT8xydK70GzOyumk8NGL0mZDc
Cxb7WBDNVHcqlz6JEM5sebctA9nIu3bBkL2GmxbxSq05vsdpTvIWU/T/Z1kHF29t
CY5NnEYRCzqzwbHFJm6tdk40dkuGjKf6tCw3+UpUMwcb9IA3C/td93UO6dknbEOw
hY7Z8Lzr8uFS55QW+cBEglgJshRB0W5jAPg2FgW64m/B7nKemkRLevrsD3q1PlaU
RhHxPmYTpAivLXnMi07JG62EQGqOm4aATTLa7m7u6vyH7xQy7uapqDOpXAze44rT
QUGB7vEpx74E+MStxKLrTEV1x0McwNyHlVOMrGnNQa8NlUA23BCb0UNaTIrdMyeM
ZFoKOcSV35O4onQ/Mr+vtFqsrMmavgKvILot1yvqlwRXdlvJjrTWNaeXO7nDnPjV
hfvNquB4UMukth2BvM8RE/I9rNdtFW5394aoGjFqT6j2X6AiEX9ZEXMK/LSduNQS
N/GmVy8TC2UuZn632ixSXhHqXwOQAnIHNvmcSg0moBazyGDJr7SGe9wJgXuqGAnG
KLbdAM3Oi79K4sreRMPP3I1dIxlD2+OGemkN477nlxNW3fJ8dtXjHz3PntCUyEGd
8vYTeHf5pqTwAHsvS0IZS6PYjT6QZcjdFRiDyuJuPgGvoLIApb+QriJ/89mkHaeb
KioIOsBr8fc=
=NaOu
-----END PGP SIGNATURE-----

--Sig_/V.xYrFJYoX/RBfWvUhDVX..--
