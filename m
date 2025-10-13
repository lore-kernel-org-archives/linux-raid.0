Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133D32848AA
	for <linux-raid@vger.kernel.org>; Mon, 13 Oct 2025 06:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760338101; cv=none; b=NLq9DvpHK2XX2Y/9Y2dcNIDa5eX36tOQW/EmNEZOPtKcTOuTHUNYZUrMsi8ZWTF37p+TIP3XYu+jtvfF/OIxZlQfbhVUkxd0cIDJvc3HxwUr767SaNVLLA6AGtsVOzawPkpjuP4XFo8uCLhwEzmX9aUlwiJd1p7a31wJPO8f9rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760338101; c=relaxed/simple;
	bh=0K5WhokvsxUypof3SAZ0c7TpYShr5Jt8lDdK4Wchzdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PxWltEUbj0y/PbrBEShH041Ed1r8ZDBFrQgTu0JE7NtkjDNdX/vFuRR5L3Qf0Roofi5mRUMUg3nUUXYAzctgTsGvIp9sf26JYG0ZRAoycDf0zxNoCJnP1PHmNP8L72KaTRFZZ8QNg4KKaERFVhgRh09NrNwm7Er0II0QR0vmDsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yzxWTxQn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2bDehkLn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yzxWTxQn; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2bDehkLn; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yzxWTxQn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2bDehkLn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yzxWTxQn";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2bDehkLn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0815D21A06;
	Mon, 13 Oct 2025 06:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760338098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M1/GWZV3ej0AjWCPfWygYfIwXIVYJA+eVR0H3bkZo4=;
	b=yzxWTxQnj1AR3ISeHsd3AqA6uQvxMf94EwzMoT/N2uCJFlnSbPvytRrJysrDLafIlXo/BS
	gwInib9PtTawIX4J1go4MU6bQyqAWJMQmXdSjS+cQ95+qgHTnp16l3I1vjXqOwo46JwlO+
	U/cbAhWmGkkU1bBikBzYFRVOVH4rrSQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760338098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M1/GWZV3ej0AjWCPfWygYfIwXIVYJA+eVR0H3bkZo4=;
	b=2bDehkLnZ2pE9aBAvWszOt+n/NXG+Nv06MMFLLrSllDNCd6wOE3cTSXXx76e1rkARFYzAU
	QSYleWF4D43eCvCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yzxWTxQn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2bDehkLn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760338098; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M1/GWZV3ej0AjWCPfWygYfIwXIVYJA+eVR0H3bkZo4=;
	b=yzxWTxQnj1AR3ISeHsd3AqA6uQvxMf94EwzMoT/N2uCJFlnSbPvytRrJysrDLafIlXo/BS
	gwInib9PtTawIX4J1go4MU6bQyqAWJMQmXdSjS+cQ95+qgHTnp16l3I1vjXqOwo46JwlO+
	U/cbAhWmGkkU1bBikBzYFRVOVH4rrSQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760338098;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+M1/GWZV3ej0AjWCPfWygYfIwXIVYJA+eVR0H3bkZo4=;
	b=2bDehkLnZ2pE9aBAvWszOt+n/NXG+Nv06MMFLLrSllDNCd6wOE3cTSXXx76e1rkARFYzAU
	QSYleWF4D43eCvCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEB741374A;
	Mon, 13 Oct 2025 06:48:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gvb4NLGg7GjESAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 13 Oct 2025 06:48:17 +0000
Message-ID: <b5ab0f4b-b536-42d0-a442-66a8e2638494@suse.de>
Date: Mon, 13 Oct 2025 08:48:17 +0200
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
 <d5227acf-73ff-4cfe-a699-061b75b2d0d3@suse.de>
 <4f333665-9e4f-499c-9cda-fe87d221933a@web.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <4f333665-9e4f-499c-9cda-fe87d221933a@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 0815D21A06
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_TO(0.00)[web.de,thelounge.net,vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:mid,suse.de:email]
X-Spam-Score: -4.51

On 10/11/25 21:25, Roland wrote:
> hello,
> 
> some late reply for this...
> 
>  > Am 10.10.24 um 10:34 schrieb Hannes Reinecke:
>  > Which I really would love
>  > to see reproduced, especially with recent kernels, as there is a lot of
>  > vagueness around it (add part of the disk on the raid as swap? How?
>  > In the host? On the guest?).
> 
> here is a reproducer everybody should be able to follow/reproduce.
> 
> 1. install proxmox pve9 on a system with two empty disks for mdraid. 
> build mdraid and format with ext4 .
> 
> 2. add that ext4 mountpoint as a datastore type "dir" for file/vm 
> storage in proxmox.
> 
> 3. install a debian13 in a normal/default (cache=none, i.e. O_DIRECT = 
> on)  linux VM. the virtual disk should be backed by that mdraid/ext4 
> datastore created above.
> 
> 4. inside the vm as an ordinary user get break-raid-odirect.c from 
> https://forum.proxmox.com/threads/mdraid-o_direct.156036/post-713543 , 
> compile that and let that run for a while. then terminate with ctrl-c.
> 
> 5. on the pve host, check if your raid did not throw any error or has 
> mismatch_count >0 ( cat /sys/block/md127/md/mismatch_cnt ) in the meantime.
> 
> 6. on the pve host start raid check with  "echo check > /sys/block/ 
> md127/md/sync_action"
> 
> 6. let that check run and wait until it finishes (/proc/mdstat)
> 
> 7. check for inconsistencies  via "cat /sys/block/md127/md/mismatch_cnt" 
> again
> 
> i am getting:
> 
> cat /sys/block/md127/md/mismatch_cnt
> 1048832
> 
> so , we see that even with recent kernel (pve9 kernel is 6.14 based on 
> ubuntu kernel),  we can break mdraid from non-root user inside a qemu VM 
> on top ext4 on top of mdraid.
> 

And what would happen if you use 'xfs' instead of 'ext4'?
ext4 has some nasty requirements regarding 'flush', and that might well
explain the issue here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
