Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BC71A275
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326868; cv=none; b=dhy++zvB6iu7wm0piS1fBM0eCKcUchHsphHOuMk+Iu0VNtbcIN7QtWSssTLJNqHXCykG6ttQCGAD1z+RYnuHyoPjW/IK2ZD976GdzbQj8M2MOQch0dtl34Rd1ghfBhMfdkQm8/DsUSnAIL2B7fXRm2qksvfp+3oSI0DPUqVqxvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326868; c=relaxed/simple;
	bh=A2lvDLbmvO+gfLQuamFV+FTo4tSpKnrhQ0g2xqYHBf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m07XOn+yHgxxEz+/2jMmId7E1dFqJUzmcexs+PKJbOmXDVKYDl8a/etrbXl6B9H3Assg8UiNSWtonnxULr3IL1DouOphK6A+vQACX34VoXeBuxPrTlOlxaQJ1JhvlMZKAaVwOjEtDy6NbqBnLuEDCHTPf/wYuOhWDvzoquuXYVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AkqJucFf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YOaJg7np; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AkqJucFf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YOaJg7np; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AkqJucFf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YOaJg7np";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AkqJucFf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YOaJg7np"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C11E421E79;
	Tue, 27 May 2025 06:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cl4BzIWoTAsRGhhAnfZ4UWFDolEhevAaSEXgwXOEAU=;
	b=AkqJucFfQSiQ7mDX7kh8L9HClLvL+eBn/MB2VrDgqfsO4RLqQD6RzZQW18EqIpzQ5Zesg/
	VaJGDjA8NEYYk/eT3BCA3Y1WK3frjZFDBabTMY/t4HPWGjUkLwOLqTH0e9I7BonhXN+cdf
	xYg2N2BIZmGO0UkGUszSI70NwrP7n64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cl4BzIWoTAsRGhhAnfZ4UWFDolEhevAaSEXgwXOEAU=;
	b=YOaJg7npJ+NvSLP3q4Ol5eVMFAX3FRYR0QPqJmDAQDjCdGbzaFRVr4/dksF2OQYkwr6ZOt
	r3sJe1Lw9rIAOtCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cl4BzIWoTAsRGhhAnfZ4UWFDolEhevAaSEXgwXOEAU=;
	b=AkqJucFfQSiQ7mDX7kh8L9HClLvL+eBn/MB2VrDgqfsO4RLqQD6RzZQW18EqIpzQ5Zesg/
	VaJGDjA8NEYYk/eT3BCA3Y1WK3frjZFDBabTMY/t4HPWGjUkLwOLqTH0e9I7BonhXN+cdf
	xYg2N2BIZmGO0UkGUszSI70NwrP7n64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cl4BzIWoTAsRGhhAnfZ4UWFDolEhevAaSEXgwXOEAU=;
	b=YOaJg7npJ+NvSLP3q4Ol5eVMFAX3FRYR0QPqJmDAQDjCdGbzaFRVr4/dksF2OQYkwr6ZOt
	r3sJe1Lw9rIAOtCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42DCB1388B;
	Tue, 27 May 2025 06:21:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zTRbDtFZNWi/GgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:21:05 +0000
Message-ID: <8115558c-34e0-4304-8837-b5720b775a21@suse.de>
Date: Tue, 27 May 2025 08:21:04 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/23] md/md-bitmap: add macros for lockless bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-13-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-13-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.967];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Also move other values to md-bitmap.h and update comments.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-bitmap.c |  9 ---------
>   drivers/md/md-bitmap.h | 17 +++++++++++++++++
>   2 files changed, 17 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
