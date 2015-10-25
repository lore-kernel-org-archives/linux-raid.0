From: Neil Brown <neilb@suse.de>
Subject: Re: Fwd: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
Date: Mon, 26 Oct 2015 05:21:36 +0900
Message-ID: <877fmag0mn.fsf@notabene.neil.brown.name>
References: <1445751362-15677-1-git-send-email-xni@redhat.com> <284284227.42321345.1445751531086.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <284284227.42321345.1445751531086.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Xiao Ni <xni@redhat.com> writes:

> Hi Neil
>
> I encountered one problem. When reshape one raid1 with bitmap to raid0, i=
t'll
> lose legs.
>
> I sent the patch by git-send-email, but I can't see the mail in linux-rai=
d. So
> I forward it again. And add signed-off-by line.
>
> Best Regards
> Xiao
>
> ----- Forwarded Message -----
> From: "Xiao Ni" <xni@redhat.com>
> To: xni@redhat.com
> Sent: Sunday, October 25, 2015 1:36:02 PM
> Subject: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
>
> One raid1 with bitmap is composed by 4 disks. It'll fail when rashape to =
raid0
> and lose 3 disks. It should check bitmap first when reshape raid1 to raid=
0.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Grow.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 80d7b22..5e9b0bb 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1898,6 +1898,12 @@ size_change_error:
>  	     array.layout =3D=3D ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
>  	    (s->level =3D=3D 0 && array.level =3D=3D 1 && sra)) {
>  		int err;
> +
> +		if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
> +			cont_err("Bitmap must be removed before level can be changed\n");
> +			rv =3D 1;
> +			goto release;
> +		}
>  		err =3D remove_disks_for_takeover(st, sra, array.layout);
>  		if (err) {
>  			dprintf("Array cannot be reshaped\n");
> @@ -2706,9 +2712,6 @@ static int impose_level(int fd, int level, char *de=
vname, int verbose)
>  			err =3D errno;
>  			pr_err("%s: could not set level to %s\n",
>  				devname, c);
> -			if (err =3D=3D EBUSY &&
> -			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
> -				cont_err("Bitmap must be removed before level can be changed\n");
>  			return err;
>  		}
>  		if (verbose >=3D 0)
> --=20

You appear to have identified a problem that needs fixing, but the
patch is fairly obviously wrong.

You've removed a test and error message that could apply to any level
change, and added a test and error message that only applies to some
specific level changes.
Why does that error message no longer apply to all the other possible
level changes?

The test that you have added is mostly OK ... but you missed something.
Look around and similar nearby code.
The test you removed certainly should stay.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWLTnQAAoJEDnsnt1WYoG5MdQP/j5Lo8zuNtYd5R6SamKCjhNC
V5wju/Mv6K55Hat08axk3P9mafsIo9WSUw6uDl8YjC6jNBsOI8Et4iTRAFTE+35W
VpDJrNVo8JXN/o/1UURS8svSu9Bi5jnx9Xs1u82W31jzfOVd/+jWrMbZBFh4GZXk
1EJHxZeqwpk2UkyYIYE+3lxNMNQpSsv4sZ/3hjjIM/6wohsqlF6weRt6uY2+vI6v
qF1oDgt/S6tYWBw+Fu7YZkVTtFTTF4frUflB3sIm2KODefiYXvFz6gqQWGmjUKQJ
ty97GAYfVvcdbqXZHLJUxVE7VTjyRTFYlWAF02ckVPnsKYF/2oNInc1BCo/kpDpT
OHpQh2MugOLrbo5fiJSx8CL5nemAx+YLU4GRt4vVARQWq7eSdVC9vPz+8Zl6JrmK
G1Cywi3E6R3/Abv9vKnr9FCGHPMC/7JsdXBh2XShQRhFUDFp0qYh23wEiZUNnPus
B+yKpJuf7G6U+lfeZV4KIUOL23Fhi1wzKi9M3ip9569rLmPjSEWAqAiTvWrmcZq1
I7mZPzJgr9d85g7DycZ8/QR0i/NDTuse+KwMRDPZ9BRNQ0oo268PE5cawTeYURRo
1/t+B8wcqS3nx+WKTP0OHFVe9EMnO+7d7CcOV7+GoUZkl7Rn8IIey/RUq2M85NEU
EknHZbApDx7mJqSDig19
=vcof
-----END PGP SIGNATURE-----
--=-=-=--
