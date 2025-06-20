Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B69136988;
	Fri, 20 Jun 2025 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750438196; cv=none; b=LjlxdiGHnt71LTxCTe9Q617mg2DSDorCPUCITgjNspOz9d+hYXS6blDwiGcrFsApoltWt89YlCUQGzlkT02IcoILWdM7nP7Me+TfDm1xFCkq0rlKeVc0Xv0O8Xx/tV42eqppgQ+Clt02fAoOGRPxHtW7aB/8tie7F9l+E2ey3NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750438196; c=relaxed/simple;
	bh=aJN9w6y7QBnbQ4r1XRjZLngcDFza0KlNe7OlghFMZbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EhPgo4m1QhEDOQjpbwQQLMlkv4SNjLpTwNqvc5m+mPmmHJcSfTtqqCxcHiBL8LOUAaZhrxTmEATpIR/XQFv9gKRVy+An4jAN1VdKGz6/lPsq0HEIZ6+j802LOMaHIawY/2GuxHxK5y0IXL2URTxauSqSyOlJ9ne+UEnK5nSUMk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QrBU3HiE; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QrBU3HiE"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55350d0eedeso2091865e87.2;
        Fri, 20 Jun 2025 09:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750438193; x=1751042993; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bgNgoba8Ku6R1NkqI9Xoa3piUfy8Hi2Dekxbr1KkRG0=;
        b=QrBU3HiEbTtTa2uAm+H2HmiD7Zl2aoh3QDJu3/p5n4tI7hLVClhfz4bbA0KU/XDqGs
         KC4CoHCs7ZJz+odydwJwC1ftCAvKTpC+xP6QWmuun19OZKABBsz9U7pYGvBXAxL1g7Xs
         l4rzJdiqFavQiXaOPxiHHFlqjWoCtV2jfeZybQKbKEYfTKjrEW55p5Gzj4aQ01TUjuzt
         DChRuXjjM1bR1ZDOxJLIHNHv4FjueS/D93m7RMuRQLZG34hISMBSKU264dL0dtBGaw3S
         bIrlBRkIpSXQ5iFHgN22E1TChlZ++XLMrNm9xgRouOYAAQlMsAsbRiOwuuKJU0HhzjWB
         ZhhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750438193; x=1751042993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgNgoba8Ku6R1NkqI9Xoa3piUfy8Hi2Dekxbr1KkRG0=;
        b=PuUEEebPEvyyxscLV7+AYpVgWgy25nKxCBxUtz+co2A5prRyRTEc2U3h1iJeDTG8uj
         V9APEfO/RL8dvYji/TzjVR7KOOOqQ2vH2Pr6MkrNRyoCfS18kJyEhdnLn79XQvkmDWMC
         p4zOU3zipLBRGoRNGNNtcV4AE+kNn26XQoLfQrpB2sZRtid/lgXCwuWA6icfCqEkSxdh
         c1l2kKgeuRoTed/z8C4qQugHlcVfTw+a8ieFh6MR2bgtF7AqFAxFQPLxgeitB0wJez70
         RKIYGr8r9W4qqFvAcRNG6kD2U/6U3sgzgrwOEST9loWvXlwrm0KyYGpjmvo4xVUQ9CdC
         cziQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7HCDl4PqSwWpJVvG31TFOIlFll9QSmOU0LLd6B+s2QbN8Nx+0HWQNtVNIBq8+6Ge/4ONX1EVdUNKm/w==@vger.kernel.org, AJvYcCWOiTEpdDMlyFlIIX7Ck7wmIFZLTmyXVdzUqF+ZmJwi3sgZlp4ar/MNc/Lqt9lN5NehYoxh0ntyldvcnAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTeXP0QXWR8LUSusrIcJvxZ2TtF9J/3RzHtFeqzDqvNRLL2DdV
	qc3dEYKG0ECZn3kifd9EN7gVrRpRIWvEnllEGUeY/GmvS/wM9ytyGWsS
X-Gm-Gg: ASbGncvhrBJyYYZFjc+naWEvIC+CfYWiCLUD7bs7BsutywuyRdKWzd7UR88jWk+hGjt
	R3jainfje8uLHW1z7LtzceAn/merNQ+qU3ZFaLyQv8UMQj6cGQZ/LSBtfsi6j/XsJ2Sgp2cpOFv
	rGXpr7WrGm0P78nzdoT7f5ZlebdKuo6pE2gNmZ5Fb4GProMLbWl7Xrk8/H6fxC+nXTOFvOw2u+A
	yu7N+Q5N1ZQrkifAglf0fsu4O/IU8q/LuTej3pb2Uf5oeCOcr4CuqKd28JN7O02zhR4nBsd0pup
	T3HzSisQZeeNxZrjTVUte8kAv8qtfjgTCRk/iahi5U1kNUwivRmEk/Pp3dMx7IQvPZTMj/fyX9u
	ysA==
X-Google-Smtp-Source: AGHT+IFGQGCAzcFp92UZH1SXWDZfbGHwQNVRUjCiVS53O7AK3y3IqeRrpUlCTOdnNgF6b8j3z2vw2A==
X-Received: by 2002:a05:6512:3f27:b0:553:cf38:5ea2 with SMTP id 2adb3069b0e04-553e3ba785bmr1468836e87.3.1750438192907;
        Fri, 20 Jun 2025 09:49:52 -0700 (PDT)
Received: from localhost (soda.int.kasm.eu. [2001:678:a5c:1202:4fb5:f16a:579c:6dcb])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-553e4144358sm343128e87.17.2025.06.20.09.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jun 2025 09:49:52 -0700 (PDT)
Date: Fri, 20 Jun 2025 18:49:51 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-raid@vger.kernel.org
Subject: Re: [v2 PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <g7ymicehyrtnmepvpupzpds7yv3v53h3oui4sbcb5njcwsmigq@x5gtxzyw5tc6>
References: <Z9flJNkWQICx0PXk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9flJNkWQICx0PXk@gondor.apana.org.au>

Hi,

On 2025-03-17 17:02:28 +0800, Herbert Xu wrote:
> Use the system-wide zero page instead of a custom zero page.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

...
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 98030accf641..428ca76e4deb 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -11,8 +11,13 @@
>  #ifdef __KERNEL__
>  
>  #include <linux/blkdev.h>
> +#include <linux/mm.h>
>  
> -extern const char raid6_empty_zero_page[PAGE_SIZE];
> +/* This should be const but the raid6 code is too convoluted for that. */
> +static inline void *raid6_get_zero_page(void)
> +{
> +	return page_address(ZERO_PAGE(0));
> +}
>  
>  #else /* ! __KERNEL__ */
>  /* Used for testing in user space */
> @@ -186,6 +191,11 @@ static inline uint32_t raid6_jiffies(void)
>  	return tv.tv_sec*1000 + tv.tv_usec/1000;
>  }
>  
> +static inline void *raid6_get_zero_page(void)
> +{
> +	return raid6_empty_zero_page;
> +}
> +
>  #endif /* ! __KERNEL__ */
>  
>  #endif /* LINUX_RAID_RAID6_H */
...

Note that an RISC-V vector syndrome implementation was added in commit
6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
which this patch does not change.

Regards,
Klara Modin

Link: https://lore.kernel.org/r/20250305083707.74218-1-zhangchunyan@iscas.ac.cn
