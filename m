Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B931741D3
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720799094; cv=none; b=V3qgoUHh+Tc4jpgCGPYPCCawyo+F+V7znuim6KrD8da8Idk3Z5wxlHneUvc8NOQwshJAS00YOIo10TIayXkNIIfVJLCa4AxzYd70gC0BGWEYjyTd93mZmflEcfWobzDzBxfPJNrnGNy1OwR/Nl+6osZFz9mpQ2lU+n6DQkfOakI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720799094; c=relaxed/simple;
	bh=n91NWVti1LdrBW+m11RV7TA/os/mDOM6nD80VOUVyF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7GXHkFTHOLKUOQjEsrtKos5ii7fBCWQX04msMb3HAMn+01XiWa2h814Lwc61mYC/Okcq+MjDQAAmsK2M4DpLNM+7+TVXnAws7FYc6L2oLt0x5w+HBfItFQsUqV/kqz4vaJTQH2PmP/3BNTCpCBoNPky5fYLM8+us9fJ2xpWpH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iitL4PBj; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iitL4PBj"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a754752c0efso23362166b.1
        for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 08:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720799090; x=1721403890; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3Adj9zh/q5MnGs+oaUHgbWACFjj6gAehSRwF0uGGYL8=;
        b=iitL4PBje9Azom0ciKLQ6I84H+W4RqzWkNIhrrwVP7aWECgl/r/2BGfABMF19M2TYs
         sACT8sZuVhicdhGuoAcOYqej9AXfyMFFGc+/wHL9f5ABWrrF48X/ZHv4FqiJbUrHS3Rk
         2eMzjBM/p9/AP+RYCPEZrTzQv+kSomkIwYwiiV22WSjdu2jBQ8A/kvzTfjz15NlZ8BBP
         WtLVDWQLEoNx3Kc+evPfdGXQ1v3VQx9fIU5q9SChe3eLPy5Cuoq7SBZvx5Z1JJHiQhcR
         ZAtMd0SOFrSCMC/MhFExhQ+7RZ+AC+VswzJ8dzFat7H2renp8uAM94DslKF13YE/dMl/
         jFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720799090; x=1721403890;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3Adj9zh/q5MnGs+oaUHgbWACFjj6gAehSRwF0uGGYL8=;
        b=JTr4PlFVY6ZBgG9hBybS++XGOouBIycUQ83Ap5rI8kDFJyZAP8KTAqaM/ajC6QpcbE
         fB9Tor0mvoMd5RNVrO4FpiZvlPb6RXJrBlLw5CdK92g2WYGZICkz6zXE6f5N6F4k86Yp
         DQqy9b0xYPVknV2IiRezt2e62uZOikk/cGhf4a4cDmvRu0toeIUp8VbQmEg9R2CndrSh
         ZwW07eLicKwehBGb7ZfmFreSKIuftqzw+OCOiJR7fyFDq6Hg01NEFAakXBa9Bpr2aiHq
         kE9TDd5SNW6hYeMRcB1oYvEjTNu7dqqYGz2TDUrVWYYPQXJ1XekEtPCXE6geOFthtmca
         lAVA==
X-Forwarded-Encrypted: i=1; AJvYcCWKYu5jzlKg9Y/PtYbURtPB+9Hedq3l3Y3v7uD8/5r4kCL2D2HXdmYyu1qwTVkN0RRvrKOuxxuXcM6TkqtDlnIkdzDGfkNOVnlKkA==
X-Gm-Message-State: AOJu0YwhkSASPYStBcM3nDLCjCF92MKhN9NuR8OcKUiowIc+PwJpnis2
	SMk1iNRJvmxfooC5vqJHdAyy+WWjlMRKqtoJKidlLPA/apkZcjd2Si6CG1mr/kw=
X-Google-Smtp-Source: AGHT+IHiCwgUpyBxGuu9tXYH/K4v+suh1jcbDZfB4bjT1GM7IDG0GtB/cdRpIZ2uMQkGLn8sSyymUQ==
X-Received: by 2002:a17:907:8689:b0:a79:a1b2:1a5d with SMTP id a640c23a62f3a-a79a1b21acdmr137896066b.9.1720799090105;
        Fri, 12 Jul 2024 08:44:50 -0700 (PDT)
Received: from ?IPV6:2a02:aa7:464b:1644:7862:56e0:794e:2? ([2a02:aa7:464b:1644:7862:56e0:794e:2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a855e82sm360020066b.171.2024.07.12.08.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jul 2024 08:44:49 -0700 (PDT)
Message-ID: <a2189c00-4bcf-4ded-9934-867819171a38@kernel.dk>
Date: Fri, 12 Jul 2024 09:44:47 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.11 20240712
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
 Heming Zhao <heming.zhao@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <yukuai3@huawei.com>
References: <7C787382-3238-4D49-92B1-ED09A4A59AD4@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7C787382-3238-4D49-92B1-ED09A4A59AD4@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/12/24 9:41 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.11 on top of your
> for-6.11/block branch. Changes in this set are: 
> 
> 1. md-cluster fixes by Heming Zhao;
> 2. raid1 fix by Mateusz Jończyk.

I'll do this one inside the merge window, I already sent off the
initial pull for 6.11. I've got other bits pending too, so it's
fine, just won't go in with the initial changes.

-- 
Jens Axboe


