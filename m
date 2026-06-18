Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE103BBA1E;
	Thu, 18 Jun 2026 10:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781779054; cv=none; b=BYt1EkGBSWpSo3bGhQC/uOeUJWbyPNcxfK5MlBszqColcEM6MAuNxy5s5vl47fNJ0GIRuj+JK00GrqCamEZX/2tW2emk1J3a9C7KXu9KqvRv6AYoeYfOz/QYUp+PCjlIThxpr0g86zNOxSQMEVLnPt+p+/RIb4zMyxt5j+AcN1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781779054; c=relaxed/simple;
	bh=jPLR5+ENJWhP0+l/7FlSBpk/q1d/my6pJLHyY5+p2Os=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VsF33rUU429M7BCUjriyOtBjBrtlXeLAxdyPgbDVr7QmELcHp183blHjUgEVUi6WO2etlZuR1KnvxvPiYEN6MEznYoC+z0Hom/zRyYz1JYWoWbigDBfVlDJ4w6uaNg6lJMeICeVUOLHHh6zDb4gx6gDhcGPRpSMVGGo0WasiVY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.13.172] (g427.RadioFreeInternet.molgen.mpg.de [141.14.13.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9140D4C1A4E998;
	Thu, 18 Jun 2026 12:36:44 +0200 (CEST)
Message-ID: <5e6ce9e2-4da9-4ded-be8c-fad3ee153d90@molgen.mpg.de>
Date: Thu, 18 Jun 2026 12:36:44 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: protect batch_head->bm_seq updates
To: Chen Cheng <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, yukuai@fnnas.com,
 chenchneg33@gmail.com, linux-kernel@vger.kernel.org
References: <20260618065544.954309-1-chencheng@fnnas.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260618065544.954309-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Chen,


Thank you for very much.

Am 18.06.26 um 08:55 schrieb Chen Cheng:
> From: Chen Cheng <chencheng@fnnas.com>
> 
> bm_seq means "stripe delay to flush until bm_seq <= seq_write".
> 
> do_release_stripe() keeps STRIPE_BIT_DELAY stripes on bitmap_list
> when bm_seq >= seq_write.
> 
> after raid5d() flushes bitmap update and ++seq_write, and
> active_bit_delay() retry to release delayed stripes.
> 
> the stripe batch head must carry the newest bm_seq among all
> member stripes, because the whole batch later released according
> to the batch head state and bm_seq.
> 
> race scenario:
> ===================
> 1. cpu0 - sh0->bm_seq=101; cpu1 - sh1->bm_seq=102;
> 2. both cpu0 and cpu1 read batch_head->bm_seq = 100;
> 3. cpu1 write 102, and cpu0 overwrite with 101;
> 
> the point is, if the head has a lower bm_seq than one of its
> members, the whole batch could be released before that
> member's bitmap is flushed.
> and the on-disk bitmap not record sh1's changes.

It’s a little hard to read. Could you please improve the wording of the 
last paragraph, and maybe also start each sentence with a capital 
letter. Maybe also use 75 characters per line.

Do you have a reproducer by any chance?

> Signed-off-by: Chen Cheng <chencheng@fnnas.com>

Also add a Fixes: tag?

> ---
>   drivers/md/raid5.c | 13 ++++++-------
>   1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a08230aac711..ee145a7bf9e8 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -980,32 +980,31 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
>   		/*
>   		 * at this point, head's BATCH_READY could be cleared, but we
>   		 * can still add the stripe to batch list
>   		 */
>   		list_add(&sh->batch_list, &head->batch_list);
> -		spin_unlock(&head->batch_head->batch_lock);
>   	} else {
>   		head->batch_head = head;
>   		sh->batch_head = head->batch_head;
>   		spin_lock(&head->batch_lock);
>   		list_add_tail(&sh->batch_list, &head->batch_list);
> -		spin_unlock(&head->batch_lock);
>   	}
>   
> -	if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> -		if (atomic_dec_return(&conf->preread_active_stripes)
> -		    < IO_THRESHOLD)
> -			md_wakeup_thread(conf->mddev->thread);
> -
>   	if (test_and_clear_bit(STRIPE_BIT_DELAY, &sh->state)) {
>   		int seq = sh->bm_seq;
>   		if (test_bit(STRIPE_BIT_DELAY, &sh->batch_head->state) &&
>   		    sh->batch_head->bm_seq - seq > 0)
>   			seq = sh->batch_head->bm_seq;
>   		set_bit(STRIPE_BIT_DELAY, &sh->batch_head->state);
>   		sh->batch_head->bm_seq = seq;
>   	}
> +	spin_unlock(&head->batch_head->batch_lock);
> +
> +	if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +		if (atomic_dec_return(&conf->preread_active_stripes)
> +		    < IO_THRESHOLD)
> +			md_wakeup_thread(conf->mddev->thread);
>   
>   	atomic_inc(&sh->count);
>   unlock_out:
>   	unlock_two_stripes(head, sh);
>   out:


Kind regards,

Paul
