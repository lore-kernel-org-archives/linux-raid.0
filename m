Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36A813E059
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 22:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716937004; cv=none; b=qtOppl5Ig+PGcP9pnP/CkXmzAQ8Qp3ogSmUK67QM9WPjZaIiq7EZnpsNEx3uoqIn/4W+jLQsAiplDiH2sCdFaLwDcl/HPGr7Ov4qn0Axw0BjGrgx3ydWg4HA5bQV4zL4kUmLIe1G0dtpJ8kHqI3fyFeJGxZ6dNxcWIyFz9waMdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716937004; c=relaxed/simple;
	bh=1JQs7JW5ULuhxkqa5n4crXXWyvW9UbvB/avA9QSq5kk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=I2oQkT3eoEzVRQLYwbz7/p0SbuQnzbpwnULKs5yLYFxez5GIRcINfEiMORkMtJ2TZ1WUDQIfTNY4fB/KXjLe9RDRdShk8g/ckIJfIP2ld0hMQLZcL3c92DdlXqM/0tSSM05fCtPpUDiM1KFfNE8iNLGxwKfptG8+AJ1abjNfmZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mAfQFGeL; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAfQFGeL"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-354fb2d8f51so1210535f8f.3
        for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 15:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716937000; x=1717541800; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zz1bHZ+4I3MAU77vrZa4+x084W5W0hhywIlSB/JvCQ0=;
        b=mAfQFGeLDpaCdNa04NKBJB98VWhyby9oDD6WgwyZ/IGu35yZ2SkjJfL7E3FAcm9hXv
         abaqHkkLMTHJ9++XzVP8BhLVYF/ecHQvSKzBMcvwO0i06phRWEv9rF5VQLR+pOfqfaHu
         q/aumY7/i+tAg4W++Zzs+XPE74lxObncVeqgFeJEnSF63ucMzJR33xNkYmOpli8jRgiH
         coM6dWeR/4aQNlRB/wN92MLtkgWTFpRPN3zrEV4Itam9W0dAfs3YWf8Uo2jV175SprMO
         HONnBNNzL1JY3bG79cnKcjcch0q2IvbFV4T9dahyaGy4QGiyF+6DkK08DjDppVdVR7PY
         rVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716937000; x=1717541800;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zz1bHZ+4I3MAU77vrZa4+x084W5W0hhywIlSB/JvCQ0=;
        b=jYn4JRRNG/1m+RpIZeOMwQGnbcK4kkw6xQbyWIz7ax8QROsWpYa6KV/zCcXZm1jCFa
         lRngarJ7n1MXxcBV2iC2d2xECKpNhI4mjWItRlJmJ2EHfavx4/f4HrEvRf7kM8wFYY1e
         AWrr4sxXl1YB/PBbYn+ZG1FkPeLFpOSunOV3dPZb1uloGfQmVaPmhAsUhaD/Ce4GAy9y
         7KaePwNHgCDA6bdnHEt44xAsVrYTeu71I8pPhRm8jQPNgsX1ZGPCBCuBIs+/RlZMuAOD
         LUEO1IAbclJQ8VA956XdcghKVeiwAmQvzgC3HjRqpruJVIpV/wth0K6C4BpE5piFM0EU
         xyxQ==
X-Gm-Message-State: AOJu0YzZ00eQ2ruAVhvtYngY0Wv6VkOKiVgrE/zGpN2eYhsZIv5MGDuB
	w3BUKsqMendJMYhS+ojpzzZAjqYx21fjQ0KtsDsPlq+MF0PYYf4eT+Fzrw==
X-Google-Smtp-Source: AGHT+IF6zg5ZFQSP+bTQ0q/Uu3ZlQkPkFqiZVe7EezpEuwkUi9ULmUednJJEMRiD1yxQXcKs4renZQ==
X-Received: by 2002:a5d:47a9:0:b0:357:b524:ed39 with SMTP id ffacd0b85a97d-357b524ef1emr7267682f8f.68.1716936999708;
        Tue, 28 May 2024 15:56:39 -0700 (PDT)
Received: from ?IPV6:2a02:3102:6876:11:5b51:e1db:2186:dbe4? (dynamic-2a02-3102-6876-0011-5b51-e1db-2186-dbe4.310.pool.telefonica.de. [2a02:3102:6876:11:5b51:e1db:2186:dbe4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6335bc7325sm138705366b.59.2024.05.28.15.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 15:56:39 -0700 (PDT)
Message-ID: <dcc76f1d-0828-4be8-bb87-394c20ce3c10@gmail.com>
Date: Wed, 29 May 2024 00:57:17 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Sven_K=C3=B6hler?= <sven.koehler@gmail.com>
Subject: Re: regression: drive was detected as raid member due to metadata on
 partition
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org
References: <93d95bbe-f804-4d12-bd0d-7d3cc82650b3@gmail.com>
 <20240507093252.000032c2@linux.intel.com>
Content-Language: en-US
In-Reply-To: <20240507093252.000032c2@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mariusz,

Am 07.05.24 um 09:32 schrieb Mariusz Tkaczyk:
> On Tue, 9 Apr 2024 01:31:35 +0200
> Sven Köhler <sven.koehler@gmail.com> wrote:
> 
>> I strongly believe that mdadm should ignore any metadata - regardless of
>> the version - that is at a location owned by any of the partitions.
> 
> That would require mdadm to understand gpt parttable, not only clone it.
> We have gpt support to clone the gpt metadata( see super-gpt.c).
> It should save us from such issues so you have my ack if you want to do this.

I get your point. That seems wrong to me. I wonder whether the kernel 
has some interface to gather information on partitions on a device. 
After all, the kernel knows lots of partition table types (mbr, gpt, ...)

> But... GPT should have secondary header located at the end of the device, so
> your metadata should be not at the end. Are you using gpt or mbr parttable?
> Maybe missing secondary gpt header is the reason?

I just checked. My disks don't have a GPT backup at the end. I might 
have converted an MBR partition table to a GPT. That would not create a 
backup GPT if the space is already occupied by a partition.

That said, for the sake of argument, I might just as well be using an 
MBR partition table.

>> While I'm not 100% sure how to implement that, the following might also
>> work: first scan the partitions for metadata, then ignore if the parent
>> device has metadata with a UUID previously found.
> 
> No, it is not an option. In udev world, you should only operate on device you
> are processing so we should avoid referencing the system.

Hmm, I think I know what you mean.

> BTW. To avoid this issue you can left few bytes empty at the end of disk, simply
> make your last partition ended few bytes before end of the drive. With that
> metadata will not be recognized directly on the drive. That is at least what I
> expected but I'm not native experienced so please be aware of that.

I verified that my last partition ends at the last sector of the disc. 
Pretty sure that means it must have been an MBR PT once upon a time.

This is not about me. I'm not asking to support my case for the sake of 
having my system work. I already converted to metadata 1.2 and that 
fixed the issue regardless where the last partition ends.

It's a regression, in the sense that my system has worked for years and 
after an upgrade suddenly didn't. I'd like to prevent that the same 
happens to others. It was pretty scary, even though no data seems to 
have been lost.

>> I did the right thing and converted my RAID arrays to metadata 1.2, but
>> I'd like to save other from the adrenaline shock.
> 
> There are reasons why we introduced v1.2 located at the begging of device.
> You can try to fix it but I think that you should just follow upstream and
> choose 1.2 if you can.

Yes, I agree with you. That's why I migrated to 1.2 already.

> As we are more and more with 1.2 that naturally we care less about 0.9,
> especially of workarounds in other utilities. We cannot control
> if legacy workarounds are still there (the root cause of this change may be
> outside md/mdadm, you never know :)).

Likely, the reason is outside of the mdadm binary but inside the mdadm 
repo. Arch Linux uses the udev rules provided by the mdadm package 
without modification. The diff on the udev rules between mdadm 4.2 and 
4.3 release is significant. Both invoke mdadm -If $name but likely the 
order has changed.

An investigation of that is still pending. I'm not an expert in udev 
debugging, and the logs don't show.

> So the cases like that will always come. It is right to use 1.2 now to be
> better supported if you don't have strong need to stay with 0.9.

Would it be possible to have automated tests for incremental raid 
assembly via udev rules? I'm not an expert in udev though.


> Anyway, patches are always welcomed!

Still working on my udev debugging skills. But afterwards, I may very 
well prepare a patch.



Best,
   Sven
