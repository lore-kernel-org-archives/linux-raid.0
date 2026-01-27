Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D53626A1B9
	for <linux-raid@vger.kernel.org>; Tue, 27 Jan 2026 04:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486997; cv=none; b=ZJx8X742N5+ZceaaBmEqHj15xGO65OGGzqtAhKaILtqDuA5/Ar5CsNvSszJkY8nLx2Yxl9Us8rN3u8CuJqXDnACEqWdOZ+CAe/knkDumrNH02D98X17O4E+/lQbbRNQ4xEK10CzKp0ScR7g8l+yGfjKSAMh6RDiG3paHer+FtfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486997; c=relaxed/simple;
	bh=BN3CAgnxqnEVrtlsViIXiKiOWir2E20j7eD9eVJlRYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NpRyBnR78+eXUq0TJSVqWwusqPBTdwjARqg3P0y6fD1Q0irCUDscNP/40PeKilUGgFtwDuz2Olj0qTJdEGRa/r36Ms9djaQt4eVPOmBe/yzydqL9n5/xFXVlhKPomxSfhoxLzshTWxBlbsEaV6MFatSo4w+UP7r3/LmFuNQ/5bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oqGmkJbr; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oqGmkJbr"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5032e951106so1909431cf.0
        for <linux-raid@vger.kernel.org>; Mon, 26 Jan 2026 20:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769486994; x=1770091794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7mP68NfFM7IQRhODpoTkfedHKfb4Sf8/+j40FdpDcgU=;
        b=oqGmkJbrnmQ0Tv/qsbV7BYAbczE3kq+nT6ejtsXTgYVmZdH+Di/Ml4nSkJW1+YvC7/
         xD1RoqE6zPIp2o1Etqcu+QF0H9ps5wI0/zmtzcIodfC3GJCUr9GUQWamfDAcaY+HeXIZ
         CFi0ZkD84kusdd6F9Jh4Eq/s7jhOFz2HmuisLMBvXrbCalyqEv+51ZY2Ic31xytgwX1J
         lV7SLTHnKXrXfqT8yZ4RTJNpp7ZRf3P1t0TqnG7C9gnV/P8dB7dmvFYXCYUfUw38T+7t
         1bPyaDMTIiwS4eDtKalnIieJQyNPGSZ+nlnEoT+MLiUV3cdew+GogNqvxZoeqOwFva1y
         9kfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769486994; x=1770091794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7mP68NfFM7IQRhODpoTkfedHKfb4Sf8/+j40FdpDcgU=;
        b=gVMBqH9ONPZMNmHohe8Xv/ie8i1AmJn2VwOGqcS6Ak7zad/UOkYilprNxFT0tY/kAl
         FP8jzbz9RtscaKrpPAK2Rkz3ws2ifMdNAJKIjc9i+a+bchyTWxA5+L7ugXZP6KZtw8Y/
         Uj6zbNj+6FCg63cnBWU+bJ5PHMS3NEzDzz2YHnX6FTeAN6/oksp8zyIlqGGdoOQ1uGpY
         toEGStraVgWC0Tjlwqn9QyijB7Zsz9eQ3/Ai50nuNZwA+2IUkqLEZWY+XgT4YMLVQfQR
         /hzofttnNa4dumOzGmXNIK6gXYToQ5HtUMbnc5xmM84o17KFBuKquF1Fj5WfJ0z8rHsS
         vo4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUdONAHZAu+WpPPenSDUv1oNXF1aShQraoWiwwvUDQZbxkFJ1cTXdfs01M8SBNpB2YgQp6ybAFwd8F8@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh6Sn4V6Wn4iVv9OMg+YbIVu0U++UiZTPJKn89mGg4UUQoV9Lp
	myH671qKF5ZppQWSr7Bte+meTFd4jYMlRSr1oH0csPA78sI1iuPIeYBpMJyOyVv1t8I=
X-Gm-Gg: AZuq6aKgAychCfC+3YgppzHZOMCHUCsUBhRPGXf6pgON67kJGQlc68ZQgVUOsl6Sv9U
	3f/wsneWR5n2FTNNjns3wCqatLGhg/7jZHJTcEePYMH3FrkWBbgCZV0WnGm4UVp8CtN+Ov+Kc+w
	Q6ofLj9o8f7TNbIgwP5Z6sfAjmoxmeQCbA2bEWPht9p9obpbwePTdthVJ4KBELIfpXGo5l9kimA
	35AH3NnLGk2mP3gPwQ8b/sytAxSlgkL3vIKLjpkLHt0vdRJuqhsr6GpbZCc1qeHLRQo9EcAJHxw
	Bd4XlmdusKMtQ0x7gJAiCNCWz7YBmueBfkKe65mStJL/hNiFZTUiArJR8qm/4H+3MjV+ggPPj3+
	hi78OmrlQ/AzK0ZiMWsVB0sD9NiGuNaJTOaNikbwyooFRrsHM42nFfkya1ZSq866P7qXghUMCMR
	VP00+LroPocO6534qhZ8krUouhwatAd4Pz9qLEoqoIGV1/wCF472K6eL6ig2dObxM41kn35Qo=
X-Received: by 2002:a05:622a:38a:b0:502:f07e:8565 with SMTP id d75a77b69052e-5032fa02f2amr4531251cf.41.1769486994326;
        Mon, 26 Jan 2026 20:09:54 -0800 (PST)
Received: from [192.168.201.17] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-502f7f9cd9esm94354071cf.33.2026.01.26.20.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jan 2026 20:09:53 -0800 (PST)
Message-ID: <8a6842a5-864d-4bde-9a9b-1af9368b1a5f@kernel.dk>
Date: Mon, 26 Jan 2026 21:09:51 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.0-20260127
To: Yu Kuai <yukuai@fnnas.com>, linux-block@vger.kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, heinzm@redhat.com,
 jiashengjiangcool@gmail.com, jinpu.wang@ionos.com, linan122@huawei.com
References: <20260126172008.343807-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260126172008.343807-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/26/26 10:20 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your for-7.0/block
> branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - Fix raid5_run() to return error when log_init() fails (Yu Kuai)
> - Fix IO hang with degraded array with llbitmap (Yu Kuai)
> - Fix percpu_ref not resurrected on suspend timeout in llbitmap (Yu Kuai)
> - Fix GPF in write_page caused by resize race (Jack Wang)
> - Fix NULL pointer dereference in process_metadata_update (Jiasheng Jiang)
> - Fix hang when stopping arrays with metadata through dm-raid
>   (Heinz Mauelshagen)
> - Fix any_working flag handling in raid10_sync_request (Li Nan)
> 
> Cleanups & Refactoring:
> - Refactor sync/recovery code path, improve error handling for badblocks,
>   and remove unused recovery_disabled field (Li Nan)
> - Consolidate mddev boolean fields into mddev_flags (Yu Kuai)
> 
> Improvements:
> - Use mempool to allocate stripe_request_ctx and make sure max_sectors is
>   not less than io_opt in raid5 (Yu Kuai)

Pulled, thanks.

-- 
Jens Axboe

