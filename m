Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A8A14D707
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 20:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714075354; cv=none; b=DgPDIlb1SUEW7Kd7H/jF2cey0T9eTP0YhxT7GvpNfk+OyYHkJ4VeardazyX/gACXSoKjnOKJWEDHEFgXUdaO30OU39vtV72GUXQLaj3e5hgha1Oy4PuM/SROjrvNZFl0RHPz6Bvg0dSilE0lBSLratIlLVMOtW/9B7sL/xBP8vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714075354; c=relaxed/simple;
	bh=/fIK0W8Gro9E/47BX0gcV6vcwjKtezBmPGBeH+iCuEM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzQQZOSInGniQzUtN+4YvMB8jUyfcn99HB2JVlxxiKWhghpgFFFN5kQAajZNsYlz3Nbiirbaob8FHj6xkl9A0fUdSc5ItfUfNlHnfAVrqk1h5LQeIoOzluwVB6fWzvZ7bIoxCOaK97d1Q1yVsSXvA0LGT/g/ipd6cDKRop9qeok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YaUOKlnJ; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YaUOKlnJ"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7da9f6c9c17so11152839f.2
        for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 13:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714075350; x=1714680150; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vzFnZtAZXdS2VmoI23EJsELSVXj4DtadgPPfkIeQoqw=;
        b=YaUOKlnJkKcc6WZaZOda5LVcGeerk7Mmxfues/fmBEJyq68MeSZPxovB+TV1MhE6mt
         4DG04mbj2LfEb/GPp7dgKrstcxBkAi0/D4IeuuINcID/eUGt7ibqTgtsY9Xt30SiE83U
         bN74C0/ff9xasnaewtuPBh+kdj3NT3cSn0ic7ZIpDXXH5h+xLtHiILx7r+76ksD+J7F2
         QEonlabG3WTa85wHgVtY7wCuarU083DJrRzYtRxXh6d361XPBClTaA9lN2fZ9cmy+kc3
         v6ZnYVIaOyRYpy2LqB2LHtmTd0xQcMQaNC4Wx6E+RnrqWsWWL/XNgP6Esz/41UFy1n1i
         tGuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714075350; x=1714680150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vzFnZtAZXdS2VmoI23EJsELSVXj4DtadgPPfkIeQoqw=;
        b=B1T4NhKA4/Bfm/1J7nJF0U8dUNi1nkSLWT/C3JSM8qcnMnbtIkhUwHbQX1XPX83X9q
         RCzeNW4WlBSCFUAarNwePHldtIdMj4JDM1CVsMHA5ExKgqbq3K6sHuKQG7RCOwohSnA+
         ugg0/5cuUyuhvjOwnAj4lj894+KPh6GyxUr1FdkWW73YQ3ZIJcJTWRSIIRdw6ofbYMQI
         p5lBVKln8x9GbAXezH9SVgk3hao8rM0E43YzdyigqLpbGxGhBs84hsgGK89ax3SmZVuS
         aybfVgqt7IaWzKLmgWPZfIKatTPnCsju5lOsNtfyQjQ9C0yi0su/sud6cbrpVi5i3Omr
         e5mg==
X-Forwarded-Encrypted: i=1; AJvYcCVPX3XmputKhdm4iqiYTK6FtCVMp3R0vCOe3vEAJcSi613dFx7ksJi6sfpSChHq1lcnHktvPHTV5Lh+VqZezEkacEGokth3BJFCxA==
X-Gm-Message-State: AOJu0YyuTZg4xZGl0cOEk0IQzbLB386S4NLVQbXMGm0zLq4cNP+vdBHR
	w80dnMoc38OTDIM5q9SHPC7o7HdHWc/jQLb/0l15OuzZXodOQ/yMXxa6WlOfilc=
X-Google-Smtp-Source: AGHT+IGqi9WU6FLxiOgMZfdIRWiIZ9cS8rBTMJ8ynuptz8U3o8n3qhef2IF68fpBaNgdHz3lXRAjDQ==
X-Received: by 2002:a05:6e02:214d:b0:369:e37d:541f with SMTP id d13-20020a056e02214d00b00369e37d541fmr1055167ilv.1.1714075349659;
        Thu, 25 Apr 2024 13:02:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id t2-20020a92c0c2000000b0036b391493e8sm3667273ilf.22.2024.04.25.13.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 13:02:29 -0700 (PDT)
Message-ID: <6addafce-5a59-47d0-b580-9ec3e54fc805@kernel.dk>
Date: Thu, 25 Apr 2024 14:02:28 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.10 20240425
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Li Nan <linan122@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>,
 Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
 Song Liu <song@kernel.org>
References: <CE08A995-B84A-4B4B-BC7A-0EB73319877E@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CE08A995-B84A-4B4B-BC7A-0EB73319877E@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/24 1:51 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.10 on top of your
> for-6.10/block branch. These changes contain various fixes by Yu Kuai,
> Li Nan, and Florian-Ewald Mueller. 
> 
> Please note that change "md: Fix overflow in is_mddev_idle" changes 
> gendisk->sync_io from blkdev.h. This is only used by md, so I included 
> this change in this pull request. 

A bit dubious to just bump the counts to 64-bit, I think. You only care
about the difference, so regular integer math should suffice. In fact
you only care about the difference. Feels like a bit of a lazy fix to be
honest.

I've pulled this, but I would strongly suggest to re-visit this change
and spend a bit more time getting this right, rather than just blindly
bumping everything to a 64-bit value. I don't care about the md bits
here, just the gendisk side.

-- 
Jens Axboe

