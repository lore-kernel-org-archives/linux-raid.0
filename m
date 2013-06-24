From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] select_devices: fix scanning of container members
 with dev list
Date: Mon, 24 Jun 2013 16:55:47 +1000
Message-ID: <20130624165547.0c0bd93b@notabene.brown>
References: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/83M5ckWc9XSZMNYwT95R_IP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1371759665-5625-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/83M5ckWc9XSZMNYwT95R_IP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Jun 2013 22:21:04 +0200 mwilck@arcor.de wrote:

> commit b3908491 "Detail: fix --brief --verbose" introduced a
> problem when a mdadm.conf file generated with
> "mdadm --Detail --brief --verbose" is later scanned with
> "mdadm --Assemble --scan --config=3Dmdadm.conf"
>=20
> mdadm -Dbv will print a "devices" list now, but because the
> container device is not in that list, it won't be considered
> for assembly.
>=20
> This patch fixes that by moving the test for member devices
> further down, after the check for a container.
>=20
> Signed-off-by: Martin Wilck <mwilck@arcor.de>

Hi Martin,
 I really don't like this.  If there is a "device=3D" entry then it should =
not
 even open anything not listed.

 Can you give me more details about the problem you are experiencing?  Maybe
 the problem is in "mdadm -Dbv".

Thanks,
NeilBrown

> ---
>  Assemble.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index c927c20..1f023e8 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -170,13 +170,6 @@ static int select_devices(struct mddev_dev *devlist,
>  		if (tmpdev->used > 1)
>  			continue;
> =20
> -		if (ident->devices &&
> -		    !match_oneof(ident->devices, devname)) {
> -			if (report_mismatch)
> -				pr_err("%s is not one of %s\n", devname, ident->devices);
> -			continue;
> -		}
> -
>  		tst =3D dup_super(st);
> =20
>  		dfd =3D dev_open(devname, O_RDONLY);
> @@ -365,6 +358,14 @@ static int select_devices(struct mddev_dev *devlist,
>  			int rv =3D 0;
>  			struct mddev_ident *match;
> =20
> +			if (ident->devices &&
> +			    !match_oneof(ident->devices, devname)) {
> +				if (report_mismatch)
> +					pr_err("%s is not one of %s\n", devname,
> +					       ident->devices);
> +				goto loop;
> +			}
> +
>  			content =3D *contentp;
>  			tst->ss->getinfo_super(tst, content, NULL);
> =20


--Sig_/83M5ckWc9XSZMNYwT95R_IP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcftcznsnt1WYoG5AQICqRAAjrFTQ4zp94Of2RiuylCOh5zr1jyPpYqG
hH/UX+aJx+A2ZGVUBIkQBUK0xPnw/9SdgifXi4v9PPBPj54mJ9wjpP9+d6cBOf/j
2oSasnLL53dqH5TNfz5g7xRT3iX+5UeRy86NYnygDhgXZQvosSzSTk7ltbSUg+Hx
oAaY/pgwaK40iiGuHX6okq3FmvNfjsLadWs1tWX5LIAuAV0/ScjZG73a4GaW97tN
0kkVFBUzq2d2PMR2hmtLfLp3PAZCk1zJHLpiz++hfRkw63/tfYRwKxL9G28uZbVF
VmM958oJ41mhBC2ypoh0dMWSBsgIc7Kf28ejfVobCSRm58H4A2xmYUrL5qqgQY30
1sVekRcNAhA8NxWdkB7Kb1BmGwEmuUo0Vx6xPK7AyYPd/SJSc7e8Edb7KikO4qQN
HgKy4XMBe7qZKVEjM4rev7bSEXXEM7OphTHZpnCItbbKr3ZVwXqRy25+iwMDFcPa
lhrxP7FZ6U8AR8PzINWPp/AWL3RDgtTaeEVMGByZn7qhCtxg3Z8AacwrsGAWGO7p
crBxiS8jYRiVBjowWvsko1YkC+cp90lEoDpd0GY03JeYglBZDcv7B5S2D63V5t/H
2t6OnXaOblb8WceHGSuQX+a0BIc9fIin0Zr6rBsUHDBlh7Gj045MJXAoic/Vi77l
ovaqVv93IzI=
=URmF
-----END PGP SIGNATURE-----

--Sig_/83M5ckWc9XSZMNYwT95R_IP--
