From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Forbid merging with partially assembled IMSM array
Date: Mon, 2 Jun 2014 12:19:55 +1000
Message-ID: <20140602121955.10a72b32@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qrb85J1JFKhsboA6=wzP.1Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/qrb85J1JFKhsboA6=wzP.1Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 May 2014 13:11:43 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Changes introduced in commit:
> 0431869cec4c673309d9aa30a2df4b778bc0bd24
> enabled adding devices to partially assembled array.
> It causes assemble process to override checking controller of device.
>=20
> For example:
> If ones created IMSM array will be stopped, and some disks will be
> attached to different controller, mdadm will allow to fully assemble this
> array as one md device (due to marge one part to another).
>=20
> This patch resolve this problem by forbidding merge operation
> on arrays with IMSM metadata.

Why do you think this is a good thing?
You seem to be saying "You cannot access that data  because I don't like
which controllers you have attached it to".

My thought is that you should provide access to data whenever possible.

Is there some important situation where the current behaviour will cause re=
al
problems?

Maybe a warning might be appropriate, but failure doesn't seem sensible...

NeilBrown

>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>=20
> ---
> Assemble.c | 23 +++++++++++++++++++++++
> 1 file changed, 23 insertions(+)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index a57d384..9fb65e5 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1329,6 +1329,29 @@ try_again:
>                                                return 1;
>                                }
>                                for (dv =3D pre_exist->devs; dv; dv =3D dv=
->next) {
> +                                             if (strncmp(mp->metadata, "=
imsm", 4) =3D=3D 0 && !c->force) {
> +                                                             int dfd;
> +                                                             char dn[20];
> +                                                             struct supe=
rtype *st2;
> +                                                             sprintf(dn,=
 "%d:%d", dv->disk.major,
> +                                                                        =
                     dv->disk.minor);
> +                                                             st2 =3D dup=
_super(st);
> +                                                             dfd =3D dev=
_open(dn, O_RDONLY);
> +                                                             if ((dfd > =
0) && (st2->ss->load_super(st2, dfd, NULL) ||
> +                                                                  (st->s=
s->compare_super(st, st2) !=3D 0))) {
> +                                                                        =
     pr_err("IMSM metadata mismatch!\n");
> +                                                                        =
     pr_err("Aborting...\n");
> +                                                                        =
     close(dfd);
> +                                                             } else {
> +                                                                        =
     pr_err("IMSM Array already partially assembled!\n");
> +                                                                        =
     pr_err("Aborting...\n");
> +                                                             }
> +                                                             if (st2) {
> +                                                                        =
     st2->ss->free_super(st2);
> +                                                                        =
     free(st2);
> +                                                             }
> +                                                             return 1;
> +                                             }
>                                                /* We want to add this dev=
ice to our list,
>                                                 * but it could already be=
 there if "mdadm -I"
>                                                 * started *after* we chec=
ked for O_EXCL.
> --
> 1.9.0


--Sig_/qrb85J1JFKhsboA6=wzP.1Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4vfSznsnt1WYoG5AQLxrBAAiIJINm0XwAD+FNecY6ZP4HmyVlwhZk7O
grjVmIHQkMj9L7LoDEGBoZ79/eA0HfKZlYDhmoaERqOosqbawCPT3iwmmfUpngQY
m7bCUlht1w7HZg9CIcrVcx1yOMIQ5t045bG5V/RLbjMXls3taB0RdFHQXOgNguEv
PqL2vDxckjg0iJmtNmJPHyZZcklbSlHrLqI9GRXhCMWOoDCcEsRYLjPZ9qPAO1si
RQf5X+63rbwOUO6GT8JcQGViv73eASWyK56BKQu9T53GOYJevbsr5TRk18orpXFG
9EuT+WNHmWke/tC73btFdiyLoADu7XV0TTUO8+FE8Gbm0uUE4UiwLr3fZz8SrhXf
ybsTvcAiuXW3aFhMF8hFHN3REwgFQ7WG+pa+lOPFr5T6ZvOA+oqO+vV6c98QaFoI
j4jeDewFOMeW5TGjsJGeVmEVyPJPJ6AuIfdbFqQWsKIf/txk9ehcUAkUO1IiSCxb
eMcXHOh5HZj08oKIVzFLHvXZ5HxrXiQ42YA0PhRNngq6yUPOA39al/IxLftkLJPL
4y1EN/g4rM8JpP0YeeLOB8kW3XpOz5zsAlTpIzN83X9WC+dWdqvhaK5ch++2QLAc
xCF99j+zaYhx2jeYG8j44WqOEl9tZva4dO3C8aF3GrASt/GMO/euzRY8la0l0+yA
QCFkKyaoqxA=
=azld
-----END PGP SIGNATURE-----

--Sig_/qrb85J1JFKhsboA6=wzP.1Z--
