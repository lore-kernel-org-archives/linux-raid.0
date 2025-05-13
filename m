Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBDF13D2B2
	for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747142143; cv=none; b=TnWwQYgdPN3M+xx/uJsWlUcxCTQctfy5/Taz5zEcxNAQB8/4NYlfO2Ba0SktRCrBkqkqHrOTA4+uoVzXf5MyZ1rNOLGVThMvxfpx36Kx/jx94X51DkdDC9/5Z9bljFJ4s81Uvd8SvQpsTSAv6SQsmNRbBugiNyJhqevXA0jvVQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747142143; c=relaxed/simple;
	bh=GdGzHbBnm4fJivL2h1eXjQdLVdWOarnmhwGb/Lyw6AU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rtIPpgM13WKgGYeMaRg7KyQtjMqOVufpEqCq4mvjQsVzHAWFqsFPSi4Pc60MKGocYSGSk3Bahtvp0ExRpqGXETXtS0hTaEFmDhC3EUIXdRzzdE+CSEwuqiyUUZN2pRrbq6RH6tf5Camp0v/KAFzTKTTB/9Wb0q6c9ImsISpG5SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AeG/sppl; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AeG/sppl"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3d8e9f26b96so52858555ab.1
        for <linux-raid@vger.kernel.org>; Tue, 13 May 2025 06:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747142138; x=1747746938; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rU8IOVHr5gw4k85+GYmpVPu2nkHluUZqwJqAK5i2vFs=;
        b=AeG/sppl9iPsTSRkle9eH9wxCgyReJvqH+nPpTW6QiZcbhj7sRyLKDPHqubmBNKMFh
         emoJXgf4d5pMXDs+b9fJUbi64WMK5tUHU31kNp1q/cgFOXyu6a8i4vTEYpGSHzFa8Xez
         UOgq50ypaEuKzBnJwjbMtd9M/9hauz6jo3/vq33JDyleavedp0OjsHzeeOyIDOG/inyP
         wPEw9oVt3eJjENkrMbi888uL0J5IyNhkr7KweoFBYXGOh7aFrr59PniEsso38AQO90w7
         7YHoXofxVZpC6KxvhCdzzdd+HUspJrCm6mDHbTDGwkEHtXKEagjs1hCr1K/uQYbvj4ZQ
         MaDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747142138; x=1747746938;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rU8IOVHr5gw4k85+GYmpVPu2nkHluUZqwJqAK5i2vFs=;
        b=NTqdxraXSTdjMcddzoRn4eXQHGMGv2uEhfUpX8Kk6LEA7ukEswBj2fkJSeJM22zRAj
         IUkXhzn4Pq6FV25iJ10/tf1nX90g/YFkFw+VgK0yyzvNkdV+ui87JHBjtedPkOtpgE+b
         KHR3NXOdNd00ItvafRDz7ozeVZ1ybZjK4fhSYNVsIYwo0yOsIeBqXJz4dRr6w9vxx0x+
         nKiurBBQm0b6xkk66E0BKcfNqtQ/UJNPuVsnKZnqlEmJnbfCb0kaj0s2Inl8CAid+ft8
         CoMg8pt5CDJN64bsEpKTsoU7bGKgnry5Bj55zOj34pANhYtsxDEHZ84R6l3XsdqoNm80
         nTrw==
X-Forwarded-Encrypted: i=1; AJvYcCUzneoA6jNWqherElmLpkgQ0tp4Bg6ssNfJsG4FfzjQqX038I4VlcsCPMjwtwex0D7VOunjUpDrDkXw@vger.kernel.org
X-Gm-Message-State: AOJu0YzeiSCclrY56nqRn5jskB9C5AGyo2s1j7GF4UkxOo8pwQ6ROq33
	SCmaFnnhPTIeNaWd3y0kLNH4JLVMtXyIcKtadffQ0ZMa1ejCXAq5YAJtUKLbtSQ=
X-Gm-Gg: ASbGncuFDxX0/Un3gqOLFhdVC+eTcU6zRl1WnsGoLo2k+AHh4nZqXAbZZijk/X3P4T0
	T2oCuoprRyezMe8hq0dWZqYQRq5uTxVXvHoRigGaEMfrjW+6JqSa9KZLckUDeLcphU7pisR8dRS
	b4bLAqomymq80fZzECRRMyonXIN3ZLQLJnutM8Y7S+0iiP+6JUleWZx0ky+FPGdOSL6rB0D8f/C
	0AeH84NDOQ1Gc5xoxdJmvWJPiz7cHjBOurMNmqru72im34OGBZ4soQC7TUbzIeZhrfm5SUZE/MP
	6P27e9Gk050YI2HMVjswDDOHwynISuwc42dZrekZHpkpHXw=
X-Google-Smtp-Source: AGHT+IHuP+kVNUoHY5pvyEYHd2NOp4x4O1C77rXnvhLY2w4b+Qp/HLzXmHky3g3ehT2ZXdH6gliS0Q==
X-Received: by 2002:a05:6e02:1809:b0:3d8:19e8:e738 with SMTP id e9e14a558f8ab-3da7e20cfd3mr168097085ab.17.1747142138414;
        Tue, 13 May 2025 06:15:38 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3db6b419a83sm1797555ab.63.2025.05.13.06.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 06:15:37 -0700 (PDT)
Message-ID: <413a1328-5d02-42e3-88c9-4d385a74aa63@kernel.dk>
Date: Tue, 13 May 2025 07:15:36 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL v2] md-6.16-20250513
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250513023136.3180079-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250513023136.3180079-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/25 8:31 PM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling following changes for md-6.16 on your for-6.16/block
> branch, this pull request contains:
> 
> - fix normal IO can be starved by sync IO, found by mkfs on newly created
> large raid5, with some clean up patches for bdev inflight counters;

Now pulled, thanks.

-- 
Jens Axboe

