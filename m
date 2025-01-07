Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67391D958E;
	Tue,  7 Jan 2025 20:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736282054; cv=none; b=IPrTLnm+2olRcah/Tjc72EksYOIzhTbndtIXr90PNlNw/lR3xaj1etGjRivk2CKve1LmrR8AcRLar0jKluYT4It9lWpLtx/EyXkqI+zwFHg5Y2M/4f0C7NoBnpEdCFrugCU0unt8EZm/PLE91Qu6ANtCUSw16msq7FkkqZxmO/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736282054; c=relaxed/simple;
	bh=B8JRArmkt3Y6QVgGsvzoWGBv2QNdmirZ0fh678/k+JY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pigg99XU6csyby6N4xvrOKcTQSufs5kp8pysMfNq3c5uRNLZnl2YNp0Q/9Ps6vqwPFgKyPMDGTs4W8zpK9D3QUQZJoSZNpKDFA47fhptwvWUW4wr4Q9R7+z5M5UvO9sV1R4GUDCtMXjLxu5fCPODfagcqtW8Hi1L4NBTFoHg29w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ROO5bLJT; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ROO5bLJT"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6dccccd429eso144540246d6.3;
        Tue, 07 Jan 2025 12:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736282052; x=1736886852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kht+cFul6vjqpxYKSnTCRGFt60+osMJrA86H74IGK+E=;
        b=ROO5bLJTLgOhp5cifM+deiyBHu8ib50/LcZ86xihsdZbz67vhYCcljLgoy0NMrE3C1
         XvF0mEGJ0eVzO1pDai6PwspIZrra4ZXX4v90lT+zhn1IwYYXz1UBKwhBP2249R6KsjCk
         jVyfLMHG1GbKIrVxPhpoAIrII51G2L+MOt7WRALbUFNCp5FNzXXj/p/FCY3boFtBHVrp
         5zU59dHwpdaGvCLVLbqaFsTktsAoOE0SI8cpScQA+f8S+vYH6PYb2HVWhDthxIr8QP7L
         6BQFVwh/eyRuSX+Yei4Gdv7+dHQu82JBmloPH10p31UShsW03APkUzMfh31103lta0Q/
         vbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736282052; x=1736886852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kht+cFul6vjqpxYKSnTCRGFt60+osMJrA86H74IGK+E=;
        b=c7QNif9RBu8Kp/s7gyZUGfN5GfEICHVQkh4QIvXcB+oPsDNUu7VLBnKAYmRYMzCvx0
         J+E0LQW+ilIZbHSsik7zu5wP516mpDa0E3Cwitv63TMVtRTpYyW5rLPI3LdP2s7j7TyD
         onuEKqUnFzuo5QpvGhvLYd8wdOOT246VTcakGtr4W7sCxIJi9RJtOFxHKfZxdlUOuY8g
         dHTQZofP4Ht3csge1O7o7oxrlEKb3C4dl8gcrTBQtGv0hw1XiZxMhB0PGct/w6UdR1hb
         jpTVnBcoly1PIJ8cjeOu0uwIJBfAaJXajEzceWlEvs8QOxdub2kaD8NVLxR7/bCGvoWY
         ZN3A==
X-Forwarded-Encrypted: i=1; AJvYcCV51RFmfpB6G1U1epd39xV3Mj3ydtz5wSODf5a3yaYhh4rMFcRaGNICy07DpHKRtP/QW8L5zxxyIUZ63Q==@vger.kernel.org, AJvYcCWLN3OofwfDfw/ZsVB7gGepB8qA7iUkwGqSJYmtFl7d4T7Dca6FQjVdOLRXez9jHqUnaDyDABg07Cr16iOK@vger.kernel.org, AJvYcCXqjjmdSuwAl89Ev7TOqMARDqDPbIvbIqas9XBa1xAG70NCn80GXCASNOE14E9BKJKCRXWWWBJ1NeUl3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlB6BpmlmFDoCCMPprA/kqCPYq9ysMR1Ya+ceuJFuGR4yzsFxv
	b7jBTmq6AuST0TTy5wzo1nAKFeNl9rUXbM3wH1FYDRSobxbYCh/z
X-Gm-Gg: ASbGncsPsd02evVq48p4dMSAB9zPdH0gL3pgpL5iCn3xRZLtsYRtuiHwWOUa50Ba6mx
	sz/8psbRKV7WCB/iKj8FskG2st7UJoLW82ALGqJCoxguaQC34IyCTcmwy10f4AOkFS9+z8ubq9M
	cmYAb90voSrXM+3YzOIqPG3mxHrChk2oRKlTjupVghOWxYnkwb2th30RkcvJFll23sY2Ie88+xc
	oIWX1futof+Qlz9f6qxh/LCN6zfEmArfdzhCB0oHOt2TrSGnFU0+zti0jA11g4vt8qZndOSXILx
	xWai58OFCGQvWCexL4WoLM/mpLyjPAWN
X-Google-Smtp-Source: AGHT+IGOz7rNoqhUwZIiKYpuUzZKpYvrk4PlgYVUi2XsnYLA78fGvk7mPsKMQW0NrGMii/IrMQNkoQ==
X-Received: by 2002:a05:6214:21cc:b0:6d8:81cd:a0d2 with SMTP id 6a1803df08f44-6df9b2d4f97mr6678276d6.41.1736282051454;
        Tue, 07 Jan 2025 12:34:11 -0800 (PST)
Received: from ?IPV6:2600:4040:5f58:2500:48a3:a7cd:313e:1c7a? ([2600:4040:5f58:2500:48a3:a7cd:313e:1c7a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6dd181d5ac1sm183958916d6.120.2025.01.07.12.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 12:34:10 -0800 (PST)
Message-ID: <13a377d4-f647-436a-806e-c05413cef837@gmail.com>
Date: Tue, 7 Jan 2025 15:34:09 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
To: Mike Snitzer <snitzer@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, thetanix@gmail.com, colyli@suse.de,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, dm-devel@lists.linux.dev,
 axboe@kernel.dk, linux-block@vger.kernel.org
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
 <Z31jQT4Fwba4HJKW@kernel.org>
Content-Language: en-US
From: RIc Wheeler <ricwheeler@gmail.com>
In-Reply-To: <Z31jQT4Fwba4HJKW@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/7/25 12:24 PM, Mike Snitzer wrote:
> On Thu, Jan 02, 2025 at 07:28:41PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> THe md-linear is removed by commit 849d18e27be9 ("md: Remove deprecated
>> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
>> time.
>>
>> However, md-linear is used widely for underlying disks with different size,
>> sadly we didn't know this until now, and it's true useful to create
>> partitions and assemble multiple raid and then append one to the other.
>>
>> People have to use dm-linear in this case now, however, they will prefer
>> to minimize the number of involved modules.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> I agree with reinstating md-linear.  If/when we do remove md-linear
> (again) we first need a seamless upgrade/conversion option (e.g. mdadm
> updated to use dm-linear in the backend instead of md-linear).


Agree with the need for an upgrade/conversion path.

>
> This patch's header should probably also have this Fixes tag (unclear
> if linux-stable would pick it up but it really is a regression given
> there was no upgrade path offered to md-linear users):
>
> Fixes: 849d18e27be9 md: Remove deprecated CONFIG_MD_LINEAR
>
> Acked-by: Mike Snitzer <snitzer@kernel.org>
>
