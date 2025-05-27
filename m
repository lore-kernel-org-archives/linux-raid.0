Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC753D984
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748325714; cv=none; b=Fs1jUv5rIINEEGb4fYLk02hiW3kdIusK0CmShXM57u/UYXvCYi/MQUwMs9UcPjFgGjU5bLQwNTZ/YrMjb3jf2EwQPR8G1/PQb1ZZoYZFU/+lrbOZuQJOZVaFHmAgetyUyfyFiz66ZYVzZbI+SXs5oSDLkBCNBo6KWGtQv1VyPjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748325714; c=relaxed/simple;
	bh=hJOpElzdANKyLnRjjLjuJ+76FAIqlp2gDe486Qq3nSE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S7hGx+oDXz8lE8qzIon6jhfPO+2o4whcT/NWZRb6lAb1aHH1oGPCENbI6wSZvozTqzEKTmptuKLJ53EPRh0HfVkFCmfgkGcZgk2AZwMD1j5gkrRdCvqRfGCyp7OZ3fUiFfgXHykldpXOJYVa7/5yi6MTw+RrcYDco6u72p0cRew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oTm6te9f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M6+XeeJy; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oTm6te9f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=M6+XeeJy; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oTm6te9f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M6+XeeJy";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oTm6te9f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="M6+XeeJy"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3ED2C1F390;
	Tue, 27 May 2025 06:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWe2Di31BJpmsJ+auLx1h9Vv+AYFAub9nn23aGOGvBY=;
	b=oTm6te9fchLf4yy6NSsv1WEXWopHAeTOwbpMnw0DcpbzYx6EUY6p6rfGut45AfsMSISBvH
	T1L3Cmf67EMrK5qje7uExwmRfvk1LN5ADMy4/r7go8YMyUB/jnhShoXOrgX7M+naHONc6I
	jGUp/RArcNMae/9chhuIi7VZRZhxl2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWe2Di31BJpmsJ+auLx1h9Vv+AYFAub9nn23aGOGvBY=;
	b=M6+XeeJyF1fiKj3bDQwv+4B00qTXZopP1EWTxc7X40JImQ7mVdsyfCeWNWMjGLFldrT5Gf
	ruaDb4ZPqpNDgZDg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oTm6te9f;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=M6+XeeJy
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWe2Di31BJpmsJ+auLx1h9Vv+AYFAub9nn23aGOGvBY=;
	b=oTm6te9fchLf4yy6NSsv1WEXWopHAeTOwbpMnw0DcpbzYx6EUY6p6rfGut45AfsMSISBvH
	T1L3Cmf67EMrK5qje7uExwmRfvk1LN5ADMy4/r7go8YMyUB/jnhShoXOrgX7M+naHONc6I
	jGUp/RArcNMae/9chhuIi7VZRZhxl2M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325711;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BWe2Di31BJpmsJ+auLx1h9Vv+AYFAub9nn23aGOGvBY=;
	b=M6+XeeJyF1fiKj3bDQwv+4B00qTXZopP1EWTxc7X40JImQ7mVdsyfCeWNWMjGLFldrT5Gf
	ruaDb4ZPqpNDgZDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEEF7136E0;
	Tue, 27 May 2025 06:01:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q1LMME5VNWhXFQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:01:50 +0000
Message-ID: <f408347b-d8c9-48a6-b533-76179b3741d6@suse.de>
Date: Tue, 27 May 2025 08:01:50 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/23] md/md-bitmap: remove parameter slot from
 bitmap_create()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-6-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-6-yukuai1@huaweicloud.com>
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
	RCVD_TLS_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	MID_RHS_MATCH_FROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,huawei.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 3ED2C1F390
X-Spam-Flag: NO
X-Spam-Score: -3.31
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> All callers pass in '-1' for 'slot', hence it can be removed.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md-bitmap.c | 6 +++---
>   drivers/md/md-bitmap.h | 2 +-
>   drivers/md/md.c        | 6 +++---
>   3 files changed, 7 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
