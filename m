Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE577262A
	for <linux-raid@vger.kernel.org>; Sun, 30 Nov 2025 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764509612; cv=none; b=l8bsi/4yrwHdkDJaSfy4RBh/I+diNVu3LvJHGOjB6We/VlzM55owxEVwLNpOZrs2ok+IKMzDYvWx9tzT3+PaoCCOJtPIydIEzsXK1CXGcWmbP9veqb9WT2jC4rVezi/oH/+D39+XYPmOe2YZ6KdtLlTYqEkNDSsrtYkaUVTG6OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764509612; c=relaxed/simple;
	bh=Zkt4szfcjXQpdS0Kyi9aT8siaek87I1lRU8rr+TdT7Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHqliqG9/f41jimJ8E2IfIe3MwIiLihPnBJYnslmY9a3/yRY8XJqm4OOyRNDIHyotIeCXzFD1XLCIUb4Ci7AwopaI2VqY65vJP3MOG7evHeZS76RkZAoW9v/LqxPUE+W1vy/GJm8whFKdpRwdEQKN+1WUzc9om+Fi2QRvD8Wyz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rTjWR71X; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rTjWR71X"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-949022f1c85so135258239f.0
        for <linux-raid@vger.kernel.org>; Sun, 30 Nov 2025 05:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1764509609; x=1765114409; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GTU1/x7Dfi7RpaKWDbcpvMWRGnF9c2LffZ90taw7x9M=;
        b=rTjWR71XR2p8j1JgZ8rZXPp6q/ZpiqkhHLaZNEsqsURLaEnTwYrbdQ42R7CbjSB469
         es2UPupOdf4DL4nW8GZfN3R1qZxUYRSxpotgY+M5r/jA+DTj1X8jfHQRost4bWnTV6Cj
         60rp6g1in2N+sepK6hig54IpcGOSM/i5XG/2EpQWbnfWTnzatj7iKNfTKHHEEWiefnrt
         LU4mBVeO9s7zuToHQFzTsx8yM31j+6DcoHERSveo+8TyddK9aYmSyZZzfrdqphVE1JPI
         T38ydBzNK8WMWtm8B3dHPFzUF6HMLulQpU06Tw35uuiLTmPOXvhfKWEtSbBtcNtAt64d
         ctfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764509609; x=1765114409;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GTU1/x7Dfi7RpaKWDbcpvMWRGnF9c2LffZ90taw7x9M=;
        b=XOUPe/afTOeiQBiS+IyYfhcTX5krAHG2OymHcQGE96LyJ9UHy7fyAhAWqRjD7S1Zo1
         wciSfh7JJ6KoLdrYUuucvxnFWgkdDeyP9zhedXS/DvjngNGJj0TtITQ7zwoeRBaJahYt
         Bi8Lo5wj05TRwmAxE73vbo/BIU+QdcH8qtjK/QgcU/61Q6VncagWNdLmYrdX8aJWH8QJ
         t4BzGSwX7hpnRYRggSdZ0222jDTniKGPvhkNY+Q+nZeGmeXvnfnPwmQa1bZMx7v64CIk
         1VcfYXNG8bqWo2WV8eX64XHhTrMeSivL8Nnoko4WkFiFKJtYeUT0IXwr25ksmFY3mXIP
         bHfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVo5Ti79+1h2WXxPU4m0AnrvP5P6H51eBGR6UHc9okgRNSQhlKlmQK+TKhLWj7loaz2VAZ+IA9vaKuu@vger.kernel.org
X-Gm-Message-State: AOJu0YxrFK4lmuJOiKDWEtkjo3eYpihOI5WIjr9y+9GNjmg/mXRZdgwD
	TfN6MdSpzQxk0wyAoKF+m8DJUzoyNGY4XtHZua/j6awSy0TzZhGzNLsuSbRHHkUvj/E=
X-Gm-Gg: ASbGncu3b4WyQSNtwhMgh4OYF1eczVsEPkHblDNtDjTO7JnQvGfjx4k43Ae768u0tyX
	TBZHC11KDGTUPLRk5NQ+h5VzhKWFHA4GgCDNaeCRRPRrL8SqiFeMp0rFiNzYtrYhOj39nKFK1qN
	aUsa2MyBWv1lknVBtCg8LJV78pIw0rpGjtoS4CtCTZoe3Nal1f2oJWcG3k/pkgSJhUOI/G/XmHg
	L83OOlp747jr336H89hoz7DsASHTlgXsHDlXYKjj7Jv23Pb4QCWYwy2NdUdH5HcsY/x3mYfSfSa
	ZWc0yw5wdNgeA/cm2I20S9WistHSMWyGXcQSHty0IF4AgezMgrlG+cgvst7celSChuzBpeJJ5Mg
	rcpc/9GJFhNR0ZVXpH8/MxdAuFjbpuqYJLN9QgPyaqUVMvsX/tjkrKS9NHQq1NpowRoESmiwhtH
	HUy4hyxdbr
X-Google-Smtp-Source: AGHT+IEvv02cH7Vlkoj6zC4v3f5s15CRrLwA+XHiOAO3o4Gb+7fiYXTJRfgjgxvm7W1M5ld7511cSQ==
X-Received: by 2002:a05:6638:8106:b0:5b7:c66b:a3f0 with SMTP id 8926c6da1cb9f-5b99976c8f1mr14535060173.18.1764509609421;
        Sun, 30 Nov 2025 05:33:29 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b9bc30f928sm4723806173.6.2025.11.30.05.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Nov 2025 05:33:28 -0800 (PST)
Message-ID: <13fdf4c3-5a3c-438e-b607-294c8ea032cf@kernel.dk>
Date: Sun, 30 Nov 2025 06:33:26 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.19-20251130
To: Yu Kuai <yukuai@fnnas.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: tarunsahu@google.com
References: <20251130030653.2302439-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251130030653.2302439-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/29/25 8:06 PM, Yu Kuai wrote:
> Hi, Jens
> 
> Please consider pulling following changes on your for-6.19/block branch,
> this pull request contain:
> 
> - fix null-ptr-dereference regression for dm-raid0 (Yu Kuai)
> - fix IO hang for raid5 when array is broken with IO inflight (Yu Kuai)
> - remove legacy 1s delay to speed up system shutdown (Tarun Sahu)

Pulled, thanks.

-- 
Jens Axboe

