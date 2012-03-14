From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5:Fix recover/replace stop if handle stipe failed
Date: Wed, 14 Mar 2012 18:33:44 +1100
Message-ID: <20120314183344.1cf93d44@notabene.brown>
References: <201203141507458909278@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mbUmD4GiRm+DpHk8dGy6BhM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203141507458909278@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/mbUmD4GiRm+DpHk8dGy6BhM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Mar 2012 15:07:55 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 849df9f6422972452b99a2c2d08d005437a52d72 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 14 Mar 2012 14:41:07 +0800
> Subject: [PATCH] md/raid5:Fix recover/replace stop if handle stipe failed=
.=20
>  If handled stipe failed when recover/replace,should not first
>  call md_done_sync(conf->mddev, STRIPE_SECTORS, 0).Beacause
>  this set MD_RECOVERY_INTR and will terminate the
>  recover/replace. And the sync_thread will repeatly start
>  and stop.

I disagree.  It is safer to stop and then (if all seems to be working) to
start again.  We will start up exactly were we left of so there is little
cost, and I think it make the code safer.


>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 360f2b9..55193ef 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2472,7 +2472,6 @@ handle_failed_sync(struct r5conf *conf, struct stri=
pe_head *sh,
>  	int abort =3D 0;
>  	int i;
> =20
> -	md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
>  	clear_bit(STRIPE_SYNCING, &sh->state);
>  	s->syncing =3D 0;
>  	s->replacing =3D 0;
> @@ -2480,8 +2479,12 @@ handle_failed_sync(struct r5conf *conf, struct str=
ipe_head *sh,
>  	 * For recover/replace we need to record a bad block on all
>  	 * non-sync devices, or abort the recovery
>  	 */
> -	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery))
> +	if (!test_bit(MD_RECOVERY_RECOVER, &conf->mddev->recovery)) {
> +		md_done_sync(conf->mddev, STRIPE_SECTORS, 0);
>  		return;
> +	} else
> +		md_done_sync(conf->mddev, STRIPE_SECTORS, 1);
> +
>  	/* During recovery devices cannot be removed, so locking and
>  	 * refcounting of rdevs is not needed
>  	 */
> @@ -2504,6 +2507,7 @@ handle_failed_sync(struct r5conf *conf, struct stri=
pe_head *sh,
>  	if (abort) {
>  		conf->recovery_disabled =3D conf->mddev->recovery_disabled;
>  		set_bit(MD_RECOVERY_INTR, &conf->mddev->recovery);
> +		md_wakeup_thread(conf->mddev->thread);

This change seems unrelated to the above changes.

It isn't needed as this function is called only by the thread that you are
waking up, so it cannot be asleep.

Thanks,
NeilBrown



>  	}
>  }
> =20


--Sig_/mbUmD4GiRm+DpHk8dGy6BhM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2BJ2Dnsnt1WYoG5AQKIog//ahSgCvLTMSEnG2E4r9BXCwFUpdSxqylI
R7qG7VRAMl9amtE/kamQAr/p6DWpFn53LBIC3xoByk9VdD+5IlK/AFANVozWUo9U
hlWNbXvyi3DOffAWePwRNS7ICRflrT0hG3pfH3AZoQp4i7h30hLlxhF4xRg+vIU3
4746Fwko7S0iJ51ytyJ0oEhuueRPK0A3wdeOqh1p8G09hBwQa2Kw5fv5fyewpQtn
T0iTOFKu/zO0xJVqxkbbzRWmxd9dp0CvqfvoTR1ozf8cfix3QivE3dUbvGbcMBKe
JKrO+m7Z64JpkJ95OTehpR79p6yqc/H4CdpYrI/2RtPq6+okt55Snm7XwdfveI8/
Ph92d5PI0MOd26kqcVdzwSeYb1CpWO1R4b7IgcckdpTBEOaaP5lrQ586QqytgWSC
VNhSCOThfGSB62EjV0sgctZvg06q4Y1eRkZ7NdkTnRTXJkhNP+4zANr50l6RvOu9
X7MWMMsmz3/tnx9Fro7SRawTR6Bvqv8zd9oFpvgE7438oHB8m9yeAJKbqsJOtPIr
qVyOhSAogAaeWvZhYzj+2bDa6EZ5qImxPFlwLWfzQ4eSO9UEk8BJ0ab6qODMPi8p
uXgPCdY7DBZRUwdv7QA2pMz6slsY9zdLGNXQ2jdMqG+/Z8F8vgu6NuGOcWHFHrDJ
z6890h1xWds=
=enBR
-----END PGP SIGNATURE-----

--Sig_/mbUmD4GiRm+DpHk8dGy6BhM--
