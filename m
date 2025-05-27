Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCCA1D5160
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326443; cv=none; b=bv7RkwR45GxgPERMnijfesZftSj2CzA3wH4wnzhRTAxmVGzUmzWKLGiDNobuxJKrDnPdLlB/RqnK7vnAsnZH6S2dWIAuhbaUq5La8cfxV0lldTZfCAvevrgN0Qc6nCQaHnZsAdFv4KlxDj0Ds5ja0JVbqXRovJGeFPbdPVXzHik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326443; c=relaxed/simple;
	bh=2eaNttKujiKGW1XShMkechFjiaDuppInGmPF27D6Ywc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b/6GCQ4HbzRagrgrfNwbfy4KrJpeFtJ6o8yo3ReJ1vuNps55xqjWvWCHKFHLnw+KMyN0vM5rmtJ56KwnAs9NOUG1Zrz1rAY516LPkJkvefBmAA3jYcKm+id7IQ7oLoDlB5NLLStN72lypX2ziFnVX6G+W1sFpdu5XqS6Z2yX3rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TQI94fB1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xyVtmZR4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TQI94fB1; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xyVtmZR4; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TQI94fB1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xyVtmZR4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TQI94fB1";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xyVtmZR4"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3849321ED7;
	Tue, 27 May 2025 06:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT6IVgx3sFelFM6RQIZn6bhZsyZyJ5oSi/3nCI6sDPI=;
	b=TQI94fB1d7wCBjoqpteZlzowl3yHcMdGI5W2QKUbp/zpVGcfMyzWiTRfapGSHujM7c34vK
	0gnlAyr6R0wttSUgCm3NxpEvblS3CV7vU+sHsblmsZB58BbC8aKP/ju3GXa4N6b57nJy8z
	5E40JfnOXQISxerAXyZAFWwnIHE58gQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT6IVgx3sFelFM6RQIZn6bhZsyZyJ5oSi/3nCI6sDPI=;
	b=xyVtmZR4qtj26xWbEceuKitNfwkB47ww9sHka2/MaYlXNKSy+75lOxTRYiuzj84EyygD5B
	bJvnFVyj5GDHbUCg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=TQI94fB1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xyVtmZR4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT6IVgx3sFelFM6RQIZn6bhZsyZyJ5oSi/3nCI6sDPI=;
	b=TQI94fB1d7wCBjoqpteZlzowl3yHcMdGI5W2QKUbp/zpVGcfMyzWiTRfapGSHujM7c34vK
	0gnlAyr6R0wttSUgCm3NxpEvblS3CV7vU+sHsblmsZB58BbC8aKP/ju3GXa4N6b57nJy8z
	5E40JfnOXQISxerAXyZAFWwnIHE58gQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hT6IVgx3sFelFM6RQIZn6bhZsyZyJ5oSi/3nCI6sDPI=;
	b=xyVtmZR4qtj26xWbEceuKitNfwkB47ww9sHka2/MaYlXNKSy+75lOxTRYiuzj84EyygD5B
	bJvnFVyj5GDHbUCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85E95136E0;
	Tue, 27 May 2025 06:13:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UaCrHiRYNWilGAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:13:56 +0000
Message-ID: <d2fabdfd-229d-4043-ad27-61bac1e1f6d2@suse.de>
Date: Tue, 27 May 2025 08:13:56 +0200
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
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-8-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-8-yukuai1@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,huawei.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 3849321ED7
X-Spam-Flag: NO
X-Spam-Score: -3.31
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently bitmap_ops is registered while allocating mddev, this is fine
> when there is only one bitmap_ops, however, after introduing a new
> bitmap_ops, user space need a time window to choose which bitmap_ops to
> use while creating new array.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 86 +++++++++++++++++++++++++++++++------------------
>   1 file changed, 55 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4eb0c6effd5b..dc4b85f30e13 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -674,39 +674,50 @@ static void no_op(struct percpu_ref *r) {}
>   
>   static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   {
> +	struct bitmap_operations *old = mddev->bitmap_ops;
> +	struct md_submodule_head *head;
> +
> +	if (mddev->bitmap_id == ID_BITMAP_NONE ||
> +	    (old && old->head.id == mddev->bitmap_id))
> +		return true;
> +
>   	xa_lock(&md_submodule);
> -	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
> +	head = xa_load(&md_submodule, mddev->bitmap_id);
>   	xa_unlock(&md_submodule);
>   
> -	if (!mddev->bitmap_ops) {
> -		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
> +	if (WARN_ON_ONCE(!head || head->type != MD_BITMAP)) {
> +		pr_err("md: can't find bitmap id %d\n", mddev->bitmap_id);
>   		return false;
>   	}
>   
> +	if (old && old->group)
> +		sysfs_remove_group(&mddev->kobj, old->group);
> +
> +	mddev->bitmap_ops = (void *)head;
> +	if (mddev->bitmap_ops && mddev->bitmap_ops->group &&
> +	    sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> +		pr_warn("md: cannot register extra bitmap attributes for %s\n",
> +			mdname(mddev));
> +
>   	return true;
>   }
>   
>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>   {
> +	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
> +		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
> +
>   	mddev->bitmap_ops = NULL;
>   }
>   
>   int mddev_init(struct mddev *mddev)
>   {
> -	mddev->bitmap_id = ID_BITMAP;
> -
> -	if (!mddev_set_bitmap_ops(mddev))
> -		return -EINVAL;
> -
>   	if (percpu_ref_init(&mddev->active_io, active_io_release,
> -			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		mddev_clear_bitmap_ops(mddev);
> +			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
>   		return -ENOMEM;
> -	}
>   
>   	if (percpu_ref_init(&mddev->writes_pending, no_op,
>   			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		mddev_clear_bitmap_ops(mddev);
>   		percpu_ref_exit(&mddev->active_io);
>   		return -ENOMEM;
>   	}
> @@ -734,6 +745,7 @@ int mddev_init(struct mddev *mddev)
>   	mddev->resync_min = 0;
>   	mddev->resync_max = MaxSector;
>   	mddev->level = LEVEL_NONE;
> +	mddev->bitmap_id = ID_BITMAP;
>   
>   	INIT_WORK(&mddev->sync_work, md_start_sync);
>   	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> @@ -744,7 +756,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
>   
>   void mddev_destroy(struct mddev *mddev)
>   {
> -	mddev_clear_bitmap_ops(mddev);
>   	percpu_ref_exit(&mddev->active_io);
>   	percpu_ref_exit(&mddev->writes_pending);
>   }
> @@ -6093,11 +6104,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
>   		return ERR_PTR(error);
>   	}
>   
> -	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
> -		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> -			pr_warn("md: cannot register extra bitmap attributes for %s\n",
> -				mdname(mddev));
> -
>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>   	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
>   	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");

But now you've killed udev event processing.
Once the 'add' event is sent _all_ sysfs attributes must be present,
otherwise you'll have a race condition where udev is checking for
attributes which are present only later.

So when moving things around ensure to move the kobject_uevent() call, too.

(ideally you would set the sysfs attributes when calling 'add_device()',
but not sure if that's possible here.)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
