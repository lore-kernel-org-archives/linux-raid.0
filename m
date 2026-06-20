Received: from lf-2-12.ptr.blmpb.com (lf-2-12.ptr.blmpb.com [101.36.218.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08979233954
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 21:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781990098; cv=none; b=IMgnhu/dQCMajsNvSeAj7Pt/y5sKL3Qx4MPzBHZObfDiiwO6iQi8bAToNBENmYcQVgYNH96g1ZLSwxF9CiQcwrHAkzZRpCcLZ1KbvCsFcWMZ6RowmcwETRxCwu0RdxFpe10bGzliz15hvnAb5M+kqHcyawba4/ab6XE3YOzDR10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781990098; c=relaxed/simple;
	bh=rhuRsvwAnKNPvRDVq3zCEGLZVaEIFPc3RA2IJ4ZMC+I=;
	h=Message-Id:Mime-Version:To:Cc:In-Reply-To:References:From:Date:
	 Content-Type:Subject; b=e+B+/bepFOvllz90bLgy/1FUGjKd5fMWe//FBVXzQPTl0QDE0gC63wzziPD1WmPSJTJoiYqwA5Jx0w3i34ATJGNZZk5wLjBZ7ScmSRxEExnAkl/k6r8dZSsQaGxz3HoPWQCd4DmXVLqxApQ3YRmxteqmpToMgtTTn4fHqPq+3IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=dB7U6F9+; arc=none smtp.client-ip=101.36.218.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="dB7U6F9+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781990044;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6R/If1+0LDH8rEde+SjBHvH8hXZzBIkuSfe/Z5MWBwc=;
 b=dB7U6F9++2cBskZQRrdpdgKlMw18QLBS+axLM8mUwH9AmSaOJxtChaoK7R3uvxWNJCOOb3
 hNPxTRg2KR8rfT/z4VNT8SPRuSVXkPPOwsJFuLnuC13CFGEJq/LCXS9/gpf2nhZ0ZFcHEa
 LVQr7ljOfqVyT663ammK4SrcyVSSf7I4CnhNGiFVfPQ4psObS0I5GVSAtU1O5PZOsp6yH0
 SHzHeN6n1cH+FOJeQnkJWJSUJHIghuUD3GKvW1uBgtTj1QEB2wMIwPiB0PyqxbDUPhCavE
 irQRhHASxsctHIbr03FChjyS67uB+r3TDCkEfbNl1YIkVcHpWvKksyqChd7fIw==
Message-Id: <d7011132-d213-4dea-9c1d-c8fd9d6e93e0@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <chenchneg33@gmail.com>, <linux-kernel@vger.kernel.org>
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 21:14:02 +0000
In-Reply-To: <20260617142839.882378-1-chencheng@fnnas.com>
References: <20260617142839.882378-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a37029b+7415f8+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 05:13:59 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [PATCH v2] md/raid5: protect bitmap batch counters aka seq_flush/seq_write consistency
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/6/17 22:28, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> kcsan detect race :
> - raid5d() closes the current bitmap batch by updating
> 	conf->seq_flush under conf->device_lock.
> - __add_stripe_bio() read conf->seq_flush without that
> 	lock when assigning sh->bm_seq.
>
> so, protect seq_flush/seq_write consistency for multiple CPUs by
> READ_ONCE()/WRITE_ONCE() under the path without held device_lock.
>
> re-explain the stripe batch sequence number update flow:
> 1. sh->bm_seq declare which batch number the stripe belongs to
>     when perform bitmap-related write.
> 	=3D=3D> bm_seq =3D seq_flush+1
>
> 2. stripe be handled,
> 	* if sh->bm_seq - conf->seq_write > 0, means the
> 	  batch stripes **newer than** the last written
> 	  batch, it cannot proceed yet, queued on bitmap_list.
> 	* otherwise , has already proceed.
>
> 3. raid5d() `++seq_flush` to closes the current batch, means
> 	* no more stripes join that old batch
> 	* just-closed batch ready to write-out to disk
>
> 4. raid5d() calls bitmap hooks unplug() or writeout, then,
>     `++seq_write` to the same as bm_seq.
>
> - seq_flush - for producer, to close batches.
> - seq_write - for consumer, the checkpoint number.
>
> the report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in __add_stripe_bio / raid5d
>
> write to 0xffff88ba5625d470 of 4 bytes by task 82401 on cpu 0:
>   raid5d+0x1d9/0xba0
>   [.....]
>
> read to 0xffff88ba5625d470 of 4 bytes by task 82421 on cpu 8:
>   __add_stripe_bio+0x332/0x400
>   raid5_make_request+0x6ac/0x2930
>   md_handle_request+0x4a2/0xa40
>   md_submit_bio+0x109/0x1a0
>   __submit_bio+0x2ec/0x390
>   [.....]
>
> v1 -> v2:
> - remove WRITE_ONCE(conf->seq_write) in held device_lock path.
> - remove READ_ONCE(conf->seq_flush) in held device_lock path.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a320b71d7117..b2c5a1930841 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3536,11 +3536,11 @@ static void __add_stripe_bio(struct stripe_head *=
sh, struct bio *bi,
>   	pr_debug("added bi b#%llu to stripe s#%llu, disk %d, logical %llu\n",
>   		 (*bip)->bi_iter.bi_sector, sh->sector, dd_idx,
>   		 sh->dev[dd_idx].sector);
>  =20
>   	if (conf->mddev->bitmap && firstwrite && !sh->batch_head) {
> -		sh->bm_seq =3D conf->seq_flush+1;
> +		sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;
>   		set_bit(STRIPE_BIT_DELAY, &sh->state);
>   	}
>   }
>  =20
>   /*
> @@ -5827,11 +5827,11 @@ static void make_discard_request(struct mddev *md=
dev, struct bio *bi)
>   			md_write_inc(mddev, bi);
>   			sh->overwrite_disks++;
>   		}
>   		spin_unlock_irq(&sh->stripe_lock);
>   		if (conf->mddev->bitmap) {
> -			sh->bm_seq =3D conf->seq_flush + 1;
> +			sh->bm_seq =3D READ_ONCE(conf->seq_flush) + 1;
>   			set_bit(STRIPE_BIT_DELAY, &sh->state);
>   		}
>  =20
>   		set_bit(STRIPE_HANDLE, &sh->state);
>   		clear_bit(STRIPE_DELAYED, &sh->state);
> @@ -6877,16 +6877,17 @@ static void raid5d(struct md_thread *thread)
>   			clear_bit(R5_DID_ALLOC, &conf->cache_state);
>  =20
>   		if (
>   		    !list_empty(&conf->bitmap_list)) {
>   			/* Now is a good time to flush some bitmap updates */
> -			conf->seq_flush++;
> +			int seq =3D conf->seq_flush + 1;

checkpatch should warn this about missing blank line after declaration.

> +			WRITE_ONCE(conf->seq_flush, seq);

WRITE_ONCE(a, a + 1) is safe, you can see lots of examples.

>   			spin_unlock_irq(&conf->device_lock);
>   			if (md_bitmap_enabled(mddev, true))
>   				mddev->bitmap_ops->unplug(mddev, true);
>   			spin_lock_irq(&conf->device_lock);
> -			conf->seq_write =3D conf->seq_flush;
> +			conf->seq_write =3D seq;
>   			activate_bit_delay(conf, conf->temp_inactive_list);
>   		}
>   		raid5_activate_delayed(conf);
>  =20
>   		while ((bio =3D remove_bio_from_retry(conf, &offset))) {

--=20
Thanks,
Kuai
