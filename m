Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Qox3LECj"
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EA6D5F
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 14:32:38 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1d05a2307a5so506675ad.1
        for <linux-raid@vger.kernel.org>; Wed, 06 Dec 2023 14:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701901957; x=1702506757; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xWAZQtJdfr8/UgExyXi1ZZoZmX5ehqJ6+RZNXO4YLb4=;
        b=Qox3LECjuCU7tlKEXiia+tpkbzylozblkv3NPe4QrcKOklnW8qS+b0qRh79TmVshz5
         oor2ooKil2QqjzqC6TOF6jjfd2Q08AcdqxqWWqAxNtlZdhH3UoKoi5WVN7K1OlIJx8dm
         8lGUxeGxefvoOe1rgyckNxonHFwuQMSUmiKZYXc1ziaIqdEMxK2FnBflqdyfNzDAthcS
         EwWSDCMqRTyfVAXZu1dtFx1yPq3dQGypCGzBxUcehkFV4adqxbrSLQ64uo6+WHMmt7fT
         3K1+u3PyBBer88xfIHo2I184xYO392L5HsHwpsQv5wOip5y8MFwldCFWqGptnbWjnNDu
         0NKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701901957; x=1702506757;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xWAZQtJdfr8/UgExyXi1ZZoZmX5ehqJ6+RZNXO4YLb4=;
        b=dLL0kHHiQbrG0rZ3hGJRdfEyA66ir7CcjBRaIg74ZRTWXbeN62TnRL3m+t1HBkHcNy
         M8V9plCR5c7ioTqkWrGxQTxnClIG9iSHJQ5EUrj510s0RV+WNHN0iOvD78viNv2znhxP
         fAKO9+yBfi307hxdJnZO3sGQbcdZLy7U8td8NvOoW+7lK44gzHWb7Ov/ZTfOWORAJKwB
         deKUeeezt27OldB2DUN0bAunrjtxJkYVN4hRfVUlabm13o80yz0+wxOvTfRVy/kaOPFm
         RER9dsLe8PfOPodR/4n6Xz0re6adXhthLoYQBtT6C1CeVMouyqeaunD0YWV3OOEYzNID
         j6bg==
X-Gm-Message-State: AOJu0YzqfZ/S7UG5L3s6Rng2gzohvtig4JASuWdzKXQnJhx6zCUeGuyF
	76A1T7aY8urkpgDXNP1ivHnIYor5gOv2UomW4CY0Zw==
X-Google-Smtp-Source: AGHT+IH64UzayIFouWLgOQEo46PfEEERkShubNVtc5YG3/evcNexP4nP8PyGHq6MXJ8GoZ5nJGuG6w==
X-Received: by 2002:a17:902:ee45:b0:1d0:9661:161b with SMTP id 5-20020a170902ee4500b001d09661161bmr3155385plo.6.1701901957428;
        Wed, 06 Dec 2023 14:32:37 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q3-20020a170902dac300b001c5b8087fe5sm311470plx.94.2023.12.06.14.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 14:32:36 -0800 (PST)
Message-ID: <2c02db20-2046-4a32-89ef-b5e0e71925c2@kernel.dk>
Date: Wed, 6 Dec 2023 15:32:35 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-fixes 20231206
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>
References: <8D537C9C-81AD-4906-8A8B-3F103D53C655@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8D537C9C-81AD-4906-8A8B-3F103D53C655@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/6/23 2:04 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-fixes on top of your
> block-6.7 branch. 
> 
> This set from Yu Kuai fixes issues around sync_work, which was introduced 
> in 6.7 kernels. 

Pulled, thanks.

-- 
Jens Axboe


