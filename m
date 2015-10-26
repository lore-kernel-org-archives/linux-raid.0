From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
Date: Tue, 27 Oct 2015 08:10:17 +0900
Message-ID: <877fm9dy5i.fsf@notabene.neil.brown.name>
References: <1445751362-15677-1-git-send-email-xni@redhat.com> <284284227.42321345.1445751531086.JavaMail.zimbra@redhat.com> <877fmag0mn.fsf@notabene.neil.brown.name> <1424506067.42737315.1445862310535.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1424506067.42737315.1445862310535.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 26 2015, Xiao Ni wrote:

>>=20
>
> Thanks for printing out the mistake. I checked the nearby code and found=
=20
> I missed close the cfd. Is this I missed? But I'm wondering that it doesn=
't=20
> close it in the following code. Now it's just closed when it's failed to
> reshape raid1/raid10 to raid0.

That is a very sensible question to ask - thanks.
After a quick look - it does seem very strange.  That handling of 'cfd'
and 'fd' seems quite odd.

If you would like to work out what should happen and find a simple way
to fix the code, that would be great.  But I don't insist.

The patch below is quite acceptable as it is a simple solution to a
simple problem and appear consistent with nearby code.  So if you gave
it a proper description, formatted it properly and posted it in a way
that didn't mess up all the white space, I would very likely accept it.

However:
 - maybe we should just remove the bitmap rather than complain if we
   find one.  After all, we are removing other things (extra devices).
   A raid0 can never had a bitmap, so when converting to a raid0, it
   does make sense to remove the bitmap.

 - The test you used only checks for an internal bitmap, not an external
   one.  External bitmaps are hardly ever used except by people who know
   exactly what they are doing, so I'm not too fussed about handling
   them perfectly, but testing for and removing an external bitmap
   might make sense.

Thanks,
NeilBrown


>
>  Grow.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/Grow.c b/Grow.c
> index 80d7b22..d711884 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1898,6 +1898,15 @@ size_change_error:
>              array.layout =3D=3D ((1 << 8) + 2) && !(array.raid_disks & 1=
)) ||
>             (s->level =3D=3D 0 && array.level =3D=3D 1 && sra)) {
>                 int err;
> +=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> +               if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
> +                       dprintf("Bitmap must be removed before level can =
be changed\n");
> +                       if (cfd > -1)
> +                               close(cfd);
> +                       rv =3D 1;
> +                       goto release;
> +               }
> +
>                 err =3D remove_disks_for_takeover(st, sra, array.layout);
>
> Best Regards
> Xiao
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWLrLZAAoJEDnsnt1WYoG5Cm0QAJ/e0pNl6GzLV9XQIAtBfsk8
okm4PVD4VDIU4ThUAyo1IIZKW4QQSm6hc4GsSFdMG+78MNGc98Zr/g6V5PI8EGFg
n5lmK5jIkMCnKuzB3Ud1TpBZPmX+XZu7IAHOZVoA/Viku6wYwqJ/AB4OSKW7sNoZ
CWXIzynhCF56+Gu2avKy49UR9hKhJ2tejK0NL+S1SRrjYZyoG7f45KbEA2JaWFjO
AETjMzwC7jzNVb0O6UZ5w3CtJoV6BW71szf6NZ4XgZ3lj+Yl6Wwaf4dpFt1Umtzp
hpfjB+tDtLNJx4fNaQzu9i/Y89jZtwZ4XqhvjB4RK+6QC5IFRhUNT+SgGesj9NYr
fO+BmNPja49XPWx0SGq6w9f9V/JRe4wO3JdlgrD+3ninPMuqByyRbKskmNzVLrtT
aeGmCqeQ7nD4nAfxXgHrb0WYjngdbmYvunBRm8bPuwas1mLY9w54ivkQD7XjF91l
MsprEGmOW7/v37dLw4l9tyI9Z8cV5GCO+cRvaELfsjAMHqOA/asCdG8fmNWxwutA
JEE3ncxBz7V6uvWIJVPGIgE18+wzH527oGM5LHJ8+ompTgxEdDSgnTVemyYLj/1Q
Eiv4804aMsyN2mJGCHr5vcYkAKVlMrNnPB+nObD+ZVwxxlUmDE6hSSRBUeTsK+jm
sy45xGZtYkdIYdqoHw4F
=8hic
-----END PGP SIGNATURE-----
--=-=-=--
