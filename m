Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B23321FF36
	for <linux-raid@vger.kernel.org>; Tue,  8 Jul 2025 06:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751956180; cv=none; b=S3vTkGBI+8fGSiMqqTereMVVUxZaoixMpBXSYo0/DUgdHsByoq/aODB6KNpphIrf+cR2KOaG9Aczu4uYjzRsuKwWs0RIEKX70NcpVwE+D2rqV/LxPLA0HSS29nKBJo42lMqaWOUsD5L9B8bXttO9DWN23Q7gv+j3xDR03im9dME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751956180; c=relaxed/simple;
	bh=5Oatd32BihQJ8vY75+fLQrfyF7ZpI6+2AT5wGPihCeI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tZfr4K8RObC++CRnFP1P7+Xp/M5HFbrSZ5SeXGl9vtVfLYquVT85M3g9ZYnbWSH6nRFafXUv1ZiYnVq8bCsNs/pd9I50X2PgN+R/q3QUG7zQpaE0vx9Bh96BsIg6z2IgQorpSRUnzb52kufPP0N4M5mOTU8V7XBjwVMpQfEo4yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VMCfcc5F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W406F+vw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VMCfcc5F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W406F+vw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VMCfcc5F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W406F+vw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VMCfcc5F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W406F+vw"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0DC2E21163;
	Tue,  8 Jul 2025 06:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751956176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4To4jsitK4KHjqZpOuO823Iz6x//PlymCNCryADJ+U=;
	b=VMCfcc5F94U4LvFJMVNHo6abD3zRF2EfLsT3PzZ0RQCExG3Crt5iDJzun1ZO52ZImFpxd3
	S+CUhlMAVwDYiCbandf/AZvHrQjK9BFEFhodoIdjDXGHp/vD4bU3FYLaMBkq25gCTmJwuG
	qEVSpeW6B91+epJZkpk4zlAeoeXmPIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751956176;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4To4jsitK4KHjqZpOuO823Iz6x//PlymCNCryADJ+U=;
	b=W406F+vw4uZb/SOaXQzwwHQoKBUzwNP4NrUY7ttiw6xdyhUU8MKRMag+5Mo9eOv7wuslbd
	pT7BJ95hIv++nQBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VMCfcc5F;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=W406F+vw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751956176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4To4jsitK4KHjqZpOuO823Iz6x//PlymCNCryADJ+U=;
	b=VMCfcc5F94U4LvFJMVNHo6abD3zRF2EfLsT3PzZ0RQCExG3Crt5iDJzun1ZO52ZImFpxd3
	S+CUhlMAVwDYiCbandf/AZvHrQjK9BFEFhodoIdjDXGHp/vD4bU3FYLaMBkq25gCTmJwuG
	qEVSpeW6B91+epJZkpk4zlAeoeXmPIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751956176;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4To4jsitK4KHjqZpOuO823Iz6x//PlymCNCryADJ+U=;
	b=W406F+vw4uZb/SOaXQzwwHQoKBUzwNP4NrUY7ttiw6xdyhUU8MKRMag+5Mo9eOv7wuslbd
	pT7BJ95hIv++nQBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 915C813A68;
	Tue,  8 Jul 2025 06:29:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BKgKIc+6bGjwMQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 06:29:35 +0000
Message-ID: <5be80152-15d2-4f57-b9d0-0fbb404b1477@suse.de>
Date: Tue, 8 Jul 2025 08:29:35 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] md: add a new recovery_flag
 MD_RECOVERY_LAZY_RECOVER
To: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-10-yukuai@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250707165202.11073-10-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 0DC2E21163
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 7/7/25 18:52, Yu Kuai wrote:
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
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
