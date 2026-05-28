Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39583B47F9
	for <linux-raid@vger.kernel.org>; Thu, 28 May 2026 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779962127; cv=none; b=SNkmkK6I14l7MP/kYEczPE53KA/Oc76c0+whzvwGCWKYVX8oOGb90NbWjksnKyrBw4S/bnA9RtdIX+LmyCt+LKUrmV9uUnT1svDzWKnh26ZSQ90qj02WxSBcV+CdElxzAKulgxKpQOgDRaz5Mlj/Gr8en45dtUvbjaMVNGtVcW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779962127; c=relaxed/simple;
	bh=QdAMF5cWbayIfoQLLliElAD+q7jyAvyF0u9F7/vRAv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLo81qjYhhEq2nDv4zsamZUBw+/2BqGV9UXYBqIJfd5Xm1zKxmfHVT+XHkQcM6rX1gf3JhWF2hp6aRclYn7mA4zwltOlkO9RM6BQZeVEoQI9h4R2pz39U5w2/yYU6kb92Bi8Yu3TOn3LubBTTfnvSI+zEWdIkb6YZGl7O66zw60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BF5pBjQa; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=gtEmH9yd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MfkimMzQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=eWcZZWs8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BF5pBjQa";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="gtEmH9yd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MfkimMzQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="eWcZZWs8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD9066B13A;
	Thu, 28 May 2026 09:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779962124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=BF5pBjQaCl2e1Rm8D+C+apxY1lOd/N58rwkBf5jv/216FwXdroWEjeZmPLmTKojKt3eR2Z
	aydpArZ5tRp7vUT35rbUO+WTXFRT4xhMoDDHvbt//K6lb2TR+MHyIRb2NNeN/quBM4Vnrg
	pA3CrFpw3LlKVYqN4tzENaUpeXCo43I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779962124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=gtEmH9yd1llte+EHO3fqErzp7rmioNwyJsOMXvUqMC9+eppCro3Z+06jCWPXGpxvqOBXVF
	rH2itovxFNZ8p4Aw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfkimMzQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eWcZZWs8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779962123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=MfkimMzQMNvrw+Vgdg0ivpq8Gmkgeg9Q6Q1uMy5Zz9SBJSnl50fuDbaSqCL2pfY0V5hr0I
	9sVOzn9fe4yl2EpWD+4MbJI8cUJ2PNJdscx7Z6snLamed1dLvau5xSndCxLYkdpLshf5v1
	2wghgXxixlMhg0rJr2HC/EBVEOmJ/e8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779962123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j0st/q00EgR/xOpxFqktmgI0ClPAoSUk9OzRlxpLPQA=;
	b=eWcZZWs82aMKWWk3/yQ8+ZvriQyMgUB26C/K88sIBhrDvCqJCuCjZiX/bJYBu0L8w2LDJX
	JtV9oK3q3wOlGRDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA0F55AD12;
	Thu, 28 May 2026 09:55:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0sLaKAsRGGq/YgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 28 May 2026 09:55:23 +0000
Message-ID: <9e491e1f-b544-4cbc-9319-8f75cf0b2130@suse.de>
Date: Thu, 28 May 2026 11:55:23 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] xor: use kmalloc() in calibrate_xor_blocks()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>,
 Song Liu <song@kernel.org>, Xiao Ni <xiao@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-raid@vger.kernel.org
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
 <20260528-lib-v4-1-4e3ad1277279@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260528-lib-v4-1-4e3ad1277279@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: DD9066B13A
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,huawei.com,kernel.org,fnnas.com,vger.kernel.org,kvack.org];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -3.01

On 5/28/26 11:53, Mike Rapoport (Microsoft) wrote:
> The xor benchmark allocates 4 pages for a scratch buffer that is used
> purely as a CPU-only XOR working area.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API than ancient __get_free_pages().
> kmalloc() does not require ugly casts and kfree() does not need to know the
> size of the freed object.
> 
> There is no performance difference because kmalloc() redirects allocations
> of such size to the page allocator.
> 
> Replace __get_free_pages() call with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   lib/raid/xor/xor-core.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
