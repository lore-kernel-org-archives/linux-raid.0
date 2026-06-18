Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE74F3F4DDD
	for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781785806; cv=none; b=Pc4P9kLDWu/r5W6klBcjiXHD8lH4D0qP1IwTMp3pt62E3jHKYoifwJKib3Sz1Bu9DV8mWtBb/65jUFXsOOwhDPiD+lMr1DRaSjcf1tuqtu4l+w/8NVApXupAe7p1McNicGOtmDTSBg5ML9e4rGu8h3eqXVQfQxt8FY46C0Zo9ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781785806; c=relaxed/simple;
	bh=us6aWQv+NOojHffFKNtqL2Z0EuqrqXHbfK46r+SN/uE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cyjW3ywj8//yrB+9Y9u6D+ESSalu66rGUVlX7ogeVeznijFTS1OIXn3tGpIOscn119J7GPaAkfIC7M1Zpy6efGA9ukU6JiqodQoUlfjjrcIU71H6Laqr/yRK4f71IVd+XK5L/RhLHsO7lLMB9C1SlwXHtkk/h0DDC8EPbXSph2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h89A12gc; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h89A12gc"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c6d3851e09so5184925ad.0
        for <linux-raid@vger.kernel.org>; Thu, 18 Jun 2026 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781785804; x=1782390604; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LxzgycV+PsauZ3FIIeSvMojO57zf/VejVA2nQhQe4g=;
        b=h89A12gcU175qLFwxcfpdPu7mA9QkLhvL/M2yZo2U69dQZcvV/b4aAmS1OkCNNlhGK
         haXPvlvupeFlTLZJz69FVeQLDdhhpB2u7PdRZ+Td0UaZ2X7f7bI52P7qdB1gvGAvasHD
         6/SlMj5NMg5H78bfTmtxmAmzOlMxszh95joLJmii52LRRIrmd/ohFr90kyqZPtbC2Ph/
         V+MmCMToL8aQbfsngwrCzHhX2lIscAaR8Itiyb1YPZ7up0oZsm+nexQrzTs97j975Qif
         vhwrDJymEdk2OCCoFXHFGdnHqZ4/MmVsvGzoPI0P2Aa4SN65OcZZIgIceZ612UDzi6tz
         enNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781785804; x=1782390604;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8LxzgycV+PsauZ3FIIeSvMojO57zf/VejVA2nQhQe4g=;
        b=gpEb5+DKXRXGJWe+fk1AQure5KFNi+bWDBCmPFcqdeKEm5zY4YJa7+m+3XIMdnLMj2
         oqtUor8ZCzxIeY2GZRdfHiCy1dEC9QjQ1hO+4kX8vdIOgLHGaY7NIq4dYQf1TeglGIL+
         dGd5o4gzGHgj5JzT1D6pi6N6p1G8hETEMvY2HMwCd2HRkodoIgZiSiyh6q5gzoHFAlIz
         3h9VOjGsjl72DkDMG9ucTWNL9pJtOLfROD6UH+moVTO//SIC7CFpxb2IREFsrfUWZ3nZ
         oMjSLBdrie16bnqJpCsxhkPD3Y5AwBpzErYta5hCXFeRDUq+myXERseWz6qT5vCy9VBn
         t5Ow==
X-Gm-Message-State: AOJu0YzWh2qRUOvf0POV+XUnaaF9jGjgiIorr2pdXiYZ4QE5srr8ZcKO
	xsrZ9fhIDo+51vF6DASFI+/twqRRB3Qzyf9yb2OH5iDEqHYfDPxDEAgO
X-Gm-Gg: AfdE7clQSGKQL1ajjBFL+pZVU7MBI5jzRXQLB3Yy/RyHsSGjzb1ERCXIv49ch8xYiB1
	QUf03B0h2MmY8zzStaNbdB/6qnVkkKv0MJwcwikKZDY/1tS4VZMXGz4ZOtavqpWkR1iCO8Zh4F7
	Xwsj9LsHLVcrB2I3RV5rSlNJtwd0V04d/CT4kHnfkfs6EJdfBoZEc2tzHKzUsf8QycSpBGD3mk6
	2d6cOLFTUPY9ZmImhcNcor07DM7+rGGTyhlPZFTPsN4KhPSW9k/vlX/jfH1SrxHBzLzY0QUnZAX
	bQslTkN7TW368fCi838zpCirFmXFT5G7VFPIMaToe7UWkSYkPqURjw+2wOOXycL9C9JhG0wXO1i
	4kqu0fhEqyVvBWMF74PlSAC2C07LRYCg45gbPY32c5vfKiZW63ZTOu7NoR6iw7BxmC12Dv8oVRL
	u8d9Q+dbVbx+Of8dhiUXGZCNatA8rnKxf2A2X9fRw5BzAb47o=
X-Received: by 2002:a17:903:11d1:b0:2bd:606d:b339 with SMTP id d9443c01a7336-2c6bc221f57mr85979705ad.21.1781785804077;
        Thu, 18 Jun 2026 05:30:04 -0700 (PDT)
Received: from [192.168.8.62] ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c6e54e823esm32973845ad.72.2026.06.18.05.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 05:30:03 -0700 (PDT)
Message-ID: <9bc752e0-06c0-4960-aac3-0c932bb07298@gmail.com>
Date: Thu, 18 Jun 2026 20:30:01 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5: protect batch_head->bm_seq updates
To: Paul Menzel <pmenzel@molgen.mpg.de>, Chen Cheng <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, yukuai@fnnas.com,
 linux-kernel@vger.kernel.org
References: <20260618065544.954309-1-chencheng@fnnas.com>
 <5e6ce9e2-4da9-4ded-be8c-fad3ee153d90@molgen.mpg.de>
 <76dd7a7b-b1ad-4f61-9eda-5957f712ed87@fnnas.com>
 <946e31d4-1ea8-4c65-be0a-0f942a9cdf8c@molgen.mpg.de>
From: Chen Cheng <chenchneg33@gmail.com>
In-Reply-To: <946e31d4-1ea8-4c65-be0a-0f942a9cdf8c@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/18 20:15, Paul Menzel 写道:
> Dear Chen,
> 
> 
> Am 18.06.26 um 13:26 schrieb Chen Cheng:
>> 在 2026/6/18 18:36, Paul Menzel 写道:
> 
>>> Am 18.06.26 um 08:55 schrieb Chen Cheng:
>>>> From: Chen Cheng <chencheng@fnnas.com>
>>>>
>>>> bm_seq means "stripe delay to flush until bm_seq <= seq_write".
>>>>
>>>> do_release_stripe() keeps STRIPE_BIT_DELAY stripes on bitmap_list
>>>> when bm_seq >= seq_write.
>>>>
>>>> after raid5d() flushes bitmap update and ++seq_write, and
>>>> active_bit_delay() retry to release delayed stripes.
>>>>
>>>> the stripe batch head must carry the newest bm_seq among all
>>>> member stripes, because the whole batch later released according
>>>> to the batch head state and bm_seq.
>>>>
>>>> race scenario:
>>>> ===================
>>>> 1. cpu0 - sh0->bm_seq=101; cpu1 - sh1->bm_seq=102;
>>>> 2. both cpu0 and cpu1 read batch_head->bm_seq = 100;
>>>> 3. cpu1 write 102, and cpu0 overwrite with 101;
>>>>
>>>> the point is, if the head has a lower bm_seq than one of its
>>>> members, the whole batch could be released before that
>>>> member's bitmap is flushed.
>>>> and the on-disk bitmap not record sh1's changes.
>>>
>>> It’s a little hard to read. Could you please improve the wording of the
>>> last paragraph, and maybe also start each sentence with a capital
>>> letter. Maybe also use 75 characters per line.
>>>
>>> Do you have a reproducer by any chance?
> 
>> Thanks to review, and , I will follow your advise.
> 
> Thank you for reading my comments.
> 
>> Actually, I have some reproducer to hit KCSAN reports in RAID-5, but not
>> for this one. Because it's reported by sashiko-review bot, and, I think
>> it's a true risk.
> 
> Maybe also mention sashiko-review.
> 
>> I will try to make a reproducer for this case later, after I figure-out
>> the other KCSAN reports.
> 
> A reproducer is not required, I was just interested, how the issue was 
> found. So don’t spend too much on it or at all.


Well , I think a good reproducer has to be :
- Concurrency as much path as possible ,
	e.g. reshape concurrency with normal I/O, etc...

Optionally ,
- Run some Sanitizer,
- Inject some fault, e.g. bad block, write error, disk drop...
- Provide some background I/O pressure,
- Do some combinations describes above

> 
> […]
> 
> 
> Kind regards,
> 
> Paul

