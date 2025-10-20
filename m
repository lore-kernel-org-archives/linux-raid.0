Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A652BE03D
	for <linux-raid@vger.kernel.org>; Mon, 20 Oct 2025 06:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760942692; cv=none; b=i6V5zmSVQRbLI9Si021ZEIP1tGXERH2B8u5ifrQW8ipUfkp6ziwSvXbmz1WLeWQn4TSWk/QcNvCTEqT22wq3of/9oOdmWCeYQ502GBXFdgEFFVvywY89EEHe6ZMyqprmVTjNcH2PEk3CAwtNn4NsylI1edqKzE8UY4C1KQtr1FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760942692; c=relaxed/simple;
	bh=uFNLl3IlIca9w03SGY5DObulHVLYLiRc0UPCovBF8EE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uUYz9/+nqVUuVJ6Zu2TPMM83C8H8oC7EQAUeXgRmDkRHl7+DtN3pC7kNUPP8opiTvNjZ4gWYLxlXObAsw9rCLoY3CD4fTJ6AwLgUGj1UkrxhQudA+8Nc74oN3xxQNrxCLhAEYEb1r52uVeuSGYWkd+nMhBsUDKf/shnqL28edO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1K0cEV9N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jpd8yj9j; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1K0cEV9N; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jpd8yj9j; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1K0cEV9N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jpd8yj9j";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1K0cEV9N";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jpd8yj9j"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EB5621F38D;
	Mon, 20 Oct 2025 06:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760942685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0Gj/wGYQl5qWPhiq2HRLgBrNspohCES9Ig4viZZ5YU=;
	b=1K0cEV9NWU0hhK5HS9eFe1yOVTPc0x5KpIg25c8UFpkQuu7eeP50UMtvUSHGD/00ryz5Kt
	J6qC/B36cQej7X1KfzKjvMf7A93wpfmAw5Tp5aDrc0xUSLfytdFxH5UlyE/CNSN8AgC44I
	lCbpxi3QOu6yH4g/1D0CcxKrtkmyzE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760942685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0Gj/wGYQl5qWPhiq2HRLgBrNspohCES9Ig4viZZ5YU=;
	b=jpd8yj9jU3xkH3ftrS0tE5zJKNFh1znBNKL3aeAe/ckdvbZpD21CLNozKbDb7VD6Ern0P1
	tECzYf7vsGgreEAg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1K0cEV9N;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jpd8yj9j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760942685; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0Gj/wGYQl5qWPhiq2HRLgBrNspohCES9Ig4viZZ5YU=;
	b=1K0cEV9NWU0hhK5HS9eFe1yOVTPc0x5KpIg25c8UFpkQuu7eeP50UMtvUSHGD/00ryz5Kt
	J6qC/B36cQej7X1KfzKjvMf7A93wpfmAw5Tp5aDrc0xUSLfytdFxH5UlyE/CNSN8AgC44I
	lCbpxi3QOu6yH4g/1D0CcxKrtkmyzE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760942685;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0Gj/wGYQl5qWPhiq2HRLgBrNspohCES9Ig4viZZ5YU=;
	b=jpd8yj9jU3xkH3ftrS0tE5zJKNFh1znBNKL3aeAe/ckdvbZpD21CLNozKbDb7VD6Ern0P1
	tECzYf7vsGgreEAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C655613A8E;
	Mon, 20 Oct 2025 06:44:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qErDLlza9Wh8aAAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 20 Oct 2025 06:44:44 +0000
Message-ID: <7f3ad574-584a-4556-bafb-88f20cc2bc40@suse.de>
Date: Mon, 20 Oct 2025 08:44:44 +0200
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
References: <A4168F21-4CDF-4BAD-8754-30BAA1315C6F@web.de>
 <e686d669-c41f-42a7-be53-9538feb4721f@web.de>
 <9ef4398c-3488-492e-82ed-903fc46fed70@suse.de>
 <fd968202-04aa-48e3-bbd7-8520570d1ae2@web.de>
 <92bc9643-53fe-4c56-abdd-7a9efb451f1c@suse.de>
 <fc14e278-34d0-408c-93ef-ad22a42e87fd@web.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <fc14e278-34d0-408c-93ef-ad22a42e87fd@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: EB5621F38D
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[web.de,thelounge.net,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	URIBL_BLOCKED(0.00)[suse.de:dkim,suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 10/17/25 22:18, Roland wrote:
> good evening,
> 
> are you really sure fs-fsdevel is the right place to report this?
> 
> i just was able to reproduce the mdraid breakage without any filesystem 
> involved,  just put lvm on top of mdraid and passed lvm logical volumes 
> from that to the debian vm, and then ran "break-raid-odirect /dev/sdb" 
> inside vm.
> 
> meanwhile,  btrfs issue with O_DIRECT seems to be fixed,  at least from 
> my quick tests, reported at https://bugzilla.kernel.org/show_bug.cgi? 
> id=99171#c35 . btrfs fix is also linked there.
> 
Ah, so btrfs is fixed, so indeed a report on fsdevel is pointless.
So on the good side my analysis was correct (phew :-); on the flip
side my attempt to offload that problem to someone else has failed :-(

So guess we need to fix it after all.
Curious, though; for RAID5 we do set the 'STABLE_WRITES' flag.
Does the issue occur with RAID5, too?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

