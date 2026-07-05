Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145F525B085
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 07:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237851; cv=none; b=rb6sOowrvn+XcO/XFR4xO01mDBE5Afufr8oaShLj0AvZOnuQIlhXH9ce502h29mTiSDz2jTbJKegU92y1ERMedlzhctHvyLxZsDt1IeVupvQGmvUXbqEIFF5N2g0G6oVJwfdWnA8tqfAf9h7f0Ko2Hybt0cEriV8MrrohhV5WQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237851; c=relaxed/simple;
	bh=MS/9QAPsxjBt53EYN8SHvaiV4+JNabOmtvjpeFWf9to=;
	h=Date:From:Subject:Message-Id:In-Reply-To:To:Cc:Mime-Version:
	 Content-Type:References; b=Ktgd6n2D5xswQj6j2D/2p6lOW6QPP7G2BpBgWa9vr2uUqLYfbV9UfJrB6nhfLSiiGM51WqIEMEu+cIV5tyl945CFRd+nHkQzS69ZZW1ZP/Seka6JdUq92U/7aZMgtZV+OzxSjH3mqEKGeliKVO6PbNP6tp1gs4tTCFAA0FEx3cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NP9BxlJL; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NP9BxlJL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783237731;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=1m5Ij7cUm3aNg4SiY7SOw7EkjbLYYJT81g6Re6w0q/A=;
 b=NP9BxlJLUL/Y5LJymCESEsKknC7cEldNpDHw8JK+kczm/TM9AzuwzvQVbJEu4sJsmDuPwm
 fQHd7SAX86szIcWAeXMp3Cb7cb6LP+UUQjQMWxizlXuCF7f2ChD0mESfVLqyvhiVy8Tzp7
 szBahwZejsnOQJ51SD7dWmro31UBzT/k5n/3GOLPlj8j9E3aWFvD5UPhgSUNnECfWzS9v9
 uboDCBvvctv7t10seX/D++x+/kkMZJu3fDQ6QBZwe7KN/+L/O4+Y/fSO+9tfv4KGUOsbkv
 jdkJEfYkEr05zfD9aE8IVOJvlRFQflfDGB52VX1/cQXDN7wE9hJaCvVLb3M9PQ==
Reply-To: yukuai@fygo.io
Date: Sun, 5 Jul 2026 15:48:46 +0800
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sun, 05 Jul 2026 07:48:50 +0000
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v6 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
Message-Id: <fb8b048b-3912-44e8-9f56-a25989cd80ee@fygo.io>
In-Reply-To: <20260623123840.2521340-4-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4a0c63+5ce2ad+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
References: <20260623123840.2521340-1-chencheng@fnnas.com> <20260623123840.2521340-4-chencheng@fnnas.com>

Hi,

=E5=9C=A8 2026/6/23 20:38, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> origin flow:
>
>        bio_endio(master_bio);   /* may drop active_io to zero */
>        allow_barrier(conf);
>        free_r10bio(r10_bio);    /* reads conf->geo, returns to pool */
>
> one scenario is:
>
>    CPU A (softirq, raid_end_bio_io)         CPU B (action_store) --> resh=
ape
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    bio_endio(master_bio)
>      md_end_clone_io
>        percpu_ref_put -> 0
>                                             wait_event wakeup, and,
>                                             	mddev_suspend return
>                                             raid10_start_reshape:
>                                               setup_geo(&conf->geo, new)
>                                               ...
>                                               mempool_destroy(old_pool)
>                                               conf->r10bio_pool =3D new_p=
ool
>    allow_barrier(conf)
>    free_r10bio(r10_bio)
>      put_all_bios:
>        for (i=3D0; i<conf->geo.raid_disks; i++)
>            =3D=3D> old obj, new geo, OOB
>      mempool_free(r10_bio, conf->r10bio_pool)
>            =3D=3D> old-geometry obj freed into new pool
>
> so .. fix by reorder the flow:
>
> 	free_r10bio(r10_bio)
> 	allow_barrier(conf)
> 	bio_endio(master_io)
>
> raid_end_discard_bio() is exactly the same.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 17 ++++++++++-------
>   1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index d740744a9746..e44a9b6e95c7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -330,24 +330,25 @@ static void reschedule_retry(struct r10bio *r10_bio=
)
>    */
>   static void raid_end_bio_io(struct r10bio *r10_bio)
>   {
>   	struct bio *bio =3D r10_bio->master_bio;
>   	struct r10conf *conf =3D r10_bio->mddev->private;
> +	unsigned long state =3D r10_bio->state;
>  =20
> -	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
> -			bio->bi_status =3D BLK_STS_IOERR;
> -		bio_endio(bio);
> -	}
> +	free_r10bio(r10_bio);
>  =20
>   	/*
>   	 * Wake up any possible resync thread that waits for the device
>   	 * to go idle.
>   	 */
>   	allow_barrier(conf);
>  =20
> -	free_r10bio(r10_bio);
> +	if (!test_and_set_bit(R10BIO_Returned, &state)) {
> +		if (!test_bit(R10BIO_Uptodate, &state))
> +			bio->bi_status =3D BLK_STS_IOERR;
> +		bio_endio(bio);
> +	}

Why is this moved to the end? I feel it's not necessary.

>   }
>  =20
>   /*
>    * Update disk head position estimator based on IRQ completion info.
>    */
> @@ -1580,13 +1581,15 @@ static void raid_end_discard_bio(struct r10bio *r=
10bio)
>   		if (!test_bit(R10BIO_Discard, &r10bio->state)) {
>   			first_r10bio =3D (struct r10bio *)r10bio->master_bio;
>   			free_r10bio(r10bio);
>   			r10bio =3D first_r10bio;
>   		} else {
> +			struct bio *master_bio =3D r10bio->master_bio;
> +
>   			md_write_end(r10bio->mddev);
> -			bio_endio(r10bio->master_bio);
>   			free_r10bio(r10bio);
> +			bio_endio(master_bio);
>   			break;
>   		}
>   	}
>   }
>  =20

--=20
Thanks,
Kuai
