Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C44390999
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 21:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781991494; cv=none; b=VxTKHtfzKCIXLLp6jfxAkC633TWmwfceNBwk6I105cL3Am7VcahUg/FsawyqmmHFsvOf47Ut3U+lGUAPIwQwa9mLr7TgOA241Exte3q0p5BlQP0zpUh+m500W1NIQysf+ZLnX2+vab8jSUWv1U0+Q7hj92mMkecPcdKbzEwu5BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781991494; c=relaxed/simple;
	bh=41b2IqADgL3QMTL7adHIF6inB78fb3bHdm8X34pS3A4=;
	h=Cc:From:Subject:To:Date:Message-Id:Mime-Version:References:
	 Content-Type:In-Reply-To; b=kFvP6m141Q4m6HIyMFuAxEhN3Krec9iJpKKvBgINgbf++jIt1bvTeBOnRiP4XYsbDQH93/+s0YbQR1zhealTAPOcsR0F0N9NU6eF4Byvn6VtoEFk3oRPL9xau8qlKVN+OQiZO/wUrkBlNLhLbagTB8HUTEfY7lu3D3n/yjDC1Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OqyWuQ8u; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OqyWuQ8u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781991480;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=q/xTnzvzLMcYq1DC5AtSFY+QHyval7bie+jm+mQx68U=;
 b=OqyWuQ8uPBM9MrhDTBn0ICQNR+AvrgnOjwfkH9Dw/u7JXr1iNrIoFdT/ykgsErdKOfPDh8
 osvEg1er8y2qm1ZNzpfXZY9WadhfYCE5Dx+IeGOXOWanyq8tdIlHqKFL5LsRKlGePX0UyW
 Uigs4IqzH6xtOVds7NcOUeACY2c1HAeB51So+A9XMx1uwb3BiiXd2euZplwjKPEQwSbPhb
 w6ddEPn5+bIAJIMQVTNtBKVBx24+J+AnlIspfB+j6jLA0q8syWtPCCMLIX0i26GgOdvT43
 rLAqqNI37ZV2FhUVN1cDVdGe0DDotvNMSJeHPFhbuOOC3kHa39CTYELT2QjI7Q==
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: use stripe state snapshot in break_stripe_batch_list()
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 21:37:58 +0000
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Date: Sun, 21 Jun 2026 05:37:55 +0800
Message-Id: <80f5f6e2-5be7-4975-b727-58883a23d83c@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20260618134748.1168360-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260618134748.1168360-1-chencheng@fnnas.com>
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a370837+82c527+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/6/18 21:47, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> The patch just suppress KCSAN noise. No functional change.
>
> RAID-5 can group multi full-stripe-write aka stripe_head into a
> batch aka batch_list, with one head_sh leading them. Call
> break_stripe_batch_list() when the batch is finished, or,
> a stripe has to be dropped out of the batch.
>
> break_stripe_batch_list() reads stripe state several times while
> request paths can update thost state words concurrently with
> lockless bitops, which reported by KCSAN.
>
> Use a snapshot to guarantees that the value used for
> warning, copying, and handle checks is internally consistent
> at current read moment.
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in __add_stripe_bio / break_stripe_batch_list
>
> write (marked) to 0xffff8e89d4f0b988 of 8 bytes by task 4323 on cpu 3:
>    __add_stripe_bio+0x35e/0x400
>    raid5_make_request+0x6ac/0x2930
>    md_handle_request+0x4a2/0xa40
>    md_submit_bio+0x109/0x1a0
>    __submit_bio+0x2ec/0x390
>    submit_bio_noacct_nocheck+0x457/0x710
>    submit_bio_noacct+0x2a7/0xc20
>    submit_bio+0x56/0x250
>    blkdev_direct_IO+0x54c/0xda0
>    blkdev_write_iter+0x38f/0x570
>    aio_write+0x22b/0x490
>    io_submit_one+0xa51/0xf70
>
> read to 0xffff8e89d4f0b988 of 8 bytes by task 4290 on cpu 4:
>    break_stripe_batch_list+0x3ce/0x480
>    handle_stripe_clean_event+0x720/0x9b0
>    handle_stripe+0x32fb/0x4500
>    handle_active_stripes.isra.0+0x6e0/0xa50
>    raid5d+0x7e0/0xba0
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 45 ++++++++++++++++++++++++++-------------------
>   1 file changed, 26 insertions(+), 19 deletions(-)

You have another patch that is relied on this patch, they should be in one
patchset. What's worse, they are sent in the reverse order :(

>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 26c24986e01c..a376560be92e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -4906,35 +4906,39 @@ static int clear_batch_ready(struct stripe_head *=
sh)
>   static void break_stripe_batch_list(struct stripe_head *head_sh,
>   				    unsigned long handle_flags)
>   {
>   	struct stripe_head *sh, *next;
>   	int i;
> +	unsigned long state;
>  =20
>   	list_for_each_entry_safe(sh, next, &head_sh->batch_list, batch_list) {
>  =20
>   		list_del_init(&sh->batch_list);
>  =20
> -		WARN_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
> -					  (1 << STRIPE_SYNCING) |
> -					  (1 << STRIPE_REPLACED) |
> -					  (1 << STRIPE_DELAYED) |
> -					  (1 << STRIPE_BIT_DELAY) |
> -					  (1 << STRIPE_FULL_WRITE) |
> -					  (1 << STRIPE_BIOFILL_RUN) |
> -					  (1 << STRIPE_COMPUTE_RUN)  |
> -					  (1 << STRIPE_DISCARD) |
> -					  (1 << STRIPE_BATCH_READY) |
> -					  (1 << STRIPE_BATCH_ERR)),
> -			"stripe state: %lx\n", sh->state);
> -		WARN_ONCE(head_sh->state & ((1 << STRIPE_DISCARD) |
> -					      (1 << STRIPE_REPLACED)),
> -			"head stripe state: %lx\n", head_sh->state);
> +		state =3D READ_ONCE(sh->state);
> +		WARN_ONCE(state & ((1 << STRIPE_ACTIVE) |
> +				   (1 << STRIPE_SYNCING) |
> +				   (1 << STRIPE_REPLACED) |
> +				   (1 << STRIPE_DELAYED) |
> +				   (1 << STRIPE_BIT_DELAY) |
> +				   (1 << STRIPE_FULL_WRITE) |
> +				   (1 << STRIPE_BIOFILL_RUN) |
> +				   (1 << STRIPE_COMPUTE_RUN)  |
> +				   (1 << STRIPE_DISCARD) |
> +				   (1 << STRIPE_BATCH_READY) |
> +				   (1 << STRIPE_BATCH_ERR)),
> +			"stripe state: %lx\n", state);
> +
> +		state =3D READ_ONCE(head_sh->state);
> +		WARN_ONCE(state & ((1 << STRIPE_DISCARD) |
> +				   (1 << STRIPE_REPLACED)),
> +			"head stripe state: %lx\n", state);
>  =20
>   		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
>   					    (1 << STRIPE_PREREAD_ACTIVE) |
>   					    (1 << STRIPE_ON_UNPLUG_LIST)),
> -			      head_sh->state & (1 << STRIPE_INSYNC));
> +			      state & (1 << STRIPE_INSYNC));
>  =20
>   		sh->check_state =3D head_sh->check_state;
>   		sh->reconstruct_state =3D head_sh->reconstruct_state;
>   		spin_lock_irq(&sh->stripe_lock);
>   		sh->batch_head =3D NULL;
> @@ -4943,22 +4947,25 @@ static void break_stripe_batch_list(struct stripe=
_head *head_sh,
>   			if (test_and_clear_bit(R5_Overlap, &sh->dev[i].flags))
>   				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
>   			sh->dev[i].flags =3D head_sh->dev[i].flags &
>   				(~((1 << R5_WriteError) | (1 << R5_Overlap)));
>   		}
> -		if (handle_flags =3D=3D 0 ||
> -		    sh->state & handle_flags)
> +
> +		state =3D READ_ONCE(sh->state);
> +		if (handle_flags =3D=3D 0 || (state & handle_flags))
>   			set_bit(STRIPE_HANDLE, &sh->state);
>   		raid5_release_stripe(sh);
>   	}
>   	spin_lock_irq(&head_sh->stripe_lock);
>   	head_sh->batch_head =3D NULL;
>   	spin_unlock_irq(&head_sh->stripe_lock);
>   	for (i =3D 0; i < head_sh->disks; i++)
>   		if (test_and_clear_bit(R5_Overlap, &head_sh->dev[i].flags))
>   			wake_up_bit(&head_sh->dev[i].flags, R5_Overlap);
> -	if (head_sh->state & handle_flags)
> +
> +	state =3D READ_ONCE(head_sh->state);
> +	if (state & handle_flags)
>   		set_bit(STRIPE_HANDLE, &head_sh->state);
>   }
>  =20
>   /*
>    * handle_stripe - do things to a stripe.

--=20
Thanks,
Kuai
