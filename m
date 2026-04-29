Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6351038AC6C
	for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 13:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777468085; cv=none; b=IH9BU7rJhmuOtZcveHiEGvqKC/lVKOKOgxahGzQveikjP/Cxa4oS4YB2Sljp3iAsFt2V+m82nkzIhsMxebWrX+pXX5tK7E948B+fMi1eZH7u8fbS1XMuSHqopDpvv0Ff8PFybQYwXsaNiR0fPpQvysU3cOvQqQpO2nhAbmvz43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777468085; c=relaxed/simple;
	bh=jAynAqlLmO4e69eTuMuUEdJIftPp6cUGoERyWl1DeLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=VHGHe0fPY5SC615zPeVMVEd5cvhgbv+BOpULi9fdaE53q0Lo7rd2WyhinuHwREYjxGUht8Mzs9q5kBspMiTUPRtnkwURR7oP1OSX1cjrKH3VzkDnLovwXsHzs51u/bkp1u1crmGmQpd6+wtCXyKTKm8pHk7WbpfD8hCH54agcHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3B85A4C2C37F03;
	Wed, 29 Apr 2026 15:07:32 +0200 (CEST)
Message-ID: <a7e94a16-439e-4b28-bc0b-580e00953473@molgen.mpg.de>
Date: Wed, 29 Apr 2026 15:07:31 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: Fix bio retry on interrupted reshape
To: Nigel Croxon <ncroxon@redhat.com>
References: <f861791b-d539-45ce-8575-5ec74d58d15d@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org
In-Reply-To: <f861791b-d539-45ce-8575-5ec74d58d15d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Nigel,


Thank you for your patch.

Am 29.04.26 um 13:10 schrieb Nigel Croxon:
> When a bio encounters LOC_INSIDE_RESHAPE during a reshape that is
> interrupted (stopped or unable to progress), the code sets
> bi->bi_status = BLK_STS_RESOURCE to signal the block layer for retry.
> However, bio_endio() is never called, so the block layer never
> receives the completion notification and the retry never happens.
> 
> This causes I/O to hang when a filesystem is layered over RAID5 and
> reshape gets stuck.
> 
> Fix this by calling bio_endio(bi) before md_free_cloned_bio(bi) so
> the block layer is properly notified of the BLK_STS_RESOURCE status
> and can retry the request.
> 
> Tested stripes and stripe size conversions under load comparing
> files multiple times during each conversion (i.e. MD reshape) on
> ext4 after dropping caches degrading the RaidLV each time and

I thought RaidLV misspelled Raid V (Raid 5), so should you resend, maybe 
write it as RAID LV.

> no data corruption.
> 
> Fixes: https://lwn.net/Articles/757123/

Which paragraph/comment exactly?

> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   drivers/md/raid5.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6e79829c5acb..9a3475429ef4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6217,6 +6217,7 @@ static bool raid5_make_request(struct mddev 
> *mddev, struct bio * bi)
> 
>       mempool_free(ctx, conf->ctx_pool);
>       if (res == STRIPE_WAIT_RESHAPE) {
> +         bio_endio(bi);
>           md_free_cloned_bio(bi);
>           return false;
>       }

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
