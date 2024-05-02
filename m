Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE15457CA1
	for <linux-raid@vger.kernel.org>; Thu,  2 May 2024 22:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714688656; cv=none; b=sJnRHPm6ajocjQfNVuJbkwv9JI7Zf9flz4YQXXeTtP7rgRhhTe8WaL+6AHWcqSOFvyDgRIHCUrWmPtvyCBiO6n/tmvJWUFSS7V/YLFBicL/upvqhKpT0c6eWH0viQX/e1BW/AufLX9sAvbpjYZoiOMkeYAq/VlKN4JQUn0dp6ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714688656; c=relaxed/simple;
	bh=szYtzJ3rNXnsaiBxRMsBFz3r74vFg7p+1KwTIcTMUWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I69E+zOUDJvtrrtpwFhbdg95Y0p/AJoKVYvTh0eAyRXjnHv56NsSiXDeeQ6yojMjOK3r5I0en8rKnEh+7ZqElqtxFpzBSDlsIaNj+hzANXavya/M2b2L1/57Xw6R78AnfjBXKWlg79h7O6V2zyyGCEm8HtE2L9vUGSwhVNHoDBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W3tGtXOf; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W3tGtXOf"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7decb824727so36183639f.0
        for <linux-raid@vger.kernel.org>; Thu, 02 May 2024 15:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714688653; x=1715293453; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7wunnbhuuOJdpVsp3oQ3FuvRO0DhvVhgNrGOg13ZI84=;
        b=W3tGtXOfDgAwcpxX8dViHkJHxKWtUwKuf9mZ1qgAcJ9M7wzpBAElfPYAeK6hteNM5S
         nQJb6hfmpunpamTXu/iMfgwsHCay6ice6PP7QRzU1tEN2PF6Akkpe4RbV35K/mrSPI44
         INp7VM7Aj/1SSdxb3Yf3Vd0ZGeA/BcO7hfdadb6f/wdjkYpkNe1eQVhXO5uxuIQOXpKu
         vcIKAgxu2tHg7xuwtvniHSa8SwRaD51GidU9HMQjZn75/NggLAe8yctjsT9AlG+D5JRM
         tLVcg0gOZFqNsL0vLF3A8biW6+pAsWMjR1DxV+aSaMAGv0LoORudOxk1HiPkiJfKCKte
         RwRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714688653; x=1715293453;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7wunnbhuuOJdpVsp3oQ3FuvRO0DhvVhgNrGOg13ZI84=;
        b=gZbX/kAgtV+YelKSrAowfT1JefCinF49RQJZO4CDfS/EDKClKpP89L6fn6AnRHdMUP
         TX9GO9F9NgWSa8/1Wg/0xsSXNF1yVqj8hSIfOOwbuymqud2SZmFBdPbWcNPIFn26HUNp
         uADV7Lo2wQU1rBZESDs9JTmIjxVSV+8WJcjaDrvqkIi/o8iC5L0XycpIDh9SVp8TnB+w
         Ep8Kooc9EG+/rqditQAq3Dr5kf8wi58xJEQg1wDb0Cr80aaK5pqtZ3rsIpdeqCiUl3OA
         +aFB6yC1ElfpKpFjUZWkHn8yP5OJQvPUgGdyG193NAIdeuGiTUdlMOHdmOIw1Aklb2aE
         rTmw==
X-Forwarded-Encrypted: i=1; AJvYcCV/2jROjJCE34PpXK+nlMh0lkxWaF8xxl6YpYWNsKg+zeFsmzEuJtP+GhyZ8XgaVfeBbB8wQzJgU3rfPRCMPvhcBLEudfeCFE04Gw==
X-Gm-Message-State: AOJu0YzjBRvhTed+aY/3ECENH9/wtr5oFqChnnP8RTiau15jw4hUfZv1
	ivWLqhucQczN3WBSE0d1YBN8SLFy4ygghOVCsquRB/5Hh8/l368VvsOMsO4mi/g=
X-Google-Smtp-Source: AGHT+IF6VgE2xpH0iFXK1S21qCep5006f0hyaCOLFTCPDlk/mSZkJXRyYUwWL2ayPODe2801sjXBKg==
X-Received: by 2002:a05:6e02:1b0a:b0:369:f53b:6c2 with SMTP id i10-20020a056e021b0a00b00369f53b06c2mr1344288ilv.1.1714688652933;
        Thu, 02 May 2024 15:24:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id bq18-20020a056a02045200b0061c16070b32sm379396pgb.90.2024.05.02.15.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 15:24:12 -0700 (PDT)
Message-ID: <3f1523d4-941b-4e6c-863f-dd1dd49fcd1e@kernel.dk>
Date: Thu, 2 May 2024 16:24:10 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.10 20240502
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Nigel Croxon <ncroxon@redhat.com>, Song Liu <song@kernel.org>
References: <B0747FE1-2648-42B0-AFDC-017BACB64588@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <B0747FE1-2648-42B0-AFDC-017BACB64588@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/2/24 4:01 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-6.10 on top of your
> for-6.10/block branch. This fixes an issue observed with dm-raid. 

Thanks, pulled. Anything on the 64-bit craziness from last time? Just
want to make sure it isn't forgotten. Would be nice to have in for 6.10
so we don't end up with it in a release.

-- 
Jens Axboe

