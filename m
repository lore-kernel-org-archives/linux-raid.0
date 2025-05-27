Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0110D23FC42
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 08:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748336135; cv=none; b=iXKXlNQdCQ5CO0MUOC6J1PfFtR/YqjgEODTKJdbYYQtIKxcM+U4R0EQtj+LRJystQWPcwfeHamI/44LQcdXr71uG1qNq7K4jYXiiCBY33W+wzLmLm7k6oRs+2uYTHxVZ9WdDXE7s+SeFa342IBm0r1eZj9bUf7E2ow5Tsciw5hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748336135; c=relaxed/simple;
	bh=emWhdKxiQ1Ix5TXXJnr/4FUk1FV3c22yptSIO6Z2iu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fiq6THoTWv4rYEEQ6skqBwJC9i+rKAguwzcRywGkE0QJySPrzB7rvnuGTOnfoKtl5Wl+Ah4KyAYASg0i4bTi1rQmAwh8QdCOtw8N1oYnjyRyHUyTSdAfbz5oLXdk3ZdOAU05qVobSsRTuEb9XSOgccTPEAbNZmmJupUU5tjFfEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=raLheafm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=srvdoB5C; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=raLheafm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=srvdoB5C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="raLheafm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="srvdoB5C";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="raLheafm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="srvdoB5C"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2954521A3C;
	Tue, 27 May 2025 08:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748336131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=phLMsUwbgpfXNra0fPq3K3SDVQPHUxuGOqqE2/eOb4I=;
	b=raLheafmQvTVMT5r7cdvLYHMXQEB0d/BwhB95/ZOlkVGT5yK4nYD5bIBohAgm/eS2AYkVl
	lABcqOuqAmz0FScI/yw4GPMavfFD31P94PD8yQjI+twQX/faQ6ww9Enm4JLSNf3VTpOqYj
	NW5zSs9gkR5r7qdRNMnZO+TCZ3YjOZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748336131;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=phLMsUwbgpfXNra0fPq3K3SDVQPHUxuGOqqE2/eOb4I=;
	b=srvdoB5CGYtJ8Cmk9N+mjM3DGRLZNe3JjyuWPkVCfOda/cfuzJqC9qkZUAFUOvj1fBX5pd
	r1/n0Ak6NdcDWnBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748336131; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=phLMsUwbgpfXNra0fPq3K3SDVQPHUxuGOqqE2/eOb4I=;
	b=raLheafmQvTVMT5r7cdvLYHMXQEB0d/BwhB95/ZOlkVGT5yK4nYD5bIBohAgm/eS2AYkVl
	lABcqOuqAmz0FScI/yw4GPMavfFD31P94PD8yQjI+twQX/faQ6ww9Enm4JLSNf3VTpOqYj
	NW5zSs9gkR5r7qdRNMnZO+TCZ3YjOZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748336131;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=phLMsUwbgpfXNra0fPq3K3SDVQPHUxuGOqqE2/eOb4I=;
	b=srvdoB5CGYtJ8Cmk9N+mjM3DGRLZNe3JjyuWPkVCfOda/cfuzJqC9qkZUAFUOvj1fBX5pd
	r1/n0Ak6NdcDWnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09B571388B;
	Tue, 27 May 2025 08:55:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HRH0AQN+NWgRTQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 08:55:31 +0000
Message-ID: <ac1feea8-325f-4b78-b82d-38930643513a@suse.de>
Date: Tue, 27 May 2025 10:55:30 +0200
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
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-12-yukuai1@huaweicloud.com>
 <a1691267-304d-4a3f-898b-2f8901031d2c@suse.de>
 <c7e108a6-c788-d3d9-346c-9db134ae9ae2@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <c7e108a6-c788-d3d9-346c-9db134ae9ae2@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 5/27/25 10:03, Yu Kuai wrote:
> Hi,
> 
> 在 2025/05/27 14:19, Hannes Reinecke 写道:
>> On 5/24/25 08:13, Yu Kuai wrote:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> daemon_work() will be called by daemon thread, on the one hand, daemon
>>> thread doesn't have strict wake-up time; on the other hand, too much
>>> work are put to daemon thread, like handle sync IO, handle failed
>>> or specail normal IO, handle recovery, and so on. Hence daemon thread
>>> may be too busy to clear dirty bits in time.
>>>
>>> Make bitmap_ops->daemon_work() optional and following patches will use
>>> separate async work to clear dirty bits for the new bitmap.
>>>
>> Why not move it to a workqueue in general?
>> The above argument is valid even for the current implementation, no?
> 
> Yes, and however, I'll prefer not to touch current implementaion :(
> This is trivial comparing to other flaws like global spinlock.
> 
Fair enough.

You can add:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
