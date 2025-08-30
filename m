Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ADD2580DE;
	Sat, 30 Aug 2025 09:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756546908; cv=none; b=G2BKbC4i8rJHZDKNjLNbU8kepMdP4AnwTf1Rwu1jtXx+WGrmQx/JfgKlKdQ+RURV/kuM/8biDP4Cgius0mosTpbVojag2YMEoCQAP//UKnrb5tqfAbRuTJbH3KSiD+TZYevLrDkQXMk3/HQ0cWuQ8WDbt2f3R+TLsTIs6REipdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756546908; c=relaxed/simple;
	bh=BqI3/sWWw1D3AtIuih58OVo2jAJVnSwLlfL1HpdrKW0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7In6k/nkRCohTiFHGRQw0fuMPZK8WXTX6E14WuwONn0BZroi9fLCW3sxg0KM8N8apRGux5usXj6xB5hqq3YORkTRavNJ6Xzc+AfEfMJUhrdleNFM/HlNnRLkay34cuDxASQetXoXGzYoOq+9UKP1DhN2z+6mfwYrI8AU35e+YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7fb.dynamic.kabel-deutschland.de [95.90.247.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 8B1F56004C2C8;
	Sat, 30 Aug 2025 11:41:01 +0200 (CEST)
Message-ID: <2eadd8d3-7705-4000-982e-cafd222977c1@molgen.mpg.de>
Date: Sat, 30 Aug 2025 11:41:01 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: prevent incoreect update of resync/recovery offset
To: Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250830090242.4067003-1-linan666@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250830090242.4067003-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Nan,


Thank you for your patch. I have some formal comments. In the 
summary/title: incor*r*ect.

Am 30.08.25 um 11:02 schrieb linan666@huaweicloud.com:
> From: Li Nan <linan122@huawei.com>
> 
> In md_do_sync(), when md_sync_action returns ACTION_FROZEN, subsequent
> call to md_sync_position() will return MaxSector. This causes
> 'curr_resync' (and later 'recovery_offset') to be set to MaxSector too,
> which incorrectly signals that recovery/resync has completed even though
> disk data has not actually been updated.
> 
> To fix this issue, skip updating any offset values when the sync acion

ac*t*ion

> is either FROZEN or IDLE.

Maybe state that the same holds true for IDLE?

Should these two cases be handled differently in `md_sync_position()`. 
Does it semantically make sense, that the default of MaxSector is returned?

> Fixes: 7d9f107a4e94 ("md: use new helpers in md_do_sync()")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e78f80d39271..6828a569e819 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9397,6 +9397,9 @@ void md_do_sync(struct md_thread *thread)
>   	}
>   
>   	action = md_sync_action(mddev);
> +	if (action == ACTION_FROZEN || action == ACTION_IDLE)
> +		goto skip;
> +
>   	desc = md_sync_action_name(action);
>   	mddev->last_sync_action = action;
>   


Kind regards,

Paul
