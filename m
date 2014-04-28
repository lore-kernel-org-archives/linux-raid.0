From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Create: don't default to bitmap=internal when it is not
 supported
Date: Mon, 28 Apr 2014 14:19:22 +1000
Message-ID: <20140428141922.02c361eb@notabene.brown>
References: <1397548904-31199-1-git-send-email-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jQZ7kjsrt=14/=oxV/t2/qU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1397548904-31199-1-git-send-email-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/jQZ7kjsrt=14/=oxV/t2/qU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Apr 2014 10:01:44 +0200 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> For large arrays (component size > 100GB) if write-intent bitmap is not
> enabled, then it is set by default to "internal", even if the metadata
> format does support internal bitmaps, which causes Create to fail.
>=20
> This patch adds checking if add_internal_bitmap is set in the
> superswitch before setting bitmap_file to "internal".
>=20
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  Create.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/Create.c b/Create.c
> index e42627c..602f79c 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -509,6 +509,7 @@ int Create(struct supertype *st, char *mddev,
> =20
>  	if (!s->bitmap_file &&
>  	    s->level >=3D 1 &&
> +	    st->ss->add_internal_bitmap &&
>  	    (s->write_behind || s->size > 100*1024*1024ULL)) {
>  		if (c->verbose > 0)
>  			pr_err("automatically enabling write-intent bitmap on large array\n");

Applied (at last:-)

Thanks,
NeilBrown

--Sig_/jQZ7kjsrt=14/=oxV/t2/qU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU13Wyjnsnt1WYoG5AQJu8w/7BtUqZI3DrKFRmU79XxR4kO142dbapk0u
SrgGvt5uPHtAm3XivRaqsuXSUp8a+qbp3D025qVrs//Hif6Cy24P84D4q1P4Mq0b
vPWdQRpqdlS8DB4YDD8rQOjGcm+QbLb/CkNl4wd89RZof3nDDJx9iKWybW+PuoLP
Lladp0SJGqjQlXGJmHt0nL7PJ3hgct9HpIBYO6BqIEmZt6P0xBjF2N+/ZYRGqPjK
63Y0psC9QPHL/WJoDSFLRYu+qV2KT81mxFUOSSdMaYoXyIoi7/JBvTCpnLEdkN9b
9YyilRTU3Ns/6w/SIPe4MeAP96OpVKlpAftPji59J72MNzCZLjx2/9SiARiIYDA8
wP6p7tQtZMFwoHxWV+k00f4uQKMEtX4LFJbIzp9BwQN25ckXvlTwLP2IxXeAbrUU
U5LMbjZd6KA+O7DrAa15Uxt5/we1DUAgmJWwUJJt8+LIgZ92Iblr+vtxD4BwdoEe
36V05+DV8UHoGaSbTZKlqRICzlFZeT4H2w3qmB352U3HLyvoovpHnYUVfQzrbIw4
QBhQXE6xchYaIt1NTgH/hmSwfC8LPcSh6ZVoLX5RF3ufKhg+SGX/2o2SNZKmtP1D
oFSyq8Af3IrF/TtRERvzMg+4xSqkIqKby651/NuM3xT6K+pqUheqpTKHPQKifWw2
edMrrD84YRo=
=yh04
-----END PGP SIGNATURE-----

--Sig_/jQZ7kjsrt=14/=oxV/t2/qU--
