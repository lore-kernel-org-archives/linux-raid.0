Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408AC2459E6;
	Wed, 28 May 2025 09:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748424429; cv=none; b=F1eqZv8WPiWOizXbpsrf3G4HUL7Z7BS6+jhD3dJarRNzx1NpHbvwy91tbPal4tFzGSkgrrpbpJxHH16hOni4xS0HpWQ+1kDbcYo1wPtzUP3Wp8IX5Kny5171/nKaJffCrrDpY7FBl2gsNBhiGvGwGYr6eJIDcklMXIK71Qb5jyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748424429; c=relaxed/simple;
	bh=Rkl9MnMzfps/nZK5j3AhdUB2c0gHsAoIEhsLJwN4W20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rVsqSN2b2lOyBu6DzLpOa5hGc/d1UJa7bU3hl7rtVCAAezhhOZj7hcup9y6LQoEV7+T3ASiI3z1lw8NibLmbg43NzdOrCoXsmASQT5XLenHd2jwpYfRwI/dfSqyQDZ4jA1wibSv4dUKzUGNNSgiJ/AX5sV7l0WIfIvSIiUVNFJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gzHKjDwU; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzHKjDwU"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43edb40f357so36731785e9.0;
        Wed, 28 May 2025 02:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748424426; x=1749029226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DADbSQp6yUGzEJGyGZDGlB+r00LCI7Uhk326gSg6NQ0=;
        b=gzHKjDwUwmku/JbteNmo0SbauFqxVf5yCd0iF5LcoW98ZDJyTH/vJ4O9wg/OZH2p1D
         UpQKDYphN87U4XoLfhb34QUAxefTtIrgM937LU/R2ldggr8vJFMHtvBtfNtiLO4N0m8q
         QGgHEAdYnqH34VWncPTT3I3vKDTJKgCeVybyp0MJ3swtUe7Smk40+hcqFQx+hxj1kObz
         Ohvhmou1pqdNmFWbYyyb99Y18ZqSirXNnsj4IeIEdAeEY0eRCEat8tcwIb8LAhe2Nt+q
         6xBHQ6SyTBJee4h01CZRJNKelb9Sq609hApsYVqBR+lZ2jxR/0bRTVo6RcgVcldNPJHi
         4pmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748424426; x=1749029226;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DADbSQp6yUGzEJGyGZDGlB+r00LCI7Uhk326gSg6NQ0=;
        b=BJsq4+AQPimNCg5QaoSjziemaPzgRIlmQqVCAjGuNxsQd5JrcJwc1xV7rSPuUrhZYj
         JMKQeqwpa4ExcTx2+qSkBFgfgRzdqEgjpQQ4mcJWL09hMxXhEOJtYe0rvZVBQGL2Jzk5
         sANEuOVYgy66L1Sc6XGMuhmqfnJi3tbiP8zm+mE+Mj01RWAqM9B3YrC6suHt0PykiOUy
         Wp6plBsPqki2+7+7dWRjaN/8cjnH2c+Y/uo7uXsMLFlIAAFqW74DlzE5sZ79203t9PH1
         1KKMK5+/wzYr+xNY1CPPQiyKZbodEDFk8VzUxm7dGReymh7Es4/wodjW8ljBfl2KxAm4
         Dk1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUy6TwbdysiGCsrAvTnQTyVVOTF0lREOZO6rzQTwx7TXJv6bcytpe+6EszBvYnD+ALtZ6xECkfxkzz4jCM=@vger.kernel.org, AJvYcCXncl3pJWTE1fiCN3hPzL//aWBNmr+z8qfR58uS8AWVTjsF4x1xlZo92EYMelAddIigrdYBgQU4lpD+Eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ44YdA+ldS4djPt47HIR5DlArCsZzm7leUV6ldY+cziq3JL7t
	48R7PorryiZT7VI0PNjNH+6YhK9LADv6WrkU6JF+9QflFowvapGBlFbN4YzJRFVkjjY=
X-Gm-Gg: ASbGncs/zNVOJt9atSpHWgVJ1hv+w4a57dvDWNxxSKxh4kUkAMUpY2iTZ3BRcDEkNdz
	7CMkguxLyz4ijnMfoJtjhArZukBKjGR2w62qo2Cgh1Wecs8pwickYqUkKSCI94JUbTqnIZGBzbE
	eGw13LU3AvpVllrql1k1CuKMVShPxq6gOCXePVBC4Hk+vgS1Zyx/NrzrHIP05tfFhoRXNfDI5J9
	NpZiDgZEl2gUA7E6fFoFB8O/WrlMBkolJal+us1TGW9dbmE6UTpAOufbDvG8mPpN3PknoYrLb6H
	AoyDwh362hGIiKPhyKuph4WS8Aw2yghpVhxS5h/k/7zW2CM/16YGOjxjMQ==
X-Google-Smtp-Source: AGHT+IHF6OaK+bSac6ECH1IPMqyc2b/hXMEmiIYiRExLKW0p4wvXpqkSjymxtwCMsKX4jY6/QmRP3A==
X-Received: by 2002:a05:600c:870b:b0:450:c210:a01b with SMTP id 5b1f17b1804b1-450c210a070mr12108165e9.17.1748424426206;
        Wed, 28 May 2025 02:27:06 -0700 (PDT)
Received: from [10.43.17.62] ([85.93.96.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4500e1d8671sm15371465e9.29.2025.05.28.02.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 02:27:05 -0700 (PDT)
Message-ID: <c60f5fc9-6053-49d7-852f-fc581bd10169@gmail.com>
Date: Wed, 28 May 2025 11:27:04 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md/raid1,raid10: don't handle IO error for REQ_RAHEAD
 and REQ_NOWAIT
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
References: <20250527081407.3004055-1-yukuai1@huaweicloud.com>
 <190d2a22-b858-1320-cd2e-c71f057b233d@huaweicloud.com>
 <CALTww2-_QoC7OCVSXHy=XfYE3K9m_CQ05HKX7QqJ504qnN=0cA@mail.gmail.com>
Content-Language: en-US, cs
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
In-Reply-To: <CALTww2-_QoC7OCVSXHy=XfYE3K9m_CQ05HKX7QqJ504qnN=0cA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dne 28. 05. 25 v 3:28 Xiao Ni napsal(a):
> CC Heinz who is a dm-raid expert. But he is on holiday this week.
> 
> On Tue, May 27, 2025 at 4:24 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi, Zdenek Kabelac
>>
>> 在 2025/05/27 16:14, Yu Kuai 写道:
>>> From: Yu Kuai <yukuai3@huawei.com>
>>>
>>> IO with REQ_RAHEAD or REQ_NOWAIT can fail early, even if the storage medium
>>> is fine, hence record badblocks or remove the disk from array does not
>>> make sense.
>>>
>>> This problem if found by lvm2 test lvcreate-large-raid, where dm-zero
>>> will fail read ahead IO directly.
>>>
>>> Reported-and-tested-by: Mikulas Patocka <mpatocka@redhat.com>
>>> Closes: https://lore.kernel.org/all/34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com/
>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>> ---
>>> Changes in v2:
>>>    - handle REQ_NOWAIT as well.
>>>
>>>    drivers/md/raid1-10.c | 10 ++++++++++
>>>    drivers/md/raid1.c    | 19 ++++++++++---------
>>>    drivers/md/raid10.c   | 11 ++++++-----
>>>    3 files changed, 26 insertions(+), 14 deletions(-)
>>>
>>
>> Just to let you know that while testing lvcreate-large-raid, the test
>> can fail sometime:
>>
>> [ 0:12.021] ## DEBUG0: 08:11:43.596775 lvcreate[8576]
>> device_mapper/ioctl/libdm-iface.c:2118  device-mapper: create ioctl on
>> LVMTEST8371vg1-LV1_rmeta_0
>> LVM-iqJjW9HItbME2d4DC2S7D58zd2omecjf0yQN83foinyxHaPoZqGEnX4rRUN7i0kH
>> failed: Device or resource busy

Hi

This issue is caused by occasional race with udev - which holds open our 
internal device open while we are deactivating raid LV.

We are currently trying to resolve this issue.

Regards

Zdenek

