Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4364A22EF5
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326893; cv=none; b=BF+UjZoj+whm+pnwGXMwY75VXHAEJcsaFfEm/dIEdB1BG9B0Xeee2xvEN+AAHLBYEi+LhqdPYKyobmrNklrqYF5PCgKhi9UET02hDMqQcOTeu+qj85ya7SFBIoVO70r6BFtfcAWoF3WKz3Iv9lydY7akRvTqB5CTPQSm8y1901A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326893; c=relaxed/simple;
	bh=/GQ5OoSazn1MSeS7/W/NBkv1+8B8ZUdcyK4t/3RFsdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozcN3Q3wEETeswW2PtsOev/7omNbl497m6Qbb0QLsS7wM07CEhP3jKmD1YIPAlrBtIOYOZsVpAc93pgMJ88Snn+kSV2/bNnF75KTiFPjcAByuLUk5IpLK4BFRh32tt6wLAJk91dTjgwdLdgrpayWJxOnDmDHS8JR+PRSa5T+f5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OEaH7Dyn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kFalqAMg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OEaH7Dyn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=kFalqAMg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OEaH7Dyn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kFalqAMg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OEaH7Dyn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kFalqAMg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C28E1F387;
	Tue, 27 May 2025 06:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2uc3EcXW0/tQctSgcTz7UAMDEK4uFLW9a0pD1WVGLo=;
	b=OEaH7DynZY445jA247/HFL9ZGhiary65fu41N5Q30rYBMxm2ubb8oMJaynexR04qkO53g0
	S3awYWaQEXwC4gcfZ4oDIOHJBdCeKP/dRpL5Ad97cbHUUch3raLtQOoWS1Osn7UkvZRoB5
	nv7cYsE6XD1uUQbEUVuTQaBKytkrimo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2uc3EcXW0/tQctSgcTz7UAMDEK4uFLW9a0pD1WVGLo=;
	b=kFalqAMgmbFoPZ2xib4p3wmRgRgRdP29hhmMHURMmImeYW8xvV/zgpwmpEk9xyUqZWKKpR
	LoJ10kDlD3OfmtAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2uc3EcXW0/tQctSgcTz7UAMDEK4uFLW9a0pD1WVGLo=;
	b=OEaH7DynZY445jA247/HFL9ZGhiary65fu41N5Q30rYBMxm2ubb8oMJaynexR04qkO53g0
	S3awYWaQEXwC4gcfZ4oDIOHJBdCeKP/dRpL5Ad97cbHUUch3raLtQOoWS1Osn7UkvZRoB5
	nv7cYsE6XD1uUQbEUVuTQaBKytkrimo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2uc3EcXW0/tQctSgcTz7UAMDEK4uFLW9a0pD1WVGLo=;
	b=kFalqAMgmbFoPZ2xib4p3wmRgRgRdP29hhmMHURMmImeYW8xvV/zgpwmpEk9xyUqZWKKpR
	LoJ10kDlD3OfmtAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F30051388B;
	Tue, 27 May 2025 06:21:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NKl2OelZNWjXGgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:21:29 +0000
Message-ID: <5d47c76d-5b7c-456a-99cc-1c443cdf8b67@suse.de>
Date: Tue, 27 May 2025 08:21:29 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/23] md/md-bitmap: fix dm-raid max_write_behind setting
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-14-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-14-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.10
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.10 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RLtz5dqupg5qtg4mecjbj51bze)];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> It's supposed to be COUNTER_MAX / 2, not COUNTER_MAX.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-bitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 689d5dba9328..535bc1888e8c 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -777,7 +777,7 @@ static int md_bitmap_new_disk_sb(struct bitmap *bitmap)
>   	 * is a good choice?  We choose COUNTER_MAX / 2 arbitrarily.
>   	 */
>   	write_behind = bitmap->mddev->bitmap_info.max_write_behind;
> -	if (write_behind > COUNTER_MAX)
> +	if (write_behind > COUNTER_MAX / 2)
>   		write_behind = COUNTER_MAX / 2;
>   	sb->write_behind = cpu_to_le32(write_behind);
>   	bitmap->mddev->bitmap_info.max_write_behind = write_behind;

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
