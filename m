From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 3/3] md/raid5: per hash value and exclusive
 wait_for_stripe
Date: Thu, 14 May 2015 15:45:11 +1000
Message-ID: <20150514154511.26b74f5b@notabene.brown>
References: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1430275735-20290-3-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Gz/dqPYAL==Fwrlljr_XLtp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430275735-20290-3-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Gz/dqPYAL==Fwrlljr_XLtp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2015 10:48:55 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 64d5bea..697d77a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -344,7 +344,8 @@ static void release_inactive_stripe_list(struct r5con=
f *conf,
>  					 int hash)
>  {
>  	int size;
> -	bool do_wakeup =3D false;
> +	unsigned long do_wakeup =3D 0;
> +	int i =3D 0;
>  	unsigned long flags;
> =20
>  	if (hash =3D=3D NR_STRIPE_HASH_LOCKS) {
> @@ -365,15 +366,19 @@ static void release_inactive_stripe_list(struct r5c=
onf *conf,
>  			    !list_empty(list))
>  				atomic_dec(&conf->empty_inactive_list_nr);
>  			list_splice_tail_init(list, conf->inactive_list + hash);
> -			do_wakeup =3D true;
> +			do_wakeup |=3D 1 << (size - 1);
>  			spin_unlock_irqrestore(conf->hash_locks + hash, flags);
>  		}
>  		size--;
>  		hash--;
>  	}
> =20
> +	for (i =3D 0; i < NR_STRIPE_HASH_LOCKS; i++) {
> +		if (do_wakeup & (1 << i))
> +			wake_up(&conf->wait_for_stripe[i]);
> +	}
> +

hi,
 I've been doing some testing and got a lock-up in resize_stripes, waiting
 on wait_for_stripe[].

 Looking at the above code,  I think
      do_wakeup |=3D 1 << (size - 1);
 should be
      do_wakeup |=3D 1 << hash;

 do you agree?  Or am I missing something?

Thanks,
NeilBrown


--Sig_/Gz/dqPYAL==Fwrlljr_XLtp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVVQ2Zznsnt1WYoG5AQKjdg//RNsjtohaqrRBjjkAY/7tFqZST4ndQINp
DgYKNTq7K7w6D8NLgeyWI3il5Eb9WFNRWoxEru5DWq37qcx+dbishNnL7x62pMwj
5dzaNwjFJQotw/Bqaz3+/egjW4UoAoRFEB2AKn9+BSMTfpw4oSfa3LnhGcJ9FzBT
ryGAsnQHwWmLDRasNW3et+anbqdZvZIIBnK6mPXfAmNHUQkoFfJ4C46nBo5qNXUF
zvNdIoVAEhdKKu6o22oklQxSkbU/w335JoZx1Z687KSkGkZODsZbU+8R+Wtek80R
Hx4nSvz0LXTAa8dpAWq3EgOh6jYl+Ef+rKnYCnCiCRLj3rvaGrldrCCGIoz6hRUT
WwVLqYU3nZg/6lkVNVhV31UD0Wdu6Njx4AfIOQoxYQewb9PzGv4c5Nim/kLS8uBB
t8aFhbBdh1/QemqM+r/jOxeyj4MLDmx1ZO4Ev3b5rwpcMxQVCRoHENjRxdyNKzOF
07dvFFWljJZEztYFt+cDRGjiRLt/jJ9bIzfqNYP7IFl5gCn62CoN2dxQh0SKMJsF
R4yMEK0x7XWA0YpE4PIUc68jmTKOt+a3H6kG76k4cfDg2gTniIYypbHTRfDscf8t
rT5kkLzomQIntXOdtIwoiRbu1rDQRmwnVkXef8mTenWIaNU5N4pIw3QWo1mGdyLM
f45CA59naVA=
=JR/F
-----END PGP SIGNATURE-----

--Sig_/Gz/dqPYAL==Fwrlljr_XLtp--
