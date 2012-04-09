From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: do not read the 'clean' flag from potentially
 non-up-to-date drive
Date: Tue, 10 Apr 2012 09:54:59 +1000
Message-ID: <20120410095459.4799c6f4@notabene.brown>
References: <CAGRgLy5=xP3ZJz71j2qYiCFLFFD6uCH0O92p3Ev2s2GnonRc8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ABkvk8C0IC0+6IrUbpdAncO"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5=xP3ZJz71j2qYiCFLFFD6uCH0O92p3Ev2s2GnonRc8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/ABkvk8C0IC0+6IrUbpdAncO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Apr 2012 15:24:22 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> I noticed that mdadm may decide that array is dirty, based on the
> non-freshest drive. This happens, e.g., when there is a drive failure
> during initial resync, and then array is stopped and re-assembled. The
> failed drive still has a valid sb->resync_offset, so if this drive is
> visible during assembly, array will be considered dirty, even though
> the rest of the drives have sb->resync_offset=3D=3DMaxSector.
>=20
> Do you think array should be considered as dirty in this case? Because
> if the failed drive was not visible during assembly, array would have
> been considered clean.
>=20
> The below patch is only to demonstrate the possible fix. The idea is
> that we decide that array is dirty only according to up-to-date
> drives. Currently the "clean" flag is initialized from the first
> superblock, which might not be the freshest one.
>=20
> I haven't tested it at all. If you think the direction is reasonable,
> I will test.

Yes, that does seem reasonable.
If nothing surprising shows up in testing I'll be happy to apply it.

Thanks,
NeilBrown


>=20
> Thanks,
>   Alex.
>=20
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 23695e7..42cbbd5 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -929,7 +929,6 @@ int Assemble(struct supertype *st, char *mddev,
>                 st->minor_version =3D 90;
>=20
>         st->ss->getinfo_super(st, content, NULL);
> -       clean =3D content->array.state & 1;
>=20
>         /* now we have some devices that might be suitable.
>          * I wonder how many
> @@ -1122,6 +1121,7 @@ int Assemble(struct supertype *st, char *mddev,
>  #ifndef MDASSEMBLE
>         sysfs_init(content, mdfd, 0);
>  #endif
> +       clean =3D 1; /* Assume that array is clean, until we see otherwis=
e */
>         for (i=3D0; i<bestcnt; i++) {
>                 int j =3D best[i];
>                 unsigned int desired_state;


--Sig_/ABkvk8C0IC0+6IrUbpdAncO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4N20znsnt1WYoG5AQKQxg//Yjx3/X6iTOyZeFK4AZSdHcFNsHA/CHE0
+ESgU9JPAQ64IM6DUpkMli7Uqyw0LrBrGIaA5p8wJxbjUANRBbNqY3yVuXy3k4QG
87ZAahH4Y2dt94to9Ik5Px97dhxGuJ9xjMKDom7DAOCQ3RuiT+E5HvfDnJLeMrhs
H3DYhru0/nZvLK76C63BWAJoh6Wv3CfEnVrJGKzhN/DtkrqRXkchrCBjtA4Y5drW
btlEHoPuksd15e+E4Um9dRNLL28UPd+Lb82QBmj1Hg39lxSC4HzQh0PmTRDZxl9o
wIdfDLOZJd+zN4TDsC0mR+qJp/QFQIf/MjjGxySYpP4guKhecLPaAsaoZVlbv+YC
3zi56vdVKbUv5EkzT4LIkMErAJUiKHHkFhs1TvWCkzua4dd8Hes7QZj23xKgMud4
q92lWIo07g87QMIggWh5B2J3b9uHctGL1ZmpbbfTBJXEav1zpCM5P/U+0zkyIbnK
K643WSy7rTP/fK57WQ14eO6g0KBoQrkCpNuzFn8RRFR72JtOXtpUmEJL6cx3JNI7
LhN25xWqL1Sw0wQNjpjQ8fbZ8Qvp457YX/13t05DKeIQcSOJeCEmcPdGNkzI92kE
T+8p4zszixOp9P4KShR7+aQBYaY6Vn61VPn1OH4/t/UUZC0sHURL2Nv4sMYfPk1O
M7TWDomKf1s=
=0/06
-----END PGP SIGNATURE-----

--Sig_/ABkvk8C0IC0+6IrUbpdAncO--
