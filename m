Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA3AD528;
	Mon, 23 Sep 2024 09:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727084587; cv=none; b=eJi2v70LOaAA8cG+8fslWuu7euBo8aO9PVaRTjytGy+4qYnAoL7mcJXEBwrMzv15pZyXWPiPRyPIQY7YUAhE0gM0nbjS8ieY7GIbNtwWqXzSm566IAvSIPZqNsluVs3CK7gPpev/PNpoMrIlWrvI5Z3ftrYlcdtACbu9o8oO+qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727084587; c=relaxed/simple;
	bh=HZ6zYXSwPUowEl1MH6o+dXDcx7rUyfmMIJd5ugjJBgU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e+RBSPIlnAPJ2MNKER+AtZEyQP0ozIarQ7rH130btBuCVWzyXjfgNeafB6LR1/R6me4kWB97hDD41jCzV51LDr4gH0wcBpWmLtfdz01B1V4XZesMQ1Chud8dlF5iK8aTVLUvUlGzC5Fzl47D/Pj9vgCP+DQW7CLShq9jRJfjZbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0zTMmEb5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AZnvGOwf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0zTMmEb5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AZnvGOwf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0zTMmEb5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AZnvGOwf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0zTMmEb5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AZnvGOwf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D5081F7C3;
	Mon, 23 Sep 2024 09:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727084583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdoB9u0I0KRlTR/rAzBQwZEq9hGZ57dCDu+Gq4HgFBk=;
	b=0zTMmEb5MqJui9N3EAMb4MTt+2PgXSuUc/dvcpjJRL0VGeOzGKcFDbGA7dCk6TW1uSmcvR
	vOh5RSLey+lCbgehhwGrzqgh7h/g3wYTkdZ+7yc4M8aJWyUlsWG++f0OZT2M+Whk9nAUK/
	NMQU5NiwfyTdAJewrXbwdtfChCjg/Kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727084583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdoB9u0I0KRlTR/rAzBQwZEq9hGZ57dCDu+Gq4HgFBk=;
	b=AZnvGOwfzbjpOWmQvz248rUXk/ygwZDNnNBXlH8sVv1rx6hrqyYxnZUAs7aYpuFVLnNnD5
	3K0JWNHWU+3BGHAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727084583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdoB9u0I0KRlTR/rAzBQwZEq9hGZ57dCDu+Gq4HgFBk=;
	b=0zTMmEb5MqJui9N3EAMb4MTt+2PgXSuUc/dvcpjJRL0VGeOzGKcFDbGA7dCk6TW1uSmcvR
	vOh5RSLey+lCbgehhwGrzqgh7h/g3wYTkdZ+7yc4M8aJWyUlsWG++f0OZT2M+Whk9nAUK/
	NMQU5NiwfyTdAJewrXbwdtfChCjg/Kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727084583;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jdoB9u0I0KRlTR/rAzBQwZEq9hGZ57dCDu+Gq4HgFBk=;
	b=AZnvGOwfzbjpOWmQvz248rUXk/ygwZDNnNBXlH8sVv1rx6hrqyYxnZUAs7aYpuFVLnNnD5
	3K0JWNHWU+3BGHAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2068C1347F;
	Mon, 23 Sep 2024 09:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pZ9mByc48WZWCAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 23 Sep 2024 09:43:03 +0000
Message-ID: <b3cbc01c-e314-4df1-bf0c-b69bdcd638f7@suse.de>
Date: Mon, 23 Sep 2024 11:43:02 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/6] bio_split() error handling rework
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <bbe71976-c16c-4e3c-b110-6bf8eb709d54@suse.de>
 <86f3586d-5b0a-483e-b94b-d4515d5c5244@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <86f3586d-5b0a-483e-b94b-d4515d5c5244@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 9/23/24 09:19, John Garry wrote:
> On 23/09/2024 06:53, Hannes Reinecke wrote:
>> On 9/19/24 11:22, John Garry wrote:
>>> bio_split() error handling could be improved as follows:
>>> - Instead of returning NULL for an error - which is vague - return a
>>>    PTR_ERR, which may hint what went wrong.
>>> - Remove BUG_ON() calls - which are generally not preferred - and 
>>> instead
>>>    WARN and pass an error code back to the caller. Many callers of
>>>    bio_split() don't check the return code. As such, for an error we 
>>> would
>>>    be getting a crash still from an invalid pointer dereference.
>>>
>>> Most bio_split() callers don't check the return value. However, it could
>>> be argued the bio_split() calls should not fail. So far I have just
>>> fixed up the md RAID code to handle these errors, as that is my interest
>>> now.
>>>
>>> Sending as an RFC as unsure if this is the right direction.
>>>
>>> The motivator for this series was initial md RAID atomic write 
>>> support in
>>> https://lore.kernel.org/linux-block/21f19b4b-4b83-4ca2- 
>>> a93b-0a433741fd26@oracle.com/
>>>
>>> There I wanted to ensure that we don't split an atomic write bio, and it
>>> made more sense to handle this in bio_split() (instead of the 
>>> bio_split()
>>> caller).
>>>
>>> John Garry (6):
>>>    block: Rework bio_split() return value
>>>    block: Error an attempt to split an atomic write in bio_split()
>>>    block: Handle bio_split() errors in bio_submit_split()
>>>    md/raid0: Handle bio_split() errors
>>>    md/raid1: Handle bio_split() errors
>>>    md/raid10: Handle bio_split() errors
>>>
>>>   block/bio.c                 | 14 ++++++++++----
>>>   block/blk-crypto-fallback.c |  2 +-
>>>   block/blk-merge.c           |  5 +++++
>>>   drivers/md/raid0.c          | 10 ++++++++++
>>>   drivers/md/raid1.c          |  8 ++++++++
>>>   drivers/md/raid10.c         | 18 ++++++++++++++++++
>>>   6 files changed, 52 insertions(+), 5 deletions(-)
>>>
>> You are missing '__bio_split_to_limits()' which looks as it would need 
>> to be modified, too.
>>
> 
> In __bio_split_to_limits(), for REQ_OP_DISCARD, REQ_OP_SECURE_ERASE, and 
> REQ_OP_WRITE_ZEROES, we indirectly call bio_split(). And bio_split() 
> might error. But functions like bio_split_discard() can return NULL for 
> cases where a split is not required. So I suppose we need to check 
> IS_ERR(split) for those request types mentioned. For NULL being 
> returned, we would still have the __bio_split_to_limits() is "if 
> (split)" check.
> 
Indeed. And then you'll need to modify nvme:

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f72c5a6a2d8e..c99f51e7730e 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -453,7 +453,7 @@ static void nvme_ns_head_submit_bio(struct bio *bio)
          * pool from the original queue to allocate the bvecs from.
          */
         bio = bio_split_to_limits(bio);
-       if (!bio)
+       if (IS_ERR_OR_NULL(bio))
                 return;

         srcu_idx = srcu_read_lock(&head->srcu);

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

