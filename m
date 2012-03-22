From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 1/1] Avoid OOPS when reshaping raid1 to raid0
Date: Thu, 22 Mar 2012 12:19:29 -0400
Message-ID: <4F6B5111.7030905@redhat.com>
References: <1332432953-30091-1-git-send-email-Jes.Sorensen@redhat.com> <1332432953-30091-2-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1BD97E9D1630B18EE8F7D09E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332432953-30091-2-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1BD97E9D1630B18EE8F7D09E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/22/2012 12:15 PM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> raid1 arrays do not have the notion of chunk size. Set the existing
> chunk size of the new raid0 to the same as the proposed new chunk size
> to avoid a divide by zero OOPS when aligning the size of the new array
> to that of the chunk size.
>=20
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/md/raid0.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 6f31f55..dff8d6b 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -639,6 +639,14 @@ static void *raid0_takeover_raid1(struct mddev *md=
dev)
>  	mddev->new_level =3D 0;
>  	mddev->new_layout =3D 0;
>  	mddev->new_chunk_sectors =3D 128; /* by default set chunk size to 64k=
 */
> +	mddev->chunk_sectors =3D 128;	/*
> +					 * a raid1 one doesn't have the
> +					 * notion of chunk size, so set
> +					 * existing chunk_sector to match the
> +					 * new size to avoid divide by zero
> +					 * when aligning the size of the new
> +					 * raid0 to the existing chunk size.
> +					 */
>  	mddev->delta_disks =3D 1 - mddev->raid_disks;
>  	mddev->raid_disks =3D 1;
>  	/* make sure it will be not marked as dirty */

Acked-by: Doug Ledford <dledford@redhat.com>

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enig1BD97E9D1630B18EE8F7D09E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPa1ERAAoJELgmozMOVy/dlfgP/0wpF1bNGuT5j+8LlS+wttQH
1NsLcovZlanWoh6/dou4bdEEYc4CiXNt9/Tr36MksNC9nfstZLl2/mYxaRenuamF
2FOrU49n9fnSbBJl/HCkbZnptDpuzbfenuI4SJGAXprVCADdrDD2qM3QJrnP9Uf8
cheBo+uihYt9ch9AGdDTjHU8RLkC1032UfjaoQkb/g/qNwlgMTwEhkSdpv1Xo4tY
LopPDmSlYm62nmiuYsIp/gvZBezWOe8kG8KEdZYGI/ZkyVQLdosKILdoT3GDddxa
Ic0Qmrvqc5+7iOQ9rWd54W4BXqTj4mbeRC9SRep3/awDyxAkjC869YmJiX+hZy4i
Q1b1Yp9a2rbuR6x2Y1aGt2g8YYdFCnCMUn6Bj9pVvaymGZIaQNM6yiGhat8OGh3Y
tIOurbZkbJmXsBdCS0VKYZUWn8vp/RdsFQBkp4uy37VCHWmDIcMwmN9SzVmFay0g
VHg3pP0zQtGjVPOYX1Kp/IZu5Wr3SAh6CdF/6MYk6obAP5RBGI1HlQB5lhx8fztC
/3hUDLnpd/5lly2xNrlKefq/cpfhaNC2NT5Qp1DlKHNq+rYyBihJPN2T9DM5wNH3
w8oxmcvSytX/tHBJyssDYyGjS2jrDvJeJLRaO1DkY9co8CGryuzM4EDp2vHuYUBA
D70H75c7AnyiHx2VR0zo
=jBFW
-----END PGP SIGNATURE-----

--------------enig1BD97E9D1630B18EE8F7D09E--
