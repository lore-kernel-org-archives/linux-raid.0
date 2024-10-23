Received: from outbound1a.eu.mailhop.org (outbound1a.eu.mailhop.org [52.58.109.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2E515B0E2
	for <linux-raid@vger.kernel.org>; Wed, 23 Oct 2024 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=52.58.109.202
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729684066; cv=pass; b=KzGGF+zm1NUP6haPMTylV+wu69+EkyKK3tEY1abF6zva97ZqJXvlivefLhEvrAVOUZo495CYC6AFaYG32MNJQe/LwbxBx1wQqHTu0fcdGztDwbLTQRgjWL7E0x2S+npmHL2lEcN63S38tJ70sd9LsVYvn4H5I9kE/+OvAGtYRbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729684066; c=relaxed/simple;
	bh=68hre9auU0UcFzrj6qjvpNuezBS+ifdYUUmtEsT2ovg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrgCgSiMjUxKD6/6c1H08zeckF+G7V1f7yPKTdoaS2A7+nIRUaBWRMaYzMGu+Tf28nWbew78ctihSbrLz1ik6k7lZqCzeeGlex3NT7GefQ7h+1YttIngY0enWlz/4JV4qKTwxqhSbz+KD8xJrSWy3fAprNnEi0fWgduEb+0P5/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=demonlair.co.uk; spf=pass smtp.mailfrom=demonlair.co.uk; dkim=pass (2048-bit key) header.d=outbound.mailhop.org header.i=@outbound.mailhop.org header.b=H9cQMtBc; arc=pass smtp.client-ip=52.58.109.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=demonlair.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=demonlair.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outbound.mailhop.org header.i=@outbound.mailhop.org header.b="H9cQMtBc"
ARC-Seal: i=1; a=rsa-sha256; t=1729683996; cv=none;
	d=outbound.mailhop.org; s=arc-outbound20181012;
	b=oBq9D16dJbQDsg3pRyP991uqOG3ebxw7EmibIV7pQDPiQUkyADLT0mYZWYvrRWr9pDsw4uE3ETTsi
	 iBy5iRZOP2njMM5z37TvzED9nhKaqJ/aqZjWa7ma8oUq+ay0HH+ETdeE4CHgzxQ4rbYGGsOZWHh7dA
	 RayXJOhwm5Xj2WRFGsUE1GCr/qzym9XmJ9EvfkBfFHzc3vSLpf4Kklr8MvbC4wZD6OAIGjI9MZ50l7
	 Dkw5jAPys3aDqqeGae7a6ZzM+XHKGMF5gwB7deug8l1pQRlZ9X158bYNLTDoKsdGBM6RQXdUQP08fj
	 pRF2GktnRQpNi/QisFwwNJLYxBjbPnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=outbound.mailhop.org; s=arc-outbound20181012;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:dkim-signature:from;
	bh=15OBzub3D3TNmzRyaJ2oUMZpMVecCcfBW7sEJ66/fEo=;
	b=g2raR+xHroem/WwmpRm6Gq6kdun6zqtdTO9NaHtg3eL2/nNVvwc7jVEdbjzRPxBBLJ+ArR7fMRkXW
	 HHaAuHgGuPvNYEYu7cMvK7lKPTnm/Ny765WFGI+aakto9ZD6iJwqTbOxDg81IzTfHrsIaMCdJ5dQfC
	 dGnFhPGoAQdwQ9FpTmMibkoRszf1aCUSw0rwYEcIA+wWFIJQEU+mV3IGSyHGdU92mRdxi9x9oYlko/
	 t1M03hJt2TFVJtlwIMlL8SDULJzSOIInXPFx8QXwBQxOHjKV/Au0SinAsbjgRtDHpSp9Qcp7vx/yKY
	 jHCo9HBAKXNU41azcPNfKDVrT/UOyDw==
ARC-Authentication-Results: i=1; outbound2.eu.mailhop.org;
	spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=217.43.3.134;
	dmarc=none header.from=demonlair.co.uk;
	arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=outbound.mailhop.org; s=dkim-high;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=15OBzub3D3TNmzRyaJ2oUMZpMVecCcfBW7sEJ66/fEo=;
	b=H9cQMtBceSScH1z9RSGEltupp2X0UfQWWCG5SEOfAInqau5k6uzd8np05bxVFAzRdR5QCmYQz9uME
	 h/gqKuqILr5wpUXptBijxylO/Oeac0igyqGljVzzVMdzLi0NKEs2A842BVWgaJKgR/3eOdq0dCjrav
	 PFZig4iljL/RcpP5WkfgSFKMaJOsupmbGtNiow3xb7n4VA12ZuBSEoMpa6kgrNzdWgUcU3ZmsifazR
	 Vy6MV4rbJx8By0fldTfbTIJVWFGkUObE4g37G+sAsISABzNeFQ35Q2zJatuGhDYXU9DykOzoEYyObW
	 uzeWhvvlmLC68wePepxtEXEKnkOioXA==
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 706bbe76-9134-11ef-9b27-7b4c7e2b9385
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host217-43-3-134.range217-43.btcentralplus.com [217.43.3.134])
	by outbound2.eu.mailhop.org (Halon) with ESMTPA
	id 706bbe76-9134-11ef-9b27-7b4c7e2b9385;
	Wed, 23 Oct 2024 11:46:29 +0000 (UTC)
Received: from [10.57.1.52] (neptune.demonlair.co.uk [10.57.1.52])
	by phoenix.demonlair.co.uk (Postfix) with ESMTP id 22E501EA107;
	Wed, 23 Oct 2024 12:46:28 +0100 (BST)
Message-ID: <098e65e7-53fb-4bf1-b973-2bda425139ae@demonlair.co.uk>
Date: Wed, 23 Oct 2024 12:46:27 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 5/6] md/raid1: Handle bio_split() errors
Content-Language: en-GB
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 axboe@kernel.dk, hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-6-john.g.garry@oracle.com>
 <bc4c414c-a7aa-358b-71c1-598af05f005f@huaweicloud.com>
 <0161641d-daef-4804-b4d2-4a83f625bc77@oracle.com>
 <c03de5c7-20b8-3973-a843-fc010f121631@huaweicloud.com>
 <44806c6f-d96a-498c-83e1-e3853ee79d5a@oracle.com>
 <59a46919-6c6d-46cb-1fe4-5ded849617e1@huaweicloud.com>
 <6148a744-e62c-45f6-b273-772aaf51a2df@oracle.com>
 <be465913-80c7-762a-51f1-56021aa323dd@huaweicloud.com>
 <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
From: Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <0cf7985e-e7ac-4503-827b-eb2a0fd6ef67@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 23/10/2024 12:16, John Garry wrote:
> On 23/09/2024 10:38, Yu Kuai wrote:
>>>>>> We need a new branch in read_balance() to choose a rdev with full 
>>>>>> copy.
>>>>> Sure, I do realize that the mirror'ing personalities need more 
>>>>> sophisticated error handling changes (than what I presented).
>>>>>
>>>>> However, in raid1_read_request() we do the read_balance() and then 
>>>>> the bio_split() attempt. So what are you suggesting we do for the 
>>>>> bio_split() error? Is it to retry without the bio_split()?
>>>>>
>>>>> To me bio_split() should not fail. If it does, it is likely ENOMEM 
>>>>> or some other bug being exposed, so I am not sure that retrying with 
>>>>> skipping bio_split() is the right approach (if that is what you are 
>>>>> suggesting).
>>>> bio_split_to_limits() is already called from md_submit_bio(), so here
>>>> bio should only be splitted because of badblocks or resync. We have to
>>>> return error for resync, however, for badblocks, we can still try to
>>>> find a rdev without badblocks so bio_split() is not needed. And we need
>>>> to retry and inform read_balance() to skip rdev with badblocks in this
>>>> case.
>>>>
>>>> This can only happen if the full copy only exist in slow disks. This
>>>> really is corner case, and this is not related to your new error path by
>>>> atomic write. I don't mind this version for now, just something
>>>> I noticed if bio_spilit() can fail.
> Hi Kuai,
>
> I am just coming back to this topic now.
>
> Previously I was saying that we should error and end the bio if we need 
> to split for an atomic write due to BB. Continued below..
>
>>> Are you saying that some improvement needs to be made to the current 
>>> code for badblocks handling, like initially try to skip bio_split()?
>>>
>>> Apart from that, what about the change in raid10_write_request(), 
>>> w.r.t error handling?
>>>
>>> There, for an error in bio_split(), I think that we need to do some 
>>> tidy-up if bio_split() fails, i.e. undo increase in rdev->nr_pending 
>>> when looping conf->copies
>>>
>>> BTW, feel free to comment in patch 6/6 for that.
>> Yes, raid1/raid10 write are the same. If you want to enable atomic write
>> for raid1/raid10, you must add a new branch to handle badblocks now,
>> otherwise, as long as one copy contain any badblocks, atomic write will
>> fail while theoretically I think it can work.
> Can you please expand on what you mean by this last sentence, "I think 
> it can work".
>
> Indeed, IMO, chance of encountering a device with BBs and supporting 
> atomic writes is low, so no need to try to make it work (if it were 
> possible) - I think that we just report EIO.
>
> Thanks,
> John
>
>
Hi all,

Looking at this from a different angle: what does the bad blocks system
actually gain in modern environments?  All the physical storage devices
I can think of (including all HDDs and SSDs, NVME or otherwise) have
internal mechanisms for remapping faulty blocks, and therefore
unrecoverable blocks don't become visible to the Linux kernel level
until after the physical storage device has exhausted its internal
supply of replacement blocks.  At that point the physical device is
already catastrophically failing, and in the case of SSDs will likely
have already transitioned to a read-only state.  Using bad-blocks at the
kernel level to map around additional faulty blocks at this point does
not seem to me to have any benefit, and the device is unlikely to be
even marginally usable for any useful length of time at that point anyway.

It seems to me that the bad-blocks capability is a legacy from the
distant past when HDDs did not do internal block remapping and hence the
kernel could usefully keep a disk usable by mapping out individual
blocks in software.
If this is the case and there isn't some other way that bad-blocks is
still beneficial, might it be better to drop it altogether rather than
implementing complex code to work around its effects?

Of course I'm happy to be corrected if there's still a real benefit to
having it, just because I can't see one doesn't mean there isn't one.

Regards,
Geoff.



