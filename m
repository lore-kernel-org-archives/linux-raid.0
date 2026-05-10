Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E829284682
	for <linux-raid@vger.kernel.org>; Sun, 10 May 2026 21:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778447835; cv=none; b=aoKWl11nLrYR47raXiApqicFU7tilfX/yQIO3zj4RaetpHYIaM4JQ6LHN4ArN+WWIL97z4ZQ8KIIX4DBYCfDDBpz2GpND3ymsARTq+5vSXylFxNX/pDk0OQaV143kqDH/Yotn/5dcbOH8D02pOyasa55uNXxajdkxlWSjaYWQRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778447835; c=relaxed/simple;
	bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldEkJAxLElXqtjmZEEfElzCZOkx2s5oqnFuErBY3VkNFV3jKJiW1vQgf0O3a3Mwadee991HvrOrcOTLSZe01x9PpY2LqpRXKo7hnvPFf1e+jHrwDNp8uQE/7T8fEk/rX96mK6d/7BuXsPQp7Jtz7gwIYIare1SO3XKZt35G8jXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso43309205e9.1
        for <linux-raid@vger.kernel.org>; Sun, 10 May 2026 14:17:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778447833; x=1779052633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=FlcdLcyrtv0MRW/tP4Zzd5TbKSSsqyli/57JBS2AZUmIjKCFyFDmfSzeK86RXZIhxN
         qpfBG5wnHEM7iuhrEJTvB/+WaCTneMYytdb22ENmpra7MMRrZ44XqGjwguZ1LEoZFITv
         784/yhMSgr1FHUNAtks4sO3tRwprKsp1ZXdfkuI4NeLygpC1B0xqn17VW4iTm1uHpG4h
         sbqGu7Y6G7jYSuJVlz2eDFirSfiAaZ1jBiqjSaOSNB7vXyFtIN/B2/rF2frC+B5JBfFf
         to+e9efyUNs36HrHy80NZQvgUx0NSO/OodGO5boKlhyKjhsEkA16RlPZamOaihKPQE0A
         Xs1w==
X-Gm-Message-State: AOJu0YwfHNest7ES2d5/1+Ud5GyeSjz21ZPwPGPaTDLPOKXTrW6PY6xp
	LAot/VvZXigVnJ52YieTAyB7EHrcmrNDixWY6vDfpDE/jxBruZtVORgg
X-Gm-Gg: Acq92OFRCAEJn4mtByr0d29iJNhVk3HjZBjAZqMjnpvuh8Aes7Ev+zsFXQGuJMtdC3F
	70r7KgvVL5/ojaukIDL9tKSdtp6SGmLDh4yf7HqSkM/GsTukcfnbVf7uDK9FxS7N9ag64d/F4y+
	keA/SP6AW/994HodeYsYlKPHRZM1936xwdXlTxw4hQLwjsQ7mvn42uJrLX0Xy/yI6upoN1nTIZM
	zgXzLjToSzQba1BQKKr/Ge8HbTMTyMb79yeys1c08+28pyKX4PbHFbKHv+MvMqLS7XG0rQSc4gT
	3Oo5B8bNcVOVySGYxnUPQtHDmOB1n+p9063QpN8PX416ikUIoL5vcniznbRe89/6TKUavAKJLqp
	ertZ1/ZxjR73VL0Jl2tLWxQEiMTbPqVpJKqIVqRIgMPjRr8/FOrGyaEP0r3mGzVVMUMADQSU4ds
	sBLl3IouA9Es2kmI+LJAc=
X-Received: by 2002:a05:600c:8211:b0:489:c57:7836 with SMTP id 5b1f17b1804b1-48e51f40ecemr379892335e9.27.1778447832625;
        Sun, 10 May 2026 14:17:12 -0700 (PDT)
Received: from [10.100.102.74] ([89.138.75.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702e0c70sm152074305e9.6.2026.05.10.14.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 14:17:12 -0700 (PDT)
Message-ID: <e3d32d96-dbcd-4915-955c-3c63c891b5bb@grimberg.me>
Date: Mon, 11 May 2026 00:17:10 +0300
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/3] nvme-multipath: enable PCI P2PDMA for multipath
 devices
To: Chaitanya Kulkarni <kch@nvidia.com>, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de
Cc: linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
 kmodukuri@nvidia.com
References: <20260416212633.72650-1-kch@nvidia.com>
 <20260416212633.72650-4-kch@nvidia.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20260416212633.72650-4-kch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
