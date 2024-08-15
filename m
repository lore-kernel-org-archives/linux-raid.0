Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A2938DC7
	for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 20:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723755265; cv=none; b=FvhRHC6kcbqrT1cdDZ8mROTE+9a8lwka1rrwGeXmqNJiT9S9slTH4PjxOlqqwByD5d+Lt1vM1M+rktTUdMV/eLRXdQ94J22nl8KCWG4eznd/RvVagC1nIC/mi12YNffDfHUqhwkFVK93dd1slc85n73SVWwSTzz/Y7R9Lb5MhAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723755265; c=relaxed/simple;
	bh=rTAjc9dSusS4yaSkR6B/4Pphhkc1zsO/5tEisNlyysU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y7CTrhUrxL80Zi87fBhTCcQuKhiJt/qJzc+0s8g612lstTjwSfcL8pYqPEChWa3/MljtW5A1gCEJwd5eXy5C2OCHRYutvUXGyEaD8odvOOBPwL6D1c/6qOJqhqoGqn6wIe8n2LmmmlX7Yy+VSi5p5UhHQZ0FowlDfubGl9Y/Wo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dW/4aYku; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dW/4aYku"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-201e2fe323aso965055ad.2
        for <linux-raid@vger.kernel.org>; Thu, 15 Aug 2024 13:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723755260; x=1724360060; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=624L+CQsCoaf7j+c27b+wgbkus6CC15J4J/+Dhx1rW0=;
        b=dW/4aYku4FEOd8nJHuLUuauIHHq9g5lSdXh8++Dkq/4jWjWrdTh27N054uGRmBgpIc
         xUUifFVu9od/eVWOzIR6I62tzv+1ZTXLd0ku6TUQDDRDatoos93y0iBGu6GwjEtxbil6
         ZK+5TwoVsFHAK88bVg56Osvkk57V3oL1OL0ZbWC+rLB1+iugRrpsLiUJIgD5fokiLsp8
         9m4Ovo9onh6rTImEGffr909lUSGYDabiqjKldSguOVpuF7b6I0sugQSSf2kx8YHN0XZD
         S9nMc3i2WQeerIy9hmDFkFNIhMUzMkrFbYxN10v6hewcLFzBZRUpG04NOQRJRruX/GVh
         /j2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723755260; x=1724360060;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=624L+CQsCoaf7j+c27b+wgbkus6CC15J4J/+Dhx1rW0=;
        b=MDBpy8uLxx2UbMQqcLThvdQexC2a6ZBRZ+0h+PrNuS0lnRciWe37nFrHFxJgKRePSc
         /ckDSlzxCGR2+Yu3eR+N138D5lWwP4qo0GBO3wox1LJvCvti+TDJiSEDilrCM7lXgN/U
         Y+eTyD/dhA2M5KIQv2cgg/9AgthIi89c0hxG9E58FW+pihQrkWKItVk/ciyzL4MoaV70
         TaX7fVkDJLLHYd4snsq6HgO9ElimD6SMgMxd7YlUDJnxPdejYMsJBfd3OhgCpMIP7mhI
         tPjs31IsBtlN5gO+rdLC6dnDcZq+M/4qf55d6NUEepCkKGXw2b0sKy7iNVCpzpUB5X+c
         MjMg==
X-Forwarded-Encrypted: i=1; AJvYcCW7O+cczd0Ukapy/g0QLT4Iq/h7/dmifaCTTcjgNkyNjVRalSxthJ2vVnJ/XjGM8GkRbNEvsYcglv2I@vger.kernel.org
X-Gm-Message-State: AOJu0YwHfVNtHs6YTkm2BglmLAQ1gzJbraYAuWHLDllfU3NrLh8QuUwf
	PLkCkbSvNSJ22YKdojHY9SX8dvp8LV45nwb3NfQ4xJLd1hqG7ISrMdStaTBN8TY=
X-Google-Smtp-Source: AGHT+IE5hKE1fw3zD75El1O+WJeoUpfQDiY/K8Phb+77Ob8iSaG54e49WSV41imrOF/pcJnAyxx/qg==
X-Received: by 2002:a17:903:192:b0:1fb:12b4:79ef with SMTP id d9443c01a7336-20205e404ddmr3713115ad.0.1723755260532;
        Thu, 15 Aug 2024 13:54:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f02fa4a7sm14072935ad.38.2024.08.15.13.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 13:54:20 -0700 (PDT)
Message-ID: <d435d7d8-cd93-4617-8337-bbf020ce2939@kernel.dk>
Date: Thu, 15 Aug 2024 14:54:18 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.11 20240815
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
 Paul Luse <paul.e.luse@linux.intel.com>
References: <A867CBE9-CE6D-4A8B-AAC0-C9DA4BCB15BD@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <A867CBE9-CE6D-4A8B-AAC0-C9DA4BCB15BD@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/24 2:51 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix for md-6.11 on top of your 
> block-6.11 branch. 
> 
> This patch fixes a potential data corruption in degraded raid0 array
> with slow (WriteMostly) drives. This issue was introduced in upstream 
> 6.9 kernel. 

Pulled, thanks.

-- 
Jens Axboe


