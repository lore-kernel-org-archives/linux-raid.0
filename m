From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/2] md/raid5: trivial coding style fix
Date: Thu, 30 Apr 2015 17:16:50 +1000
Message-ID: <20150430171650.4db1bcca@notabene.brown>
References: <1430377277-6167-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1430377277-6167-2-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PdYNcDWRrEbxFxaTVV1sdvC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430377277-6167-2-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PdYNcDWRrEbxFxaTVV1sdvC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2015 15:01:17 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid5.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2651bda..bae3e2c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5789,8 +5789,7 @@ static void raid5d(struct md_thread *thread)
>  		if (released)
>  			clear_bit(R5_DID_ALLOC, &conf->cache_state);
> =20
> -		if (
> -		    !list_empty(&conf->bitmap_list)) {
> +		if (!list_empty(&conf->bitmap_list)) {
>  			/* Now is a good time to flush some bitmap updates */
>  			conf->seq_flush++;
>  			spin_unlock_irq(&conf->device_lock);


I'm happy for these sorts of changes when you are fixing up nearby code, or
if the change significantly improves readability.
But I'd rather not bother is one-off trivial fixes like this.

Thanks anyway,
NeilBrown

--Sig_/PdYNcDWRrEbxFxaTVV1sdvC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUHW4jnsnt1WYoG5AQK2Sg/9ERlZ7QoIgi8E3kAigfTFNicHyYNS9pVH
mUGkcEcDn96Nc0hEwH+a8++i8+SGnOHKMYYcltFujtNgCpz0tDd7rRLTBpqIQEr3
sMd8UP3zXrMe7n/nQPNlu/zFdk4aXdDxWFbhe9CkpSmhumVskvIXD9LWwgb1o7n6
Je4jk1ja6550hGdOinrQDz0Xafuam42uGhCTmPkGo/CfXNLDPAisUzihqvtCOCs5
cMMh0yNYsnF1UY70DFbF5isFUXFW6eVW3HreFBxFm/cRUqfT5dBJd2ziUdJvmhWP
hoDyRCSRFV9BeBkOyWFainmTwvjeO7rg1LL3qq8njbJo+A/PSqfH8h5Gui99VIia
axObH7eFK4mgJreCyab5N9Y6FslyzoG4tvGOUb2xBOR0fkmIz8Ag8LUQCWcyZFM/
7zyJYTggHMLc//jOpK9kA1F7RNCJWilpSqua0It4yGohuWANpaSWQI11JBVYFfJG
HRxp6orvbIzcwjc/hCin8qazirzBcfODdlhzXoDSXWvO3jWGG0n6Gi02WIwR+h7L
5Nt3lazdtM3e5prjy+RL/W0S2XkDwZ+3wrBduFFtkNWOq7XCHc4FUQjyTH+vIZHd
ALxVsuhZR9t7DwAZEladJYXA5U+nu/Hdn9ODWjNK+ERo4r1iXyZSlPFFWCB9tQX8
s8KyA6XaXz4=
=a+BV
-----END PGP SIGNATURE-----

--Sig_/PdYNcDWRrEbxFxaTVV1sdvC--
