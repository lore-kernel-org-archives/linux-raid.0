Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831871FCC63;
	Tue,  5 Nov 2024 07:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730791463; cv=none; b=BGzl9H9yyWrm3WhurCUUVdYWisgdFQNEouBi3eXx5yObEWckQK3V85bvjJrInvlH237JkU8S3iT7sXnTSHBntO1C7sCRocdL4yOJjvKBVh2uo5n3K46u+5CpZlKHVmA4xM+mz2gOefoGcp57AEGbz1p82ENG8u/jTz3V5bq+dUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730791463; c=relaxed/simple;
	bh=tZf4iGCKHaut23kHuRi13RmaE3baXf6aCu62FRe3I0c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ktGQZkjuUtv9pZVp0anh/ucC2mwnH9PoeY4PvpoGtqOyCEh6ydWCaWWn+3zxhoCxLDR8yv9GJ1jTui9/gYmVn2JCQi1j52gdgtGYa+lFS1BZ3ST7gtJazZ5xl1wfa2FqG2fTaCc1u8uo1/WWt1R4uBXUxbyZhk1MhI7bqzvKJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cWZsX0hN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Dn1im1Z2; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=cWZsX0hN; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Dn1im1Z2; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cWZsX0hN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Dn1im1Z2";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="cWZsX0hN";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Dn1im1Z2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9216F21CC5;
	Tue,  5 Nov 2024 07:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mTSk6dPrdVoblDJwYmQ358zSkY1AiYUIHp9DtlAvrHU=;
	b=cWZsX0hNv2odLh4sPYbojHf8dz2cM9c614X+XVehBvA+UIzWM8ETPR23r56veCoVi9rgpS
	i8cqVzT2o88jzHyCjhcKFVSGMhw+UNUGkDtVUw18zfBa3XxtO0l8m84RpADyqNOKPnY3cv
	u37L1rMguparMgxRe4FqDLY0ZrHf6QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mTSk6dPrdVoblDJwYmQ358zSkY1AiYUIHp9DtlAvrHU=;
	b=Dn1im1Z2wy+0VbGfrA1O0qmQxTuNONi9WmYhQpIWNclQyAKQBpWl4PsFQ7GPzV0ryAZfuh
	Cc4jWpqRJy806jDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cWZsX0hN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Dn1im1Z2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mTSk6dPrdVoblDJwYmQ358zSkY1AiYUIHp9DtlAvrHU=;
	b=cWZsX0hNv2odLh4sPYbojHf8dz2cM9c614X+XVehBvA+UIzWM8ETPR23r56veCoVi9rgpS
	i8cqVzT2o88jzHyCjhcKFVSGMhw+UNUGkDtVUw18zfBa3XxtO0l8m84RpADyqNOKPnY3cv
	u37L1rMguparMgxRe4FqDLY0ZrHf6QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mTSk6dPrdVoblDJwYmQ358zSkY1AiYUIHp9DtlAvrHU=;
	b=Dn1im1Z2wy+0VbGfrA1O0qmQxTuNONi9WmYhQpIWNclQyAKQBpWl4PsFQ7GPzV0ryAZfuh
	Cc4jWpqRJy806jDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 364E81394A;
	Tue,  5 Nov 2024 07:24:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id P9anCyPIKWcVGAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 07:24:19 +0000
Message-ID: <ae72817e-689a-454a-950c-1a313dbc4c7f@suse.de>
Date: Tue, 5 Nov 2024 08:24:18 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] md/raid0: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-5-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241031095918.99964-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9216F21CC5
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,oracle.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51
X-Spam-Flag: NO

On 10/31/24 10:59, John Garry wrote:
> Add proper bio_split() error handling. For any error, set bi_status, end
> the bio, and return.
> 
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid0.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
