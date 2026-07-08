Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130E737FF66
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501533; cv=none; b=hK/U3I2eRc5Qsr0fNEsnse/xsjWwDVuBCcISIrcXYL4JEEZzuiey3E07j2OIx8jyEeD6f//S+DLbPsd8+CAznJ4YNzURY1Tw9yGpORfxopH7Dc1mnSpV2qTpZkqY84T+kUJWakosPBRk8WKDhoyo2wp/JbxrIA6BBMh/sSjy9vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501533; c=relaxed/simple;
	bh=wnsjc0TTT8++uRt/i+f+itVgjw2nO2+vbqNJksJq6Cs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dIGw0MR/O6BRLUMWVWg4f7kX0DkWZTusW4/YhqeR+jH7OyBXE5DXP3ehz7WFgqqCH97nYXQrVjZlm+dOhE/lltUlbJss4oYMBABf8ZKQa7GC9QHH3C2C0/2QvSoCEwPCnx2hbxYBU3GNwyqcp+K/ifyEzKpR0FRbEqLX9B2duNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dfojDrwJ; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dfojDrwJ"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493b61b52b6so3953615e9.1
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 02:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783501530; x=1784106330; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ir0CO47nQT8KVIrdPQKQrEcLGdQC54RwQc/fSTsMcdQ=;
        b=dfojDrwJ+GnRkQb4q3iKeqesHu4oPoB41Hr7yprQ4iqAoeyzoWRvAWifsOnKF1xv57
         n/atEf07jlEvyiG/ZqDeSlbmrUKd9sN5ANl5vk4BqiOujuT65pza2NEqGi8V/brBnkLb
         fGltIIkY8a/3kSWekxRJGtMj177VzpZDFmM0AkA62gk3Pc0huZSejOSMTUTyhyFxIDr0
         CIfkhmYlntZKcdvwKJCyUg+7FsVXRo4sgPTx2AONWRY6OIM48l7hZiTZHyIHue9kJAb+
         ZLDKL3eZCu4d4a8kE8EDAXE1ilmqPG2vd5HTC4a9TAODZ48RtyF02SGLG888W9q45VDh
         adxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783501530; x=1784106330;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ir0CO47nQT8KVIrdPQKQrEcLGdQC54RwQc/fSTsMcdQ=;
        b=eKc1zypQ5wk1GqLTqtf1pyEkuW3J8niuC3l9/53/SfaPQSXwspMFqy/SXQ4PMxlYkf
         rSm11uq5e4XZ+wXO4xfM6OwhY4n+rQF9rstmymeSkm74qeXGP8dovIKH6CpSAmJKKss7
         vqV3soXk4AHAhXQcX6OBwRE3/gY5URomsue2NmC+AS9XBndxFP6T5FDRA5ESlPAYyTTi
         hMtNrnpbnTmgdfvHxyqyElZg2fUDMNp5Uv+L9h2CStXNzztMGhRsN1TeTJ3R8Ou5JKex
         JuOqBUeutshIlhkJCIS0gvZheOkyjTIRvmpH+5rwMvbq+sEzRb91xvwpbun2kul7YbaH
         hyww==
X-Gm-Message-State: AOJu0YyhcVOOvYqw81/9wl0W8YX8DbA+taJ/PiRK4S4uCAVuwsV0fSA1
	m7jyLZIxlfk3W1wMIfA3r5BqxXfMh4i8w6hTrKxGiShgyfzoUZT/3Ax0gxZNig==
X-Gm-Gg: AfdE7cnNOWZVZvoAwwvMYAL0J8AYv4gZLeblb4MMsHpShvncPb33TWcbE9z1hu+Y/yY
	4apk1/ONYG/Vepyk7rTmOSBn9PLNr8KcIyE4RMrtgpeecBeCeLhYKlkGqLaFYLDjSZIDKdDqo+D
	MsZUtfIiOP+pYdrbhJUq2x0QvwJPQC8UYtzqfB9bx9QpxZEK2WmH4qjx+Rjy7ZXGx6djn25px4m
	NmrIhZS6VjKqreqryVLM7Qo3ZBmVvWIJdlzWeSBdczh1QewVeZOxbGlCi4PonsKt5R7mQTNeO58
	KIWaJG0k2U6zhbL0cQgg+23c29P+q2N3CURaDIiQZY4HWIcjgBYNhDj7zJEXHi+n4iDAcbUyTCM
	MzvOdhHX6QJ2GVPXHaqWJGtLQHtcTza4Tpp/UQhSwUbXsgpiHmcP+CYVjd1exyG+VaJ4P5p5Ajm
	SI6iFDwi3wpwiDZdNCjQNtx44kUmJoVwVTnDQ4Wd5fG15T+A==
X-Received: by 2002:a05:600c:138c:b0:492:6447:7a7f with SMTP id 5b1f17b1804b1-493e688c6dbmr16518705e9.6.1783501530108;
        Wed, 08 Jul 2026 02:05:30 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([195.72.110.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d8cdsm44254622f8f.1.2026.07.08.02.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 02:05:29 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 vverma@digitalocean.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/7] md/raid1: advertise atomic write limits and
 handle runtime constraints
In-Reply-To: <fbf1a5d6-d362-4eeb-8434-2f4a114a70bd@oracle.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-3-abd.masalkhi@gmail.com>
 <7cbaaca3-4eb5-434d-a13f-f9574c9f977b@oracle.com>
 <m2se64zak9.fsf@gmail.com>
 <856abedc-d2f3-4248-9583-4d7e1a11abc1@oracle.com>
 <m2pl1073l5.fsf@gmail.com>
 <fbf1a5d6-d362-4eeb-8434-2f4a114a70bd@oracle.com>
Date: Wed, 08 Jul 2026 11:05:28 +0200
Message-ID: <m2h5m97sx3.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi John,

On Tue, Jul 07, 2026 at 17:20 +0100, John Garry wrote:
> On 06/07/2026 12:35, Abd-Alrhman Masalkhi wrote:
>>> well it seems to be that everything in the driver is split over
>>> BARRIER_UNIT_SECTOR_SIZE, so is in effect a chunk size.
>>>
>>> Note that atomic_write_hw_unit_max is going to be small always compared
>>> to BARRIER_UNIT_SECTOR_SIZE.
>>>
>>> However, can you check the blk stacking code to make sure that this does
>>> as you want? As I remember, for stacking we take the atomic write limits
>>> of the first bottom device and then stack the other bottom devices and I
>>> don't think that setting atomic_write_hw_unit_max in this way has an
>>> impact - see blk_stack_atomic_writes_limits()
>>>
>> I checked blk_stack_atomic_writes_limits(), and you are right: setting
>> atomic_write_hw_unit_max here alone does not have the intended effect on
>> the final stacked device.
>> 
>> Also, since atomic_write_hw_unit_max is expected to always be smaller
>> than BARRIER_UNIT_SECTOR_SIZE, 
>
> Yes, always expected to be much smaller.
>
>> it seems that there is no need to set an
>> additional atomic write limit in raid1, or even to set
>> atomic_write_hw_unit_max at all. Is that what you mean?
>
> Even though we expect it to be much smaller, it's good practice to 
> ensure this.
>
> One method to do so - which I already mentioned - was to set the chunk 
> size to BARRIER_UNIT_SECTOR_SIZE. You were not keen on that.
>

I see, thanks for the clarification. My concern was mainly conceptual,
and I was also worried that setting the chunk size might affect other
operations, such as discard. Since that is not the case, I'll set the
chunk size to BARRIER_UNIT_SECTOR_SIZE and update it accordingly in v2.

> Another method is to set max hw sectors for the RAID1 device to 
> BARRIER_UNIT_SECTOR_SIZE.
>
> Thanks,
> John
>

-- 
Best Regards,
Abd-Alrhman
