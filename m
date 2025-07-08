Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D441DE8B5
	for <linux-raid@vger.kernel.org>; Tue,  8 Jul 2025 06:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751956153; cv=none; b=cBESPs5TThRnrKliDzgX0KqjlCE/wWqZV4tXw7IIykLudutVCf73Wc303lwSghAwzHSHSNOGTfUPHMZjKA21a7lmb1OABKZD8TCCyVAwrimFcfcKV5cZMw0+IoyggjNi7M5AFBYtCIPbglMjxmleKfdMxj6I3L5g6tCVrO/0LEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751956153; c=relaxed/simple;
	bh=PyvlMDPADjGC+xhH71l8P/3Nb6XgKkbcxrQ79QVKHzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bigfopJ4WDsflGFm2kPLGPadc7dj2ZsYHJtQgk5ztUGIkubXivXQg9gLpyv7GLhSEHAhzQcG18FMOlPsv5/ha9Qjf5K9z9FwNcNAzbBhlwFX42nJqmk6Wmk2sF+1Pa40rh0T3hBKlhS65J9XBGa0ufaA/8OElhoYOg4/W5iyfgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JSeXqReM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Jb44HHQF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JSeXqReM; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Jb44HHQF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JSeXqReM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Jb44HHQF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JSeXqReM";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Jb44HHQF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C91E21164;
	Tue,  8 Jul 2025 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751956142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwrODoUEtN+bfHM40liIEJNwF5cYta7coCfWXqbCMQA=;
	b=JSeXqReM8O7X1LoCFBAKJCpntkca3RC/eKqgKBNmS03ffoylS7GOngqIsK0J6+KmrUgvKi
	7DSNtarUkStk6T1CAnMfwmALsazLRW/pxtFJis0Yb8LAudVeOxHKYhdmaNkLYZ14Y6qda8
	0Ff3hhpTX2X11stFDOyZBTn6tkpNw9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751956142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwrODoUEtN+bfHM40liIEJNwF5cYta7coCfWXqbCMQA=;
	b=Jb44HHQFwpzS4lzznxFmHykxtP5W0LPl2L0+RWHFwSeMje0Kl8Oruj4E/zqgARFxhQ8/sR
	OQNBCxUnEdsralDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JSeXqReM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Jb44HHQF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751956142; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwrODoUEtN+bfHM40liIEJNwF5cYta7coCfWXqbCMQA=;
	b=JSeXqReM8O7X1LoCFBAKJCpntkca3RC/eKqgKBNmS03ffoylS7GOngqIsK0J6+KmrUgvKi
	7DSNtarUkStk6T1CAnMfwmALsazLRW/pxtFJis0Yb8LAudVeOxHKYhdmaNkLYZ14Y6qda8
	0Ff3hhpTX2X11stFDOyZBTn6tkpNw9Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751956142;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwrODoUEtN+bfHM40liIEJNwF5cYta7coCfWXqbCMQA=;
	b=Jb44HHQFwpzS4lzznxFmHykxtP5W0LPl2L0+RWHFwSeMje0Kl8Oruj4E/zqgARFxhQ8/sR
	OQNBCxUnEdsralDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C785713A68;
	Tue,  8 Jul 2025 06:29:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id t2NqLq26bGiyMQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 06:29:01 +0000
Message-ID: <4ef10fad-03cf-4fc3-90c4-13fd31dd19c0@suse.de>
Date: Tue, 8 Jul 2025 08:29:01 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-7-yukuai@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250707165202.11073-7-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 3C91E21164
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Score: -4.51

On 7/7/25 18:51, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently bitmap_ops is registered while allocating mddev, this is fine
> when there is only one bitmap_ops.
> 
> Delay setting bitmap_ops until creating bitmap, so that user can choose
> which bitmap to use before running the array.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 79 +++++++++++++++++++++++++++++++------------------
>   1 file changed, 50 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 41da352ccbde..1a60932516bc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -671,9 +671,11 @@ static void no_op(struct percpu_ref *r) {}
>   
>   static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   {
> +	struct bitmap_operations *old = mddev->bitmap_ops;
>   	struct md_submodule_head *head;
>   
> -	if (mddev->bitmap_id == ID_BITMAP_NONE)
> +	if (mddev->bitmap_id == ID_BITMAP_NONE ||
> +	    (old && old->head.id == mddev->bitmap_id))
>   		return true;
>   
>   	xa_lock(&md_submodule);
> @@ -691,6 +693,14 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   
>   	mddev->bitmap_ops = (void *)head;
>   	xa_unlock(&md_submodule);
> +
> +	if (mddev->bitmap_ops->group && !mddev_is_dm(mddev)) {
> +		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> +			pr_warn("md: cannot register extra bitmap attributes for %s\n",
> +				mdname(mddev));
> +		else
> +			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
> +	}
>   	return true;
>   
>   err:

Ouch. This will cause havoc with the udev rules.
Having different events for 'add' and 'change' tends to confuse udev
rules (most treat 'add' and 'change' identically), so at the very least
you would need to document this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
