Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EEC21767A
	for <linux-raid@vger.kernel.org>; Tue,  8 Jul 2025 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751955868; cv=none; b=hZT5+PUQCKWWdU+oJnXWCmorqFRVlSlwI4aAfytDJ1PK2LMwnBbEMiFKGJczvyU25jSykf7Rp/Tg6dJNB5XdLSj/K2Ktitish6GYedNNboN4Zq6RLDgCTt7PqAVlxgbmR8bfDu1kKzH2KSK8yA7Mf3iS6P0ZFRCJV1xmb/0sFr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751955868; c=relaxed/simple;
	bh=VoELUSs6WtAt0k0wb1KDuT9r3hmVjoke337eeM4RCPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UN3QKrWV3mL5siFuabiu9dq6+LVUQgPhcnUzQWhmYxXAtTr+wyu/p4Ty0jyc+/pqFcNLjED8p+gCrrZhlkNu8pLp828fzMPWYsV5wpUfZiu3kDEPSSRm+gSFT2u1GvwX9yOpI59QyHGz9mPnCqF/tOUSvf+1X9EzhZL+n1jtZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VOXJo2ts; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yg5atwa4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xnRjJGO0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=1YJVR87E; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VOXJo2ts";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yg5atwa4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xnRjJGO0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="1YJVR87E"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E586D1F441;
	Tue,  8 Jul 2025 06:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751955865; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhSjB7eeBvliVFTftkEcbzFfski/Q9EF3eUSjNC24+8=;
	b=VOXJo2tsWdJ0HwgRpab2ykmgo+ki/f/gAR4c8QXdyeQ4wqddN9naiySdWlFscQC4u2vmcR
	rbwIBdi8jGD3wq7mMkxnxHkc/kF/Vjc63dQ/fIFMHvSs4L1e3nu9usi37Eg85/qfSEE055
	FC7O2Cykojr0Is+fT/63CQ2l17uV6UY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751955865;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhSjB7eeBvliVFTftkEcbzFfski/Q9EF3eUSjNC24+8=;
	b=yg5atwa4x6H2G1VAGKXrlzSOgh7nM5HX3p8b9tgQuG66ObBKEgtHLK+2Wd5uQ6dLMqDIyZ
	R7pD0X9+1TCm2mDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751955864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhSjB7eeBvliVFTftkEcbzFfski/Q9EF3eUSjNC24+8=;
	b=xnRjJGO0JwsrvBkDAOrZ+QzV1uQAt/AXNJNvOs9i24r14/kT/+FORNZItIljMnmLcHPSHd
	ei1K0XgJ4zB7zc3cN4ViIDW3ZffdxZ3r+uFFgieARZA+1+/CIW1Q6meosLW/PnOo53Q3P5
	WVLHnmhcUlgeR0I6jLjvSlri5hfUgV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751955864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhSjB7eeBvliVFTftkEcbzFfski/Q9EF3eUSjNC24+8=;
	b=1YJVR87Eoj2vYibwc56kNumTasjUFg+hDKhsrBnnYdR9qcQ8QkSMKvrlHZm7Q55qeuikyw
	cZbMvCHJ+s4yRKAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7838213A68;
	Tue,  8 Jul 2025 06:24:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AM7TG5i5bGh+MAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 08 Jul 2025 06:24:24 +0000
Message-ID: <875889d8-7c8d-4735-a35f-06245b88462a@suse.de>
Date: Tue, 8 Jul 2025 08:24:24 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] md/md-bitmap: add a new sysfs api bitmap_type
To: Yu Kuai <yukuai@kernel.org>, hch@lst.de, xni@redhat.com, axboe@kernel.dk,
 linux-raid@vger.kernel.org, song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-6-yukuai@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250707165202.11073-6-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,huawei.com:email,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 7/7/25 18:51, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> The api will be used by mdadm to set bitmap_type while creating new array
> or assembling array, prepare to add a new bitmap.
> 
> Currently available options are:
> 
> cat /sys/block/md0/md/bitmap_type
> none [bitmap]
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   Documentation/admin-guide/md.rst | 73 ++++++++++++++++------------
>   drivers/md/md.c                  | 81 ++++++++++++++++++++++++++++++++
>   2 files changed, 124 insertions(+), 30 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
