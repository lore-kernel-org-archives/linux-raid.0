Received: from pasta.tip.net.au (pasta.tip.net.au [203.10.76.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894C014D283
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 08:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.10.76.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741337180; cv=none; b=bVjy7v3dtl9UQcQsoOCUcym+VXsJyszIo8Bgiq9FAQsl+zxKttZj+vJXkhP54m22U0OGY/Akea7t6s8GLOu1z/AlHokvTTfmgBh8gWXSkxifLHoPK1gxcWcMHCTvupFGsxE6eFkD09X8P1SjA//IRi2isk7iMGtrEvNuI4rU2zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741337180; c=relaxed/simple;
	bh=Lp+0s0Wgh8nskmT12r/ssTJXCxVdZAekt1m7SwihMmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DBMaSr7HIlm/+8B6s+5jjTxscMPU95oANuJ7jIfKPp+Yb1m4veSj7KhPlwmoLAS5y4xgrvSC2D5f1c/PdAgCx4gQ0f5HVqFU2jaqpmTIVui+r0A3mSi0WplJnWGjoXjBIJaJmO+3bUcQs6OwXZ+D7GbC+Fq7LAATan6VuGuJmw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au; spf=pass smtp.mailfrom=eyal.emu.id.au; arc=none smtp.client-ip=203.10.76.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eyal.emu.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eyal.emu.id.au
Received: from [192.168.2.7] (unknown [101.115.15.227])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailhost.tip.net.au (Postfix) with ESMTPSA id 4Z8KdJ4jnbz8tqY
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 19:46:12 +1100 (AEDT)
Message-ID: <e619f4f9-ca95-4259-a0a5-669abc3813a4@eyal.emu.id.au>
Date: Fri, 7 Mar 2025 19:46:09 +1100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eyal@eyal.emu.id.au
Subject: Re: Need to understand error messages
To: Linux-RAID <linux-raid@vger.kernel.org>
References: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
 <CAAMCDefYhzMxbn8D2CAQ-XtsmykPPLsL8sjt-e0tF2QDMy=Y1A@mail.gmail.com>
 <adedae1f-dfdb-4770-aa1d-af2292851629@eyal.emu.id.au>
 <cc4e3021-d2c4-4aca-8923-5f143c156ffd@suse.de>
Content-Language: en-US
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
In-Reply-To: <cc4e3021-d2c4-4aca-8923-5f143c156ffd@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/3/25 18:16, Hannes Reinecke wrote:
> On 3/7/25 05:20, Eyal Lebedinsky wrote:
>> On 7/3/25 12:27, Roger Heflin wrote:
>>> That is the report uncorrectable error coming back to the OS.   ie
>>> sense key: medium error.
>>>
>>> It looks like you had a few commands lined up (the tags) and one io
>>> hung (2888) and eventually failed (bad sector) but it took long enough
>>> that  is timed out on all of the other IO behind it (the SOFT_ERROR).
>>>
>>> The scsi layer should have retried the SOFT ones I would think.
>>>
>>> You might want to check to see what smartctl -l scterc says the disks
>>> timeout is and what the OS level scsi timeout is.  I set the disk
>>> timeouts as low as the disk will allow and leave my OS timeouts
>>> default (30 sec typically).
>>
>> SCT Error Recovery Control:
>>             Read:     70 (7.0 seconds)
>>            Write:     70 (7.0 seconds)
>>
>>> I would have thought there would be a md rewrite.
>>
>> I also thought so. The fact that I now see 48 Reallocated_Sector_Ct suggests that there were
>> writes to the failed sectors, since a failed read adds a Pending then the write leads to Reallocation.
>> Now Current_Pending_Sector is zero.
>>
>> Also, 48 reallocated is more than the one failed sector the disk sensed,
>> and the following timed out tags is something the OS saw (and the disk should not reallocate?).
>>
> The MPT hardware has a very poor queueing implementation. It exposes a SCSI host with literally thousands of commands, but the component drives
> only have a queue depth of 31. So there is a mismatch, and there are
> issues when a long-running command (eg a command triggering error handling) will block the pending commands already queued within the
> firmware.
> In these cases the offending command will cause the _pending_ commands
> to timeout, even though the would probably be perfectly fine if they
> hadn't been blocked. And returning 'QUEUE_FULL' status would be too
> easy...

Are you saying that the blocked commands which end up timing out are treated as bad sectors by the drive?
I expect them to then be marked pending, then only when written to they will be reallocated.
Who is re-writing these sectors?

Why does md/raid say nothing? Are these sectors outside the raid area, so not monitored by md/raid?

TIA,
	Eyal

> Anyway.
> Fact is, your drive developed read errors. And experience shows that
> a read error is the beginning of the end for a drive.
> So I would recommend to not investigate further but rather get a new
> drive.

Yep, I already have one ready for when the situation deteriorates further.

> Cheers,
> 
> Hannes


-- 
Eyal at Home (eyal@eyal.emu.id.au)
