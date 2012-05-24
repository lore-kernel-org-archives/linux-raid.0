From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/4] raid1: directly dispatch write request if no bitmap
Date: Thu, 24 May 2012 12:21:12 +1000
Message-ID: <20120524122112.05b4d6e3@notabene.brown>
References: <20120523072619.670179001@kernel.org>
	<20120523072829.967587288@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Su4hAPa/alD=fS60uNC2E./"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120523072829.967587288@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/Su4hAPa/alD=fS60uNC2E./
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 May 2012 15:26:20 +0800 Shaohua Li <shli@kernel.org> wrote:

> In raid1, all write requests are dispatched in raid1d thread. In fast sto=
rage,
> the raid1d thread is a bottleneck, because it dispatches request too slow=
. Also
> raid1d thread migrates freely, which makes request completion cpu not mat=
ch
> with submission cpu even driver/block layer has such capability. This will
> cause bad cache issue.
>=20
> If no bitmap, there is no point to queue bio to a thread and dispatch it =
in the
> thread. Directly dispatching bio doesn't impact correctness and removes a=
bove
> bottleneck.
>=20
> Multiple threads dispatch requests could potentially reduce request merge=
 and
> increase lock contention. For slow stroage, we just worry about request m=
erge.
> Caller of .make_request should already have correct block plug set, which=
 will
> take care of request merge and locking just like accessing raw device, so=
 we
> don't need worry about this too much.
>=20
> In a 4k randwrite test with a 2 disks setup, below patch can provide 20% =
~ 50%
> performance improvements depending on numa binding.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid1.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2012-05-22 13:50:26.989820654 +0800
> +++ linux/drivers/md/raid1.c	2012-05-22 13:56:46.117054559 +0800
> @@ -1187,10 +1187,13 @@ read_again:
>  		mbio->bi_private =3D r1_bio;
> =20
>  		atomic_inc(&r1_bio->remaining);
> -		spin_lock_irqsave(&conf->device_lock, flags);
> -		bio_list_add(&conf->pending_bio_list, mbio);
> -		conf->pending_count++;
> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		if (bitmap) {
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			bio_list_add(&conf->pending_bio_list, mbio);
> +			conf->pending_count++;
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
> +		} else
> +			generic_make_request(mbio);
>  	}
>  	/* Mustn't call r1_bio_write_done before this next test,
>  	 * as it could result in the bio being freed.

This looks like it should be 'obviously correct' but unfortunately it isn't.

If this raid1 is beneath a dm device (e.g. LVM), then generic_make_request
will queue the request internally and not actually start it.
In particular this means that the cloned bio has no chance of being released
before the next clone_bio call which is made on the next time around the lo=
op.

This can lead to a deadlock as the clone_bio() might be waiting for that
first cloned bio to be released (if memory is really tight).

i.e. when allocating multiple bios from a mempool, we need to arrange for
them to be submitted by a separate thread.

Thanks,
NeilBrown

--Sig_/Su4hAPa/alD=fS60uNC2E./
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT72bGDnsnt1WYoG5AQJ7ixAAlxcMbDxsy7Gh3zITFU7Tq4Gr8I27SNgS
ZV3et/a3/+nHZ7Pa9wUZtmCngo/WtUFzpGQWLIOrTSPQ/9XhzjFNcLvYD7eH46UF
wxlXspnoru7z4hRvmzF+R6XGODaiT58F+eBFsEBss3+sVlo0Wyta4Pn6a7ssrHuF
wmUQyoZuwZfCoiK8GNqk48zjHaOpA+6hl0N9wjGDzMzKMBctnYZfSvyGEKTga5+5
iKiF9A5XgZq9tdbPPM4Qca01SfsIi5culSits1fVUsYc8KgWOAuhS/asFzXc1Bwa
sM98JLLsS81sSQMe6dD3AO0hYz0+AxiVbHCXmxocaal2Mw/KNorkYp5T+7EBMUkp
Y9mX9nOIslKSWx2az8PyMQ3xdOsviNIFu47UNA7z7Glvod3KUnawrQwu6R0COAte
weIgCVA/L6TpRHLq8aZu7lYra3uoguz24mOTk+2SXzNHIGYqHDNlOKtY1oHe3daV
gC1sd3GRzDSo89dR0rwF+nRXdOci6L614kbsdgj8V/ZuXVBiYdqgRZ+zoRK0wc8F
YuNhl665858Ed+5xZkodeDNIketh5zILYQiZp+uiHHXq9afKyZAuIgOBKRKxqL9D
u0BkXxZ7igJBxflzmQ9ClriksKqkcy4p1uBlzn/plCydF4EUVZK0dqR1J3q5ll9i
BJensSzk7is=
=cshU
-----END PGP SIGNATURE-----

--Sig_/Su4hAPa/alD=fS60uNC2E./--
