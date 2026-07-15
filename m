Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310523CF212
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784114215; cv=none; b=k8hl6hcxoeMA3FH0h0UnlJzyAojB4q4t/T+YZo/ccijnPb1kmKm2EU8gKTtVYYS5LN98OtQL1OtjMaBZGprdgIs4QcNHYne1K2LzCgurG2ss8gZj+zuEzd7h55VLelruWM8Ik0xZdN8RT8+jeF7hn2YqZe5bOm8OeLO2f0QbMvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784114215; c=relaxed/simple;
	bh=HZpP+eYnvqgbZe598aJSUkGMNUbOrLPlP4WxoEV6Cic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rvwCJgfiEhcvamZ2UE5lBHMrd7uKpYipXLfeh/TP9z1E5P29HReII/WBiEv8K3RtsU1bh7KEyHt2Uj8oRvZ8iPN6ttwN0daZURENi8eTu4ynrGUdB+6ykBUfiMQ+59A5/ytXF4c+JahuAQrZtOycdoa2xbYiQ/JlN3J+/yJyCfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMiev6p9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMiev6p9"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4629051c9d1so1259103f8f.2
        for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 04:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784114211; x=1784719011; darn=vger.kernel.org;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i/YnbegFnz1wwTJlvFDY2bFOXAZg2zEqKBOBmaLrjis=;
        b=FMiev6p985OY0NvfO98zCfNZ8gOF+/vn5ZB1PQ4Ea1N1QnhKR+L74Xueimeuvo0hAL
         nEiCHoG/u4O/FZF4nA732Jl5uWQw+Hp58E57Z4s4/RkSJVwXWeb+WrTca9+anlA0dyzw
         mRT3zeqeGQGhcAcvvyAMYgtZsIsoc4hn15XIhDu8ezGesU486yc9Y0f6jt55w6lqdY0q
         lOiGKR8S+AYNMlGCiTwsH4LS3DoIMHbZp0ryhLspYysPruqNo0yjmW6BStMcnjHpShNc
         38vMaKi13V+p2QO6PWdGpb8V/OJ/mXf7sqH8iUxhNMmiBYkpuGVu9m7YtPMJ7CsV6x3H
         yXIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784114211; x=1784719011;
        h=content-type:mime-version:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i/YnbegFnz1wwTJlvFDY2bFOXAZg2zEqKBOBmaLrjis=;
        b=nrDP9uo5MJjla6TCktlEkyrRH4v3ECeUU7p56QWjVXAcUy65z/+1c/9V3zkBmG5sY3
         m0Ki1+R5G+yBxhOCRtD4enGgN2n7G4h6S1VXrsIoY/E2b1kIBHNie0OeYRyUwbzclxsS
         3+JkrQF8Tq+p5U1vH2Ht7aHHrKqiAhnxq5vgdQ1c1hy34ADNQ+whnrWAqIbdcUwRQ9zT
         O6Bu80WhTaEvShY5arx3ii2eWULd1KtMIsfBDZGOwkzIbIeERVQ8Q565JGV65wmqMPYQ
         nqrsPnreC3aK513kCQeaULdFMvcnSBjqVEN1UXWr42aP3MXrQufw1qPYxz3bkDuzGZQU
         TAjw==
X-Gm-Message-State: AOJu0YwgtB6j9Yn73fp6qJ1/VIEKWAfcwkrPPNBh+MbTVj7F02U5YVHc
	xILCtZD4DL8F81O+MQzPqMalCgxzsBNnYTnZugJbZXiISEJb9EvrYADqXQ4DbA==
X-Gm-Gg: AfdE7cnn0nBjeu6FDUVGLj4zFY+7/Rj+KuwEtkXwNBKmqG1ukgz0Wilf9BSVJG35znh
	CJKrp40HuVDJ82xWy0iq2TZWjNvTohdaXT6ooFgMvoj4oALTdWq28Q1mF2lkdzDJxp1wp1QA+7n
	NTqoPnr6E0wxWGVGvtAuR2Uhw5AqTE7XNKDkJX59Bgrg1oSotBTxX4ZyStX9WtqLHNL0ZewtY1/
	2VzcsvHpZRQAyQcM2Z2IYWEA6QsJWhc49VUXVqWb8cAMpuA3BNfTCgvlmi/W4WaFnjmBDd1+KOU
	tV2iDVUiXr/TTf7pMQHxH2peYU7EmwerTS+VmJMZzmOz8Tstf4axGscqsx0YlZ8Kpz3MyO7wkNV
	roW3NSlXPCr+o4QzJuMtzIgD7bvbDOG3OKN1sbPqxTRwVl20RE6TF9jdQMtnbCENrTwhVDVkxSt
	+Taj6AI2UmuzIVQtb8OFi0vzbP49vuqqIv9WMF5ysopc1UldkKwJrAdqdBh2zgVGjQxA==
X-Received: by 2002:a05:6000:2508:b0:473:d65d:49c1 with SMTP id ffacd0b85a97d-47f2dcd739amr20287206f8f.32.1784114211112;
        Wed, 15 Jul 2026 04:16:51 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3030:66c:7341:15aa:e312:84c7:17f2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a973fsm16486017f8f.17.2026.07.15.04.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 04:16:50 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fygo.io,
 magiclinan@didiglobal.com, xiao@kernel.org, axboe@kernel.dk,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 3/7] md/raid10: consistently fail atomic writes that
 require splitting
In-Reply-To: <f8554f5b-5a3f-4972-8bea-36fe983ded5e@oracle.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-4-abd.masalkhi@gmail.com>
 <33aca226-f744-45e0-a137-1f85ab146e02@oracle.com>
 <m2tsq0eff4.fsf@gmail.com>
 <f8554f5b-5a3f-4972-8bea-36fe983ded5e@oracle.com>
Date: Wed, 15 Jul 2026 13:16:45 +0200
Message-ID: <m2o6g8ec4i.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Hi John,

On Wed, Jul 15, 2026 at 11:49 +0100, John Garry wrote:
> On 15/07/2026 11:05, Abd-Alrhman Masalkhi wrote:
>> On Wed, Jul 15, 2026 at 10:25 +0100, John Garry wrote:
>>> On 10/07/2026 11:15, Abd-Alrhman Masalkhi wrote:
>>>> RAID10 currently handles one badblock path explicitly by failing atomic
>>>> writes with EIO. However, another badblock path can also reduce the
>>>> writable range and force the bio through bio_submit_split_bioset(),
>>>
>>> What is this other badblock path which you are referring to?
>>>
>> The other path is when the requested write overlaps a bad-block region
>> from the beginning, but the intended write extends beyond the bad-block
>> region. In that case, the current code silently reduces max_sectors.
>> As a result, we end up calling bio_submit_split_bioset(), which
>> completes the bio with -EINVAL rather than -EIO. This is the same issue
>> that existed in raid1 and was fixed by patch 2.
>
> OK, it would be nice to add a concise version of that info to the commit 
> log.
>
Thanks. I'll update the commit log accordingly and send v5.

> Reviewed-by: John Garry <john.g.garry@oracle.com>

-- 
Best Regards,
Abd-Alrhman
