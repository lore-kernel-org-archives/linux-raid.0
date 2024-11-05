Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512D11CDA25;
	Tue,  5 Nov 2024 07:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730791424; cv=none; b=ge6Q/HZpeD0mYunDcK1X95uyXbKV07+jFAobx79Q9MQuWmk3Mqa1K44Vll5AXVEGK8JhNnqnpHTHj/QSWF6/j1mGDv975tIL+Kl9EhuJQHcjHzuLvVzH9x3nMDYULJ/WszMKY3v/9GnB5ojI1dVfdq12BieBgm7yko4g+0DrlZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730791424; c=relaxed/simple;
	bh=4SFJYhYjmbGFZrjDBnwbKzr9OIWd6vgVaJrmbOOScBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2sr2WxcQnDEDtDuevTK6tt+a6Gs/3saoSS75WgPVlFyqzk97nPhMWQ7MA8uvlkeNgiRrQ16CHrxqu5Lqs/yKoYmuFrNDyMhK9qO3FqoE6hIahWQ4Wggiaw/caaM8HnyIjG3ivyGuhYHoPZTB4S0He4jE26qw+8WZItYslCl6uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VFYk6YZR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CKMl/M+L; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VFYk6YZR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=CKMl/M+L; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VFYk6YZR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CKMl/M+L";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VFYk6YZR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="CKMl/M+L"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5A2B21FBAF;
	Tue,  5 Nov 2024 07:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tF+5nfkmy7GOmPfUHe3jHxsEfmHevG5JYtYFnek+odg=;
	b=VFYk6YZR7bfMjEw6GeiDDCQxU3HU3OJbiuyY5An1Rbk8l6Vue7nE0sUZOn6XXIvWJsMaoz
	SxAMJwnQpnWfc5otz9Ig1cfXL/kgdlYgAe78tP6TR/hmIAUXgPmPNUxrvwckFS8jOERykG
	ZdELcG6nWTD9xpojpsVqe+v4B01t6pA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tF+5nfkmy7GOmPfUHe3jHxsEfmHevG5JYtYFnek+odg=;
	b=CKMl/M+LJ3pjAO+yEgscpkjnDDDs3aTYACzv5sWCmf851d3r51F2YQtbECGK2/aeWcB4h2
	z5vqt41eEcrgoHBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791419; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tF+5nfkmy7GOmPfUHe3jHxsEfmHevG5JYtYFnek+odg=;
	b=VFYk6YZR7bfMjEw6GeiDDCQxU3HU3OJbiuyY5An1Rbk8l6Vue7nE0sUZOn6XXIvWJsMaoz
	SxAMJwnQpnWfc5otz9Ig1cfXL/kgdlYgAe78tP6TR/hmIAUXgPmPNUxrvwckFS8jOERykG
	ZdELcG6nWTD9xpojpsVqe+v4B01t6pA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791419;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tF+5nfkmy7GOmPfUHe3jHxsEfmHevG5JYtYFnek+odg=;
	b=CKMl/M+LJ3pjAO+yEgscpkjnDDDs3aTYACzv5sWCmf851d3r51F2YQtbECGK2/aeWcB4h2
	z5vqt41eEcrgoHBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F32191394A;
	Tue,  5 Nov 2024 07:23:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sV6EOfrHKWflFwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 07:23:38 +0000
Message-ID: <607f2eb5-3e9e-4dfa-bda0-dd33280bf351@suse.de>
Date: Tue, 5 Nov 2024 08:23:38 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] block: Handle bio_split() errors in
 bio_submit_split()
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-4-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241031095918.99964-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,wdc.com:email,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,oracle.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 10/31/24 10:59, John Garry wrote:
> bio_split() may error, so check this.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/blk-merge.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index a16abf7b65dc..4d7b6bc8814c 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -107,11 +107,8 @@ static unsigned int bio_allowed_max_sectors(const struct queue_limits *lim)
>   
>   static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
>   {
> -	if (unlikely(split_sectors < 0)) {
> -		bio->bi_status = errno_to_blk_status(split_sectors);
> -		bio_endio(bio);
> -		return NULL;
> -	}
> +	if (unlikely(split_sectors < 0))
> +		goto error;
>   
>   
>   	if (unlikely((bio_op(bio) == REQ_OP_DISCARD)))
> @@ -123,6 +120,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
>   
>   		split = bio_split(bio, split_sectors, GFP_NOIO,
>   				&bio->bi_bdev->bd_disk->bio_split);
> +		if (IS_ERR(split)) {
> +			split_sectors = PTR_ERR(split);
> +			goto error;
> +		}
>   		split->bi_opf |= REQ_NOMERGE;
>   		blkcg_bio_issue_init(split);
>   		bio_chain(split, bio);
> @@ -133,6 +134,10 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
>   	}
>   
>   	return bio;
> +error:
> +	bio->bi_status = errno_to_blk_status(split_sectors);
> +	bio_endio(bio);
> +	return NULL;
>   }
>   
>   struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
