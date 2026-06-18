Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D56038945A;
	Thu, 18 Jun 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781784979; cv=none; b=hm2xqPC7yJeOYuVMhzKbHx1Dx+oSBlzoonISmwqekOWWWjhsa5GaTvnpF16e+1+Cmd1PYy0Hwmmaykd2Nzl0OdmtGC2TJ/H6g1/QORTUgJJdugZLuvKx7M2fW17vzEPEws1IwGr47fubrJMmlKGUGNNa1zXPZFNGw4rYqI683zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781784979; c=relaxed/simple;
	bh=5soVQy6M23Fc89e99YRFC+m0cehAh9XM5KFWz9Eg0qU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pg10eVjmPinGp+w5T/glzMg36J8BFxoR+8hp33hwb5keJ3xMqDmZNtBlc7job1jkQroyvc75OatgZ1Ta81qVgpZgZK4g+nR1IXPHHu0whZe0jV3bHdTbJCwFuxllG4uxjkFaeK5DQadcJf/blgW7sBbrSomJ/LJNI5VjeDSl//E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id AB9FD4C2C37D5B;
	Thu, 18 Jun 2026 14:15:50 +0200 (CEST)
Message-ID: <946e31d4-1ea8-4c65-be0a-0f942a9cdf8c@molgen.mpg.de>
Date: Thu, 18 Jun 2026 14:15:50 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: protect batch_head->bm_seq updates
To: Chen Cheng <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, yukuai@fnnas.com,
 chenchneg33@gmail.com, linux-kernel@vger.kernel.org
References: <20260618065544.954309-1-chencheng@fnnas.com>
 <5e6ce9e2-4da9-4ded-be8c-fad3ee153d90@molgen.mpg.de>
 <76dd7a7b-b1ad-4f61-9eda-5957f712ed87@fnnas.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <76dd7a7b-b1ad-4f61-9eda-5957f712ed87@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Chen,


Am 18.06.26 um 13:26 schrieb Chen Cheng:
> 在 2026/6/18 18:36, Paul Menzel 写道:

>> Am 18.06.26 um 08:55 schrieb Chen Cheng:
>>> From: Chen Cheng <chencheng@fnnas.com>
>>>
>>> bm_seq means "stripe delay to flush until bm_seq <= seq_write".
>>>
>>> do_release_stripe() keeps STRIPE_BIT_DELAY stripes on bitmap_list
>>> when bm_seq >= seq_write.
>>>
>>> after raid5d() flushes bitmap update and ++seq_write, and
>>> active_bit_delay() retry to release delayed stripes.
>>>
>>> the stripe batch head must carry the newest bm_seq among all
>>> member stripes, because the whole batch later released according
>>> to the batch head state and bm_seq.
>>>
>>> race scenario:
>>> ===================
>>> 1. cpu0 - sh0->bm_seq=101; cpu1 - sh1->bm_seq=102;
>>> 2. both cpu0 and cpu1 read batch_head->bm_seq = 100;
>>> 3. cpu1 write 102, and cpu0 overwrite with 101;
>>>
>>> the point is, if the head has a lower bm_seq than one of its
>>> members, the whole batch could be released before that
>>> member's bitmap is flushed.
>>> and the on-disk bitmap not record sh1's changes.
>>
>> It’s a little hard to read. Could you please improve the wording of the
>> last paragraph, and maybe also start each sentence with a capital
>> letter. Maybe also use 75 characters per line.
>>
>> Do you have a reproducer by any chance?

> Thanks to review, and , I will follow your advise.

Thank you for reading my comments.

> Actually, I have some reproducer to hit KCSAN reports in RAID-5, but not
> for this one. Because it's reported by sashiko-review bot, and, I think
> it's a true risk.

Maybe also mention sashiko-review.

> I will try to make a reproducer for this case later, after I figure-out
> the other KCSAN reports.

A reproducer is not required, I was just interested, how the issue was 
found. So don’t spend too much on it or at all.

[…]


Kind regards,

Paul
