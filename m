Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0D71EE017
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326215; cv=none; b=i18DBKOg+GFhr7niGNkNY4SY7JkJgZXkx5EXacfOiBpOeD0u6F3j/LcwT+EYqJsG91oxMDcwnFEoyxdED9hlVmef0F92zaORDAgQi786OqmmUcOuW/CDxWeoHbouy9wwWB+817lkD7GSk8Ig05csx+ZBmmWdb4kCkVDiasje5C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326215; c=relaxed/simple;
	bh=eI4C9G5xJzpBpNASfpC2+tN2SrDq2IXni/3Kbzv9u7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rUXC5FUEeF4G6XpBz6u1I3aTepMsDs81ILLpkz1BJ5NE4wK5xMmUXR+WzFjA3viw2qq1fAfNl5+vnoFj+Ik4b9scvuiS09UCb3WM7et2RCgCDt+/NQPo+2w9o7gDbbLMnIgYUVzeq/PE07nyU08CgOK8pMa/r60/LzTGEiXu+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Buo/oC0y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3AMFIqmR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Buo/oC0y; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3AMFIqmR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Buo/oC0y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3AMFIqmR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Buo/oC0y";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3AMFIqmR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 84FE121E79;
	Tue, 27 May 2025 06:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LzbgYeMiACS2U3RQ6hcLbsfyT0tPPC71RPXXgfPSUik=;
	b=Buo/oC0yeazYNNpmu1E/rP62D5tdOEXSEbL0Rc/4oO8utdY3mpjE9tTAJfOsd8KwXCk1eC
	iDnqaAe9gjjNVPeNN+XpdAfA3vFo6hNSz3ZvEDEZjdOXi6g2EqujjLGkBL79ZUQAE/HtVb
	bEeE9Kj/FP9mJsvTj3CpTk8jMelNqZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LzbgYeMiACS2U3RQ6hcLbsfyT0tPPC71RPXXgfPSUik=;
	b=3AMFIqmR2GrtSlhTTSn9edGSb6pJKOLw3FM+ygxMdfNRIJ11xzruPKCPnWVrReuGc/AljY
	tvXizJiiyZytQeAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Buo/oC0y";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3AMFIqmR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LzbgYeMiACS2U3RQ6hcLbsfyT0tPPC71RPXXgfPSUik=;
	b=Buo/oC0yeazYNNpmu1E/rP62D5tdOEXSEbL0Rc/4oO8utdY3mpjE9tTAJfOsd8KwXCk1eC
	iDnqaAe9gjjNVPeNN+XpdAfA3vFo6hNSz3ZvEDEZjdOXi6g2EqujjLGkBL79ZUQAE/HtVb
	bEeE9Kj/FP9mJsvTj3CpTk8jMelNqZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326211;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LzbgYeMiACS2U3RQ6hcLbsfyT0tPPC71RPXXgfPSUik=;
	b=3AMFIqmR2GrtSlhTTSn9edGSb6pJKOLw3FM+ygxMdfNRIJ11xzruPKCPnWVrReuGc/AljY
	tvXizJiiyZytQeAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE7A0136E0;
	Tue, 27 May 2025 06:10:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xLnHLEJXNWinFwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:10:10 +0000
Message-ID: <23b75e25-fa2f-4d12-8d96-6de01e43ad49@suse.de>
Date: Tue, 27 May 2025 08:10:10 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-7-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-7-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.51 / 50.00];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLf34csc5ba3ztc71of6h9nuns)];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,huawei.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 84FE121E79
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -1.51

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The api will be used by mdadm to set bitmap_ops while creating new array
> or assemble array, prepare to add a new bitmap.
> 
> Currently available options are:
> 
> cat /sys/block/md0/md/bitmap_type
> none [bitmap]
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   Documentation/admin-guide/md.rst | 73 ++++++++++++++----------
>   drivers/md/md.c                  | 96 ++++++++++++++++++++++++++++++--
>   drivers/md/md.h                  |  2 +
>   3 files changed, 135 insertions(+), 36 deletions(-)
> 
[ .. ]
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 311e52d5173d..4eb0c6effd5b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -672,13 +672,18 @@ static void active_io_release(struct percpu_ref *ref)
>   
>   static void no_op(struct percpu_ref *r) {}
>   
> -static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
> +static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   {
>   	xa_lock(&md_submodule);
> -	mddev->bitmap_ops = xa_load(&md_submodule, id);
> +	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
>   	xa_unlock(&md_submodule);
> -	if (!mddev->bitmap_ops)
> -		pr_warn_once("md: can't find bitmap id %d\n", id);
> +
> +	if (!mddev->bitmap_ops) {
> +		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
> +		return false;
> +	}
> +
> +	return true;
>   }
>   
>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
> @@ -688,8 +693,10 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
>   
>   int mddev_init(struct mddev *mddev)
>   {
> -	/* TODO: support more versions */
> -	mddev_set_bitmap_ops(mddev, ID_BITMAP);
> +	mddev->bitmap_id = ID_BITMAP;
> +
> +	if (!mddev_set_bitmap_ops(mddev))
> +		return -EINVAL;
>   
>   	if (percpu_ref_init(&mddev->active_io, active_io_release,
>   			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> @@ -4155,6 +4162,82 @@ new_level_store(struct mddev *mddev, const char *buf, size_t len)
>   static struct md_sysfs_entry md_new_level =
>   __ATTR(new_level, 0664, new_level_show, new_level_store);
>   
> +static ssize_t
> +bitmap_type_show(struct mddev *mddev, char *page)
> +{
> +	struct md_submodule_head *head;
> +	unsigned long i;
> +	ssize_t len = 0;
> +
> +	if (mddev->bitmap_id == ID_BITMAP_NONE)
> +		len += sprintf(page + len, "[none] ");
> +	else
> +		len += sprintf(page + len, "none ");
> +
> +	xa_lock(&md_submodule);
> +	xa_for_each(&md_submodule, i, head) {
> +		if (head->type != MD_BITMAP)
> +			continue;
> +
> +		if (mddev->bitmap_id == head->id)
> +			len += sprintf(page + len, "[%s] ", head->name);
> +		else
> +			len += sprintf(page + len, "%s ", head->name);
> +	}
> +	xa_unlock(&md_submodule);
> +
> +	len += sprintf(page + len, "\n");
> +	return len;
> +}
> +
> +static ssize_t
> +bitmap_type_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +	struct md_submodule_head *head;
> +	enum md_submodule_id id;
> +	unsigned long i;
> +	int err;
> +
> +	if (mddev->bitmap_ops)
> +		return -EBUSY;
> +
Why isn't this protected by md_submodule lock?
The lock is taken when updating ->bitmap_ops, so I would
have expected it to be taken when checking it ...

> +	err = kstrtoint(buf, 10, &id);
> +	if (!err) {
> +		if (id == ID_BITMAP_NONE) {
> +			mddev->bitmap_id = id;
> +			return len;
> +		}
> +
> +		xa_lock(&md_submodule);
> +		head = xa_load(&md_submodule, id);
> +		xa_unlock(&md_submodule);
> +
> +		if (head && head->type == MD_BITMAP) {
> +			mddev->bitmap_id = id;
> +			return len;
> +		}
> +	}
> +
> +	if (cmd_match(buf, "none")) {
> +		mddev->bitmap_id = ID_BITMAP_NONE;
> +		return len;
> +	}
> +
That is odd coding. The 'if (!err)' condition above might
fall through to here, but then we already now that it cannot
match 'none'.
Please invert the logic, first check for 'none', and only
call kstroint if the match failed.

> +	xa_lock(&md_submodule);
> +	xa_for_each(&md_submodule, i, head) {
> +		if (head->type == MD_BITMAP && cmd_match(buf, head->name)) {
> +			mddev->bitmap_id = head->id;
> +			xa_unlock(&md_submodule);
> +			return len;
> +		}
> +	}
> +	xa_unlock(&md_submodule);
> +	return -ENOENT;
> +}
> +
> +static struct md_sysfs_entry md_bitmap_type =
> +__ATTR(bitmap_type, 0664, bitmap_type_show, bitmap_type_store);
> +
>   static ssize_t
>   layout_show(struct mddev *mddev, char *page)
>   {
> @@ -5719,6 +5802,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>   static struct attribute *md_default_attrs[] = {
>   	&md_level.attr,
>   	&md_new_level.attr,
> +	&md_bitmap_type.attr,
>   	&md_layout.attr,
>   	&md_raid_disks.attr,
>   	&md_uuid.attr,
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 13e3f9ce1b79..bf34c0a36551 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -40,6 +40,7 @@ enum md_submodule_id {
>   	ID_CLUSTER,
>   	ID_BITMAP,
>   	ID_LLBITMAP,	/* TODO */
> +	ID_BITMAP_NONE,
>   };
>   
>   struct md_submodule_head {
> @@ -565,6 +566,7 @@ struct mddev {
>   	struct percpu_ref		writes_pending;
>   	int				sync_checkers;	/* # of threads checking writes_pending */
>   
> +	enum md_submodule_id		bitmap_id;
>   	void				*bitmap; /* the bitmap for the device */
>   	struct bitmap_operations	*bitmap_ops;
>   	struct {

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
