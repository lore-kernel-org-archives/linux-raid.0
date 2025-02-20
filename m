Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA651C6F70
	for <linux-raid@vger.kernel.org>; Thu, 20 Feb 2025 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740063154; cv=none; b=mwt55LU4vp9GVm8hVJ0VH4kbqHUBLKoApStSgIbSERk9PM4ns9Crt9VGMzJqWlp80jO8kqPcqtwtNHbj6qBqORHjAWphfPeBazFSqGTXsQHW0iaC1/TBEVpkXsgWEg0dktc1VYFfSJLKjYbcMOEieKFrY6JYVbAX337gqPjLAl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740063154; c=relaxed/simple;
	bh=Ek+ntk2lutM6juPRlRMGsl3v7u8Z9GAsn37D9WBCY/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=npJL63ZNgwrjr+8laOjotha0/+cmNf81wDYS8ZfO1S2dD7iJAG5+GpLzOXphaV4LeX9ZikxrWHmEusA4w+nRCSCTdUfc5N0qdyffmOwKCqSj4afGRN6JIsmiPzBjIpCM5mmUuHDZ9rmLXimoWFl9bQxITcOY/QPrUx2JLRULjbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=lDawCSP/; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="lDawCSP/"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d193fc345aso3535225ab.2
        for <linux-raid@vger.kernel.org>; Thu, 20 Feb 2025 06:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740063152; x=1740667952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VFRC818MXDiOzHSrN3kJzYu/q9Bt4AZI5m8rgQlTzQ0=;
        b=lDawCSP/swrRONCAXc1GVCQQI8sPxtec3hEjEHhS1Bja1MJk3lSvOVJMpUu8mvdfwb
         wLvqCT+enls3ueaCngt1iSshmfFhE5fDwd70yYYE2mL+h7CaCdMCzPKkKtl4WG1vxzAl
         Siv5oBwMHpjbe0MZZEpsEiE9JLcHPXkKtzbufFNt+p/K81IVSGDec2fXwyTj526pr530
         yYxpFXFBU+Dktz9jen6WyhngdfkO8tx5heq6odXFOSDtlMzkp8g4u78sUXLvvF6n8yew
         mzDF0uI2FqJ6Sfe9gOgZWdcUG5ibmD/4mDrL6ExgNbksxdZh1fm9qhYq/AD1uh669Vsx
         EhNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740063152; x=1740667952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFRC818MXDiOzHSrN3kJzYu/q9Bt4AZI5m8rgQlTzQ0=;
        b=sZkbKchGGTpgpW0cWvFTwdAghNDmx3d4cOIh+NZtzBA7yhTz/EhG+lTSwNLrXh6Ewq
         GI4e38ddbUzXr90QDp1DPyMIvqwk/5cAlRIt3aVXRcGiRLhUp0jKhMGAKufw+lgKEStE
         u9t3oBic8ACfp0zLk/n4pPQNI6xFnQqB/Xuc0e9pRMnP3z2jEKQb49IB9zoJlePkk86t
         rsq6tiBSqGWE08u1y+LYlI8GN5w8svjnYJTG71TsC6L3yQk9gqi0XeIQCJVUJGSWK9Mr
         XHKo360/E0a+Mv2/NrxWmGhopglvqkQShiz73OX931+3HiMMKMKxh/aUA/Mg1og6+1dR
         0ilw==
X-Forwarded-Encrypted: i=1; AJvYcCWtqNy4iDJzGHGgeboQvV+VshHTrsrhqXObQ4eckToAwdMQ7FRzidxjKfU51ly/O6oXff4cpkHrxVgp@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8m1sxCRsB2uJOhzBIOcmcAPn/XXPTQ7dOsO7NDTjo2UiF5c7x
	+rap5bog65Ms6FsHAl9/rX1y+yfnaWiTgcpiGx3xmt8i/VIUk0M5PV+YkH0Lq28Lg8D72g8s+rV
	p
X-Gm-Gg: ASbGncsvcS2aYVhcURGzd/ltrvDlLtiDOMHB0Z6M7bYOdZO8Lvq3Xk1rtgRBiicN/kD
	NxFi618lNriYmV2ZJeVqO5Q9MvWd7HP2M8IzR442bR5CgZXzRpmdO7YfIVLqsKW5kiOPrh1poKW
	Xc0btPb1ZsF8jBvmLnbheHDeDFIEqrEAK4iAIcfxb/y0+5kh5dd9KXdMFgHy1bHZbdm+dHelzBR
	BUUW/ic4tj34rxiHQ4J2Dt2b/R1kwiq/PFW9kROOwl5T5Yw2h21ZZ1srSyrB6iW0JCV9rU97cXj
	dhlFuFuVYrNq
X-Google-Smtp-Source: AGHT+IE4xuro4gVboCsOumkRv15PSx6r0hBhZCdTRbhxb8fifr4sg8Co9VvZsSbQN+qC/fkS8z7QuQ==
X-Received: by 2002:a05:6e02:1a46:b0:3d1:9cee:3d11 with SMTP id e9e14a558f8ab-3d2b52a0c3bmr78432235ab.3.1740063151652;
        Thu, 20 Feb 2025 06:52:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee849f9ee7sm2640090173.82.2025.02.20.06.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 06:52:31 -0800 (PST)
Message-ID: <6e98057a-cd83-470a-8764-f87310678aa8@kernel.dk>
Date: Thu, 20 Feb 2025 07:52:30 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.14-20250218
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc: bvanassche@acm.org, song@kernel.org, yukuai3@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250220031941.3274042-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250220031941.3274042-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/19/25 8:19 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following fix on top of your block-6.14
> branch. This patch, by Bart Van Assche, fixes queue limits error
> handling for raid0, raid1 and raid10.

Pulled, thanks.

-- 
Jens Axboe

