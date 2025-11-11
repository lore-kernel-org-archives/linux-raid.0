Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0366C307499
	for <linux-raid@vger.kernel.org>; Tue, 11 Nov 2025 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762869772; cv=none; b=DTDhan+I+C2mLdQiz+OKLn6mHBEHn8LaBclMCIiQaG8eAyXYhK+H2YfYS63Rku/NL1xrUW+/znQGmqP1uWl0ajlZb9klebyrz4niWNOe29o837zYv7eeiKSo54p8oQD2AxwCUaPvkba5+8qExuHz9tSRGZVNl499xI5QU6dvNOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762869772; c=relaxed/simple;
	bh=+r3MreT/sT1crw54UI3hsaeGtJviYXqN84hPams0hvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CyI9YBijpIr/aY/5kLlcS1ZQ/rnSPXxDYD4hTXpHjriWshk2zkFiHXEiTJ4oqT+7OIwzoSQz32o0+ELUssC7zrwDYynVqT0z8PdFkF1Y8gSrwEnunsUV9PW4wqH7bPaJs4tvF6iUkyphKHwzLX695Z6tSn3sMs6DnOQgfuLak9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rm1hMLqq; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rm1hMLqq"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-93e7c7c3d0bso357363339f.2
        for <linux-raid@vger.kernel.org>; Tue, 11 Nov 2025 06:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762869769; x=1763474569; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kawQyvNWLbHDUPhQUWN8vZdFV5j3qEt7ltniUTxkDo4=;
        b=rm1hMLqqj8ptfoOWC40cTuLVzu3hQBh7hJUEIgih8e4Y933cglapFvvAcxQGDg2a8B
         gt6Dn1Uk7Lwwr4k991phNHRBMgCFSaisidvxuTOdtQaraiilQn8Xzvok7hXQIzgCfxok
         NGBU7l5iZd7bcr10kEaW4ZbqRSpzwjgLEgGF6AEYl3u6lq5YCGMJ8BWpoHm4+B81Ekmc
         p80e4gLrcVECFkhlzVFcPbuiro8IfXKcLw5SRSeN44wR71vyFuhxJsYEwduSZoVRXxrr
         xshO2z4CCwlorwJ19q0N+zkBGJkF+yL83GOsC0EieAQ69Qi++eF0DsI8MnIIsFTuJBQZ
         9p+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762869769; x=1763474569;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kawQyvNWLbHDUPhQUWN8vZdFV5j3qEt7ltniUTxkDo4=;
        b=DKmUZLBmK9O08XNE4vl4FyvsnNQsLVGbH/OFQWmHv2ASsPoB4FHByomtD4AJ9sVcU1
         2lNONsSaK0wmIb2QxHZYoj0jLsVVT8QCWNjrw1t2zQx5Pn1YRn68WQnMcckwC21CuECW
         I54SuiNntOODt6VUQLt2t7igSP01Dhh5HHLW6WYqkMo3TXHGnu9VPLdISLEtqTF4Jr/R
         V4V/5zwTV8NTKFEF0u64Qv6lRL2X9qVMFH/0DYUMyal/YBSknLEZt94Pz8GhoYo3EsAy
         c/n0VFs/iF77bCkUyDpkmBZieBlypbN9K4X32LUbt5K4d21RNhYEBunhPOJ/3VjCuo2G
         h9sg==
X-Forwarded-Encrypted: i=1; AJvYcCXUNmRzkUKv7+EFSy3AOb9bEvY64+XB7egRl287vpPYJeeiKW8SY3edwdtIpy6225juvoEGFNboJbQh@vger.kernel.org
X-Gm-Message-State: AOJu0YwhtNh/Zp8hbPM7AVVlDBRQ5pIWyMlFk7yF67iB+we7G6ipgRUM
	o2j0umKHwI463ewk6xmNWWaSvRWVXGhwg6vuShjDydmyTESqH7Uj7CyWy0PCwozj5LA=
X-Gm-Gg: ASbGncsS9LbaZcUuIN8344rKyNpefyT/lJCX7zb2O+SDAGM6xaHpIfAWcB/ygHNhDYp
	PvybhvfBIM//NDrh56xqUW1BVTTyPJXIHsjJdFuZTRQpQ3Imdd+8HtoGkHZhQ+bS2ls3H/qJE9w
	axua0CiAPcnssP7Zb5j+LS6gt5/RejO5RNKc31t9dFp+84Xj8xgAjZlGLYcII0bgMG0JyTGYK3I
	4OicU8LU4HfW6nE+E8Sp3Y0j4GRHQLvoNvd/xAVcOxfjB+VAtQP1V18rpSIRh3fnGT8OlVpG9oc
	OAgOkx3HcISU59v5AjIdOMSQI59sIrT3LKB8iKm7K/HjgaJgCjbjxLHF6BS6QCyPEJv9NDEvNZH
	z5nGzr+nLR14Cbmh2QLrgVBf+bnHgshE6rbPYYnLrOf/UCtGUwqmwLgd8YJ9Rh24/U6LYtrF+dQ
	==
X-Google-Smtp-Source: AGHT+IEjx/Ad1PPGGmmL2f+33W3x8Uw2hjSm6whM7hoISF4f4YXW/8JP7W6YocdtEbXJDFt6cPZXgg==
X-Received: by 2002:a05:6602:14c8:b0:948:6aca:4932 with SMTP id ca18e2360f4ac-94895f76778mr1714074539f.3.1762869768413;
        Tue, 11 Nov 2025 06:02:48 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b74698c508sm6266557173.59.2025.11.11.06.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 06:02:47 -0800 (PST)
Message-ID: <0bfb4acf-b07d-4b12-8f4c-fc5359595d47@kernel.dk>
Date: Tue, 11 Nov 2025 07:02:45 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.19-20251111
To: Yu Kuai <yukuai@fnnas.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linan122@huawei.com, hehuiwen@kylinos.cn, xni@redhat.com,
 nichen@iscas.ac.cn, john.g.garry@oracle.com, wuguanghao3@huawei.com,
 yun.zhou@windriver.com
References: <20251111033529.2178410-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251111033529.2178410-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/25 8:35 PM, Yu Kuai wrote:
> Hi, Jens
> 
> Please consider pulling following changes on your for-6.19/block branch,
> this pull request contain:
> 
> - change maintainer's email address (Yu Kuai)
> - data can be lost if array is created with different lbs devices, fix
>   this problem and record lbs of the array in metadata (Li Nan)
> - fix rcu protection for md_thread (Yun Zhou)
> - fix mddev kobject lifetime regression (Xiao Ni)
> - enable atomic writes for md-linear (John Garry)
> - some cleanups (Chen Ni, Huiwen He, Wu Guanghao)

Pulled, thanks.

-- 
Jens Axboe

