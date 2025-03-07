Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655B31A89
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 07:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741331785; cv=none; b=k+2/Rw6gPkx+LIe6/mFd7WI34W1tuS3C0zo/5C1Gat/FdWwVbOzREt6IKZEyPXWqfMsccm6EtvGuHZQFPXerVYpuUMtUHTObYm/laG7jHUgiZbrZu5DEo7H57JzO3+mLWbWBwesB0cZyL3T423QhXUiEOCb721Uo5nYbJ6bPCnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741331785; c=relaxed/simple;
	bh=7tW21i3t1YSzpbTLvlKFqqIYzvxBu0HhmdvfNNPlv7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u2JD7VoSkfpky529lCFhSgv0Enmo52ySXDOT90o1NnAjLfxhAixa5PhLy++J92+/YqGHkG8T/Q3ME2iWSM3tjojmOugUED3DQP2bIHzsDSlGULMBMYFAaJRw6B7xcqNL6hWJgGOTk7vtkteic2c03v0g+PkUTRiYzRy8tFaCKWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xywHqpHH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z+VO/Xfg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xywHqpHH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z+VO/Xfg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xywHqpHH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z+VO/Xfg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xywHqpHH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z+VO/Xfg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 918A51F38E;
	Fri,  7 Mar 2025 07:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741331781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wo82nYSRDn8TvsHEzUnGu7IhpuLb8r4LVb7fCnivUU=;
	b=xywHqpHHvgNs0vpUVpDCIiIjmJtHIxxLRcGkLpOjcnXfWwBAmese4OT+9xXe/8UhVDBNoU
	BANUWjxvyP38eYKD80OdV82FTXO8hHtInxpa2qvhN6f02p80dLo0CGTQhOapDVSJv+1ukU
	nrEwsoOADlkWGKSUXF99pMeIAC/nWjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741331781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wo82nYSRDn8TvsHEzUnGu7IhpuLb8r4LVb7fCnivUU=;
	b=Z+VO/XfgQfyyOlQcXGd1TmzJmTqWxvdzl28euEV7Lg9pFRnK3dqNDxlnsRL1OBQQuWLkXl
	tC9YDc3dmrbFH5AQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1741331781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wo82nYSRDn8TvsHEzUnGu7IhpuLb8r4LVb7fCnivUU=;
	b=xywHqpHHvgNs0vpUVpDCIiIjmJtHIxxLRcGkLpOjcnXfWwBAmese4OT+9xXe/8UhVDBNoU
	BANUWjxvyP38eYKD80OdV82FTXO8hHtInxpa2qvhN6f02p80dLo0CGTQhOapDVSJv+1ukU
	nrEwsoOADlkWGKSUXF99pMeIAC/nWjk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1741331781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9wo82nYSRDn8TvsHEzUnGu7IhpuLb8r4LVb7fCnivUU=;
	b=Z+VO/XfgQfyyOlQcXGd1TmzJmTqWxvdzl28euEV7Lg9pFRnK3dqNDxlnsRL1OBQQuWLkXl
	tC9YDc3dmrbFH5AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71A2013A22;
	Fri,  7 Mar 2025 07:16:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /FcYGkWdymeBHQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Mar 2025 07:16:21 +0000
Message-ID: <cc4e3021-d2c4-4aca-8923-5f143c156ffd@suse.de>
Date: Fri, 7 Mar 2025 08:16:20 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Need to understand error messages
To: eyal@eyal.emu.id.au, Linux-RAID <linux-raid@vger.kernel.org>
References: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
 <CAAMCDefYhzMxbn8D2CAQ-XtsmykPPLsL8sjt-e0tF2QDMy=Y1A@mail.gmail.com>
 <adedae1f-dfdb-4770-aa1d-af2292851629@eyal.emu.id.au>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <adedae1f-dfdb-4770-aa1d-af2292851629@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On 3/7/25 05:20, Eyal Lebedinsky wrote:
> On 7/3/25 12:27, Roger Heflin wrote:
>> That is the report uncorrectable error coming back to the OS.   ie
>> sense key: medium error.
>>
>> It looks like you had a few commands lined up (the tags) and one io
>> hung (2888) and eventually failed (bad sector) but it took long enough
>> that  is timed out on all of the other IO behind it (the SOFT_ERROR).
>>
>> The scsi layer should have retried the SOFT ones I would think.
>>
>> You might want to check to see what smartctl -l scterc says the disks
>> timeout is and what the OS level scsi timeout is.  I set the disk
>> timeouts as low as the disk will allow and leave my OS timeouts
>> default (30 sec typically).
> 
> SCT Error Recovery Control:
>             Read:     70 (7.0 seconds)
>            Write:     70 (7.0 seconds)
> 
>> I would have thought there would be a md rewrite.
> 
> I also thought so. The fact that I now see 48 Reallocated_Sector_Ct 
> suggests that there were
> writes to the failed sectors, since a failed read adds a Pending then 
> the write leads to Reallocation.
> Now Current_Pending_Sector is zero.
> 
> Also, 48 reallocated is more than the one failed sector the disk sensed,
> and the following timed out tags is something the OS saw (and the disk 
> should not reallocate?).
> 
The MPT hardware has a very poor queueing implementation. It exposes a 
SCSI host with literally thousands of commands, but the component drives
only have a queue depth of 31. So there is a mismatch, and there are
issues when a long-running command (eg a command triggering error 
handling) will block the pending commands already queued within the
firmware.
In these cases the offending command will cause the _pending_ commands
to timeout, even though the would probably be perfectly fine if they
hadn't been blocked. And returning 'QUEUE_FULL' status would be too
easy...

Anyway.
Fact is, your drive developed read errors. And experience shows that
a read error is the beginning of the end for a drive.
So I would recommend to not investigate further but rather get a new
drive.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
