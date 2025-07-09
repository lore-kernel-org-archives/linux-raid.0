Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7E1283CAA
	for <linux-raid@vger.kernel.org>; Wed,  9 Jul 2025 09:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752052295; cv=none; b=gQM6yOrmgBQhX2vb4HZEMtpZWBFaRD1llg/ghn08e81w2o8S7iXWXZ7KHBCp2R392O2UuIr7ZI/2U6+uVeQV4ZaJD07C6/WSTAygvLDJ5jM4slkt5fRYhCCWxh9HrTyDlcxbA6tsur+NuYyuiLK6thXRQZE8NfoAxM5VSlJqKA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752052295; c=relaxed/simple;
	bh=xq1srIYBXaKc6X9uXuf9ibsfe+u93QJTpSLKrhAWbgc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAMiveuWvpPoba/V/7C3FHX3/N8kh7Sgc3xoVoYHus6o9rTVOLqSwK1j67liq6Xfnwd65KXNlrk83Ag24wbiSFWPCP/xmif7y4BSIQUVKyGwwCyVeUkeiAPHILO0oBWwjOSBDS2o8inEpljDpsqLIxjI6RBPLXNoPgVgqN1vqdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O4R54ish; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tTvBJH3W; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=O4R54ish; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tTvBJH3W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O4R54ish";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tTvBJH3W";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="O4R54ish";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tTvBJH3W"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 525281F393;
	Wed,  9 Jul 2025 09:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752052286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rDm+uS5mtbJ9ukszmq8aQBxnl6SFtPQ+2CXWTY1j8W8=;
	b=O4R54ishoUjcMjOLLqDZcEeA7g2XHtaK6dbF7AxB1cP2PZi0BdRM8sKZTbIQRon/PCXJsE
	WYt0vo/rCNRbPY5IVRS/hHDAwvfxVaN6tfs2sJnxRAcsa1BSfkYCSJJXl8be7/UyXXbjrf
	C6kQ4SI1kuLTYWT6znK5YUfeY61MgPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752052286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rDm+uS5mtbJ9ukszmq8aQBxnl6SFtPQ+2CXWTY1j8W8=;
	b=tTvBJH3WgSSHBpx3tff0x06D17z5GOiBawCMhZTrvbvcaarIvytME7FWWMS0af775WBYWm
	FPxLnhZc+SjJtYBA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1752052286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rDm+uS5mtbJ9ukszmq8aQBxnl6SFtPQ+2CXWTY1j8W8=;
	b=O4R54ishoUjcMjOLLqDZcEeA7g2XHtaK6dbF7AxB1cP2PZi0BdRM8sKZTbIQRon/PCXJsE
	WYt0vo/rCNRbPY5IVRS/hHDAwvfxVaN6tfs2sJnxRAcsa1BSfkYCSJJXl8be7/UyXXbjrf
	C6kQ4SI1kuLTYWT6znK5YUfeY61MgPQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1752052286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rDm+uS5mtbJ9ukszmq8aQBxnl6SFtPQ+2CXWTY1j8W8=;
	b=tTvBJH3WgSSHBpx3tff0x06D17z5GOiBawCMhZTrvbvcaarIvytME7FWWMS0af775WBYWm
	FPxLnhZc+SjJtYBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DD21136DC;
	Wed,  9 Jul 2025 09:11:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fCxcBj4ybmgTCAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 09 Jul 2025 09:11:26 +0000
Message-ID: <c3724941-7ef2-4593-9ca8-232115a164d2@suse.de>
Date: Wed, 9 Jul 2025 11:11:25 +0200
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
 <9cc88458-5162-42e0-97ab-07ef0c529061@suse.de>
 <CAHW3DrhO0gikFu4Hv6fTAp-xL8jZs5VVikw==w7Msjj7x376ug@mail.gmail.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAHW3DrhO0gikFu4Hv6fTAp-xL8jZs5VVikw==w7Msjj7x376ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/9/25 08:44, 余快 wrote:
> Hi,
> 
> 在 2025/7/8 19:57, Hannes Reinecke 写道:
>> On 7/8/25 13:31, 余快 wrote:
>>> Hi,
>>>
>>> Hannes Reinecke <hare@suse.de <mailto:hare@suse.de>> 于2025年7月8日周二
>>> 14:29写道：
>>>
>>>       > +     if (mddev->bitmap_ops->group && !mddev_is_dm(mddev)) {
>>>       > +             if (sysfs_create_group(&mddev->kobj, mddev-
>>>       >bitmap_ops->group))
>>>       > +                     pr_warn("md: cannot register extra bitmap
>>>      attributes for %s\n",
>>>       > +                             mdname(mddev));
>>>       > +             else
>>>       > +  kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
>>>       > +     }
>>>       >       return true;
>>>       >
>>>       >   err:
>>>
>>>      Ouch. This will cause havoc with the udev rules.
>>>      Having different events for 'add' and 'change' tends to confuse udev
>>>      rules (most treat 'add' and 'change' identically), so at the very
>>> least
>>>      you would need to document this.
>>>
>>>
>>> Do you mean document here as new sysfs entries are created under mddev
>>> kobject?
>>>
>> No, I meant to document that 'add' events will have access to
>> different sysfs attributes than the 'change' events.
>> In the running system one will only see the final status, so it's not
>> immediately obvious that some attributes are only valid for 'change',
>> and not for 'add'.
> 
> Thanks for the explanation, just to make sure you mean:
> 
> diff --git a/Documentation/admin-guide/md.rst
> b/Documentation/admin-guide/md.rst
> index 2030772075b5..db7a39894c8d 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -388,6 +388,9 @@ All md devices contain:
>         bitmap
>             The default internal bitmap
> 
> +If bitmap_type is not none, then additional bitmap attributes will be
> created
> +after md device KOBJ_CHANGE event.
> +
>    If bitmap_type is bitmap, then the md device will also contain:
> 
>      bitmap/location
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 22378686a964..60e2de23c9b5 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -699,6 +699,7 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>                           pr_warn("md: cannot register extra bitmap
> attributes for %s\n",
>                                   mdname(mddev));
>                   else
> +                       /* Inform user with KOBJ_CHANGE about new bitmap
> attributes. */
>                           kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
>           }
>           return true;
> 

Yes, that's what I had in mind.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
