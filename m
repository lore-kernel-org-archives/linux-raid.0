Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D113BC668
	for <linux-raid@vger.kernel.org>; Tue, 26 May 2026 21:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832304; cv=none; b=DXci9L2JYuD4y7bcnNzVb+rsosB71rDvvUnct2B8Bq7JzrRZhtrZWg1DfVbrQ16rQS6nYqnFky5GxR7fXxu6Z/qslvHAxmZ/MNHNBoaS1FElMMJChqFl29kEfnV6oOenHqrKlD0l1HGtX32Aa5RMxDIW0L/CaRb+hoX4rRWmcaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832304; c=relaxed/simple;
	bh=/JQM2OwPOrXvBPoLMhF6DhSJJg9UVNCh2Y3F7mDsZq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bjk8ZHL4BZKI7pLttJGQ5xjxeD5oSV3/ChgHMCxV3V2a3V7WYfthQ12F+VvSpgAziNZJiqQwulv1L68HxJ7p3D9nYa0fpGX5/Ody5n4K6wHFVu+forrlxk9SUw3NyG05A3GZz1wpBN6jXcZehRwoezFzrzYcYTX9GBrnSO25uv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=ner3lzy2; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="ner3lzy2"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69d7f4cc61aso1854475eaf.0
        for <linux-raid@vger.kernel.org>; Tue, 26 May 2026 14:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779832301; x=1780437101; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RA7cD0bS7vuj5BqYOqhUb3Pso3HctOE2AcDFDnLY8ug=;
        b=ner3lzy2tdEv1Y/7W5mtK5dtfav0oSsR9OiUqlPJLcC0O+ywc4xMZQoNHax44doTKU
         Zdlc26o5D44p6HTSABZc2rgkjd1RWgyYQ4LIgv+quzMV/NAtMg4daffhdr314hu0TJ2i
         lNSWVpZsBWv8H+BbyY78yhYdAc0k8KdvQMLNYCeFgAcwL9o+8NwKekcl3m68UBWxERJg
         u1jTbf6YjO2ViMIP8mzSgd0djfNI/y0ljXHug+j+ss/AvDqTjYVakEGm12KsmCWxHp+n
         /BlxxIfeEQDgSOg0bByHMHRw71o1TuVyt9g7QuHkTOYEQpmzIdXxHHbyqDDHtlWeyn4c
         MGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779832301; x=1780437101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RA7cD0bS7vuj5BqYOqhUb3Pso3HctOE2AcDFDnLY8ug=;
        b=DK3tlSp9mI09W71YgwHTE+0TKBP3KB0iE4PPranZvK99mnjR38S1b3V29LNlenI9Wy
         j0ZGynKWHLZNcU3q1HIzN8mmKDjCgda4UAK/dHPWMNkIPc7HS/ezsEVB8HoKggaqIdOR
         QHOu/H8VH7qQ0tpbcJRBjbZb6GGPlq4tLNY69wLiOXknTGKRvo6qhhI25+Z/QnSCaw18
         ykqKlh6pvpa9Bt0zHumcj6xUuef3Bv7ydNgl2jDCPTtWDL6Eup2PGorshNOqOXNvkLvN
         EomWQe2fDzM9DCpe/Kx/Qff4t/29dEupFAj2ucjCmS9ngEJ3dmO1339fBgcdqAO0R/0s
         dEKA==
X-Forwarded-Encrypted: i=1; AFNElJ9n1eXh3BhpYPixKO5Z9dNnSofkphd4w3jOQc9WflGM4x3HL4OKYs2BDZyKZ3cOFpFJltPUBZHEsr1O@vger.kernel.org
X-Gm-Message-State: AOJu0YzmJ+ssDiUxVBBRwZMyv2oW5dQIHd3TW7fhcZ02yKhtudm3fhrN
	p8ADk7cgrBWdNzi9kljlEuY+4XyVF9sr8BVRG7Xv6yBX7wdyivTI3pl1jyuQokwwyLU=
X-Gm-Gg: Acq92OE3W2wy4/SjjkoSaaLi54QOAXjlmaxojqaRPWsHbBcmY8TDIjQ7k2rjbY1P8jI
	CLuvLFhCbP5SWKV7m17wZNeFAiGr9WMzK6y0W1wP8ffafmYctFua5yrtz2wp+uz23V/wMnJKF2p
	/cafPMEY503Zmi6lF1iYRMlw3UDpbpxql6RmrjjnLYyRaisZpe6adT8cfkedusPF1Bmnx2Y7M1P
	f5hIXHZFsEcuZp7z5SxYZew/PvbEuX20BQBNh6BZTAPJjBLAuSuvsJyrDCYnP9AeU1UZOfNfUQK
	2Y1hjNukFp2QLKq9CfeS+ev6GetTnCeuoF2yj8mn1Rh5r0vyEIPLm2lpwnkhhmswg1iCIuhn2DV
	1h8JWdd5oqQIycf4fFUfJYNs2ympKsld6gTtKdHT2xSPMefcz4Nj7QhPyZWVXcVXd9gsiPGOOZI
	RFHGEnKJ6VwU7WSVt91nNhpII6t2baLEmu6vVfjgbdjt9VoOV0X1Y63LDOzhbAQ0UscvWp3UhC8
	0iUsohCHPyz43wVXwM=
X-Received: by 2002:a05:6820:1995:b0:69b:bf80:2db5 with SMTP id 006d021491bc7-69d7ecbfda4mr11748930eaf.52.1779832301111;
        Tue, 26 May 2026 14:51:41 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d83aa422fsm6396077eaf.14.2026.05.26.14.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2026 14:51:40 -0700 (PDT)
Message-ID: <b89e372e-3068-4c26-9552-13e6853ba000@kernel.dk>
Date: Tue, 26 May 2026 15:51:39 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/3] md/nvme: Enable PCI P2PDMA support for RAID0 and
 NVMe Multipath
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: "song@kernel.org" <song@kernel.org>, "yukuai@fnnas.com"
 <yukuai@fnnas.com>, Christoph Hellwig <hch@lst.de>,
 "linan122@huawei.com" <linan122@huawei.com>,
 "kbusch@kernel.org" <kbusch@kernel.org>, "sagi@grimberg.me"
 <sagi@grimberg.me>, "linux-block@vger.kernel.org"
 <linux-block@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Kiran Modukuri <kmodukuri@nvidia.com>
References: <20260513185153.95552-1-kch@nvidia.com>
 <20260515043535.GB3756@lst.de>
 <4ed83782-04cf-45b5-93a0-05a08e61b82e@nvidia.com>
 <053b99b2-c994-42ff-af63-6e63ab468557@nvidia.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <053b99b2-c994-42ff-af63-6e63ab468557@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/26/26 11:09 AM, Chaitanya Kulkarni wrote:
> Jens,
> 
> On 5/19/26 17:11, Chaitanya Kulkarni wrote:
>> Jens,
>>
>>
>> On 5/14/26 9:35 PM, Christoph Hellwig wrote:
>>> Still looks good to me as per the reviews.
>>>
>> If there no objection, can we merge this ?
>>
>> -Chaitanya
>>
>>
> There is outstanding work I want to send out based on this one.

Out standing, outstanding, or both? :-)

> May I please request you to merge this patch series ?

Was waiting on the md parts to get reviewed, by I missed that Xiao Ni
already did. I'll queue it up.

-- 
Jens Axboe
