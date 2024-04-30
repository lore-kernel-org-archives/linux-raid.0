Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB4F12CDAE
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475723; cv=none; b=p12pBYZtTis3xUCsCt3ieIyOmqUSEwxDM51QYgLLlqe/9NNi3+t1ic6tW40G6EFRZPzAafdhrCL9OzWOqg32DHdpzHWzgbGaMk2tnGrlJbMh48JElPHBwM8UIVxNxBf1mVODJoY1hZpAD9bdA5wwVuALaEqaRuG3JWW0x54Icv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475723; c=relaxed/simple;
	bh=O1aLL/6+4LLxjqvB+J/UIphsphfmRdox2Ep5fa0bbB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EhtF8QyU9Bv1donbuBJgu355xV0mv3FmcNM5IB8mkMZquD8BeYQkSg0a9Y9Pv0uy8vWrQRZySuT/za/TLcLOMPCC9WZYZAaT2FJr5kQe9M63FOD7CSRnQi96sGs5IDx+esViZM2WmwewDhbzm41WZjXUSLxST+flLtgVf082MkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=S9LolPHU; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QqRQIlR6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=yMNjYDW2; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bDUE+MiX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="S9LolPHU";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QqRQIlR6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="yMNjYDW2";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bDUE+MiX"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C0280218E2;
	Tue, 30 Apr 2024 11:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714475719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LcoOVUu0fCMBGEcSyXfNBb0P1OaFsoPZct2jzM0F0go=;
	b=S9LolPHUMGLWINgrqisc1z4914QhCkqHbTno6yZHBmgX5hWDN8YCq6Mmme6/xUpj4IJ3kt
	DzmGIJJXPar3FPs+5SB0NTTa9gbhCjYTv00OC/lLttzpD5G+Y+0y5FGNB0hmjvFQ3gUjtA
	QKEYThi965k+Qal6tDbW4abJLi7x9lY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714475719;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LcoOVUu0fCMBGEcSyXfNBb0P1OaFsoPZct2jzM0F0go=;
	b=QqRQIlR6SuGcnTIYqNyjcFueSy3l71/MPJVbk3zUc6qb1+8ChIPk605tUxw9cHPMo+ZE3r
	dlZ9y1U3zCTwi1Dw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yMNjYDW2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bDUE+MiX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1714475718; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LcoOVUu0fCMBGEcSyXfNBb0P1OaFsoPZct2jzM0F0go=;
	b=yMNjYDW2J0jqUpOUdjCmV95uezZtLQE+9XXEwIshniknaaeVP5ZetYg4qaz0utu4goM9MO
	osbo+degy5XXwUY8UBvK4fqZTOfAGLI8Cvqb1DktexpyP1jt8HSbKXLCsCcLXxGdqVfuJe
	Yy6Ju9xWrZJz4NyWp7EAVzJlW8qc9kY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1714475718;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LcoOVUu0fCMBGEcSyXfNBb0P1OaFsoPZct2jzM0F0go=;
	b=bDUE+MiXE91bCM3xo+VPdOzzgE5PiW77DFKsCRHCKWyZkfU6Rs6ooa08kSUZKvnR2UzDQ3
	OYrG2Lz1k1sPOyAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9DB9E133A7;
	Tue, 30 Apr 2024 11:15:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YzucJcbSMGaIBAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 30 Apr 2024 11:15:18 +0000
Message-ID: <85f74f83-bd1b-439d-874c-b3a38bdd2d71@suse.de>
Date: Tue, 30 Apr 2024 13:15:18 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Move mdadm development to Github
To: Yu Kuai <yukuai1@huaweicloud.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Wols Lists <antlists@youngman.org.uk>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, John Stoffel
 <john@stoffel.org>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240424084116.000030f3@linux.intel.com>
 <26154.50516.791849.109848@quad.stoffel.home>
 <20240424052711.2ee0efd3@peluse-desk5>
 <3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
 <20240426102239.00006eba@linux.intel.com>
 <38770f23-92da-09a6-227f-11f1176294e2@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <38770f23-92da-09a6-227f-11f1176294e2@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.49
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C0280218E2
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.49 / 50.00];
	BAYES_HAM(-2.99)[99.94%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]

On 4/30/24 11:26, Yu Kuai wrote:
> Hi,
> 
> 在 2024/04/26 16:22, Mariusz Tkaczyk 写道:
>> On Fri, 26 Apr 2024 08:27:44 +0100
>> Wols Lists <antlists@youngman.org.uk> wrote:
>>
>>> On 24/04/2024 13:27, Paul E Luse wrote:
>>>> * Instead of using the mailing list to propose patches, use GitHub Pull
>>>>     Requests. Mariusz is setting up GitHub to send an email to the 
>>>> mailing
>>>>     list so that everyone can still be made aware of new patches in the
>>>>     same manner as before.  Just use GitHub moving forward for actual
>>>>     code reviews.
>>>
>>> Does that mean contributors now need a github account? That won't go
>>> down well with some people I expect ...
>>>
>>> Cheers,
>>> Wol
>>
>> Hi Wol,
>>
>> There are thousands repositories on Github you have to register to 
>> participate
>> and I don't believe that Linux developers may don't have Github 
>> account. It is
>> almost impossible to not have a need to sent something to Github.
> 
> Will it still be able to send and apply patches through maillist? It's
> important for us because I just can't create pr at GitHub in my
> company, already tried with Paul, due to our company policy. :(
> Although I can do this at home...
> 
I do think this is a valid point.
(Having been in Beijing recently I do share the pain from Kuai :-)

We really should keep the mailing list alive, and enable people
to choose which interface suits them best.
I don't have a problem in switching to github as the primary
tree, but we should keep the original location intact as a
mirror and continue to allow people to use the mailing list
to send patches.

This is especially important for low-volume mailing lists,
where we have quite a few occasional contributors, and we
should strive to make it as easy (and convenient) as possible
for them.

Cheers,

Hannes
>>
>> Here some examples:
>> https://github.com/iovisor/bcc
>> https://github.com/axboe/fio
>> https://github.com/dracutdevs/dracut
>> https://github.com/util-linux/util-linux
>> https://github.com/bpftrace/bpftrace
>> https://github.com/systemd/systemd
>>
>> I see this as not a problem.
>>
>> Thanks,
>> Mariusz
>>
>> .
>>
> 
> 

