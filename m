Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A856168B1;
	Mon, 23 Sep 2024 05:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727070823; cv=none; b=cwgRp4n0OdO2IY+qlSdXY6NdL0oPeG/HHGfsvAigWPUo6+Nj9huJdFM5i1LvyHi6mOGuJU3hG+nPGmTIK1zLsadt4YyJEERPm5F0rvOLQgdVV2S4L/IEt2ABg55b0QerG/YCd1yRKscglmI5BU52VoNtpMnNCv2qNgl5QDES1rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727070823; c=relaxed/simple;
	bh=sf3V80GPyFtj7LTIRLJsWvkyG0ioyji0ZftZpNH+jRg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E9VBa3Vl/+GEvZT1wGTTLPhoHxMXfz8ORKAdrL1ItZ0wnMDXNMM8b0nfuBraVaJ9Mw0BapYnqzmyel2CcRkFkbrDnulwfyuIOdwJa0QqdCk4wLAhSdghBGDFBx237+0WIgzm1fFI+MvUA1r675x46fQlCg2OCcGE2C4gyZJpFv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rXZblZ4m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Th0Y4fG6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rXZblZ4m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Th0Y4fG6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rXZblZ4m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Th0Y4fG6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rXZblZ4m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Th0Y4fG6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CE9D22072;
	Mon, 23 Sep 2024 05:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727070819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADuezOlETxy0/n7y7P2jfSYJYAvuEB7u84Eti02Znbo=;
	b=rXZblZ4m2uBDwSUjlo8y1xdUvmjQHXDx9AKH+xXny8oXpBKpv2ZnqpR1moQahMaiCJ4L/k
	+ce/vhZCS0CIbpB7jfRSYgtCWsW3bahHTiRdtDmSQse2ytLvWgfHZGvuKZU68/VCRnyEe1
	3hbGIJeIYsciOIpty0AxS/Y1OEzzkmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727070819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADuezOlETxy0/n7y7P2jfSYJYAvuEB7u84Eti02Znbo=;
	b=Th0Y4fG6lBw7XZWnN2uvfujRuQmSlb3+prwmQlRL03OA9WSi7FjZpwhQKCJoWaIHXO2N7z
	XzGHfm+gCI/BlVAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rXZblZ4m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Th0Y4fG6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727070819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADuezOlETxy0/n7y7P2jfSYJYAvuEB7u84Eti02Znbo=;
	b=rXZblZ4m2uBDwSUjlo8y1xdUvmjQHXDx9AKH+xXny8oXpBKpv2ZnqpR1moQahMaiCJ4L/k
	+ce/vhZCS0CIbpB7jfRSYgtCWsW3bahHTiRdtDmSQse2ytLvWgfHZGvuKZU68/VCRnyEe1
	3hbGIJeIYsciOIpty0AxS/Y1OEzzkmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727070819;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ADuezOlETxy0/n7y7P2jfSYJYAvuEB7u84Eti02Znbo=;
	b=Th0Y4fG6lBw7XZWnN2uvfujRuQmSlb3+prwmQlRL03OA9WSi7FjZpwhQKCJoWaIHXO2N7z
	XzGHfm+gCI/BlVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 09A0B132C7;
	Mon, 23 Sep 2024 05:53:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GInrOGIC8WYVRAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 23 Sep 2024 05:53:38 +0000
Message-ID: <bbe71976-c16c-4e3c-b110-6bf8eb709d54@suse.de>
Date: Mon, 23 Sep 2024 07:53:33 +0200
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
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240919092302.3094725-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4CE9D22072
X-Spam-Level: 
X-Spamd-Result: default: False [-6.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim,suse.de:mid];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -6.51
X-Spam-Flag: NO

On 9/19/24 11:22, John Garry wrote:
> bio_split() error handling could be improved as follows:
> - Instead of returning NULL for an error - which is vague - return a
>    PTR_ERR, which may hint what went wrong.
> - Remove BUG_ON() calls - which are generally not preferred - and instead
>    WARN and pass an error code back to the caller. Many callers of
>    bio_split() don't check the return code. As such, for an error we would
>    be getting a crash still from an invalid pointer dereference.
> 
> Most bio_split() callers don't check the return value. However, it could
> be argued the bio_split() calls should not fail. So far I have just
> fixed up the md RAID code to handle these errors, as that is my interest
> now.
> 
> Sending as an RFC as unsure if this is the right direction.
> 
> The motivator for this series was initial md RAID atomic write support in
> https://lore.kernel.org/linux-block/21f19b4b-4b83-4ca2-a93b-0a433741fd26@oracle.com/
> 
> There I wanted to ensure that we don't split an atomic write bio, and it
> made more sense to handle this in bio_split() (instead of the bio_split()
> caller).
> 
> John Garry (6):
>    block: Rework bio_split() return value
>    block: Error an attempt to split an atomic write in bio_split()
>    block: Handle bio_split() errors in bio_submit_split()
>    md/raid0: Handle bio_split() errors
>    md/raid1: Handle bio_split() errors
>    md/raid10: Handle bio_split() errors
> 
>   block/bio.c                 | 14 ++++++++++----
>   block/blk-crypto-fallback.c |  2 +-
>   block/blk-merge.c           |  5 +++++
>   drivers/md/raid0.c          | 10 ++++++++++
>   drivers/md/raid1.c          |  8 ++++++++
>   drivers/md/raid10.c         | 18 ++++++++++++++++++
>   6 files changed, 52 insertions(+), 5 deletions(-)
> 
You are missing '__bio_split_to_limits()' which looks as it would need 
to be modified, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

