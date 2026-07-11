Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BF81E7C12
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 17:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783791846; cv=none; b=CuwTQdLzyET7Y2zg7xZlMTgUz5sIthX1aqrbUAn/qRbBndaVQJeSU3wgPRVeuMfwMPyPG/QIRH1o6paN0rQzg87Hk9QF8VEMluNwl94atU6WmU4WJpwNK5CiYZF+CwBbbsLumZkl4SpjsO+bAGdpH5UVo6oqgkie93YdLqC+HCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783791846; c=relaxed/simple;
	bh=QaebH4SY6lTCF+bYrqMBtdG86enntGMrHSa+tlLd8ZQ=;
	h=From:In-Reply-To:Subject:Message-Id:Content-Type:References:To:Cc:
	 Date:Mime-Version; b=t+J8RUAg0INgUOftpB3mai3EdiTYANE0BmzgUSBh0ZPUdQFhMIK1AmzChjfdVR+Z6iqJHl8NSfoQjQkHqgM95CAGX54k/ZM1reS4LEBQmFQRqyrpvRBMPXq+n1GQQv3Cbtpc3GpbOMzzZbZACl6ffBFSFW5hXNRNtpvnj7UYlwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=AmlcoIx5; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="AmlcoIx5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783791836;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=wE45Zi//ngGG2zCjWxjDU+BeRdl7JaQqgxT2QqPzchI=;
 b=AmlcoIx5kD08JGUvyAh23+uf5pNwpTxJhvEp4Ou6KpKtxvPVkOSsyHlCs9dslVsi2ljBtd
 UhUdRYg89DvruTF46wyWmESBkcBF7Ue5OZjPYsWWEWgANRVQ7IJlkIUZUjxT3Bl8y0Tewf
 7/TPa0gXRfP/QAp/bmh0vCNvvo4RRjNX89wVz/WrTacAO6RTxrcufanBeKdv+kvhO7xkAV
 0pbqRllJx8Wom1Nc3KBnPzU3oUZTGKOoOTuwbnSK3PgKAUlghqHr6RGLZFUjqnSGOZbSQB
 V7Ry5Tu69cTgGqlSR2hXTbz5ascQd+cYDsJOYF34n1v/j5jTJZQw+0GQAYFzsw==
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260711100352.425177-4-chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
Message-Id: <2a399970-710a-49fb-ab72-e1076b05cfbc@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
X-Lms-Return-Path: <lba+26a5280db+988982+vger.kernel.org+yukuai@fygo.io>
References: <20260711100352.425177-1-chencheng@fnnas.com> <20260711100352.425177-4-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sat, 11 Jul 2026 17:43:54 +0000
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 12 Jul 2026 01:43:51 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/11 18:03, Chen Cheng =E5=86=99=E9=81=93:
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
> 	bio_endio(master_bio)
>
> raid_end_discard_bio() is exactly the same.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 19 ++++++++++++-------
>   1 file changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index db68fcc9e9be..d77f60db7660 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -329,24 +329,27 @@ static void reschedule_retry(struct r10bio *r10_bio=
)
>    */
>   static void raid_end_bio_io(struct r10bio *r10_bio)
>   {
>   	struct bio *bio =3D r10_bio->master_bio;
>   	struct r10conf *conf =3D r10_bio->mddev->private;
> +	unsigned long state =3D r10_bio->state;
> +	bool returned;
>  =20
> -	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
> -		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
> -			bio->bi_status =3D BLK_STS_IOERR;
> +	returned =3D test_and_set_bit(R10BIO_Returned, &state);
> +	if (!returned && !test_bit(R10BIO_Uptodate, &state))
> +		bio->bi_status =3D BLK_STS_IOERR;
> +
> +	free_r10bio(r10_bio);
> +
> +	if (!returned)
>   		bio_endio(bio);
> -	}

Apparently this change is not enough, the R10BIO_Returned case still return
the master_bio before freeing r10_bio.

I think you should get an active_io reference while allocating r10_bio to
guarantee that no r10_bio is active while array is suspended.

>  =20
>   	/*
>   	 * Wake up any possible resync thread that waits for the device
>   	 * to go idle.
>   	 */
>   	allow_barrier(conf);
> -
> -	free_r10bio(r10_bio);
>   }
>  =20
>   /*
>    * Update disk head position estimator based on IRQ completion info.
>    */
> @@ -1579,13 +1582,15 @@ static void raid_end_discard_bio(struct r10bio *r=
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
