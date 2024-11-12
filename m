Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1675C1A00D2;
	Tue, 12 Nov 2024 06:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731394710; cv=none; b=V8aKWEn+eQWH22vw5p0anfYikBznDiEPPCsXxY+yyYRbhdiyTd7vbuhMh7bT41HQtfigDwD6DcgYvwxPR7fPR4UkAssXZxYh5HDHY9kHMxFHJUIo2VTs6PJIbjIEbfqo+M+bTBXGzT49A9APWD9NlFtv4ZmwOJtjOeu9kK8XtEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731394710; c=relaxed/simple;
	bh=AZIV42PJsKg2EthXhisl/ikXjtCsixe0A2InWQkcTUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hEkp4KHfmdnjnuVlTSWT53DLhoEshncLYEmu5DhXO8Ue91zL43J+ymHFzq5myIrbEqblBrnxHOQHenYr9Fdugkf4/WYhYFwxqVOVbwWi9eqd7XxLT58KwFjGaF15g9G5i5lx/ethNK/aeUFc1wciC74/TIbLApysFr2xE95+KlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=klQryMFF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YwY90BSy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=klQryMFF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YwY90BSy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="klQryMFF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YwY90BSy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="klQryMFF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YwY90BSy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 144B21F451;
	Tue, 12 Nov 2024 06:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731394706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40YRUFJlt6S1W6poVrnNRAeQUnvx+RFpH6nmn561DnU=;
	b=klQryMFFTjJ4aKyiodpHPrJfDrwWLFe0e7BBgKoNeWSgoEnO571lTFDVbGI9xYhOOQ9+SP
	CWi/QypGXYuMapGjiu4zW0nnL1CPKwPvn7DPdWqsTFBVScPDY9WaYMOqQLqq6+wxEKpQTv
	3kdjT2D6wBG6Z93KZU8nh0tAv1Oyo7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731394706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40YRUFJlt6S1W6poVrnNRAeQUnvx+RFpH6nmn561DnU=;
	b=YwY90BSy2HQ37zRtrJD3zuI3zBSgszz/egWdpNT3Mq3yArFOSavyIvYgTZKmN4GuXWrKd0
	R8egC6smso8uDtDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=klQryMFF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YwY90BSy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1731394706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40YRUFJlt6S1W6poVrnNRAeQUnvx+RFpH6nmn561DnU=;
	b=klQryMFFTjJ4aKyiodpHPrJfDrwWLFe0e7BBgKoNeWSgoEnO571lTFDVbGI9xYhOOQ9+SP
	CWi/QypGXYuMapGjiu4zW0nnL1CPKwPvn7DPdWqsTFBVScPDY9WaYMOqQLqq6+wxEKpQTv
	3kdjT2D6wBG6Z93KZU8nh0tAv1Oyo7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1731394706;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40YRUFJlt6S1W6poVrnNRAeQUnvx+RFpH6nmn561DnU=;
	b=YwY90BSy2HQ37zRtrJD3zuI3zBSgszz/egWdpNT3Mq3yArFOSavyIvYgTZKmN4GuXWrKd0
	R8egC6smso8uDtDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4B0013301;
	Tue, 12 Nov 2024 06:58:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m2BdJpH8Mme6bQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 12 Nov 2024 06:58:25 +0000
Message-ID: <32402888-28ea-436a-b958-7136123f2c0c@suse.de>
Date: Tue, 12 Nov 2024 07:58:25 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] block: Rework bio_split() return value
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
 <20241111112150.3756529-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241111112150.3756529-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 144B21F451
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 11/11/24 12:21, John Garry wrote:
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
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
