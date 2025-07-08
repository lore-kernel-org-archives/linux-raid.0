Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D5D2D9ECB
	for <linux-raid@vger.kernel.org>; Tue,  8 Jul 2025 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751975847; cv=none; b=WHsyRwZRUZbQ7quPYynYgXZz5Q10Gd78KdUAj/vBosd8RQmEbBEImJSOmveAmOQK9Rmjz5NKgLEeMZBKuePwclknCoUu7R/Qm/SpO33gHz9kiCINjsZ23zT6Cs6LXTxIs69f3uMKFIdWopSGmw7Pm8qNojBTMkv+lJ9RyqEeyNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751975847; c=relaxed/simple;
	bh=UttwhI//ptEU2U1wtkxFAZD8t2U4Uiph33//eUFJ9Uo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FcfrjHTFnkaUyHGtWaaRr5TftX1CkSWu2BKKW7WuID8tNa0k0v5MVOJleXs70p9AMLQ74yXq6n/mUxrjI/R3A+BnAOYc3M2tj49/uNViNKNdbQjNoVOKNuhe/R14j2vTgHkhllTv7nqkZ5FbGKRRz+OqMkg4ZFeunxPH0qVNSZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BUsdOB9U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ghL5ryVt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BUsdOB9U; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ghL5ryVt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BUsdOB9U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ghL5ryVt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BUsdOB9U";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ghL5ryVt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BD63C2117F;
	Tue,  8 Jul 2025 11:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751975842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PQMfFflf8nsyy+MeTF8T4e9L5VzuPm71CRjVX0nTeE=;
	b=BUsdOB9UC7cMGU89K2VycklNf60fhuMdjbkZQApRNyg9P8s8UTOwXNtStl3KpgECjdU1PQ
	V7qyTRuigj79ypp7V9uDF31dagx6IDf5fJLOLf8eXeFDanG72yJspblHHhG4U17JtDtmWc
	oeLxmk1dv7+pIvTR56wDjmBpYpBUTLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751975842;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PQMfFflf8nsyy+MeTF8T4e9L5VzuPm71CRjVX0nTeE=;
	b=ghL5ryVtshfPjDCKtzFRbWLRweOYxmCwdzgTboSVOnbzz6reIdKMcsc6VG/YcnvGBecN52
	mMb7TbZVUgC6dqCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BUsdOB9U;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ghL5ryVt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751975842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PQMfFflf8nsyy+MeTF8T4e9L5VzuPm71CRjVX0nTeE=;
	b=BUsdOB9UC7cMGU89K2VycklNf60fhuMdjbkZQApRNyg9P8s8UTOwXNtStl3KpgECjdU1PQ
	V7qyTRuigj79ypp7V9uDF31dagx6IDf5fJLOLf8eXeFDanG72yJspblHHhG4U17JtDtmWc
	oeLxmk1dv7+pIvTR56wDjmBpYpBUTLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751975842;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PQMfFflf8nsyy+MeTF8T4e9L5VzuPm71CRjVX0nTeE=;
	b=ghL5ryVtshfPjDCKtzFRbWLRweOYxmCwdzgTboSVOnbzz6reIdKMcsc6VG/YcnvGBecN52
	mMb7TbZVUgC6dqCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 933F513A70;
	Tue,  8 Jul 2025 11:57:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cBIlI6IHbWj1GQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 11:57:22 +0000
Message-ID: <9cc88458-5162-42e0-97ab-07ef0c529061@suse.de>
Date: Tue, 8 Jul 2025 13:57:22 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: =?UTF-8?B?5L2Z5b+r?= <yukuai1994@gmail.com>
Cc: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
 yangerkun@huawei.com, yi.zhang@huawei.com, johnny.chenyi@huawei.com
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-7-yukuai@kernel.org>
 <4ef10fad-03cf-4fc3-90c4-13fd31dd19c0@suse.de>
 <CAHW3DrjVM-yb-U==ZfR3k9ZS7qSpqY4ASch7qqhP2zquTdSS2w@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAHW3DrjVM-yb-U==ZfR3k9ZS7qSpqY4ASch7qqhP2zquTdSS2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: BD63C2117F
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.51

On 7/8/25 13:31, 余快 wrote:
> Hi,
> 
> Hannes Reinecke <hare@suse.de <mailto:hare@suse.de>> 于2025年7月8日周二 
> 14:29写道：
> 
>      > +     if (mddev->bitmap_ops->group && !mddev_is_dm(mddev)) {
>      > +             if (sysfs_create_group(&mddev->kobj, mddev-
>      >bitmap_ops->group))
>      > +                     pr_warn("md: cannot register extra bitmap
>     attributes for %s\n",
>      > +                             mdname(mddev));
>      > +             else
>      > +                     kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
>      > +     }
>      >       return true;
>      >
>      >   err:
> 
>     Ouch. This will cause havoc with the udev rules.
>     Having different events for 'add' and 'change' tends to confuse udev
>     rules (most treat 'add' and 'change' identically), so at the very least
>     you would need to document this.
> 
> 
> Do you mean document here as new sysfs entries are created under mddev
> kobject?
> 
No, I meant to document that 'add' events will have access to different 
sysfs attributes than the 'change' events.
In the running system one will only see the final status, so it's not
immediately obvious that some attributes are only valid for 'change',
and not for 'add'.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
