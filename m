Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAB419F416
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326672; cv=none; b=X7O/ipM0cEF085Y6oKU8LhZ5u09iCGALgrH0JXVfRtm1msxkFZBkveq9RMn7MLX+1RzZ708P8HEeXGQmO7sGOsR5on68Zwq9wsvBxtVeDOTer08pS5qYdaYaGu8M813BkJdSDAw9XVAYNzruyxFgSJJ1yZrUCpXEUvWoRIzubso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326672; c=relaxed/simple;
	bh=Vbp1YOl2MniHpPkdu6PShuqEZK8C2oWfnJe4IEdL6As=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pHaJHkC0EYjWDR4wyAMZ6N6kC628+ehJlvD55jjFiWeLLCt/MmVsRWov0kzts8JmQ16mCTK0mx17GjQiqyfKSqZOXoKRxDssUEp4eKvG1kadRU/stle1szAGHzcYOspIH6ZFkyIsdJhJNAtrryDyIC4ccSSGiv3XwlmUF92kilA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X3c3VlQI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sG6DU/f7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=X3c3VlQI; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sG6DU/f7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X3c3VlQI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sG6DU/f7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="X3c3VlQI";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sG6DU/f7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12CC621F0B;
	Tue, 27 May 2025 06:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLETFTnrSMu3fw8ZbRIEVTmVKLtfAdhphoeg6Y8jc1A=;
	b=X3c3VlQI0QIebB3WQqLEeBo7Ra4zBYSRlVtCTN2CgKwt40E+ZgdMWp4WJyE/JOrqBrkH23
	nh3r58kRyrHLo6Uql2lVQdzI1qGp4YN02fcGj3HNTDBFTtiYhczG/hGqWK9Tp7fnliu9+X
	DEqS2kFb7t5NnT508YJH1RLrtf1pbCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLETFTnrSMu3fw8ZbRIEVTmVKLtfAdhphoeg6Y8jc1A=;
	b=sG6DU/f7iMdeCsA8F8F251IzlBP6P9JHCHRIqjrqC9zZKqShdLoJ7iIgjUzRI5GEizLMjm
	hRDpelXp13uECpDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=X3c3VlQI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="sG6DU/f7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLETFTnrSMu3fw8ZbRIEVTmVKLtfAdhphoeg6Y8jc1A=;
	b=X3c3VlQI0QIebB3WQqLEeBo7Ra4zBYSRlVtCTN2CgKwt40E+ZgdMWp4WJyE/JOrqBrkH23
	nh3r58kRyrHLo6Uql2lVQdzI1qGp4YN02fcGj3HNTDBFTtiYhczG/hGqWK9Tp7fnliu9+X
	DEqS2kFb7t5NnT508YJH1RLrtf1pbCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OLETFTnrSMu3fw8ZbRIEVTmVKLtfAdhphoeg6Y8jc1A=;
	b=sG6DU/f7iMdeCsA8F8F251IzlBP6P9JHCHRIqjrqC9zZKqShdLoJ7iIgjUzRI5GEizLMjm
	hRDpelXp13uECpDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DA3C136E0;
	Tue, 27 May 2025 06:17:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eXI6FQxZNWjgGQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:17:48 +0000
Message-ID: <d41f0296-45b9-4264-adc8-f41601b36edd@suse.de>
Date: Tue, 27 May 2025 08:17:47 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/23] md: add a new recovery_flag
 MD_RECOVERY_LAZY_RECOVER
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-11-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-11-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.31 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,lst.de:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 12CC621F0B
X-Spam-Flag: NO
X-Spam-Score: -3.31
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This flag is used by llbitmap in later patches to skip raid456 initial
> recover and delay building initial xor data to first write.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md.c | 12 +++++++++++-
>   drivers/md/md.h |  2 ++
>   2 files changed, 13 insertions(+), 1 deletion(-)
> 
Wouldn't it be enough to check for the 'blocks_synced' callback to check
if the array supports lazy recovery?

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
