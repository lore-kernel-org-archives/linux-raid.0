Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2956287508
	for <linux-raid@vger.kernel.org>; Wed, 12 Nov 2025 07:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762931652; cv=none; b=QxKXPUi1Ech9sX90uVi9u6y0opceDgAJ2jWxmuRu9p4GbZaafNkkFNPZalmUADEDc+5jbDhflLovVh7vl7N3fbBttGfbpbBGGiGpNc05gQG2dRPPrj8gMHoSxPZuUQIwa5vM+T474XIERLnoYJjvqZGuDsAEKI2yBd24oE7Kzgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762931652; c=relaxed/simple;
	bh=cUgCmt7/S4H78nSegwnrwPgzDrfISuJQ8hnVSCrlVDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C0PajoTe2n7/+0Rv87IVq1sYUeG/SFKkc9MnGiSrv6NqWOl1Mu/ojlM5B0S2bgHCNgxaard+In+BcCnTBDa2w2yzYAzt7WA9uqeUHTMUe9EKiqChWH88YyDG4p07+kaLSXfop9KHTwTyAt+Bq8vtNHYNS2K3Fcj3MMId1uds1gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XgH8q1jr; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgH8q1jr"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-29555b384acso5271525ad.1
        for <linux-raid@vger.kernel.org>; Tue, 11 Nov 2025 23:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762931650; x=1763536450; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X8sb02e1W+AKeJ6wR0eYaD2KkfiM6HqalBahoIkkYHA=;
        b=XgH8q1jr2+XQgLkfDKCa/eUWE1ZvSrkjRxtr5lBbLGxRYdtzxNaRzJKM50Ux2SEHOn
         0BlAjFIYdWeA6qeOVyyZmDrK6k4OKLxGTQYKjGI7qHlLKCwbVIW0OFzrgEv4v5ewBziv
         lv4ohKUGv7dG6To2zsCiMcMO+Ruuo3xwZdTgTqKyLYSvet1wbq7QLkzDOvfx78zFlOw+
         MR3w5gfbC9TLFm1qlc0UjFCOBC78Zar1o6Tx335kme/yEGz0nsP3JeYSRpYmnGxuxOuv
         z5Wpi3dE0zdK4SoBYUa7rWSOkPUcOAf6XQY3Au3eII4YW4J+vud6XV4zDnR1hSYZ39Yj
         SQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762931650; x=1763536450;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X8sb02e1W+AKeJ6wR0eYaD2KkfiM6HqalBahoIkkYHA=;
        b=krUPwTOufcY3s9beYADku8+7Cpe7cA62uYNisQ8tYolrtbF7Hd0yPHfl3W8CCIFpPC
         SdMb1cMWKS0LnIaVVcjyazF0aL2T24Zpj6X/B6mo9wjsmIyFXjYc1NGjBsvWEuTKfJ6S
         iHZHl7BmoxIE156g+ViD2xjTUmTw6UYhmi6ShkR7AMASCDzmoXx9xxLftTuM2ieGO4dQ
         rnhnLPJX83P9Lf67BBhMGuTf7ScoLwm+h4hTXvtjbTa/iiINkYqp+caqyn8KFV3wCwJ4
         C0ZfpjgZFtg2pttUv1Gz8rTZ9k2Vqnt0YBCTOY+qAnCNOVWLU2QHfX1IRqZTX//jrIPt
         0t3A==
X-Forwarded-Encrypted: i=1; AJvYcCU+kyBP3BCD3sfT2XsoxrfWwtaAJMP7/+Y8SkMNVOrLl1jFDuRcu0K/nB0B4qIUtg2qvGiBlEz3Q8f6@vger.kernel.org
X-Gm-Message-State: AOJu0YxMW/iJXLh2A9giA9R9ydVq0KQsJ3avyv1aERI8s95Xf9/FSqky
	lIAKiD+0m6wsCOKyCEQ3l7bQI30VB8DkMHsPA5E4mqXy0JGoHUIoaOpp
X-Gm-Gg: ASbGnctZ/xzhBTv/tzDLvytR896i2UMYnPID7ulqWMJkUGH5vb7rpRlWGkjz2I0htnD
	XY6Qiuq8T6LhAC5/jwfYig0If2iTk8KaW4cfYAfipM/4AkI/Bq4VRy0/e0hm6SOMFE4PBNcaE/a
	CtowCARxckE/QXiM2persGXtDo3M+XHK65vx6AAci6dRlrxceYrhzjB9rZ8yHWk5UI23mIxAB2G
	qflJ0lWMlk2HR7IRfCCDUfGuoFWhSJslf3nt8MEQtEf4FmBwCc5NqrunWORZ8Qrp37MN38VfIEf
	VX2y5nnxXx+6BxyCt1caT0qfLjotUA/R06icSMNx9EeCT2T8ZSPGCFXKhqZcTnPLPrCu0e58uJp
	jFasvQwgBi1Pr9eCOArbUK/FNcg5jCeeICG2WqZC1dxVYg8KZyH5LOBxoNV00ixpPa4LTRRcNAW
	kLotoeiF7GXQ28X1Ef
X-Google-Smtp-Source: AGHT+IFxIDHbMDQtJnDd1j29er8I9W16ktyYHaqy/e9kdgu1LMq6asMSVrMWec36NOc6lpyOhk0v6w==
X-Received: by 2002:a17:903:3d0b:b0:295:9e4e:4090 with SMTP id d9443c01a7336-2984edde5demr21733055ad.52.1762931650013;
        Tue, 11 Nov 2025 23:14:10 -0800 (PST)
Received: from [9.109.246.38] ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dca027esm19947645ad.70.2025.11.11.23.14.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 23:14:09 -0800 (PST)
Message-ID: <c91c87ab-dd85-4c42-9af4-a25ea2540de3@gmail.com>
Date: Wed, 12 Nov 2025 12:43:05 +0530
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] xfs: fallback to buffered I/O for direct I/O when
 stable writes are required
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20251029071537.1127397-1-hch@lst.de>
 <20251029071537.1127397-5-hch@lst.de>
 <7f7163d79dc89ae8c8d1157ce969b369acbcfb5d.camel@gmail.com>
 <20251110135932.GA11277@lst.de>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251110135932.GA11277@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/10/25 19:29, Christoph Hellwig wrote:
> On Mon, Nov 10, 2025 at 07:08:05PM +0530, Nirjhar Roy (IBM) wrote:
>> Minor: Let us say that an user opens a file in O_DIRECT in an atomic
>> write enabled device(requiring stable writes), we get this warning
>> once. Now the same/different user/application opens another file
>> with O_DIRECT in the same atomic write enabled device and expects
>> atomic write to be enabled - but it will not be enabled (since the
>> kernel has falled back to the uncached buffered write path)
>> without any warning message. Won't that be a bit confusing for the
>> user (of course unless the user is totally aware of the kernel's exact
>> behavior)?
> The kernel with this patch should reject IOCB_ATOMIC writes because
> the FMODE_CAN_ATOMIC_WRITE is not set when we need to fallback.
Okay, makes sense.
>
> But anyway, based on the feedback in this thread I plan to revisit the
> approach so that the I/O issuer can declare I/O stable (initially just
> for buffered I/O, but things like nvmet and nfsd might be able to
> guarantee that for direct I/O as well), and then bounce buffer in lower
> layers.  This should then also support parallel writes, async I/O and
> atomic writes.

Okay.

--NR

>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

