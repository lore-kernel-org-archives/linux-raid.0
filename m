Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B811F55FA
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326504; cv=none; b=j3V1Wq1HCuqnqBSPvB71OB4X9XyqnJ1srKP+lr0sjsbX9JgDcaNT8fYxXHqHTkdsx58jCr2F/ev9ebDnCDpgELTaTudx3vhdm2CHK8Y3LjVAhJLuY/Hr5HbGpu9RsYliRpqFkAtKWBF7aINCU+Lq3yHzbYQPT1uzunmIBqB6Xkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326504; c=relaxed/simple;
	bh=7cqRvWmsjLpLwLP6G4YoQhs0bVKffM2fN7biKpXdZnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bf6kzc3m8SdbRAzt5SUrl8SPvv4jsWmLRsfzoQGU/RVrwNHoD6dkSv8Aynzy3t5qSNSUuDRhNtY0v/aUeAnCTkw5R9yGt94e78LtDwxyNvlepTMeya/CJXUiKdMDiXYOV4zXtxU5jzwh4S3XjZOWf7SRIfOSKBBSTtOppSQy+Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=esFvNxFx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DtQS3xDs; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=esFvNxFx; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DtQS3xDs; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="esFvNxFx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DtQS3xDs";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="esFvNxFx";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DtQS3xDs"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BEFD11F387;
	Tue, 27 May 2025 06:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ylwDSgJrNNL5Pa/DSxqo6KU+2lsVPVESW17ju/vi8A=;
	b=esFvNxFxLolycRCGGpM6qpxlZevMLkQngMWufknmy7kt1+QACyriuNGf2kZctTAHwXJ9Dg
	4njQsYBgdn5FQk1Sy7DxFpmsaTswiIZuY1wK8idN8rPqtCDw5IbzuvRtswHvEeWEJrx/Ev
	wTUoHz5g9rg+uUrreSM1sc3PS/0adBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ylwDSgJrNNL5Pa/DSxqo6KU+2lsVPVESW17ju/vi8A=;
	b=DtQS3xDsfkvz3+ZZX4KVgvJobgsNRgXqZcuU6N6gQkBlycKF//Szo4fltwyvWrgxFV/JtJ
	RaKVVvesJi5vudCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ylwDSgJrNNL5Pa/DSxqo6KU+2lsVPVESW17ju/vi8A=;
	b=esFvNxFxLolycRCGGpM6qpxlZevMLkQngMWufknmy7kt1+QACyriuNGf2kZctTAHwXJ9Dg
	4njQsYBgdn5FQk1Sy7DxFpmsaTswiIZuY1wK8idN8rPqtCDw5IbzuvRtswHvEeWEJrx/Ev
	wTUoHz5g9rg+uUrreSM1sc3PS/0adBM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ylwDSgJrNNL5Pa/DSxqo6KU+2lsVPVESW17ju/vi8A=;
	b=DtQS3xDsfkvz3+ZZX4KVgvJobgsNRgXqZcuU6N6gQkBlycKF//Szo4fltwyvWrgxFV/JtJ
	RaKVVvesJi5vudCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A102136E0;
	Tue, 27 May 2025 06:15:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7GI5FGRYNWjsGAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:15:00 +0000
Message-ID: <1fafc497-1ed7-4016-9fa2-ae82d48aa778@suse.de>
Date: Tue, 27 May 2025 08:14:59 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/23] md/md-bitmap: add a new method skip_sync_blocks()
 in bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-9-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-9-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.969];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This method is used to check if blocks can be skipped before calling
> into pers->sync_request(), llbiltmap will use this method to skip
> resync for unwritten/clean data blocks, and recovery/check/repair for
> unwritten data blocks;
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md-bitmap.h | 1 +
>   drivers/md/md.c        | 7 +++++++
>   2 files changed, 8 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
