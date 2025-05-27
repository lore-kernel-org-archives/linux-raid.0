Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D0C1E008B
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748325412; cv=none; b=mkJtWIeVlK/AS+9NBdPAn0ht7UZiRaqKar8ipWyj9Gs5XztM/Jcn2Afv6qANCRCkB3pm99n0Cy5FGmTgCpDwfBoMREIAHujyKJUIlcC1j9vkiJ/x6/yuRcYI4umjvi+/HSx9lp0ZK48GyTV8/SsYKb57cIFe7Fy8SSN9yjlLeMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748325412; c=relaxed/simple;
	bh=bsGDXYk1ADjZ/R2ql2cC7u51eEsVwAZld2dQR0a1yS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7gyOD/lcIj0W+lbHJZ2EdajoG/WzO8cCHnHJYut4/+MNTCN2B6gvipW3YHHvi74dQAiNWseuIkskR9guOK5oYv+bQYmNMbSl94xLGnnVO2iLD0IdR+GCkbEzaafMto/HEYjN0LqlFghfQ5wFmlvKBiYmFiTZWzSW82VSBfyLjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I3p6YpDY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Me1w9A7/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=I3p6YpDY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Me1w9A7/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="I3p6YpDY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Me1w9A7/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="I3p6YpDY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Me1w9A7/"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B4D851F387;
	Tue, 27 May 2025 05:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+INI7n3KdwtHuM7fPLLVZp6WZPu8T9ohP8zvsEPeRo=;
	b=I3p6YpDYBfxdqy/Ub9jkfeLRa+HeSE86Z5ObtHE8Dd8e0fc6quQErt1tFG2n6BxJgLpK8u
	fld7r8lXt1B+lAfharhl/LVDufRUYck3ZVQ890Mf/S946vRk+bplgdjrlaQbkwF+FYXNL9
	J12steqlhyQqSa28i7z6yH0yvQiGyiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+INI7n3KdwtHuM7fPLLVZp6WZPu8T9ohP8zvsEPeRo=;
	b=Me1w9A7/FI7qppbi0SutCecR0yG7iS5xTftqTLLfps4xtN+y4mxhLL8nqnCeTifxY/AF7+
	AxlYWaF5q2JbLmAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+INI7n3KdwtHuM7fPLLVZp6WZPu8T9ohP8zvsEPeRo=;
	b=I3p6YpDYBfxdqy/Ub9jkfeLRa+HeSE86Z5ObtHE8Dd8e0fc6quQErt1tFG2n6BxJgLpK8u
	fld7r8lXt1B+lAfharhl/LVDufRUYck3ZVQ890Mf/S946vRk+bplgdjrlaQbkwF+FYXNL9
	J12steqlhyQqSa28i7z6yH0yvQiGyiU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+INI7n3KdwtHuM7fPLLVZp6WZPu8T9ohP8zvsEPeRo=;
	b=Me1w9A7/FI7qppbi0SutCecR0yG7iS5xTftqTLLfps4xtN+y4mxhLL8nqnCeTifxY/AF7+
	AxlYWaF5q2JbLmAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 053E5136E0;
	Tue, 27 May 2025 05:56:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i6MPOyBUNWi+EwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 05:56:48 +0000
Message-ID: <ae95ca8d-65b4-4084-8c4d-4e8f9913d7c8@suse.de>
Date: Tue, 27 May 2025 07:56:48 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/23] md/md-bitmap: cleanup bitmap_ops->startwrite()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-4-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-4-yukuai1@huaweicloud.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> bitmap_startwrite() always return 0, and the caller doesn't check return
> value as well, hence change the method to void.
> 
> Also rename startwrite/endwrite to start_write/end_write, which is more in
> line with the usual naming convention.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md-bitmap.c | 17 ++++++++---------
>   drivers/md/md-bitmap.h |  6 +++---
>   drivers/md/md.c        |  8 ++++----
>   3 files changed, 15 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
