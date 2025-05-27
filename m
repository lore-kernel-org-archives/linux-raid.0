Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683D51A08A6
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 05:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748325299; cv=none; b=CGhedmXkRv54zJTlhv5ni0ZlxtyGqN4vzMGs+LqFaDCGgfSe/G9zIU3Km6TdLd7sguGALccuQ+ZhRAGG8g3rXoxUPmymlvl8vnMpUXaRuZ/SVN9dmq2ew9bjslf5b5tvIrDn5GAlR6yq2voHosw58U3HpW9/qQ6tv1AIPcxs2EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748325299; c=relaxed/simple;
	bh=HkjE7lQ+VQpHNv3eYK3H1wg3tTNpFZT5LgHzLZ2SYWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jAgZQxouj2Oif8wHrdxPkiH9zqP0RRc0IFi2EYMYJXQ31yqqZ4XOKDv7UmVdAyCD+Dj1rsyzzbIjvcid6kbUbxfGWlT+UmDatU+hPsSlgF12EiLA9uB1xW5UILR0qxTLTyQQGC+ZM1IMTFBhyKOESZKdwh3Hb9jdy4ye6VynmE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kFWzo1kA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K6/9BIau; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=kFWzo1kA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=K6/9BIau; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kFWzo1kA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K6/9BIau";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="kFWzo1kA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="K6/9BIau"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D22021E7B;
	Tue, 27 May 2025 05:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ujn/Hs3ODzWXnlJmvVGgJxQTg9fV2NjCnJmCZsagxwk=;
	b=kFWzo1kA/RRvHVrlGXem/W8nkAki6Xa9bWeEHrfp1sqW8YImXC02atzvi/jhCf01eJnSPH
	3QF02YHJlUJGEBcUaJQ2l2U3o86WLTN2fSQWs2hX2+K0wSvBCbwEycPe2lUESv0iusxCwj
	nhIhX7UQKUmphuKSoaBstT+9Y3c5yS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ujn/Hs3ODzWXnlJmvVGgJxQTg9fV2NjCnJmCZsagxwk=;
	b=K6/9BIauxRqswmHQmlOu3EwMYa6Zp/gEBpJOaqQsH7KnIX083+chh0qF4jQ+oMEg7+Vjle
	fKn2ShsKtanus6AQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kFWzo1kA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="K6/9BIau"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ujn/Hs3ODzWXnlJmvVGgJxQTg9fV2NjCnJmCZsagxwk=;
	b=kFWzo1kA/RRvHVrlGXem/W8nkAki6Xa9bWeEHrfp1sqW8YImXC02atzvi/jhCf01eJnSPH
	3QF02YHJlUJGEBcUaJQ2l2U3o86WLTN2fSQWs2hX2+K0wSvBCbwEycPe2lUESv0iusxCwj
	nhIhX7UQKUmphuKSoaBstT+9Y3c5yS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325295;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ujn/Hs3ODzWXnlJmvVGgJxQTg9fV2NjCnJmCZsagxwk=;
	b=K6/9BIauxRqswmHQmlOu3EwMYa6Zp/gEBpJOaqQsH7KnIX083+chh0qF4jQ+oMEg7+Vjle
	fKn2ShsKtanus6AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E500C13964;
	Tue, 27 May 2025 05:54:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TErmNa5TNWgnEwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 05:54:54 +0000
Message-ID: <2b1e65ef-f3f2-4b6d-b671-4a19725859d8@suse.de>
Date: Tue, 27 May 2025 07:54:54 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/23] md: add a new parameter 'offset' to
 md_super_write()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-2-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-2-yukuai1@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Queue-Id: 5D22021E7B
X-Spam-Flag: NO
X-Spam-Score: -3.31
X-Spam-Level: 

On 5/24/25 08:12, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The parameter is always set to 0 for now, following patches will use
> this helper to write llbitmap to underlying disks, allow writing
> dirty sectors instead of the whole page.
> 
> Also rename md_super_write to md_write_metadata since there is nothing
> super-block specific.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-bitmap.c |  3 ++-
>   drivers/md/md.c        | 28 ++++++++++++++--------------
>   drivers/md/md.h        |  5 +++--
>   3 files changed, 19 insertions(+), 17 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
