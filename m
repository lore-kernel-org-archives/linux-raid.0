Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9464C2206B2
	for <linux-raid@vger.kernel.org>; Tue,  8 Jul 2025 06:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751955711; cv=none; b=T6EjmqJ11Ginzol4uviXJ9Zxd8mzC4X1Dv9ScnByXME9vOW4us18ug4xtt89GRy9WipgTj2PTKVOatbcMplmGmG2remVtbCMc8tFqgnt8VTEWR0cGCBvuA+4QR+ZyKpsGQY7FDJ7T0OKW/UgKjtRduCiGbD7IABAP3CjAIOrBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751955711; c=relaxed/simple;
	bh=nlZFPMT+sEEHp0tr33yZUEG1sXb3bgGF4SvBzSrYE8k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F53Dx47KXNsPkndQ6OiNPYtqBrF+wdStmOB+1qdc9CSKTUqfstqi0LgmFAfiA7Oe9elp8wX1xGkOJzv0qOhe3g6G+gKtNf765J56XE9B/7Te3ctgxcW099yQp2j10nZiIQ+TmZMVSBD3aenoJszLMd/xnWgg0mY4xLxw6hK8Xq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XK2d1d82; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S2BkSFbE; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=XK2d1d82; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=S2BkSFbE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XK2d1d82";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S2BkSFbE";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="XK2d1d82";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="S2BkSFbE"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AA1311F390;
	Tue,  8 Jul 2025 06:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751955707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4pDXFeVdoxaOHFmIapee0JP1uWF5Adz5JKiYZotLY4k=;
	b=XK2d1d82/TyP0YJLqLPTdT6BBtdpPuTykrbD6Ee5i+l4aRJBnLDBptFKygbJ2WiCVyAZPP
	OZTExPZpiRGybxIAmad47CngzVww8OFZuiMnIzcvvp0t7l2FvlxeRE2cqkg1Dorg8pKTuM
	5tHO6nihNotEtAJV4SrJcyOXIS5aRek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751955707;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4pDXFeVdoxaOHFmIapee0JP1uWF5Adz5JKiYZotLY4k=;
	b=S2BkSFbE4gEmPMbhQx/il0IDSzNn3HmDrger+MrrTTKOB+njOgIbr7muI6Ysg0Xl3DfaWW
	g5Er/kEASJC5SkCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751955707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4pDXFeVdoxaOHFmIapee0JP1uWF5Adz5JKiYZotLY4k=;
	b=XK2d1d82/TyP0YJLqLPTdT6BBtdpPuTykrbD6Ee5i+l4aRJBnLDBptFKygbJ2WiCVyAZPP
	OZTExPZpiRGybxIAmad47CngzVww8OFZuiMnIzcvvp0t7l2FvlxeRE2cqkg1Dorg8pKTuM
	5tHO6nihNotEtAJV4SrJcyOXIS5aRek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751955707;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4pDXFeVdoxaOHFmIapee0JP1uWF5Adz5JKiYZotLY4k=;
	b=S2BkSFbE4gEmPMbhQx/il0IDSzNn3HmDrger+MrrTTKOB+njOgIbr7muI6Ysg0Xl3DfaWW
	g5Er/kEASJC5SkCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4494C13A68;
	Tue,  8 Jul 2025 06:21:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qgIuDfu4bGjELwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 06:21:47 +0000
Message-ID: <d7902d92-ebbc-4423-8174-abe93834f491@suse.de>
Date: Tue, 8 Jul 2025 08:21:46 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] md/md-bitmap: support discard for bitmap ops
To: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-4-yukuai@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250707165202.11073-4-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30

On 7/7/25 18:51, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Use two new methods {start, end}_discard in bitmap_ops and a new field 'rw'
> in struct md_io_clone to handle discard IO, prepare to support new md
> bitmap.
> 
> Since all bitmap functions to hanlde write IO are the same, also add
> typedef to make code cleaner.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md-bitmap.c |  3 +++
>   drivers/md/md-bitmap.h | 12 ++++++++----
>   drivers/md/md.c        | 15 +++++++++++----
>   drivers/md/md.h        |  1 +
>   4 files changed, 23 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
