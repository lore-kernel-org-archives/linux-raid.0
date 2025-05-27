Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D401A275
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326801; cv=none; b=H8ItHb49HWxJQQT1oxkE9IhM5cVBCtbIZOisbduc5e9bhvEJEFKPoCQTadQ5zz1XagXAEMvRk/Ae4FWOnY2zZipe4LDtzIgSddqXpAU2ilnBG8es6wQYrNoOiBo0aDzHoSHQzYZW52B+4OEienXruExUIXYBZwyq0VcI9m/Vvhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326801; c=relaxed/simple;
	bh=gOVl/UxJqzGqyN7iE9TUHcu1Ycvob5Uw/zyvqptWjKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZz+SehhZIdGsxkn3pb+xQ+kvljYS3VMulSFv84SUDvkrZ+7L7F8Z3xjbn8ixCh3ndc+N4WtB7x53IbvgeBxcUhoPQTccTIEjbyc7ahks1/kTXDnyuDdK2HFEe+BDYkVWb813zF8QsEIx8nxZAI2QRhRs8ATMlq2M6CreXF03U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WSUnWPX3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=pGeF4BMo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZDoq0b1l; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KjuKmOrQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WSUnWPX3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="pGeF4BMo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZDoq0b1l";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KjuKmOrQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6C0EA21E79;
	Tue, 27 May 2025 06:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9oLdOGdMiTlLo4FcXmV6p6DfCR2IxVmo9Bbr5NzW4w=;
	b=WSUnWPX3e34c/mAqFJbTL+M3ToBvoKWnjdIHEj739CNHZQZgzVieM8a6MMlBOvn5FJL+nG
	WayC4G+GBFtS5984MWWGiT91c0nqWT955TyYDE3LDyMIiFWEEc5xgwFIqQ+rAx109Z1KSj
	exzeR7u1xGDIMMuwQuSrLSEAv6PKY/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326798;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9oLdOGdMiTlLo4FcXmV6p6DfCR2IxVmo9Bbr5NzW4w=;
	b=pGeF4BMoVHUE2hkg4SAO7L9soNvPkBrozRad1A0XtcidoBC1EdZvPKjBOJWu7ivOMax7Xd
	OKTOYNldwwq3avAQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326797; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9oLdOGdMiTlLo4FcXmV6p6DfCR2IxVmo9Bbr5NzW4w=;
	b=ZDoq0b1lI1gonw25o1UZGaB7/QaESoLdXpLPEvwJ0xtzr80C2Lc8dWmUP88w2JhjEtVLqi
	J+mMH2EpX+uJJoEIPgId1Vj2C5+BeEih2n8IFWQq/QYEuqlOumyhu5+IzbwKmW90hD0+sC
	HQ49ejJ2UpEL3q2ZMwhO6RCQlCxo2Uk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326797;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9oLdOGdMiTlLo4FcXmV6p6DfCR2IxVmo9Bbr5NzW4w=;
	b=KjuKmOrQP3a52dxHTiFawIHyBx+1z8JzBsbo6TQYxZN0ALBAbXIcgZuzF7D9Uj6LnIIMgF
	jC3uN9nLFI7JS6Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E89E7136E0;
	Tue, 27 May 2025 06:19:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /YqdNoxZNWhsGgAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:19:56 +0000
Message-ID: <a1691267-304d-4a3f-898b-2f8901031d2c@suse.de>
Date: Tue, 27 May 2025 08:19:56 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/23] md/md-bitmap: make method bitmap_ops->daemon_work
 optional
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-12-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-12-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> daemon_work() will be called by daemon thread, on the one hand, daemon
> thread doesn't have strict wake-up time; on the other hand, too much
> work are put to daemon thread, like handle sync IO, handle failed
> or specail normal IO, handle recovery, and so on. Hence daemon thread
> may be too busy to clear dirty bits in time.
> 
> Make bitmap_ops->daemon_work() optional and following patches will use
> separate async work to clear dirty bits for the new bitmap.
> 
Why not move it to a workqueue in general?
The above argument is valid even for the current implementation, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
