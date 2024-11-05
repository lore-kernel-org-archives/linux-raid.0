Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E891D4161;
	Tue,  5 Nov 2024 07:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730791353; cv=none; b=LGBenbZPrIt1x//09TsFwiWPFNZy+TR2xkHfiMj5XQrcuTgdqL7Xd99DYsbQDU6As7D9nnPh+1pa/zEVNoFbcw5G5DXKGGvc2bWbiq1Q+rerFPR/7wzOAtmzMyYXRZ5Os5cqc/P+UFYYMEZVqFKoLfI8zgYppUJFZottpwaNtOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730791353; c=relaxed/simple;
	bh=lG8CR6ORiPTYFbIsi3fci17rrN2LhgasE/ZYsPq4+Kk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tHaci+zZGoFldR/qJtYSUM31+XRLt6g/pL3YbWEJLlpsIasZvCHg314gz1r0CBYu6mAVNibb5gLKHSczqV40f03xoMXSmeUlNQImSlmuEwRcgeV7m2vwvIjlRtARZathXfCRihnToeT+3ZbU5JZEwQfic0X/QLnUdyTgHhg6sT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ATe/deWA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=crLythmp; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ATe/deWA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=crLythmp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ATe/deWA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="crLythmp";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ATe/deWA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="crLythmp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74B5421C55;
	Tue,  5 Nov 2024 07:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlx8c9Zql1kdrGuF+WKQIeKwMFr6yqL0OHnGjbvgYsU=;
	b=ATe/deWAY5L2p3rNsWc3mjqAakvvj21hvszk4juCncTWt6kPttbWHQz60HIXAxOhnAQKyG
	ojwG+i5DSibc/pl0kiApnHwkfYBPBzlW5hzNj0VywWkLqdOIVfD3erv+gnXHfbkSla2OAK
	X0rU7+oc2t6SFt9b4SGHtCnOxr3/mvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlx8c9Zql1kdrGuF+WKQIeKwMFr6yqL0OHnGjbvgYsU=;
	b=crLythmpNbBwTbzn4yTC6Pcbs1m3tIzGnEUcGv7yEtw/vvHdXK4c9MCPBkJ1hZMJBNeSAj
	nOursfUDsPpsspDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlx8c9Zql1kdrGuF+WKQIeKwMFr6yqL0OHnGjbvgYsU=;
	b=ATe/deWAY5L2p3rNsWc3mjqAakvvj21hvszk4juCncTWt6kPttbWHQz60HIXAxOhnAQKyG
	ojwG+i5DSibc/pl0kiApnHwkfYBPBzlW5hzNj0VywWkLqdOIVfD3erv+gnXHfbkSla2OAK
	X0rU7+oc2t6SFt9b4SGHtCnOxr3/mvI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wlx8c9Zql1kdrGuF+WKQIeKwMFr6yqL0OHnGjbvgYsU=;
	b=crLythmpNbBwTbzn4yTC6Pcbs1m3tIzGnEUcGv7yEtw/vvHdXK4c9MCPBkJ1hZMJBNeSAj
	nOursfUDsPpsspDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 177F41394A;
	Tue,  5 Nov 2024 07:22:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kGkDBLXHKWeTFwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 07:22:29 +0000
Message-ID: <aee733a2-96a3-488d-930c-c4c9c3661daf@suse.de>
Date: Tue, 5 Nov 2024 08:22:28 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] block: Error an attempt to split an atomic write
 in bio_split()
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241031095918.99964-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,oracle.com:email,suse.de:mid,suse.de:email,wdc.com:email,lst.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 10/31/24 10:59, John Garry wrote:
> This is disallowed.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   block/bio.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 7a93724e4a49..07b971853768 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1749,6 +1749,10 @@ struct bio *bio_split(struct bio *bio, int sectors,
>   	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
>   		return ERR_PTR(-EINVAL);
>   
> +	/* atomic writes cannot be split */
> +	if (bio->bi_opf & REQ_ATOMIC)
> +		return ERR_PTR(-EINVAL);
> +
>   	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
>   	if (!split)
>   		return ERR_PTR(-ENOMEM);

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
