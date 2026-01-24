Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F47426980F
	for <linux-raid@vger.kernel.org>; Sat, 24 Jan 2026 03:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769225907; cv=none; b=jZww1gd4b15hdrgUUOASWg0boXdH8TJBU4fHcU1BPHhHiPR8WcD1nF87mebYOwy0mPK9+JIh93RTFaVpqbQVo4hK4ONnhUpiSYqSIXpJHuszCrs7BTIp5efe/t42rhqZ6zXX9bx57iYyxf9A1nD334cTLWAdIAREXh/5hzkQPQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769225907; c=relaxed/simple;
	bh=Hc0p4esjtmP0p0Q60Jby7tjJS6WFKbZCOGIaX6HPOA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwbSCNwNd2E7lLJfiILLcee9CicMMYXHGn3Q+FOeWEPzj9Wb2Z2GxdAvW3iJIsK4FiZ/Tojgd5Go/XPm+P3prIKSa1wCKJMcfTXVtephtmxPkV2q54oZtIXRYjYs5vM7LcHg/t381hYYNqoKzWGRa3aUxZvu7386aiPkBobwts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iZGfrRWm; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iZGfrRWm"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4044d3ff57bso871673fac.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Jan 2026 19:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769225903; x=1769830703; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2HrqLaMllGTcSoVAzXQL65lpnvx8tOwwlEPBowcJKyc=;
        b=iZGfrRWm51VwDygP4Bb/VfOKFRnwgEN4AQW92WsSAFRMMtFkRPJFhGV+mgQCC3kW9U
         4R8TiDdx5bGD9V6T4Z7FC1wuXdwtfU6DipYWGi+fKxai5fNJaXh8BI9LOMB7lcB7GVcA
         VozK2BPjF82JjmWfWsvFV0iS084Bg+Wf+yvhtOsnPxN4O6A/9IhtjiPRhabeBY2O7YRL
         AJ5acf+sVhbrq1s8TqMeHblpA2Wm87i3+LlXyyW2dUPaCtQiipx3DJHZzTKea8d1ySrF
         zV86UenN0KBDZaNc/WMjJI0GJHjk/CGWsrVa1B61miHM4zeNic+ZwYJiAi3gL9983xzc
         TBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769225903; x=1769830703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2HrqLaMllGTcSoVAzXQL65lpnvx8tOwwlEPBowcJKyc=;
        b=fNXK+rjmOoV7HEtfyWflXzItDCl7n2JqskjcmIkTNC1i8kSGBxWbLSlSHUg7SjD3cR
         nWBT/L8oxuycdH/J5PihWyMGbSoFhH2i9VUifZxNNwdvLIzSZ0UIf9NZYCROVEtrg3yc
         jMx4/+sblHR0wshvVzuQ7+65xGlxaNLDCtegtmvOJnu2E20O4vSFK+IRfZ8FZvG3KA8k
         YoulyTvNEi9RaRazG7nkSG45aJcohHpBj87ibSPnVeRUYg995lE7PhM/uFxY+CRX7zsV
         zwLulrnKnEbo/KHwWbB8XLeEb7g1Pk1MmK2MXlLv1Oa/acdSKJ83TvXqJypa4LmpxK96
         yHzw==
X-Forwarded-Encrypted: i=1; AJvYcCWRwQ6q2eVQzPU0rwJ1Eg4ppZXeZPXSmyFx7FnhPyF+3xUGJHLmtXP5y2o0W29wm8t7dpYFS23y2L6W@vger.kernel.org
X-Gm-Message-State: AOJu0YzkPZN1OGvHBm3LCH2+XW3xIF9hg88v5I54cz1f3/O9RyoVEX/H
	4eRHHddwTJHLi7E/Zs/pdMEzrSX7XpedTZRqvZ1gDZ9i/HW7Vpjja9BGVzfSpXxn9ZI=
X-Gm-Gg: AZuq6aKifnAnrh1ujC/gtiDpaZmYHmvo06LkoM57YIB/3LYRe93GxoNl+m7n9KIlez9
	bV/KqcRwNQX64p2V0eR+8EWsyINT4X3eOcz3IAohvaXmr1eDEsh11eIX8x7QYwx3FEgcj7e3hNM
	nbLHkp+lPWRFU/byFmLDI9YRG02xA9U6QCbDAg5ZSwknH8BgdiYd8jnet8ck0VKQOs1yAKuTxtV
	9V+F5fcWmvLqpp6E8NRD2qBPurflRi2rPVudW+7eH8CkfI3PDSQG2/OY8bX5HEwDrFGjblsS3qm
	gSikZNxWNsh14BaQxGoQgOfa46za3nXATSj6Uw+dTfqLIUHEUMdnpYZ/N/qghLrk3G1ehWASgYI
	em2ud+X7Zt8xu7ygtHi3GKTC0iPOc1MWghZvkMB2gOcGQpZqj2IlMiSgiyVhlb3bSB7V7TWKY3t
	ymqCraKLn67hXxn/GKeGmDwfmtmFaaol8Umarg+NxTL+Udnv41DTh+vJVp4+nf/fa+CSN/tA==
X-Received: by 2002:a05:6870:214c:b0:399:58c2:2e5b with SMTP id 586e51a60fabf-408ab837981mr2301633fac.51.1769225903105;
        Fri, 23 Jan 2026 19:38:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-408af7ff54dsm2679799fac.1.2026.01.23.19.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 19:38:22 -0800 (PST)
Message-ID: <c3d421ba-0151-4a1b-b4f0-6d3ffe4b7d1f@kernel.dk>
Date: Fri, 23 Jan 2026 20:38:21 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] md/md-llbimtap: fix two corner case problems
To: Yu Kuai <yukuai@fnnas.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linan122@huawei.com, xni@redhat.com
References: <20260123182623.3718551-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260123182623.3718551-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/26 11:26 AM, Yu Kuai wrote:
> Yu Kuai (2):
>   md/raid5: fix IO hang with degraded array with llbitmap
>   md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout
> 
>  drivers/md/md-llbitmap.c | 4 +++-
>  drivers/md/raid5.c       | 7 ++++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)

Is this just for review, or do you want them picked up off the list
too?

Both look fine to me, fwiw.

-- 
Jens Axboe

