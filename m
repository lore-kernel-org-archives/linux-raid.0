From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/2] Fix sign extension of bitmap_offset in super1.c
Date: Thu, 26 Apr 2012 11:18:35 -0400
Message-ID: <4F99674B.7070900@redhat.com>
References: <1335453177-8515-1-git-send-email-Jes.Sorensen@redhat.com> <1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig466ED570CB4BF786FF6EFE37"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1335453177-8515-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, joe.lawrence@stratus.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig466ED570CB4BF786FF6EFE37
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/26/2012 11:12 AM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> fbdef49811c9e2b54e2064d9af68cfffa77c6e77 incorrectly tried to fix sign
> extension of the bitmap offset. However mdinfo->bitmap_offset is a u32
> and needs to be converted to a 32 bit signed integer before the sign
> extension.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

I was scratching my head over this patch, saying to myself "But won't
that cause us to truncate large values of bitmap_offset?"  And it will,
but I see your point now, that's *exactly* the problem if we don't do
the sign conversion before the extension, the actual bitmap_offset
should really be signed in order to support negative offsets, but since
it isn't, when we save a negative offset into bitmap_offset it appears
as a really large positive offset, and then when we sign extend to long,
it keeps the large size positive offset instead of picking up the
negative offset.  Gotcha.  So, I see why this works, but do you think it
should be fixed this way, or by converting bitmap_offset to type int32
instead of uint32?

> ---
>  super1.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/super1.c b/super1.c
> index 36369d8..be77c33 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -620,7 +620,7 @@ static void getinfo_super1(struct supertype *st, st=
ruct mdinfo *info, char *map)
>  	info->data_offset =3D __le64_to_cpu(sb->data_offset);
>  	info->component_size =3D __le64_to_cpu(sb->size);
>  	if (sb->feature_map & __le32_to_cpu(MD_FEATURE_BITMAP_OFFSET))
> -		info->bitmap_offset =3D (long)__le32_to_cpu(sb->bitmap_offset);
> +		info->bitmap_offset =3D (int32_t)__le32_to_cpu(sb->bitmap_offset);
> =20
>  	info->disk.major =3D 0;
>  	info->disk.minor =3D 0;
> @@ -1651,7 +1651,7 @@ add_internal_bitmap1(struct supertype *st,
>  		offset =3D -room;
>  	}
> =20
> -	sb->bitmap_offset =3D (long)__cpu_to_le32(offset);
> +	sb->bitmap_offset =3D (int32_t)__cpu_to_le32(offset);
> =20
>  	sb->feature_map =3D __cpu_to_le32(__le32_to_cpu(sb->feature_map)
>  					| MD_FEATURE_BITMAP_OFFSET);


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig466ED570CB4BF786FF6EFE37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPmWdLAAoJELgmozMOVy/dqhwP/3It4wgLRRaQ/sWjzeXkzw59
03Ji4i/FZL15+tQiCfi1fjBcroG9p8RESJHdxwAW0aHe9u5pJKFE0YZ3rUhokTkf
AUa+sJi4VUXV7gnvyjqazvPMnCcEUxuZja/ZJYAGgeeVRc+MFQkRoqmdWyfTLhMB
sp9TO6DrRvwi28O31bQO48nPe5AEmxXcQK1iqM2FMhc2Al2Fq50zTQxjaC5Sodus
xAPzeNQ5Fp6fmM1h+PuDvi4696qqMXPA+md7X0Zs6plLiTQM1QGVHS3qaA3c7osi
M2hqG9XHlg8TZmU+R+dZH758iGTX+UGIUO2civqfjNm6UetoEAb/+b0g6oro7NWc
WqxKvnady8xzt/PiTc5S4etNr+ztgW18xDMUssRjYmpNd/MYQocT6z6+XQO0/jeg
5wg4yFGfVAj+ZcOvsO2dYBsgaXMFxMhxfnb5OZ3U7z78o6qtfglNhpDjUYVDDLpf
i11BnpjwBddz5w8jMUQTHF/pUs5JvV8sg2aL6dLtXBwsXve7XzEs+xNZtisya9Sg
chTKALmtewAF938kAw8e7OL+6y+wzZBVD9GUNw2NJG1idaJZJareVi134aOXq4hc
FSdjgMdjHH58bWaqpBwIiIOKVi1f3DFBEYl5gtW7IBL7a/pcaasANPU3fYDwocFd
4UaLr1GAHKHOGZb1C7ic
=lLgH
-----END PGP SIGNATURE-----

--------------enig466ED570CB4BF786FF6EFE37--
