Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E693207
	for <linux-raid@vger.kernel.org>; Mon,  2 Feb 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770041046; cv=none; b=Galx6smuetMnNGq87IuMz+4jyHl2MMdQnstRmabNdvuhzTIeGIlnIvACwUoUxL31Sk1xUZdfjnEDxdqUAf41KmqQqXa1rGcwFDzbQ/OUJk4BXIuKxqWhO5/ZVFtBRHmp78N5xtQKVN5qHl9SOHRuhOTwwPG5twYoIy5PHZjn5P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770041046; c=relaxed/simple;
	bh=UdTEU6rGmQGkueTBJiIUb3q5EpBCW9cJmVJIfS+ZJKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AT2qNNvyLvmieKdFTMedeV5t9G9MSRuuLQGPuDRauoyQJ+Bhdw2zDRTbS46WuczxYX0Nfwq1vqKTu0YxRZwBcrvRFTqDMOocSNMWx0FS3q9rMsYksR6u33EWTGJVYvdnm7Prh3YzPkZ5fPOL7+hX1dn/jS3K7geUH08uAnDdmPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FfL1FC43; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FfL1FC43"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d18d9503eeso3353413a34.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Feb 2026 06:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1770041043; x=1770645843; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AdaCXIGmM5WY83Bb/BglAowZg6aPFVt0zQ+PsAhRpHM=;
        b=FfL1FC436eWBZ9+W8InhoWo0fgRNXz53F3BrI0JvNBmQdjfwkvHGOEPk/eVA6IktOs
         WQwkiDAmRjYziWKjM9Bq7xAwxrwjegX5i+3EOSaZjpi+Ug9CekloXaQTxI9Ke1pxiKG9
         zamR9ppjvame4Hj/xYU5ueCIQmq7Ji20fwe59NsNCyxAnVmC6pcisJl5KqHuHZW96WXh
         IcIynC50zTG7bEpCcYrQvTC2IHSWtBlHSlb6itTeeXyuKD5hqbX1Mw8JjZXTmo3d6/Jj
         17xo4AfgKttuXUB5va646d0y0wnAUWuUp+tZYVh/D1xDXUc6CE1RaNq0kBbtcvpq5JAq
         /+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770041043; x=1770645843;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AdaCXIGmM5WY83Bb/BglAowZg6aPFVt0zQ+PsAhRpHM=;
        b=UfAPdIEOscGIiauZ9ru8/SMCPGQx011mlupIiIXsv0wVA7lT3QRq+vmqfz+poEiIgX
         phmecj2+Kpb/yyoyRNW/zaKUA9I28++tn0MrTLC3tbAkUHZfWSuWv67EKaOkg94OwABR
         //M5f1qdPAb+TEYUx7+bxMniAvSHtujCTg+I1g8Qvis1lsGiCPQLHd6Pogs6j2dbE3an
         sUKFqFhvkY5sIC+wYi9F1Z44aZfeUuBu7uPHw57fi72mF1JFySHrCcwF5yzSZgdePWOD
         KqcFhtSYVbh6qwEffWc6L8GjnO1d2K8hfajtPNz7mwPCG8BP096QAbjzKLSuXA5EBScp
         Y52w==
X-Forwarded-Encrypted: i=1; AJvYcCUAAyB10RWkmZnPOeRvRzTHLGq7EOuIoXF26TpWAG/vMl8+ToBYu4DX5/u52t6hEkXqXmR+Rtp8JeA3@vger.kernel.org
X-Gm-Message-State: AOJu0YyiqKvVwY+pxcs7KMFHlEhzJh8sMUTwJj7nmhiVHFZj29zm4MF0
	1OVbt0W77gGQpBgPDiME8kC/6agJ5bwowCatACI2/PUhreaoSPFaYm+l6J3+9m/vtOc=
X-Gm-Gg: AZuq6aK3XD1iCgdFgYKqo46JDTXB1tT5HdE4ZIL04KG0Y/UBZkG/3XzUbDu0Ex9a1ko
	4bVXw25KedLxGDWg9MzIpeA7XKpDzbKsUxA2qBToM9f970RyJmBhdtWk9UnfzQnGlzPgEubxL/M
	jGuzPzNf3R3CluaWzmwLyrb4vrN2qhoEURZMqKqa3umH59K60XNPNomUUnJgGv5OgsxWPIbAE3/
	b+B2htFy0oh3oU+a6w1SydBXz0UAo+vQaYJKzwYNgPgnAIi/pGpOduG1pkOGSfY1ZbuVWhxU9dX
	2XMNMsJGq/Vi50p8nT/T+GPh5dPKflgITNrSl5qEVOrzTCF5XHBxn7qJQJIMoTYY4Ez8Chl4on1
	Zv5yKVY5nTPO4lOpNYzlkwldm7cQqomLkiFojsROxBnf7rUaZA0wDCb7odxTEqx4b5j8N4e8j9x
	t32JEazf/a5mbJA9Mkt1E8EwYdndMV1PNf2hCA60KtqRAhaJAlJyGxYWtEWfQIimlogH7T0A==
X-Received: by 2002:a05:6830:82da:b0:7cf:d9bb:63a1 with SMTP id 46e09a7af769-7d1a5299159mr7309387a34.16.1770041043430;
        Mon, 02 Feb 2026 06:04:03 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d18c7cf8d1sm10910727a34.18.2026.02.02.06.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 06:04:02 -0800 (PST)
Message-ID: <024b12ad-b4f7-41a2-a914-fde49aba4c86@kernel.dk>
Date: Mon, 2 Feb 2026 07:04:01 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.0-20260202
To: Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org, Li Nan <linan122@huawei.com>,
 Xiao Ni <xni@redhat.com>, Zilin Guan <zilin@seu.edu.cn>
References: <20260202124236.4065531-1-yukuai@fnnas.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260202124236.4065531-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/26 5:42 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your for-7.0/block
> branch.
> 
> This pull request contains:
> 
> Bug Fixes:
> - Fix return value of mddev_trylock (Xiao Ni)
> - Fix memory leak in raid1_run() (Zilin Guan)
> 
> Maintainers:
> - Add Li Nan as mdraid reviewer (Li Nan)

Pulled, thanks.

-- 
Jens Axboe

