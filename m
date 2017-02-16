From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH V3 2/2] RAID1: avoid unnecessary spin locks in I/O barrier code
Date: Thu, 16 Feb 2017 18:04:28 +1100
Message-ID: <87r32yvcoz.fsf@notabene.neil.brown.name>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <1487176523-109075-2-git-send-email-colyli@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1487176523-109075-2-git-send-email-colyli@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, Shaohua Li <shli@fb.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Feb 16 2017, colyli@suse.de wrote:

> @@ -2393,6 +2455,11 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>  		idx = sector_to_idx(r1_bio->sector);
>  		conf->nr_queued[idx]++;
>  		spin_unlock_irq(&conf->device_lock);
> +		/*
> +		 * In case freeze_array() is waiting for condition
> +		 * get_unqueued_pending() == extra to be true.
> +		 */
> +		wake_up(&conf->wait_barrier);
>  		md_wakeup_thread(conf->mddev->thread);
>  	} else {
>  		if (test_bit(R1BIO_WriteError, &r1_bio->state))
> @@ -2529,9 +2596,7 @@ static void raid1d(struct md_thread *thread)
>  						  retry_list);
>  			list_del(&r1_bio->retry_list);
>  			idx = sector_to_idx(r1_bio->sector);
> -			spin_lock_irqsave(&conf->device_lock, flags);
>  			conf->nr_queued[idx]--;
> -			spin_unlock_irqrestore(&conf->device_lock, flags);

Why do you think it is safe to decrement nr_queued without holding the
lock?
Surely this could race with handle_write_finished, and an update could
be lost.

Otherwise, looks good.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlilTvwACgkQOeye3VZi
gbnTIw//a0L5hyPoPUxCPM6suBvB/4yo65K3TzchiY15Zqw1UELd/hAgyiiOpxkY
pAcwf2U8ZlQVf2W7txMPBa2CM5xJKLDFEaTsPEthmeWF0EmQBDo1rHSkJ0K/9PDo
uaog4LXDbwFDMPpB4YfzZMdzu6H7I4Z8XzVcCNURmvREJWKCnHeGVdt+F5kOwSKD
aDD89FR6hv2j/3Wsvyvcf8pEwaut20tufaqEk3YkVDhjJMEIW7QQR9jL+t6VYBJ3
AFcr3k7KQCa3vx7Feq7JqjlATRSUjsTRU+6wLqUb9i2s7uB7SrZ6v7GsqpVrDPG+
xsW0RYvvOM87qqngovviMvYcFdBXLcKD4q0q09ryy+WCmi+WB1FqcEsykK7UygYy
ZaEL8lIYD5kzt46PdSDnvllULMXDVhFIP4EAsOgl+8ANR3WdIXpw8rMuYeVGPYsL
PWHCjZBuyZes4FVe79dWzwSgT+CSnxY9Wv+mC1myxvXhzpiTTf6GPLBWGuh7tQ9J
ft++PLl7N9NsySLK6KC0YLoZY2/kk4jotyS3NvmSNdTuHa+HwMsYb6SaVsTIdxAG
h9Ja5GYOMuCIgirhFH/J6Sx6scwTy6+LSMXk0rSmNcdLiUBn/cgJtFi5b8kIqy/Z
axp3v/+P/H5y5MboUmDEHnTpiRDZCumLJAF2jZUNkvLKcrHeutw=
=eYXk
-----END PGP SIGNATURE-----
--=-=-=--
