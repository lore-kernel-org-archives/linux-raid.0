Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DE5284888
	for <linux-raid@vger.kernel.org>; Wed, 17 Sep 2025 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115321; cv=none; b=OX5Qc0gtGc+vLYISIwggsaY465Gw1t/KBXm8XAJXLlck7tIxiTlrPDV7e7yLG8mEmQE737FgagJUB3Fp9l5ri9YZY53kUv1h+7ecY8CA7F4rVZFgxYASNRgRhifawxNIOk+ia4Sfkn/sm9vtc6QC6wP81cxwOuPyWU7OfDElnos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115321; c=relaxed/simple;
	bh=Nmr6lcv2CNDyGpXvoHn0q/udjP4zcmNWEvHXekPMVL0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tYiVlqI96JJ2KT6WoQ7Bs/vUZq2I4ppIJ20oh9IhO1Fn3goE34ywKRI1G2cNuMP0qtJVwU8nlWalXHu4kR9yOoWXjCI1btJCsstjeOolsetQf4Bk8VVWh5pPQ+UZOE06bj9Kfl/5E8IRjWfYdysKRdphxkI3exrkzDioyBt4qtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CEL5FUxU; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CEL5FUxU"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-424197bd073so3959815ab.1
        for <linux-raid@vger.kernel.org>; Wed, 17 Sep 2025 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758115316; x=1758720116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dMJ57nRyP0a6b1BuiyGtLla26Abwla3P9duCF5wfULw=;
        b=CEL5FUxULkusfYT9Rrpmk7M2gA+dv7m3CZHRyf6nUciIeHfZ3tVOWYPBG0S5V7D8cJ
         XO1kaBDS9r1x3ZQPW4ATJmjIjp+/obdVkYiEIrLzi0GtbzYiVmk6bd2SiF+0C0kgkywS
         43dcw4bekYVLLzO4nvdehLz5ruQ1oUd7Ws50ozuRFFwLE0zkl8jYjM+FofedrtV2Ocqi
         abqUtNTvDN3mpxaD36WaF1bIyMubRTgG2qNBUd4Wu/Lnvm6tjJkosz9AwVPvKleHtHlL
         OIR6YWBCDuBuOXTRdf3gauTaKQK+cZTX/t41voZgN/KLATk0+Wo5T0CDkvhD4IyJUFf+
         53wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758115316; x=1758720116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dMJ57nRyP0a6b1BuiyGtLla26Abwla3P9duCF5wfULw=;
        b=L2VAqkgf/CN+lXDml7SS+3qJJ5/LMF+h57Vb3OKnx/paWMvBcSdnA1OdxqCIWEwVw0
         egN/ve7BP0qFlwP8TYgc4nWBMp7TA3b0B/v961C9hnQ0aWTgcmB5BvQXG0b/kFmkILnP
         BnClENHufcD6Ru4erOBxIbWz2yocS30VI7Q/oM0fk0YEsJ3dS0UY6tbYCb2f0KC59hP8
         +axBLXuFxLWhYRouhVtsisK2KcQjjzjot9BbqjOcrdAMyAgslRv9Zd9z1TE66Kci/Qzy
         a18+62MUkrtBwU2TN7WtTB+AOI/9qc4y9bnhpWBsCjKDMxLXx3vPXp7Q8etyPUSQtEQ8
         i/rA==
X-Forwarded-Encrypted: i=1; AJvYcCXhOnx03yrMhm98KpHXPZjemYLXf56kSvOjWdWIW5/CcmOBSFEHKfjNVzEgVszcNA+/bItiT7bV7Vvq@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7mI70Vmg01WHQfI7WA2IsTVIwLsWymJm5reCiJU8ijVh6jJkT
	Vuch9AS2rxj8eGTf3RkHhlPDGsTJnu3kP90DcDWdACcM/RfxIOnYzottn1J8U0IuUh0=
X-Gm-Gg: ASbGncv4CFffTEY5Jhh51k30LKLqlMizrZYGoi3MjJ+M0vjm38a7wLf1iBAcAftkCFA
	VBRDVW7/P62KXzudbIoHzHs7nV5Hu4UkFvjPEoQupkHuhqA0tCPIk3vBd/qFO3FCw+Agj7+YFUN
	jx/U/Enmo7t+nIlKkzW/69H/HF+NqOs3v0FCLQEE9fKS91Nz5+9kNIiiUyN8LAE8nnJKlOqtBGL
	PI8fr0FQU2asiPZtBaK2hwsDxFggGyjNmqrQM9aUpPU3o7NaFJlt2KKVVIk7mi/5R49MmB9uYH1
	NUpwa/jucwgZNoiEdTtSNvxmncHthnl8LKw6Pu04V5Fh0dSyMuysK5b3gShXJa/5RX7VJwzda93
	xwuwONItORQL2nzMTWVM=
X-Google-Smtp-Source: AGHT+IHSpzOaWwnFlZgfl4JfEV7AGMMb/I3wng29e2F7j8UdqwxsOuC6KxjQOdtNGivJ3EwBqX/aVw==
X-Received: by 2002:a92:c242:0:b0:424:36a:7b00 with SMTP id e9e14a558f8ab-424114f2623mr52787045ab.13.1758115316438;
        Wed, 17 Sep 2025 06:21:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-511f2f6b4d6sm6916133173.36.2025.09.17.06.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 06:21:54 -0700 (PDT)
Message-ID: <d334cba6-bc9c-4da0-8e28-672632d70188@kernel.dk>
Date: Wed, 17 Sep 2025 07:21:54 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.17-20250917
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: john.g.garry@oracle.com, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250917011056.1843135-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250917011056.1843135-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/25 7:10 PM, Yu Kuai wrote:
> Hi, Jens
> 
> For 6.17 on drivers supporting write zeros, raid{0,1,10,5} are broken and
> can't be assembled.

Pulled, thanks.

-- 
Jens Axboe

