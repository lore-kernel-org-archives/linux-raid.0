Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA371DF74F
	for <linux-raid@vger.kernel.org>; Thu, 21 Aug 2025 09:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755768844; cv=none; b=oxNc1jMKRVAvprD9JSSPsVp+DJcoc01+jQyJcbS7ZX1J/5soVJMyNLEWlt0xttRgZAaw9dqMSXlmitAVvLIDuEk+YT2P4E8l2Zgl9OMD7QckKYVB0y1NOueDzKbPIQO5dR8zFVHn1NJsBhtFQjPGDPueL/TykSZM+UdNiXjtTAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755768844; c=relaxed/simple;
	bh=JuXeAv/4FcR9lnR8pXag6In1cVN738yVG59mHtXWChI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4kbNp0u0/6aHIJj0nEcOjOERGTUIB5oTzzArloFtrDTQCQsVaY8oriBZS0eBk5PshUPT57XcEtnQYnloImGN7EddWr6OVAiBBGFCvFWRr7yS0Ee/MoqPK/q2dvRyq1eoIE44qlaQzva2Zi4VnR49fN4JOtVJw+/eUwJ2xzmBL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zrXyiQAY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OMHyoTyx; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=zrXyiQAY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=OMHyoTyx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zrXyiQAY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OMHyoTyx";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="zrXyiQAY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="OMHyoTyx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3ACF722532;
	Thu, 21 Aug 2025 09:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755768840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gg0vUG6DASwLwZ3W8D+ed+NRC56JkeEwrvEc6aXDzQw=;
	b=zrXyiQAY0DV+iXi6NvTSNzfbzyJKFdPiqZ8OCT2wQKzw+L86Jv06lku7zDfY57+C+tZqoj
	fYVlG5dv4txir4l8F1Am31sXjUZ0YGCyGzTMSmgtksZ27f93pKjcEZ18Y9BKLX/3Nah90Y
	g0daCCw4ws4NFx0hEfkMZzs5peLLuys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755768840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gg0vUG6DASwLwZ3W8D+ed+NRC56JkeEwrvEc6aXDzQw=;
	b=OMHyoTyxm2TNr4dtHBVE0lrmibw5QFXiPcBbNQFBIlnlHpOFle5M1Xx3P7cuOmT+qRQW2V
	I1x9lMVxNv4SIfAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755768840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gg0vUG6DASwLwZ3W8D+ed+NRC56JkeEwrvEc6aXDzQw=;
	b=zrXyiQAY0DV+iXi6NvTSNzfbzyJKFdPiqZ8OCT2wQKzw+L86Jv06lku7zDfY57+C+tZqoj
	fYVlG5dv4txir4l8F1Am31sXjUZ0YGCyGzTMSmgtksZ27f93pKjcEZ18Y9BKLX/3Nah90Y
	g0daCCw4ws4NFx0hEfkMZzs5peLLuys=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755768840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gg0vUG6DASwLwZ3W8D+ed+NRC56JkeEwrvEc6aXDzQw=;
	b=OMHyoTyxm2TNr4dtHBVE0lrmibw5QFXiPcBbNQFBIlnlHpOFle5M1Xx3P7cuOmT+qRQW2V
	I1x9lMVxNv4SIfAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DECA0139A8;
	Thu, 21 Aug 2025 09:33:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZtywNQfopmgaKAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 21 Aug 2025 09:33:59 +0000
Message-ID: <7db2eb2c-9566-4d6b-9f82-a0f65110a807@suse.de>
Date: Thu, 21 Aug 2025 11:33:59 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
To: Christoph Hellwig <hch@infradead.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org,
 linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, colyli@kernel.org, xni@redhat.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
 <aKbcM1XDEGeay6An@infradead.org>
 <54fc027f-f4dc-0412-0d6d-b44a3e644c39@huaweicloud.com>
 <aKbgqoF0UN4_FbXO@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <aKbgqoF0UN4_FbXO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30

On 8/21/25 11:02, Christoph Hellwig wrote:
> On Thu, Aug 21, 2025 at 04:56:33PM +0800, Yu Kuai wrote:
>> Can you give some examples as how to chain the right way?
> 
> fs/xfs/xfs_bio_io.c: xfs_rw_bdev
> fs/xfs/xfs_buf.c: xfs_buf_submit_bio
> fs/xfs/xfs_log.c: xlog_write_iclog
> 
>> BTW, for all
>> the io split case, should this order be fixed? I feel we should, this
>> disorder can happen on any stack case, where top max_sector is greater
>> than stacked disk.
> 
> Yes, I've been trying get Bart to fix this for a while instead of
> putting in a workaround very similar to the one proposed here,
> but so far nothing happened.
> 
> 
This feels like a really stupid fix, but wouldn't that help?

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 023649fe2476..2b342bb59612 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5478,7 +5478,6 @@ static struct bio *chunk_aligned_read(struct mddev 
*mddev, struct bio *raid_bio)
                 split = bio_split(raid_bio, sectors, GFP_NOIO, 
&conf->bio_split);
                 bio_chain(split, raid_bio);
                 submit_bio_noacct(raid_bio);
-               raid_bio = split;
         }


Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
