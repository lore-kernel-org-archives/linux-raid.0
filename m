From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm segfault with incremental
Date: Mon, 23 Oct 2017 13:12:06 +1100
Message-ID: <87mv4iehop.fsf@notabene.neil.brown.name>
References: <CAJO99Tk=at4gXNgEHKmq1=iDip+vt2LT-T8d+FSQYGJquH5C2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJO99Tk=at4gXNgEHKmq1=iDip+vt2LT-T8d+FSQYGJquH5C2g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Bj=C3=B8rnar?= Ness <bjornar.ness@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19 2017, Bj=C3=B8rnar Ness wrote:

> While working with mdadm policy/udev to add slaves when they are
> inserted, I notices
> mdadm is segfaulting if it gets a blank drive and action is set to
> spare or above.
>
> Looking into the code, this segfault is caused by the following code:
>
> Incremental.c line 965
>
>                      st2->ss->avail_size(st2, devsize,
>                                          sra->devs
>                                          ? sra->devs->data_offset
>                                          : INVALID_SECTORS)
>
> avail_size in my case is super1.c avail_size1
>
> and here the code sets:
>
> struct mdp_superblock_1 *super =3D st->sb;
>
> and later tries accessing i.e super->feature_map, where it segfaults
> because in the case
> of an empty drive, st2 is created in super1.c/match_metadata_desc1
> where it sets:
>
>         st->sb =3D NULL;
>
> I am not entirely sure how this is supposed to work, but atleast
> currently it segfaults.

Hi Bj=C3=B8rnar,
 thanks for the report.

This was broken by
Commit: 641da7459192 ("super1: separate to version of _avail_space1().")

in mdadm-3.3.  The code in Incremental.c should really be using
=2D>validate_geometry, rather than ->avail_size.

This patch should fix it.  Could you please try and report?

Thanks,
NeilBrown


diff --git a/Incremental.c b/Incremental.c
index 91301eb5e609..baea9761cee1 100644
=2D-- a/Incremental.c
+++ b/Incremental.c
@@ -870,7 +870,7 @@ static int array_try_spare(char *devname, int *dfdp, st=
ruct dev_policy *pol,
 		struct supertype *st2;
 		struct domainlist *dl =3D NULL;
 		struct mdinfo *sra;
=2D		unsigned long long devsize;
+		unsigned long long devsize, freesize =3D 0;
 		struct spare_criteria sc =3D {0, 0};
=20
 		if (is_subarray(mp->metadata))
@@ -942,10 +942,13 @@ static int array_try_spare(char *devname, int *dfdp, =
struct dev_policy *pol,
 			close(mdfd);
 		}
 		if ((sra->component_size > 0 &&
=2D		     st2->ss->avail_size(st2, devsize,
=2D					 sra->devs ? sra->devs->data_offset :
=2D					 INVALID_SECTORS) <
=2D		     sra->component_size) ||
+		     st2->ss->validate_geometry(st2, sra->array.level, sra->array.layout,
+						sra->array.raid_disks, &sra->array.chunk_size,
+						sra->component_size,
+						sra->devs ? sra->devs->data_offset : INVALID_SECTORS,
+						devname, &freesize, sra->consistency_policy,
+						0) &&
+		     freesize < sra->component_size) ||
 		    (sra->component_size =3D=3D 0 && devsize < sc.min_size)) {
 			if (verbose > 1)
 				pr_err("not adding %s to %s as it is too small\n",

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlntT/cACgkQOeye3VZi
gbnngRAAk50KglK64ThpzsLzD03h9UnHIQJeIWcjeD0WEpWzBd993m9pz42YCSzd
Ij0VjNf8nvtk+WaaV93zjaWcENuJsm2SuZcwq7X1ayVKdu3NDuVMRW8pROy/PWCb
fVvgGSF9d1dVHmUzLYKtvG2LKjPhyBV2RnpyIHr7+cMfqhm4churcAqbquxwEXjI
pm2RBpZmU8qXtoAQTl0CVuNVv7Vc+Qnb1d8Uyy9tX+gY2dhADssMCZK/gbQ8KL/E
nIh2t+KXVbQbcXideby0EYmmHDoYtZyM7bKwi/kw6UMktGgijbFS8F7oLfmMxYYn
8A2dHvNZ6xNBy7+Ch+qBDSd6tmU8RqVS5Jiu1aWH3xBFLyBKAYuoUPmMCLP5Sh2N
2y6eOIrwxfZZr08hGOAfpq40VkknFdGYHRdHMWeZWb8VfuhQV/4liUy9M3/Nvi00
so3tCbujla8o55jLWrc79NxZDB/jAUbxt1J9Do/wIZO9TAmRW5vYvgn5fC8HOabX
WWXBR12ZEAwUKdfPhNEPOIPbvyRiVyeKuClMzNzBi5Nh1Y+JFTRrHQioKNhSukcg
AE3XESSlRrLpxUhZf9yDYxDpTGQ8pEFw68GlOKxkWNafwtVHcLJUDOFg6KnZXlgX
bAugy4/RqJa1cgH0CA5X1aXRMgiX1HQEtGCMXILcli01kdI3p5M=
=vgOE
-----END PGP SIGNATURE-----
--=-=-=--
