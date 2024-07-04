Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37937E57C
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720080260; cv=none; b=Hq787626lYvzexhI29vgdWu8QTpGgK0VYQNyzgCxnJb/TY+rGgOf9wq1dgyCPK/MMTSZcZmV/KKMTMbhcTU1NFXqtliStsXyCMRM1THpP2loteOOlMZcXSYPXiD54Dw95/aXRrMNc+Q4cxttHhW1+hNAwIW2Wx/iP1tjX91LwTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720080260; c=relaxed/simple;
	bh=EBOQaGRZRYu20D3o3C5GBVaGRtdKenMar74yAQQKtSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eibdnFENNQd88+/69N0DJYNK6qEwGmbH+WuN0zEbpJOyz6uvul/5HbOsnyqEgV4OrMQJK7YlzPD1K8pigxbFBw4uB4G6I52OKYOrDWHKx5c/r7cO9Hwys/JWZ1Ffm5c8jYG0UNv9rliJx3eTIpPN6zZQDOSzqLEOFSzg04FFVZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H2qkEQKK; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H2qkEQKK"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58c4096ff59so59326a12.3
        for <linux-raid@vger.kernel.org>; Thu, 04 Jul 2024 01:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720080255; x=1720685055; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=beZVSmzviPLTiIPZUDrb9b1k1Fm7DeDn/ZhMmVz7pQ0=;
        b=H2qkEQKKlS9b7jfm8M8ZdcNatrhUX6mwbvWJE8Z5geXKmI/ZLgMiq9mPg0tlYzyx6b
         +C9TJ9TyPlRaOuAgAKepdo8kqVL8U+pdyGDgODLv9AGtarvqsPUnG2Lk+WLRasq6wj6m
         uC43+FR9M0RevQRaaNFDaR3hxDBbadjRmmm9XAmb0gGP59fWYENu4kqBoH+CrKQsNOLV
         gID+mpBcgoc/CwbsN81g4uOWwYkiAgg8NdknlEfGEbiJp71AbujSS9WHbStkLJ2vZu41
         qftxaDCVxi7H2fG7QtQpsx3cMf4esxJq0YtmEzT+lD/e3D1HaGwiWqFSxFthxjKcMrBb
         QVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720080255; x=1720685055;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=beZVSmzviPLTiIPZUDrb9b1k1Fm7DeDn/ZhMmVz7pQ0=;
        b=RF/XbUerEHa6lDhUu2cvbMWNvjjmG0NvC62MlgsJI4P5N8AgvMcQEjYAjR+Ft7ysqa
         aibViGpCdsP+QbpYOlQIsX9O2nYFnUSn1BS47loVgqMmRe7q63Em0vzVWeErxIoCz/qp
         ZJc6Lcd31S6Z9jOe+9g5Y9H/uky8yTDdI5V8m7rRmpoOWMurnTg8NpsgnWN8Ttp4dpEc
         fcBtj87iOWfwo18TnKGEs9/mWqnu1ufO29A5VFO19u948WuV/Z/Ckrc3iLbb76uOF7PJ
         Wm47FErWPwqWMD8f5dKbe1e7vD1Qo/Uuuw+MDNqhqmrKnlILC6VSjHhLlZPH0oVJ39Zk
         O/+A==
X-Forwarded-Encrypted: i=1; AJvYcCUeb4xPqUh64c5201G6HOwKPlgVZs1/FVPYzJj2igEQKX9DHf9Dmp2zv7H6ZqbZGxYE3EoYF1OeXBks5ujGeg5XjHwI7gTAYbGQdg==
X-Gm-Message-State: AOJu0YxKOxCwm1bFvoTXHySF9ucHB3SLat97DK9vMB2ETXVYCTt+EWKz
	50p9zt+tIUWLDX/03ic8mQgDf4AH3DQoc/BNcGyjHRG/N2qNAK5SCvAib1HtCCQ=
X-Google-Smtp-Source: AGHT+IHlQwXsx9bF6shbGSDLe3TyHFjuAQmZx4m5JVAE6I+tJf21p1/sgwMowjzphPg2/gQWsetChQ==
X-Received: by 2002:a50:9fa4:0:b0:58b:e3b:c5dc with SMTP id 4fb4d7f45d1cf-58e57a120c1mr581881a12.0.1720080253957;
        Thu, 04 Jul 2024 01:04:13 -0700 (PDT)
Received: from [10.22.242.22] ([77.241.229.232])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614d50464sm8051894a12.69.2024.07.04.01.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jul 2024 01:04:13 -0700 (PDT)
Message-ID: <7f0694d5-4e6d-4280-a8e1-04c7e0f05a08@kernel.dk>
Date: Thu, 4 Jul 2024 02:04:12 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.11 20240704
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 Yang Li <yang.lee@linux.alibaba.com>
References: <14E500CE-4D02-4125-AB61-6F65705FD8AF@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <14E500CE-4D02-4125-AB61-6F65705FD8AF@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/4/24 1:51 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.11 on top of your
> for-6.11/block branch. This PR contains various small fixes by Yu Kuai,
> Benjamin Marzinski, Christophe JAILLET, and Yang Li. 

Pulled, thanks.

-- 
Jens Axboe


