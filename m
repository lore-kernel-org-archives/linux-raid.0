Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4524A049
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 08:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336045; cv=none; b=lHWwI8xFFBTpkve9ZSJYLr293nFPvBP26UyghVlR/h+Mk4Q1bTKJonWyI6ZfJpS6fPv6cigpKXQi4nG+bvkLfw9tWyt22PC9EuxS6LAVZVrZSxCAxBvAh/3wFY36afR2bwSXpFu2DpzAbf1P5WSFo3ISjMEtJO1ZmBt73YXSPG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336045; c=relaxed/simple;
	bh=XF5VzNvpeKGlQPwfHqmEm5o0Bq1rCBURjliIbksP/e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFQeNQXYn7jzCO7W/v7x9tSAqBDkwD9f/ISYDwSLgwxiqZV+bTaWUiENMznpy9Jvc+mb6wcCPpxyXqy+O4QuBfhfsMxOEzABKL8OYgZ5gIucN429VaGJJuTRCx/rG7iLl2DjWejpl2rC9Hp0RUpHT4ZG9lLsyhVPFago6MkSf74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kUS6EvQK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=77nFOA09; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kUS6EvQK; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=77nFOA09; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kUS6EvQK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="77nFOA09";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kUS6EvQK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="77nFOA09"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 49B8421A21;
	Tue, 27 May 2025 08:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748336041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1uFQ6WQesoTLzcyfD02l0QPHNSPhDb59xUd8IZZfyQM=;
	b=kUS6EvQK08gjvUAwJMu9nzib34qgXcyY+Ek6VIZ10FYCSgapJPAcrUhQQQ9jVX4A5LEK/M
	XctTJxELBEHjkXAXuuKKMtZC1vkFMeNHNxaxcyC79falwqjUwnjukXcisaHJichpiiWCjr
	Fz7xQHbR8iex+h0YH59ap4/IsoOmoeg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748336041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1uFQ6WQesoTLzcyfD02l0QPHNSPhDb59xUd8IZZfyQM=;
	b=77nFOA09xZOr8vwKXTWIgx4RlVM9tLjb2RMwNQq4zXUps3bfJIQn8Y3AmMCtO0yIoedoon
	oGC1Hw8Af3Fk6aCw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kUS6EvQK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=77nFOA09
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748336041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1uFQ6WQesoTLzcyfD02l0QPHNSPhDb59xUd8IZZfyQM=;
	b=kUS6EvQK08gjvUAwJMu9nzib34qgXcyY+Ek6VIZ10FYCSgapJPAcrUhQQQ9jVX4A5LEK/M
	XctTJxELBEHjkXAXuuKKMtZC1vkFMeNHNxaxcyC79falwqjUwnjukXcisaHJichpiiWCjr
	Fz7xQHbR8iex+h0YH59ap4/IsoOmoeg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748336041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1uFQ6WQesoTLzcyfD02l0QPHNSPhDb59xUd8IZZfyQM=;
	b=77nFOA09xZOr8vwKXTWIgx4RlVM9tLjb2RMwNQq4zXUps3bfJIQn8Y3AmMCtO0yIoedoon
	oGC1Hw8Af3Fk6aCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C177B1388B;
	Tue, 27 May 2025 08:54:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q1XCLqh9NWiPTAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 08:54:00 +0000
Message-ID: <25c23f9d-4fa0-4cad-9c96-43c25e018113@suse.de>
Date: Tue, 27 May 2025 10:54:00 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/23] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-8-yukuai1@huaweicloud.com>
 <d2fabdfd-229d-4043-ad27-61bac1e1f6d2@suse.de>
 <d95b41a0-c1aa-8b8b-d959-05e41eee3a7f@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <d95b41a0-c1aa-8b8b-d959-05e41eee3a7f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 49B8421A21
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.51

On 5/27/25 09:53, Yu Kuai wrote:
> Hi,
> 
> 在 2025/05/27 14:13, Hannes Reinecke 写道:
>> On 5/24/25 08:13, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> Currently bitmap_ops is registered while allocating mddev, this is fine
>>> when there is only one bitmap_ops, however, after introduing a new
>>> bitmap_ops, user space need a time window to choose which bitmap_ops to
>>> use while creating new array.
>>>
[ .. ]
>>> @@ -6093,11 +6104,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
>>>           return ERR_PTR(error);
>>>       }
>>> -    if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
>>> -        if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
>>> -            pr_warn("md: cannot register extra bitmap attributes for 
>>> %s\n",
>>> -                mdname(mddev));
>>> -
>>>       kobject_uevent(&mddev->kobj, KOBJ_ADD);
>>>       mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, 
>>> "array_state");
>>>       mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, 
>>> "level");
>>
>> But now you've killed udev event processing.
>> Once the 'add' event is sent _all_ sysfs attributes must be present,
>> otherwise you'll have a race condition where udev is checking for
>> attributes which are present only later.
>>
>> So when moving things around ensure to move the kobject_uevent() call, 
>> too.
> 
> I do not expect the bitmap entries are checked by udev, otherwise this
> set can introduce regressions since the bitmap entries are no longer
> existed after using the new biltmap.
> 
> And the above KOBJ_ADD uevent is used for mddev->kobj, right? In this
> case, we're creating new entries under mddev->kobj, should this be
> KOBJ_CHANGE?
> 
Yes, please.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
