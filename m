Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19861A3BC0
	for <linux-raid@vger.kernel.org>; Thu, 10 Oct 2024 06:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728543230; cv=none; b=qV130mQwMX6eCNTp8G4FGuFyb05FkYXTF6jY+qTSbUfU+SbeTNoFGanzLb/B0phDgVuxn3VvUl0koXDsMS7M2Nlb+TY7vPC08SL6CPHhkHe8BKhuxbQhodhhYAFHXFx5Z9Pob+yKfrIbTJrQ0A9aII0sYn6Lan+D8SKKd2J6kcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728543230; c=relaxed/simple;
	bh=SD4CmtX5VnfXhErM5GvvOa2RfxVSUMheGkks92amcQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Sbx3iQ7fotbIqc+2eCV/Re20DYJF6jSGWPqEYvAhPaYJLM03fPAErdOMHAV+NBrpXOw6QG19GJSCuDuivjus9pR/StH4OzfIl5dYHZvVW43mncGI1eTWU6lfP4E+7b3qcY6Sf7/2TxWDc6oy7/CbRk3QMcmRYEs02rpgPT2IpLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=l6p6eX1z; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fwaq7P2W; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nr+YIk3n; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=R7L0vUbD; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="l6p6eX1z";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fwaq7P2W";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nr+YIk3n";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="R7L0vUbD"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E854F1F7ED;
	Thu, 10 Oct 2024 06:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728543227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNNJoC1JgPbUNMBa5Z7/kloyNXt41kiclG3ziLPAnyg=;
	b=l6p6eX1zDo1jRk1xCmn2DP0UHFV3y4dzeEw9zNdVpQxuX5sW9p3ypStIaZlON1bsO40H8r
	QhRGNQ/J67DowC9W2QapE2K/bcSEyvenn8Ic/qdGxePctv0Y7DV4EXqTbpEnqHM9pt+04U
	QBKaZL7+M1hFm37y2kzDrB7FRNPd9+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728543227;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNNJoC1JgPbUNMBa5Z7/kloyNXt41kiclG3ziLPAnyg=;
	b=Fwaq7P2WCCu3RdUhVolmtmtBgZHvlpXLO066P+z1J+k2AgJ7us5IimoYgKqWdNm+u7BuH4
	S2ShyxMr2q++KgBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nr+YIk3n;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=R7L0vUbD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728543226; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNNJoC1JgPbUNMBa5Z7/kloyNXt41kiclG3ziLPAnyg=;
	b=nr+YIk3nrwK28ZTp7ANPPlKdWnlRLbooZ+qww6p7uuqwOzikP6af8WjLyIRd3Cely2uk7J
	TfAMX5bVf+hHSORJxGYqmy182yfnkTbe27+Sh6bxoIS9grLRN/rZtEJiZNqHvyflj98j1U
	GWcnIGpUnFuohs/ZuDYIx5fn2MH8vQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728543226;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNNJoC1JgPbUNMBa5Z7/kloyNXt41kiclG3ziLPAnyg=;
	b=R7L0vUbDRx0eETFWYh33yZLU8Kz+g3IkB/S0SOJsnkyIf2U4VUF+wztMjMNjlwmTrRLl1t
	/o3WwjjVTYHK+8Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BC15B1370C;
	Thu, 10 Oct 2024 06:53:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rtAMLPp5B2dNUAAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 10 Oct 2024 06:53:46 +0000
Message-ID: <ca607ec6-708c-4340-b8b1-05576b92dd88@suse.de>
Date: Thu, 10 Oct 2024 08:53:46 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Reindl Harald <h.reindl@thelounge.net>, Roland <devzero@web.de>,
 linux-raid@vger.kernel.org
References: <5f25dea4-41f6-4bf2-aeed-deb9d8c76e29@web.de>
 <14d8314d-7c36-4f4d-bdef-b8ad0be37fa5@thelounge.net>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <14d8314d-7c36-4f4d-bdef-b8ad0be37fa5@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E854F1F7ED
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[thelounge.net,web.de,vger.kernel.org];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

On 10/9/24 23:38, Reindl Harald wrote:
> 
> Am 09.10.24 um 22:08 schrieb Roland:
>> as proxmox hypervisor does not offer mdadm software raid at installation
>> time because of this bugticket
>>
>> "MD RAID or DRBD can be broken from userspace when using O_DIRECT"
>> https://bugzilla.kernel.org/show_bug.cgi?id=99171
>>
>> ps:
>> also see "qemu cache=none should not be used with mdadm"
>> https://bugzilla.proxmox.com/show_bug.cgi?id=5235
> that all sounds like terrible nosense
> 
> if "Yes. O_DIRECT is really fundamentally broken. There's just no way to 
> fix it sanely. Except by teaching people not to use it, and making the 
> normal paths fast enough" it has to go away
> 
> it's not acceptable that userspace can break the integrity of the 
> underlying RAID - period
> 
Take deep breath everyone.
Nothing has happened, nothing has been broken.
All systems continue to operate as normal.

If you look closely at the mentioned bug, you'll find that it does 
modify the buffer at random times, in particular while it's being 
written to disk.
Now, the boilerplate text for O_DIRECT says: the application is in 
control of the data, and the data will be written without any caching.
Applying that to our testcase it means that the application _can_ modify
the data, even if it's in the process of being written to disk (zero 
copy and all that).
We do guarantee that data is consistent once I/O is completed (here:
once 'write' returns), but we do not (and, in fact, cannot) guarantee
that data is consistent while write() is running.

Which means that the test case is actually invalid; you either would 
need drop O_DIRECT or modify the buffer after write() to arrive with
a valid example.

That doesn't mean that I don't agree with the comments about O_DIRECT.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

