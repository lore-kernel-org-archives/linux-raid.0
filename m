Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0532A1C9EB5
	for <linux-raid@vger.kernel.org>; Thu, 10 Oct 2024 08:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728549270; cv=none; b=R6YjseNJa1pLcIBZ2AcdR2rImxDlgNApGFLopGw/fadT1XZ9zWk+RPxQIWq/k2EY8rM+PQsdk6M53q5fzOKUvZYjKB80bCrnbSohmxBwOVutyUybJkwaVcADt8t3U85YyzZNPt7QtnR5Y1U8KnBLM6vYvYSxCs/xmjCKeJwIjTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728549270; c=relaxed/simple;
	bh=NnwO2VRE18yVcz5jWcwkSCkKevWfYO47TdRPtXS+Hv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gUMkblzuflfjc48XpbicbZEwRVUBM0iT1iP9jJo9/R2alNJ5IvQybG7GIj/fpPZZ3oxXG9StKjDBdaJ/cIgl5yDygOp6NQxO5sSL0vGLxWFzz5PkZ2w2tfX2DdaOakT4AqfwigsGJmmeJ6t4pzJYDC1BFMv4IV+pRLK5UWwgNng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tsOElgis; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k6fn7qId; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tsOElgis; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=k6fn7qId; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tsOElgis";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k6fn7qId";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tsOElgis";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="k6fn7qId"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 182411FEDA;
	Thu, 10 Oct 2024 08:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728549267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azkaO0x1wi+IL4KrGPuDW4JU32n1iprQvUibuMKNlxA=;
	b=tsOElgisDxF2YZrSrpzUzK2IpdjwqJWUszQZOtBJcOv64EV86i3sFFjiXSOWLdWR9Eafs+
	cgCaAj3Ks1Gpj030Y72P76WjXUTUwiUMfkSbcm1Y81U8XLfpS2VZjANpjP8+xuODZfkjk3
	qv2XdCgQ/zZhpTxmNksO1p4pj/wVTVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728549267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azkaO0x1wi+IL4KrGPuDW4JU32n1iprQvUibuMKNlxA=;
	b=k6fn7qIdFDP4QxvQK2dzR2U8yXNM9U6h6G/e8jerRbeZQnwMyvAiENy6+8FUpW5biTFcKc
	bjMsuwCT2BO9lDBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728549267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azkaO0x1wi+IL4KrGPuDW4JU32n1iprQvUibuMKNlxA=;
	b=tsOElgisDxF2YZrSrpzUzK2IpdjwqJWUszQZOtBJcOv64EV86i3sFFjiXSOWLdWR9Eafs+
	cgCaAj3Ks1Gpj030Y72P76WjXUTUwiUMfkSbcm1Y81U8XLfpS2VZjANpjP8+xuODZfkjk3
	qv2XdCgQ/zZhpTxmNksO1p4pj/wVTVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728549267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=azkaO0x1wi+IL4KrGPuDW4JU32n1iprQvUibuMKNlxA=;
	b=k6fn7qIdFDP4QxvQK2dzR2U8yXNM9U6h6G/e8jerRbeZQnwMyvAiENy6+8FUpW5biTFcKc
	bjMsuwCT2BO9lDBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F210C1370C;
	Thu, 10 Oct 2024 08:34:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MiNvOpKRB2cccQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 10 Oct 2024 08:34:26 +0000
Message-ID: <d5227acf-73ff-4cfe-a699-061b75b2d0d3@suse.de>
Date: Thu, 10 Oct 2024 10:34:26 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Roland <devzero@web.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
References: <5f25dea4-41f6-4bf2-aeed-deb9d8c76e29@web.de>
 <14d8314d-7c36-4f4d-bdef-b8ad0be37fa5@thelounge.net>
 <ca607ec6-708c-4340-b8b1-05576b92dd88@suse.de>
 <24498365-34bb-4296-a725-2bd80e226bdd@web.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <24498365-34bb-4296-a725-2bd80e226bdd@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[web.de,thelounge.net,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 10/10/24 09:29, Roland wrote:
> thank you for clearing things up.
> 
>  >Which means that the test case is actually invalid; you either would
> need drop O_DIRECT or modify the buffer
>  >after write() to arrive with a valid example.
> 
> ok, but what about running virtual machines in O_DIRECT mode on top of
> mdraid then ?
> 
> https://forum.proxmox.com/threads/zfs-on-debian-or-mdadm-softraid- 
> stability-and-reliability-of-zfs.116871/post-505697
> 

The example quoted is this:
 > Take a virtual machine, give it a disk - put the image on a software
 > raid and tell qemu to disable caching (iow. use O_DIRECT, because the
 > guest already does caching anyway).
 > Run linux in the VM, add part of the/a disk on the raid as swap, and
 > cause the guest to start swapping a lot.

And then ending up with data corruption on MD. Which I really would love
to see reproduced, especially with recent kernels, as there is a lot of
vagueness around it (add part of the disk on the raid as swap? How?
In the host? On the guest?).

Hint: we (SUSE) have a bugzilla.suse.com. And if someone would be 
reproducing that with, say, OpenSUSE Tumbleweed and open a bugzilla
someone on this list would be more than happy to have a look and do
a proper debugging here. There are a lot of things which have changed
since 2017 (Stable pages? Anyone?), so it might be that the cited issue
simply is not reproducible anymore.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
