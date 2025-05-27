Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481251E521D
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748327182; cv=none; b=AApcSDuHAmrjhf1gPQ0hpZvfaqvPs5f7jnvxwR0iJwSz6Cnrj/yQl8/fU4hJq9Sc/LSeI61ypG0zlMxHHIxf7iwdhypJUka7ZBaff0GpHlt+WUjx74Etk2Ad7k36nk7Ib2iIXd1HG3j6O6iXCAo3gz2jyBzD3P7wfosRKZy9rgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748327182; c=relaxed/simple;
	bh=iLyCYe9QROBs+4m6nqO1oJwH4OrdSBlzd//QAzkwr3k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sOLzQjajsqnHVXK/zQmrzRW6/So3CqBw5ZLzzifYRbly6F71KVXkJJeCEeiRQU097VQNWYyT3sV0wUusNetIMoyw+xEs1YlrrTCvU6kCNt+dBh3GsBry3ofrnViq7y+Ar8yB2+hKN/cGx5B1aKDiyFOEBsjx2iTRQIM3Qa+fphM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qvgSVqRT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GBiatK3K; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qvgSVqRT; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=GBiatK3K; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qvgSVqRT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GBiatK3K";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qvgSVqRT";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="GBiatK3K"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C77121E79;
	Tue, 27 May 2025 06:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748327179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TTK7udJsipMh50kW+4qAhsXw608B2+GBzr2fRJNy/A=;
	b=qvgSVqRT/Bo8UdNIb6TMXST+o0G15ifG91u8d6CyRpALrCXIpilr4p1Ryyn7Q+Il6Xdq8a
	1Z4FYsQ/lijcoLcAKBx93ZwukbmbDDxCLkC2kSdL3230oU/gY6B16cvI/OmyeVQFxF7yWd
	bi17/vjKxnYK51saWIeKsH8b6NFZj1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748327179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TTK7udJsipMh50kW+4qAhsXw608B2+GBzr2fRJNy/A=;
	b=GBiatK3K6ziM0ebQ5f8UF/L39DfMcxTHhxPoZ0XbS19eeKutnB3PwLk/K9id2km8jxS5ho
	SvrnhxGcSAyOalCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qvgSVqRT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GBiatK3K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748327179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TTK7udJsipMh50kW+4qAhsXw608B2+GBzr2fRJNy/A=;
	b=qvgSVqRT/Bo8UdNIb6TMXST+o0G15ifG91u8d6CyRpALrCXIpilr4p1Ryyn7Q+Il6Xdq8a
	1Z4FYsQ/lijcoLcAKBx93ZwukbmbDDxCLkC2kSdL3230oU/gY6B16cvI/OmyeVQFxF7yWd
	bi17/vjKxnYK51saWIeKsH8b6NFZj1A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748327179;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TTK7udJsipMh50kW+4qAhsXw608B2+GBzr2fRJNy/A=;
	b=GBiatK3K6ziM0ebQ5f8UF/L39DfMcxTHhxPoZ0XbS19eeKutnB3PwLk/K9id2km8jxS5ho
	SvrnhxGcSAyOalCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D35861388B;
	Tue, 27 May 2025 06:26:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +MdVMQpbNWg5HAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:26:18 +0000
Message-ID: <32896f89-f5f9-4aa5-9cd7-d19e4b16e822@suse.de>
Date: Tue, 27 May 2025 08:26:18 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/23] md/dm-raid: remove max_write_behind setting limit
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-15-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-15-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.31 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 5C77121E79
X-Spam-Flag: NO
X-Spam-Score: -3.31
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The comments said 'vaule in kB', while the value actually means the
> number of write_behind IOs. And since md-bitmap will automatically
> adjust the value to max COUNTER_MAX / 2, there is no need to fail
> early.
> 
> Also move some macros that is only used md-bitmap.c.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/dm-raid.c   |  6 +-----
>   drivers/md/md-bitmap.c | 10 ++++++++++
>   drivers/md/md-bitmap.h |  9 ---------
>   3 files changed, 11 insertions(+), 14 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
