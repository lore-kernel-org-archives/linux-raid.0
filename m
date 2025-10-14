Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019EC1FC3
	for <linux-raid@vger.kernel.org>; Tue, 14 Oct 2025 06:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760423483; cv=none; b=eF/l8h+1lMlsdzB8nxWPwWRpjx/SH0zUofvVXkXahpNGvjecSyUiiSLPvzrhz+xY2AwG3rR09ycXq1LMD08JPB778TPuH3+ic3Ubcog2YarZ8dJQG2DZ1TR1u2tNPAZtQ42FL4t+Ut+DBjOCDjKL7OYxYQM0jPyaAG49P+PE1Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760423483; c=relaxed/simple;
	bh=xgk+vCV4NQ2+PHLULbmp3E8uWLNEgmSm2Qcs9cywWqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=k22b0649LVzmJmRlRtr7NI0irhXjw7xugnUGdRitpKZmYXs02GgiQn0NZ/+srpEhNzPnokMzJw1mqt1g6BiJQEmyxPI4CO856soQK2hjhfCO5vcmEX0FZRDL35UIJqdqXQoexj9/3VD8uejDI806XCkLhgePuul0LQAa/sce5Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qx5H/d2p; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3vXY1bMX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YbXJAlbH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HcGxVWsw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qx5H/d2p";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3vXY1bMX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YbXJAlbH";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HcGxVWsw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2CA11F44F;
	Tue, 14 Oct 2025 06:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760423479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ST+vIsTPr6CFlcPYcuMUBveWPt0gK0J77AYUhrWP0Ao=;
	b=qx5H/d2pXHVJ1FlrQ+59pXy8Bxloi/PvjTSKU1TroeGt+JEC+d5yoanNjbRa2xAiAxrx4a
	I22AbE0ZE7OGCbnzjlpSmOqDq9tMjXFQ8ykivBJFzGr5+e6LBMKkD2J52nnXLAAhZLoLMs
	2txZMPtuGDgiKGpxMDXz9piFIlmRa+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760423479;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ST+vIsTPr6CFlcPYcuMUBveWPt0gK0J77AYUhrWP0Ao=;
	b=3vXY1bMXDYaofhGao45aX5mp2sSXTOGukHR5DqjKlUon6MPkGDUQusfG7gXo0rBX05LIWH
	Z4UbV8fkqi8MbKBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760423477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ST+vIsTPr6CFlcPYcuMUBveWPt0gK0J77AYUhrWP0Ao=;
	b=YbXJAlbH8eZNE1gF7CW/0K73tC6O6ERMKVvGUSJxgMI3Skp5O9SSKsegwIZhBg8l/ULCya
	fqTKcTes+Z43Sd5y77B0Vb0MBcd+mOGXk4pYaI/U4hpjv9JUc0qwS1vW+0xxG0LRRsjk8b
	sdSM7S65LOqQLAeEVSFPDJnTpm9pN8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760423477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ST+vIsTPr6CFlcPYcuMUBveWPt0gK0J77AYUhrWP0Ao=;
	b=HcGxVWswOQGKqp2iEijznZx4+I8UeUmALxI2wsIfOtir/bcDacNRUfpxxdpDX4ct+kzK7M
	8IgxBXLtDMhdh7AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9072213A71;
	Tue, 14 Oct 2025 06:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8WSFITXu7WgyHwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 14 Oct 2025 06:31:17 +0000
Message-ID: <e691a801-7d2a-46ed-9e0c-8d281cc2c999@suse.de>
Date: Tue, 14 Oct 2025 08:31:17 +0200
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
 <b5ab0f4b-b536-42d0-a442-66a8e2638494@suse.de>
 <6fb3e2cb-8eeb-4e76-9364-16348d807784@web.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <6fb3e2cb-8eeb-4e76-9364-16348d807784@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_TO(0.00)[web.de,thelounge.net,vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,pve-hpmini-gen8:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/13/25 21:04, Roland wrote:
> hello,
> 
>>> 7. check for inconsistencies  via "cat /sys/block/md127/md/ 
>>> mismatch_cnt" again
>>>
>>> i am getting:
>>>
>>> cat /sys/block/md127/md/mismatch_cnt
>>> 1048832
>>>
>>> so , we see that even with recent kernel (pve9 kernel is 6.14 based 
>>> on ubuntu kernel),  we can break mdraid from non-root user inside a 
>>> qemu VM on top ext4 on top of mdraid.
>>>
>>
>> And what would happen if you use 'xfs' instead of 'ext4'?
>> ext4 has some nasty requirements regarding 'flush', and that might well
>> explain the issue here.
>>
>> Cheers,
>>
>> Hannes 
> 
> 
> thanks for feedback and for this hint.
> 
> i tested with xfs today , and it seems to make no difference.
> 
> i can inject inconsistency at disk with the mentioned tool at block 
> level via debian-vm with xfs inside debian and hosted on xfs formatted 
> md raid1 on proxmox.
> 
> root@pve-hpmini-gen8:~# cat /sys/block/md126/md/mismatch_cnt
> 59648
> 
> # cat /proc/mdstat
> Personalities : [raid0] [raid1] [raid4] [raid5] [raid6] [raid10] [linear]
> md126 : active raid1 sdb3[1] sda3[0]
>        48794624 blocks super 1.2 [2/2] [UU]
>        [==================>..]  check = 90.5% (44183744/48794624) 
> finish=0.7min speed=107987K/sec
>        bitmap: 1/1 pages [4KB], 65536KB chunk
> 
> md127 : active raid1 sdb1[2] sda1[3]
>        48794624 blocks super 1.2 [2/2] [UU]
>        bitmap: 0/1 pages [0KB], 65536KB chunk
> 
> unused devices: <none>
> 
Hmm. I still would argue that the testcase quoted is invalid.

What you do is to issue writes of a given buffer, while at the
same time modifying the contents of that buffer.

As we're doing zerocopy with O_DIRECT the buffer passed to pwrite
is _the same_ buffer used when issuing the write to disk. The
block layer now assumes that the buffer will _not_ be modified
when writing to disk (ie between issuing 'pwrite' and the resulting
request being send to disk).
But that's not the case here; it will be modified, and consequently
all sorts of issues will pop up.
We have had all sorts of fun some years back with this issue until
we fixed up all filesystems to do this correctly; if interested
dig up the threads regarding 'stable pages' on linux-fsdevel.

I would think you will end up with a corrupted filesystem if you
run this without mdraid by just using btrfs with data checksumming.

So really I'm not sure how to go from here; I would declare this
as invalid, but what do I know ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
