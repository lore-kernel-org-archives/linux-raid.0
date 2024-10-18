Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C7D20E312
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729270645; cv=none; b=JwjJdZSCK2hHDuEazOLEI8aXXcM/IyDMmeOGbWlHYD62BfkyJ3Bc5fJo+w6qk0Ix9LiWr6oTrX3osF0IKg0tBKqeFbJ8ERNjJCl1Y6hsm7OgTzg7Tfv/9biHanfyXMHN1hdhSxoQNPYZh9FQ66r6dTFO4Rk9SV/Zyy7EQo7GR7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729270645; c=relaxed/simple;
	bh=/ZnfYm4u1hNerT7plDWREszDAVYEta00oYlCCam/H/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TRGWmle3pS//VHhwVKhkrxodsvF8+CJtcdyN+hMciRLJoTkBxc0HrNIc28M46+nxA2EuvFtatVt5Ba/ncIjlr5f+yZ/n9Dr4PccTiPjwbDBLHEE7XDD4v0J6UhHzFGXBAUUAUXvO5Kf76pvl2Zk/bGWIb4gzAqDzH7tRQEexH90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PW3oJU4V; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PW3oJU4V"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a398638ff9so9229735ab.3
        for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 09:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729270642; x=1729875442; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Ymvx+RUxLHN+KA65XR4AzYXfIpw69GvUGoxuwddB84=;
        b=PW3oJU4VrplHVMW8fo+cRG+IVwumzrbvw74zls0591UghySEXnUuC2fEo3zKO0UT8c
         IC1ep+b4g9AkE2utInJ0KwDxdA8aXHZ9YpL8rOZTIlt4kvW/e91IDIpgZhS8PdBAM9hp
         kgpIFpNwpy/1oOcjq6TJUlxJE7+6hbzfseRhlTpzH+X88LcWBRinwOyurNla8rFGtOgi
         b7jS4D5j+hrFX/fxxjo1I+1qnnOULWMBPj50kyPtrKnEDeu9dMmJzN8I+OCiESgXBXhE
         /FEA/NfwlJR0TKNf+Q1Zep2M5JMTtvRniDkX9T0L453vJ/Bbg/LGz4ZnQDv7AU59cVlH
         84xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729270642; x=1729875442;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Ymvx+RUxLHN+KA65XR4AzYXfIpw69GvUGoxuwddB84=;
        b=TTk7nQN/PzlokPXXKngabt1AhZ4TQUl+p7Xx07WD6bFK/oDPaQnn2N/6kOxczI5Ljj
         2A3TSR8ScUIgHa6bDzTASQIlInWWEIjX5YeG7xie6IQDqPVw906Wdmpe6cBSOzAljXbL
         QCrewaThYwK9xI5ixZ8InXbEGOj7ciuI7M514OaRxluD+HSXEc2722H1uMcNz+v2BjQE
         0CugXgtTTWK2m0mY7ezBEJifyWhUsDti9CFM1q9qJsMwRhmRAVvas9uQH5WYQcMvcWXX
         RSDCE3fhCsmJ45Yk6F1+CixaXkhi+2yxvAkbroQd7kJV9rsX8v8WOazKTHTk+gsyi4uj
         bX4A==
X-Forwarded-Encrypted: i=1; AJvYcCUUAPNKdiGgx8aZwYsYdWvP7UySPnXHhpUVZVyEn3TJ4PtdpqiImIu343BIVOS9x+ALkMaL8hZVDx/K@vger.kernel.org
X-Gm-Message-State: AOJu0YxNO9LjpYum92XVxP9WMDR9Nk8LcQKUiCWoGraH0IQLdQQEU6eV
	+QFOKr6mK2fwQdiE0m0x8QTLwItFrQRqeeOkTP7UTq6itzc6IrBgvPDANvlMOBI=
X-Google-Smtp-Source: AGHT+IH56fWqvT8TH2A09kQ+ypwowt9AjJwi3htXxTH3VUwVsXpSfkwW9xusntTF1xoSzAkuZtJV+Q==
X-Received: by 2002:a05:6e02:160e:b0:3a3:4175:79da with SMTP id e9e14a558f8ab-3a3f407341fmr39177685ab.13.1729270642251;
        Fri, 18 Oct 2024 09:57:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a3f3ff715bsm4875475ab.49.2024.10.18.09.57.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 09:57:21 -0700 (PDT)
Message-ID: <30375cbb-9db4-4167-ad46-8e38e7567145@kernel.dk>
Date: Fri, 18 Oct 2024 10:57:20 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.12 20241018
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Li Nan <linan122@huawei.com>,
 "linan666@huaweicloud.com" <linan666@huaweicloud.com>,
 Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>
References: <9C34128A-7886-47B9-93F8-0AA772EF2532@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <9C34128A-7886-47B9-93F8-0AA772EF2532@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/18/24 10:41 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.12 on top of your
> block-6.12 branch. 

I'll pull it, but it's not making this -rc, it's too late for that.
It'll go out with next weeks pull request.

-- 
Jens Axboe
