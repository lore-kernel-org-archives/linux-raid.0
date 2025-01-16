Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97619343E
	for <linux-raid@vger.kernel.org>; Thu, 16 Jan 2025 21:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737063807; cv=none; b=C4aU1we0IFT1MZ2D+l7q4dUqncgeIH2bC2jN4Z9RC+tmC8+06eYsfDYowhB0KeEI/63GVhd5h8d3GO5mTBxo8xLrqbMw94irtBspV/EJzsru0Q0QiVnaYJM8m9SvcWHv757LPUlVXcPD7rWDFHWxdHJhhkgrjMWDE6ZuBTuqM1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737063807; c=relaxed/simple;
	bh=sFoA8/j4tn+hIqRXCuvh6LXXvgVk3H/wAcgRh05gMaM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hcpwGkqeBw9PIm913EV9U6BMxlEjpXM2s6sqGCyG2x/bWl4o5893j8YxUbctuf0bx5yyc4EZN/Vv6XAb1hvoPBeDYbUddY/Jnzz2qr1PTAa1yri1+RrJlPUjFNGtWCs+m5nwV0eha6S1NbxIghaASANIsD5WaZ8woANQifElHi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QfHkmkoC; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QfHkmkoC"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-844e61f3902so115579039f.0
        for <linux-raid@vger.kernel.org>; Thu, 16 Jan 2025 13:43:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737063804; x=1737668604; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXO1/+KmwjsBeHnPmIMl7KgTMIIZe0FYrbnVCQu969k=;
        b=QfHkmkoCHW8eI+OnCluMZjce7V1fjTeHzO8/y1m9I8bo2+BkODy/Yn4B+9vrRYncDu
         zu4VfAqnOcPwYMfzjArQUzYjPWYc54NxM6i2mnhQLpLxmAyac4Gi7ga8HNhGcLi/2B+D
         8Q4xizB8m8FPgMbctgakjUW2SL4jr4QtlhL20prKTfc3zaBmd+q6POp18RhLbV1EuSPb
         vHx6A0gwjluCj6aDbF1fhRTKaACU/xxeVWXOZDkvBrlppjhRHSRCjZNmdCKBDj7priFW
         uF3crTTETpxS3JowUwPf1HSPspmYb1iAVbesR2I/CBlFoagSNjoT4NuQFDQJq8PpKAVA
         i7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737063804; x=1737668604;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXO1/+KmwjsBeHnPmIMl7KgTMIIZe0FYrbnVCQu969k=;
        b=cPGYUysdEFDTGIX43xToeDVBkWijJxmyrEMFG0YZCPWksAfq+AdFThOwgl+pwxvwg/
         jcqx6/WUJ3OkNvB6hUWHwGloSFS59ELkhZyMIEAL4a5IwuEikEBzySo1Df6oVQuk1xmM
         QEerR7vT5n/OvtZUd5BDGOloIXsKqGd4sbaZUqnmjTgn8DCpYc1Q/iq3e5cn8hXJv5xT
         FhyYz2EeJc7FfglB8Y8SQQOCSW3ffg8INtp5pNonAx8NgLmJpjmkvza5piAMxjP2XXZ5
         M2iD4Jv7XICCL0X6Gd99pXjbGVuflHidDuBCsUeIVl2EGG9a+f+RKz32k1jXO81LIUPH
         fbcw==
X-Forwarded-Encrypted: i=1; AJvYcCUFjLJuNFbH3QJew95dBUpEkot8WpP52jFjNLqNQdlBG0PL24VVFhswFgreacAmi7qNQvLPcG8nv89K@vger.kernel.org
X-Gm-Message-State: AOJu0YxufgtLmYc9YiEGyPxqukZHi2ZDf708N/fLnFozp7A3Ae+JMsIf
	rZfQQORXW8cF4SmJsc0eKMRRl84U6odpzF1sOyT7nWfyCfS3nLT2XnJwy/j9M2x7KeopAiJIO2Z
	F
X-Gm-Gg: ASbGncsef3GtnLw5PzQAUwh8E5OeAlrtXrIKM4imYoa2RGIAwSgQCs1xOjdwBs0suJg
	6txbCNQZ7kA/ZSB/jXz5tIU42lw51dzMr8K4WT3O8rDlJWnj2byKnRWd2yDbZFjfjCujZ2aV8Pr
	FeQg/BcNz3warZEXzRFwSLhhEpfCjvdF4lePdWmQ2qiI9MK6QHPAKspZ72EoMs8rkwTB3nRe/GW
	g7gSwg4d9nRfNhlzTw+NuAzekD9BEQ15+U0dnW+ySyCzvVxelUi
X-Google-Smtp-Source: AGHT+IFD79sN9HgDhRLdgyYN+HMVLn2kfb4ZK42LuCT0bB3hEwvSWSXLXpkO8hg3Xcf5UV6XFMDciQ==
X-Received: by 2002:a05:6602:3c4:b0:84c:e8ce:b547 with SMTP id ca18e2360f4ac-851b62b1e17mr2931739f.13.1737063804664;
        Thu, 16 Jan 2025 13:43:24 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756497aasm247567173.77.2025.01.16.13.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 13:43:24 -0800 (PST)
Message-ID: <68be04e0-5944-4557-a1ff-81f981c0f373@kernel.dk>
Date: Thu, 16 Jan 2025 14:43:23 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.14 20250116
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
 Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Song Liu <song@kernel.org>
References: <5A8F7169-012D-4D1F-A2AD-1C95393EC900@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5A8F7169-012D-4D1F-A2AD-1C95393EC900@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/16/25 11:38 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix for md-6.14 on top of your
> for-6.14/block branch. This patch, by Dan Carpenter, fixes an error
> handling in md-linear. 

Pulled, thanks.

-- 
Jens Axboe

