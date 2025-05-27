Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFB027738
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748325682; cv=none; b=GGDncnONPchCLAv1w/IsL4x7TTYkXJdJd00c/ZFfVZqEf2idfOtODQPfNcsH9k0t/lGsPDbImDuUgzhyn4by/ps8ElfctOM4L4CIfupQCIMs0KWW5XX5ctUZz7b+w+muGtNOkpvrdPmuaaT6hjAhTJ/VY05WzW6XYI4u/+UfkPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748325682; c=relaxed/simple;
	bh=Kql1ui4lqYw7KULpt0RTd4apvHmTzCQZrVz2AX9WWUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpI1mnHik7SBLzUFgZ8Js9U+/44HpEukuYTzR+HSXv6Hzx4sGJJ9htxUWoSk2WPKJG4+5D11nst7RGMi0NSaU/HxD2GMBMaS6jdf5wX9XvQjL9ocJbU4rFh/TuCyWvyna2/XhmiKTeNY7j4Jn6N1TWi9yYVl9Dl2szKybeE8/64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=awYRnmNX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c+HfYXa7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=awYRnmNX; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=c+HfYXa7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="awYRnmNX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c+HfYXa7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="awYRnmNX";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="c+HfYXa7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7F5121F387;
	Tue, 27 May 2025 06:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmPngFWdVllMPArAJKK1RB/eTXuiJ2ZggJwMciO+SFc=;
	b=awYRnmNXthfTq159Pn9WVJ9K8cpPV1uOIOXFcQ6FXtQwL85NyWj9CEWW014kR/b8HQgD7u
	rVsJJPKWbd6Jtvipe8y1lryxGwe9eFnbewwkT25xp+UUqhRUGf4KosQnMn72FNKwtjNku/
	HbH8WIJAGmL8NKDexd+JUESZnR3k90U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmPngFWdVllMPArAJKK1RB/eTXuiJ2ZggJwMciO+SFc=;
	b=c+HfYXa7MlhuOhx8JyrYxGYseItjuVr+xy0R/DF+u32/biVGkzA7U221zE6Vt9fzXK8pP2
	Vj1A/3nEhAjWnmAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=awYRnmNX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=c+HfYXa7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmPngFWdVllMPArAJKK1RB/eTXuiJ2ZggJwMciO+SFc=;
	b=awYRnmNXthfTq159Pn9WVJ9K8cpPV1uOIOXFcQ6FXtQwL85NyWj9CEWW014kR/b8HQgD7u
	rVsJJPKWbd6Jtvipe8y1lryxGwe9eFnbewwkT25xp+UUqhRUGf4KosQnMn72FNKwtjNku/
	HbH8WIJAGmL8NKDexd+JUESZnR3k90U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmPngFWdVllMPArAJKK1RB/eTXuiJ2ZggJwMciO+SFc=;
	b=c+HfYXa7MlhuOhx8JyrYxGYseItjuVr+xy0R/DF+u32/biVGkzA7U221zE6Vt9fzXK8pP2
	Vj1A/3nEhAjWnmAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E192136E0;
	Tue, 27 May 2025 06:01:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GOdKES1VNWgsFQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:01:17 +0000
Message-ID: <8de1354f-35a6-47fd-bc59-4e301384bf6e@suse.de>
Date: Tue, 27 May 2025 08:01:16 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/23] md/md-bitmap: support discard for bitmap ops
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-5-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-5-yukuai1@huaweicloud.com>
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
X-Rspamd-Queue-Id: 7F5121F387
X-Spam-Flag: NO
X-Spam-Score: -3.31
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Use two new methods {start, end}_discard to handle discard IO, prepare
> to support new md bitmap.
> 
This actually does more than just add new methods; but not sure if one
should list all of that. Maybe just 'Add typedef for bitmap functions
and new methods to support md bitmap'.

 > Signed-off-by: Yu Kuai <yukuai3@huawei.com>> ---
>   drivers/md/md-bitmap.c |  3 +++
>   drivers/md/md-bitmap.h | 12 ++++++++----
>   drivers/md/md.c        | 15 +++++++++++----
>   drivers/md/md.h        |  1 +
>   4 files changed, 23 insertions(+), 8 deletions(-)
> 
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
