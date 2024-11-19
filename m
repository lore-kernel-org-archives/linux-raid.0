Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55AA1D3564
	for <linux-raid@vger.kernel.org>; Tue, 19 Nov 2024 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732037423; cv=none; b=opAO3Fj1yO64+W6FMkeFz40x66tP8W5OLkdAYxARt3dguOAP+esas0oZ7dks9ugJEGqopIeLEKxMahQ5oW1n5yUoiuASgUB7Elzh79og4TGffLvW/ICeRq9MEDZXo/kQyVWbh67SEtE4xa+hsxzYZOOLjinA++n9u65AdcLjURw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732037423; c=relaxed/simple;
	bh=8HJq7NwqhChQyegz0sCYyZp2xmSM4MBTlZm9RLzRPyU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fmKjzzcYe+MZP+NzCcpuWqZ0rL/P5TlTmFkFU2Myfo6ei+kZSHto9tLqBJAJyzrooEvnxHeifrBtw3vXugzawLSNUttZRnNkyIL4ZgUAb9jvZU0zVTXv1Wq/K7FS6VXTAMHfHfAsbnP+SqBKTLZIvPiC9fjiCKpeji1G9THpqms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N/9WhMeT; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N/9WhMeT"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-29678315c06so1334500fac.1
        for <linux-raid@vger.kernel.org>; Tue, 19 Nov 2024 09:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732037421; x=1732642221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1XwymtzFptex07g8t0oBCz32E5vUvl6qwiNVcfZVz0=;
        b=N/9WhMeTRClo2fTmgekXYxNkWdfKnHFfwVPTHgUAgczJGyic6O91eqawBeAkWCBHK3
         fOlPdZ9diN6Xn/7CQ+OkNwDP1W0NxZEjvWEBh1aM8EYgUHUrE/bxDQ5Y6g1Ex2j1s7nY
         ClveatV3IV0MVNxLITh7rl5W5Z4T3rvZNEOJSK/cpxpKTtbAsUHjX8Y7VTvIO0lv5gz1
         VY+cDzwwTvG9t0g1dehqyh/RnCtO3UjgWqrr+vjMR3HtA6QSW1msZZS0NJvNcIagIA+t
         gkdYWRFbDgoyRodzjJ9NxX+izwrdvHLEh3TTeIR1btW18+QOxWIFNzvMuxDYqffGxOZh
         p2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732037421; x=1732642221;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1XwymtzFptex07g8t0oBCz32E5vUvl6qwiNVcfZVz0=;
        b=O7MpzHCTCiT6/IH4/akievH/dwY2pYD6vCIOt4EGFWlOTjSoraEk/orNUxumxViHjJ
         Wg5/rS5Z/9anYl1EwQH+OIxK3NoIzg6f589o3PlNe07PGuAibqjSLBx/YYkVUuMIC1mm
         pg0g6781UK+Zeg8hZYHuMOodBkvBspKCbWTXiQLxizT3UAVDoyyBD4rB/qcPwPconO2o
         HPxUC84THEDYPI2DE9SmRO1wzjqStSOlFXz6twE9wK/oJVlxJyjXNAYU60qOu1VbRDPF
         mJGbiZVF86cP7eCbe6pnyJFd588IGHfzEIeHbHT4Rj6kRfXPAkDm19DCWSzo3UahYV0B
         kyfA==
X-Forwarded-Encrypted: i=1; AJvYcCUKBVsfTagdvx2UG+tZAYqugumNIJwbkmXstcTRYdrCPADoeOE3ZUeWjd44ivSRfCsVYb9ijOhVt30Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs+lzbbxyiHKShbL9TnwvDdQGwGSrHEAxJNoBTCIWAOdcq5YNL
	kMIK2Gde3dKkdKeCDjgqlVxzGamcWwg15r8mFMtpcmHMCrmgkChlRBGWsHtMWdo=
X-Google-Smtp-Source: AGHT+IFbst9trImFfYVW3CX067lMGhsuhKjR8MGYTNOoJM+ovbJqMJ/SvIsnK0nojAHbjy2eogmP3g==
X-Received: by 2002:a05:6871:3a0a:b0:27b:5abb:7def with SMTP id 586e51a60fabf-2962ddd314emr15082932fac.20.1732037415966;
        Tue, 19 Nov 2024 09:30:15 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-296518bb670sm3595531fac.12.2024.11.19.09.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 09:30:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: song@kernel.org, yukuai3@huawei.com, hch@lst.de, 
 John Garry <john.g.garry@oracle.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, martin.petersen@oracle.com
In-Reply-To: <20241118105018.1870052-1-john.g.garry@oracle.com>
References: <20241118105018.1870052-1-john.g.garry@oracle.com>
Subject: Re: [PATCH v5 0/5] RAID 0/1/10 atomic write support
Message-Id: <173203741480.120673.1977109756276902670.b4-ty@kernel.dk>
Date: Tue, 19 Nov 2024 10:30:14 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-86319


On Mon, 18 Nov 2024 10:50:13 +0000, John Garry wrote:
> This series introduces atomic write support for software RAID 0/1/10.
> 
> The main changes are to ensure that we can calculate the stacked device
> request_queue limits appropriately for atomic writes. Fundamentally, if
> some bottom does not support atomic writes, then atomic writes are not
> supported for the top device. Furthermore, the atomic writes limits are
> the lowest common supported limits from all bottom devices.
> 
> [...]

Applied, thanks!

[1/5] block: Add extra checks in blk_validate_atomic_write_limits()
      commit: d00eea91deaf363f83599532cb49fa528ab8e00e
[2/5] block: Support atomic writes limits for stacked devices
      commit: d7f36dc446e894e0f57b5f05c5628f03c5f9e2d2
[3/5] md/raid0: Atomic write support
      commit: fa6fec82811bc6ebd3c4337ae4dae36c802c0fc1
[4/5] md/raid1: Atomic write support
      commit: f2a38abf5f1c5aeb3be8e9f4d3d815c867fff7ca
[5/5] md/raid10: Atomic write support
      commit: a1d9b4fd42d93f46c11e7e9d919a55a3f6ca6126

Best regards,
-- 
Jens Axboe



