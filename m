From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 5/5] md/raid5: Using conf->max_degraded rather than 2 to
 determine whether there is excess compute-disks for raid4/5/6.
Date: Mon, 29 Oct 2012 08:45:51 +1100
Message-ID: <20121029084551.16188427@notabene.brown>
References: <201210271028214347208@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8Sg3L3MNJTjNZoACf2G5D8m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210271028214347208@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8Sg3L3MNJTjNZoACf2G5D8m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Oct 2012 10:28:25 +0800 majianpeng <majianpeng@gmail.com> wrote:

> In func analyse_stripe, about judging how many want-computer disks,it
> used 2.But for raid4/5, it is at most is one.So using conf->max_degraded
> to replace.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid5.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 684ca76..930dee0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3285,7 +3285,7 @@ static void analyse_stripe(struct stripe_head *sh, =
struct stripe_head_state *s)
>  			s->uptodate++;
>  		if (test_bit(R5_Wantcompute, &dev->flags)) {
>  			s->compute++;
> -			BUG_ON(s->compute > 2);
> +			BUG_ON(s->compute > conf->max_degraded);
>  		}
> =20
>  		if (test_bit(R5_Wantfill, &dev->flags))

If I were to bother changing that code at all, I'd just remove the BUG_ON.
But I won't bother.

NeilBrown

--Sig_/8Sg3L3MNJTjNZoACf2G5D8m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI2njznsnt1WYoG5AQJ4mA/6A1tOVP1jANcrz1FHBFFHIXAJpLJKKA7f
AIbgBP9PwdaNA+eYaB2nodgHSDHgoWNo9zfr4asAiswsgh2zT5NGJAiU/Z2ocg2e
a++CGB0lOMrs+iefFmNI2DHQZTasOpQTezA6Trivtde1R2QLqrHFQynk6+KcwO+0
C5N/ChmzLtRKmVaHy+SLZXpUXwDLAfAYJ3JHf5NtPfK0O4l7ZO75bIggFm/Z4mAA
6RnpX+QEGa1ybZPIVvHQaR+Lkfykk1oiHNU/Kgius/4RfDegIqHf0aunCIaYf0cn
huYI0dlB4CL87aVslckCVrNRiUPDs51msWm5ZZ6FjgEleHjTJy0XRLXBXMCup1+r
Rnoi/wTg0iPffRaobo5FaJK5Aqce402HTZXR64O5Iew0CKOPiBFSSw7xPv47wn0W
ny8bFxQX+TPNX55JwFcr/dDS7qOvBSI8Y2X7IG1bUx1+W3pdyNm40UAx9rbtijPD
N9oTPDplqfInS62Ca885MHBmsAdcqxNr7Mm2DDLrMDw3rM+P2AjuFBkAkmf9MfDr
WFjo+1X30otxOezrMup+BGqtnh1ZR8L2sU2/QFy2+e01zb7CySFHxtMCfh5FPV1e
hAhJ+3pWDz6WayM6zeQfPLhLNnZzhB1XLwnBg7cn5t+AdlF4dOBkC7DQxNAwQvCc
jxUX39vaiMk=
=5iWq
-----END PGP SIGNATURE-----

--Sig_/8Sg3L3MNJTjNZoACf2G5D8m--
