Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D94303CA4
	for <linux-raid@vger.kernel.org>; Wed, 15 Oct 2025 06:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760511431; cv=none; b=qPxbUyG4HhPUv/pAAnjP/6dz3YPGl8ddrT84NJl8/nP4KSTX4NHQicpGtoejkAjvQuIZz8eWNs1LCgLb+830kKD4fXLk3E81INTv05ROi/MnDdKDn3IcDcY2T+dzACh5I73FLzCwFjpN7sdrf5BPT+DjJlsZz/owwY1VYimSkpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760511431; c=relaxed/simple;
	bh=Yk1BvWliXr7YH3EzthxwmA8+EIVe1a0FU5GAUZoXpeg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FJ4TO0DQON2OPCdcTF67MhtzeHSJ28iQHML9QDNRajDmlPqtNYWoi2Rsd8FftYFNXjmV+xiVaDQiS+UE+m/6qmhihzX3L3jKarqAIH2SvcLJmM+1m/irp7GNYhGRE877iugcB7cAbSj2voGMwpqg5qNPSD3PHztO6rRFndQxFzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bPG2tf/o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4cWKMvvO; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bPG2tf/o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4cWKMvvO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bPG2tf/o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4cWKMvvO";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bPG2tf/o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="4cWKMvvO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C0A4720EF9;
	Wed, 15 Oct 2025 06:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760511418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vABGQncGrlKK6zfwGkL/rtdidYc6xH8cn/Bavk5KuOI=;
	b=bPG2tf/o7pVrcgnkmqZ0dL2qWe0aUBmVqRPx9pfGwsNHSsSHzBuJHb46uG2rHPJ+yW6UDy
	fFFRT6QdH0w+nOMfVGRS2EQBrKgxDnQ4zbbXj4haSq0Em4rOUvtL7lvAJhSlJUXVSXvLyt
	dcekTBKMB8D0aNCoy/fAaPe2YqyLZ+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760511418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vABGQncGrlKK6zfwGkL/rtdidYc6xH8cn/Bavk5KuOI=;
	b=4cWKMvvOFrSGTXob/p5dH+PZAhWDFYRNdLwoQbIVhER56XUxOm3u/AjeFfo1on/3+qXqH5
	ahI5uZMLbdAzmlCg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="bPG2tf/o";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4cWKMvvO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760511418; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vABGQncGrlKK6zfwGkL/rtdidYc6xH8cn/Bavk5KuOI=;
	b=bPG2tf/o7pVrcgnkmqZ0dL2qWe0aUBmVqRPx9pfGwsNHSsSHzBuJHb46uG2rHPJ+yW6UDy
	fFFRT6QdH0w+nOMfVGRS2EQBrKgxDnQ4zbbXj4haSq0Em4rOUvtL7lvAJhSlJUXVSXvLyt
	dcekTBKMB8D0aNCoy/fAaPe2YqyLZ+E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760511418;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vABGQncGrlKK6zfwGkL/rtdidYc6xH8cn/Bavk5KuOI=;
	b=4cWKMvvOFrSGTXob/p5dH+PZAhWDFYRNdLwoQbIVhER56XUxOm3u/AjeFfo1on/3+qXqH5
	ahI5uZMLbdAzmlCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A78AA13A29;
	Wed, 15 Oct 2025 06:56:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TX/FJ7pF72gzGgAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 15 Oct 2025 06:56:58 +0000
Message-ID: <9ef4398c-3488-492e-82ed-903fc46fed70@suse.de>
Date: Wed, 15 Oct 2025 08:56:54 +0200
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
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <e686d669-c41f-42a7-be53-9538feb4721f@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0A4720EF9
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_TO(0.00)[web.de,thelounge.net,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

On 10/14/25 22:14, Roland wrote:
> sorry, resend in text format as mail contained html and bounced from ML.
> 
> ﻿
> Am 14.10.25 um 08:31 schrieb Hannes Reinecke:
>> Hmm. I still would argue that the testcase quoted is invalid.
>>
>> What you do is to issue writes of a given buffer, while at the
>> same time modifying the contents of that buffer.
>>
>> As we're doing zerocopy with O_DIRECT the buffer passed to pwrite
>> is _the same_ buffer used when issuing the write to disk. The
>> block layer now assumes that the buffer will _not_ be modified
>> when writing to disk (ie between issuing 'pwrite' and the resulting
>> request being send to disk).
>> But that's not the case here; it will be modified, and consequently
>> all sorts of issues will pop up.
>> We have had all sorts of fun some years back with this issue until
>> we fixed up all filesystems to do this correctly; if interested
>> dig up the threads regarding 'stable pages' on linux-fsdevel.
>>
>> I would think you will end up with a corrupted filesystem if you
>> run this without mdraid by just using btrfs with data checksumming.
>>
> yes, it's correct. you also end up with corrupted btrfs with this tool, 
> see https://bugzilla.kernel.org/show_bug.cgi?id=99171#c16
> 
>> So really I'm not sure how to go from here; I would declare this
>> as invalid, but what do I know ...
>>
>> Cheers,
>>
>> Hannes 
> 
> anyhow, i don't see why this testcase is invalid, especially when zfs 
> seems not to be affected.
> 
Welll ... I am sure you are aware of the somewhat dubious state of zfs 
and linux, right?

And anyway: 'break userspace' is a matter of debate here; the use of
O_DIRECT effectively moves the burden of checking I/O from the kernel
to userspace; with O_DIRECT you can submit _any_ I/O without the kernel
interfering, but at the same time you _must_ ensure that the I/O
submitted conforms to the expectations the block layer has.
And one of the expectation is that data is not modified between
assembling the request and submitting the request to the drive.

But that is precisely what the test program does.

> please look at this issue from a security perspective.
> 
> if you can break or corrupt your raid mirror from userspace even from an 
> insulated layer/environment, i would better consider this "testcase" to 
> be "malicious code" , which is able to subvert the virtualization/block/ 
> fs layer stack.
> 
> how could we prevent, that non-trused users in a vm or container 
> environment can execute this "invalid" code ?
> 
Well, yes, but then this is O_DIRECT.

> 
> how can we prevent, that they do harm on the underlying mirror in a 
> hosting environment for example ?
> 

Well, this has been an ongoing debate for years, and we from the linux
side have had long discussions about that, too.
But eventually we settled on the notion of 'stable pages', ie that the
data buffer for a command _must not_ be modified between assembling the
command and submitting the command to the drivers.
Precisely such that we _can_ do things like data checksumming.

> not using it in a hosting environment is a little bit weird strategy for 
> a linux basic technoligy which exists for years.
> 
Oh, agreed. We do want to make linux better.
But there is a perfectly viable workaround (namely: do not disable
caching on the VM ...). So the question really is: where's the
advantage?
Security and O_DIRECT is always a very tricky subject, as O_DIRECT
is precisely there to circumvent checks in the kernel. And yes,
some of these checks are there to prevent security issues.
So of course the will be security implications, but that was
kinda the idea.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
