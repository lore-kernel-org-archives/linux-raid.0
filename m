Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811D61CDA25;
	Tue,  5 Nov 2024 07:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730791294; cv=none; b=QvV50gR5raJICcAe04QnpDBJOFlC+/ul6vj+ixEH4e2wCwWCYJzXPTWPSufBmr7VwCYb85W7nShub8Pjf3tW8hE7kKOt+MrzXOh7Ca2lIaaBoYbF942Xt9Y0dWlY/wHAEXGz1Y0JDyqukU0CYK/dKLd0R5Q4mK+8DJNUPDP94ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730791294; c=relaxed/simple;
	bh=qnc0tlVadcGLDbLU1ZUvqHKhBdDJMQ5csGxylZPaEEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDxXJksiU23rUjMLmuiaS/UCZnsEaNDJ8gq5VHpCu5f7/XpzSDl2CRA5hmt4+hfBMtagJK8wscLTya6mZKZYYnNySHTDxeIjoHMhlYrndP7lTFzdqg5hl+fmv588Fc56I9pQfr0QsYKviQeK6jolzWllI4N1wVq+pFJktfpmNts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=s3iolotg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vuY4kWF1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=v5lsIJGa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mV1Ng9ZE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="s3iolotg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vuY4kWF1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="v5lsIJGa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mV1Ng9ZE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F1B31FBAF;
	Tue,  5 Nov 2024 07:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cv5X+dJo+qYbCmGxX1UUGabGePe6AL3CemLdnsLnX3Y=;
	b=s3iolotg/x7CIuw300Rpt0qXFpuaeSzZnlhceovpaLUAqIbIp68KhzixxlTgoxx1394c1o
	RFk8EWNB/uUiQ8eSXj61OCE6al/24HOztRbY8C2mBmussgqwDDoo82QhBbNPON6DUHN98G
	oJ1txrnGFxzNrxftj4sxtHm8Jbc1HLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cv5X+dJo+qYbCmGxX1UUGabGePe6AL3CemLdnsLnX3Y=;
	b=vuY4kWF1Kvr6WnvevEy7WwAmay5iRbEeyPYTU+WMf7xCNVAzp5eAZ6fbHWtNGPlgzoA713
	6w9G8ocfmNPYt/DQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cv5X+dJo+qYbCmGxX1UUGabGePe6AL3CemLdnsLnX3Y=;
	b=v5lsIJGapgpdpAex/5OWu97Go+rI9WLQ/+nLoAtGvM7s4ZDJP4bxfj79A3Vn56gQfLa9uZ
	8kzTn5rvWP6yRcRG/LA4TNpSrpoEYpe9PXlr7zODYZhVPDVekvNegr76ac2dcF67Z9CfWI
	psT70iCfwl7g/cKQrBvoe2PaVS1fhGs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cv5X+dJo+qYbCmGxX1UUGabGePe6AL3CemLdnsLnX3Y=;
	b=mV1Ng9ZEUXgYYLaUHekwv2pC9RUNZ6sZxl01LcOUbp6omnsvG9l3DLBZT5pK4OlLy7LaDr
	FYrQEMMTdAdDCTDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F10931394A;
	Tue,  5 Nov 2024 07:21:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4borOHjHKWdQFwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 07:21:28 +0000
Message-ID: <c3102f97-df59-4859-9af1-d241a357d02f@suse.de>
Date: Tue, 5 Nov 2024 08:21:28 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] block: Rework bio_split() return value
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241031095918.99964-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,oracle.com:email,lst.de:email,imap1.dmz-prg2.suse.org:helo,wdc.com:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 10/31/24 10:59, John Garry wrote:
> Instead of returning an inconclusive value of NULL for an error in calling
> bio_split(), return a ERR_PTR() always.
> 
> Also remove the BUG_ON() calls, and WARN_ON_ONCE() instead. Indeed, since
> almost all callers don't check the return code from bio_split(), we'll
> crash anyway (for those failures).
> 
> Fix up the only user which checks bio_split() return code today (directly
> or indirectly), blk_crypto_fallback_split_bio_if_needed(). The md/bcache
> code does check the return code in cached_dev_cache_miss() ->
> bio_next_split() -> bio_split(), but only to see if there was a split, so
> there would be no change in behaviour here (when returning a ERR_PTR()).
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/bio.c                 | 10 ++++++----
>   block/blk-crypto-fallback.c |  2 +-
>   2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 95e2ee14cea2..7a93724e4a49 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1740,16 +1740,18 @@ struct bio *bio_split(struct bio *bio, int sectors,
>   {
>   	struct bio *split;
>   
> -	BUG_ON(sectors <= 0);
> -	BUG_ON(sectors >= bio_sectors(bio));
> +	if (WARN_ON_ONCE(sectors <= 0))
> +		return ERR_PTR(-EINVAL);
> +	if (WARN_ON_ONCE(sectors >= bio_sectors(bio)))
> +		return ERR_PTR(-EINVAL);
>   
>   	/* Zone append commands cannot be split */
>   	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
> -		return NULL;
> +		return ERR_PTR(-EINVAL);
>   
>   	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
>   	if (!split)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>   
>   	split->bi_iter.bi_size = sectors << 9;
>   
> diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
> index b1e7415f8439..29a205482617 100644
> --- a/block/blk-crypto-fallback.c
> +++ b/block/blk-crypto-fallback.c
> @@ -226,7 +226,7 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
>   
>   		split_bio = bio_split(bio, num_sectors, GFP_NOIO,
>   				      &crypto_bio_split);
> -		if (!split_bio) {
> +		if (IS_ERR(split_bio)) {
>   			bio->bi_status = BLK_STS_RESOURCE;
>   			return false;
>   		}

Don't you need to modify block/bounce.c, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
