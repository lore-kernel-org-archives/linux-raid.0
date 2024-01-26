Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AE3800
	for <linux-raid@vger.kernel.org>; Fri, 26 Jan 2024 00:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227526; cv=none; b=FZRaeKjQtNu14XVxAeB9n3C1ylx+5vqu17W8wJlV5oxB/0uZXh27zMOyrpgbCAQ+CZP8Sepc+ulQBiTtfJsE2aNmO5fk8Jw7HsBgyd3nNJWxt5/yJcTYCZ2yVf6rOTIjxzZNU6VZhM4jXdcmZnAmQPcqcAK5oAPleWMUgkk/AGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227526; c=relaxed/simple;
	bh=Kzm4KfkfW4+Y7Ina+BLFZY+KUrRacaVM5WDD6Q7eo1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bnRlQOvd2TLX62sCCScg69xP4dR3YXmqOv/tuC3n+7kbF7XrYyOjMMzgw55MS3tA79C/sQBGE+38p9MEsBP2F6S+Ww1o4FzYQHyAdnus+41bcgSF3sSuxklX+SjMfiLSI9bqPkIUdsHLOpFh+47SfKqMZKYPT4c0zvvJsSb4kjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ear5AKh5; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ear5AKh5"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7beeeb1ba87so100261039f.0
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 16:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706227521; x=1706832321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z4cegJ0a7EmnYtuvu9G/8R1EOdNDeQxgaCDSv79LEb4=;
        b=ear5AKh5FicXwLbDpp3mdvgJzOh3YPFLHcNmtKqXrWNdYXke+WzULEQWXjt3T4MSgi
         rAONDhfcIbCFE7H3Ld0TJ78hX3tSPFqpgRiZknXHFUeEHLx5FQrXNopvIKfs63dlc/Dl
         YjyFEra9Z26cpRIGkqBXNoHEadnVNYccDCbR+UMl1u87WoS2M2gRxgm/rqX76mBw3qa5
         4eeaUpRo31HBbIlkEqgXMHgWhrb5MgABegmKSOyejBIxINcrMclau8F3awKi1CfzRJeU
         0qlqwJ3oPtozo/ps6j7OH/FvqdmZkhcHDEv0cJ5Sg9YCnqCJpKezmCuTFqq3tfd/ZNfY
         BTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706227521; x=1706832321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z4cegJ0a7EmnYtuvu9G/8R1EOdNDeQxgaCDSv79LEb4=;
        b=HnEjvwzhL0j82MmRAo1ncvzM5diqLzQ48kLBAzclwd+QVbhHVQR9U63qEtj/9FVmOp
         EzHC7MyzDj+t9IHXxR3T/eiGCIf3CzkeykQshcqIPasWb8dONUZ0qAqwZu0XR/thjYbg
         8Lbl4pKQ6YSJ4bjdqSpzgQmaBEusYBePTKMWc/UWFYAF4I1RyLytAey1G14QIpxFUExL
         LCbUFa58Wi2CLZBYvOrf9sNzTzutBt6t4z5x9Gi7Cr4cuSRCRv0F7a1v2Yg9M3yQSVJ6
         eo0u4Ri8cAMSFMfhUean1fCKRh3/a2mj9Q1izN79/sniJYH2gWYb3n/cisTyJgr1bKxz
         L+zA==
X-Gm-Message-State: AOJu0YydOr6EezcSRrZf/wf8+uyi1boVIoAE+K1IE78xpL6th7bW+Sv6
	VjBvoRdXyk3v6G0tkYelr4IROLtHxLKVawynZDQnlmj+pg9yPOVrgblTqH5x0N8=
X-Google-Smtp-Source: AGHT+IGGcKUrZm5biMk0n799psHLl0QQXZz+C+X/OQPxltmh4iTrl8nW5/woOH7WRXLOdmJZe5kOCQ==
X-Received: by 2002:a05:6602:4f0f:b0:7bf:b9e0:c7c3 with SMTP id gl15-20020a0566024f0f00b007bfb9e0c7c3mr1262797iob.2.1706227521420;
        Thu, 25 Jan 2024 16:05:21 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id j71-20020a63804a000000b005d7c02994c4sm76626pgd.60.2024.01.25.16.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jan 2024 16:05:20 -0800 (PST)
Message-ID: <4740cafc-f881-49f2-9a0d-75390b9b06ca@kernel.dk>
Date: Thu, 25 Jan 2024 17:05:19 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.8 20240125
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>
References: <19B1724B-E840-4A83-BF7F-3A3FE2C26776@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <19B1724B-E840-4A83-BF7F-3A3FE2C26776@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/25/24 4:59 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-6.8 branch. 
> This change fixes a RCU warning. 

Pulled, thanks.

-- 
Jens Axboe

