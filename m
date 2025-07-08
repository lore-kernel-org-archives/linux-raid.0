Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19171E3DCF
	for <linux-raid@vger.kernel.org>; Tue,  8 Jul 2025 06:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751955785; cv=none; b=heguq5l/x2kNlT54t/1HRrRGWzPHZxbe47rn9j7/EJbi0RcocdthkINGSDwk7eNRqJDzU0my4w8uxVXRkwPkfWMxrt349d7WK/8p4Wwx5ny/1mS0zSfxmUTa9FPNyQ+XTcvsqnhKEFlvMPE8FfotKH0qtlik6pcq8VfVJ7OjiRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751955785; c=relaxed/simple;
	bh=DVUKtc6/HbWXJgaq/nStFh+tCVYx28CR4CkwILgNjDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AqOJ4nmjeyPBf1ffZyGVwqxjwvKw3NkdVuTlcxYAl6Xuzbi1mMYqRl2P9aHujMBaL1BwcLPKR665TKCb0+LqG/Gh3ANjQIi3es1eAqMYof82043W3xg2gz9adj4XMApgix14CHgh+HM/GW224qAxf1g4BIhuyUqbhDIMOK1s7Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AIIDBChY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XtcAyRyd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AIIDBChY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XtcAyRyd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AIIDBChY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XtcAyRyd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AIIDBChY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XtcAyRyd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D4F31F393;
	Tue,  8 Jul 2025 06:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751955782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVISJUhnhtW9LCo5XcUdD3hSIQ2Q6+/VEhWfHNDO6yU=;
	b=AIIDBChYAowp/uppmt1ira8xfizlTIjurHKfHUh98QTYIeWzHTCJ+n0Tul/Ut5inpY9Evw
	H8ApVuiL/Y9/KaER10ilZEWr+pGuj8Kdhac8RT54qWml2HefttHG9K5P7vL+et3UuYljtU
	ldlLdXfmR/k6HyfXTYaZ3pMbYpVta3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751955782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVISJUhnhtW9LCo5XcUdD3hSIQ2Q6+/VEhWfHNDO6yU=;
	b=XtcAyRydYpHXSORyYsxJzfQqK12543KAikXljkazcsTvyW/0SCU5CeZ13raYGOn8VFrmMx
	VoJTWfpSqmyF4ADw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751955782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVISJUhnhtW9LCo5XcUdD3hSIQ2Q6+/VEhWfHNDO6yU=;
	b=AIIDBChYAowp/uppmt1ira8xfizlTIjurHKfHUh98QTYIeWzHTCJ+n0Tul/Ut5inpY9Evw
	H8ApVuiL/Y9/KaER10ilZEWr+pGuj8Kdhac8RT54qWml2HefttHG9K5P7vL+et3UuYljtU
	ldlLdXfmR/k6HyfXTYaZ3pMbYpVta3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751955782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eVISJUhnhtW9LCo5XcUdD3hSIQ2Q6+/VEhWfHNDO6yU=;
	b=XtcAyRydYpHXSORyYsxJzfQqK12543KAikXljkazcsTvyW/0SCU5CeZ13raYGOn8VFrmMx
	VoJTWfpSqmyF4ADw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C441B13A68;
	Tue,  8 Jul 2025 06:23:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nus3LkW5bGgaMAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 06:23:01 +0000
Message-ID: <6a143dc0-97ef-4e2b-81ce-055e0204b02f@suse.de>
Date: Tue, 8 Jul 2025 08:23:01 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] md: add a new mddev field 'bitmap_id'
To: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-5-yukuai@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250707165202.11073-5-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/7/25 18:51, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Prepare to store the bitmap id selected by user, also refactor
> mddev_set_bitmap_ops a bit in case the value is invalid.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 37 +++++++++++++++++++++++++++++++------
>   drivers/md/md.h |  2 ++
>   2 files changed, 33 insertions(+), 6 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
