Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720613C2F
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 06:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748326577; cv=none; b=LCB9REWlEYH3h5jlZXv4eR9e/WqMvmYkBauoxd/aWMhlryxRz0wSju7/tkHJHK/mc1K/4PpS3nvWBCUVEN9Aqzvp7Egv8acwmYtTWfGVYiygl3jopviA2kqp30TeOau7AxhQeMd81MHq+HVzy/ZUZ2Kj3hfq6nk35Kmpe6Nkkq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748326577; c=relaxed/simple;
	bh=7XVpgHCYVxJIoUlgSw6eAHknpW8QNrfl86MR6MgEHe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P04+jXsaAd+T1D+NCx7sp29E5nafnoNZPEJGrsNYOr/oDnSH7iQgXDVdR/ihCiRKhNKgV3ERTfBINkxrEBRwpInSJljK450rlbU+ZVkhpnynzCFzKLW8v0KhJrtOmo9PmcoAMQQ5PJz96DVLHapJG+hwM2gXzIjSdPDv9bTAfhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U0cAAHFp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lcvCM5pX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=U0cAAHFp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lcvCM5pX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U0cAAHFp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lcvCM5pX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="U0cAAHFp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lcvCM5pX"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9044F21E79;
	Tue, 27 May 2025 06:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4TGjR+xoKkDpafTHxNXLjZWkn/zfsodRa7cBDqKn6Us=;
	b=U0cAAHFpxR5klKH5MSYryeASRhCODHAGd2z2ff8Vwrd8CWJq3lUPXr20BOSCENW6RxFlTS
	4cGOU0MC4O58fpB/5e7cdHpUMO9Vm0VpZYsYFjzYZrT3jFy6jkCfya/1U64YBXM7ikbny7
	Jl8y0DJtdboQ1teDgHRQW0V9pDZUmck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4TGjR+xoKkDpafTHxNXLjZWkn/zfsodRa7cBDqKn6Us=;
	b=lcvCM5pXipxgY9mPiW6yt1uGOwOxU2a90JKGF7xahwSYMcBb8ThdanUcDjnsv0Dx4tguY1
	LfouLFwsoTV27dDA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748326573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4TGjR+xoKkDpafTHxNXLjZWkn/zfsodRa7cBDqKn6Us=;
	b=U0cAAHFpxR5klKH5MSYryeASRhCODHAGd2z2ff8Vwrd8CWJq3lUPXr20BOSCENW6RxFlTS
	4cGOU0MC4O58fpB/5e7cdHpUMO9Vm0VpZYsYFjzYZrT3jFy6jkCfya/1U64YBXM7ikbny7
	Jl8y0DJtdboQ1teDgHRQW0V9pDZUmck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748326573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4TGjR+xoKkDpafTHxNXLjZWkn/zfsodRa7cBDqKn6Us=;
	b=lcvCM5pXipxgY9mPiW6yt1uGOwOxU2a90JKGF7xahwSYMcBb8ThdanUcDjnsv0Dx4tguY1
	LfouLFwsoTV27dDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 089D7136E0;
	Tue, 27 May 2025 06:16:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UeSGAK1YNWhPGQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 06:16:13 +0000
Message-ID: <2559061d-7c99-46c9-8274-9e60f59b4904@suse.de>
Date: Tue, 27 May 2025 08:16:12 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/23] md/md-bitmap: add a new method blocks_synced() in
 bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-10-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-10-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.10
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.10 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,huawei.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 5/24/25 08:13, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently, raid456 must perform a whole array initial recovery to build
> initail xor data, then IO to the array won't have to read all the blocks
> in underlying disks.
> 
> This behavior will affect IO performance a lot, and nowadays there are
> huge disks and the initial recovery can take a long time. Hence llbitmap
> will support lazy initial recovery in following patches. This method is
> used to check if data blocks is synced or not, if not then IO will still
> have to read all blocks for raid456.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/md-bitmap.h | 1 +
>   drivers/md/raid5.c     | 6 ++++++
>   2 files changed, 7 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
