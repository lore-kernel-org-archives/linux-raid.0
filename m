Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104EA1D9663
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 10:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748601862; cv=none; b=bWMBrzKXWo901BGNaeMKE+n0yonZjGRf9W0/mUiTLC09JKZ/ydCdJzhOCSAVBMdPnFOE/PGvGz43YCRLa56ib0GFpZY/1bHyTkNOzcRKsSRFwDEhLi+oY7Zd2J2ILgiA8jn6NG9LNfczYrAWRCQM9fe3Jz9/7L/BB/6OSjuSZrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748601862; c=relaxed/simple;
	bh=jyMOzNg0aKUz7U5o/jbgdXMYIuct2Afk/LawBBMSWRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tL4hQ0XyjdxgEEaIRfoQMywjhMhJIB4HRfjyc0zCMjMaXIeqeicwCZzTjn9icu/uLRUU7gR5qObEnekkc+fR1CVHQVe4oF67C0v8RjWNQU5bkBN+OT8nW1RrH0jqxhqgrL0OwXRewFhFtiLpvlJ5a5YW34WVjbe1PirYFRklXf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L578sQsG; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L578sQsG"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86d01686196so20442039f.1
        for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 03:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748601856; x=1749206656; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/zNmJT46XehqV1pRz+G08N/a40YkifYJ/rv0iAEbnlE=;
        b=L578sQsG/ia+PkgeZQqSfJTD8TKcFTHYYcGO51LzlZF4mdOnLcrdeJ0HXcdcJlBURC
         v0DfmsZ/1vlHbiYHMCCOKo/cjRWQ8miFgJ5CwLMPf7IQ4AVpQFIl6lPT+wcgEyI/X1s5
         aspCgBSbdbP/HR8AcLqJMgYHrcckEUlgPWtqy+43Lc+vSFpc4jBQUI5Sh2Wmqdf/d6BY
         AIELZaBPxmDxdZg3OYR+A/X6u6mGeevRyIsg9RP0dPd1E2LB2dQs9slZT2B28qvFkiV0
         c5m6QW1Cz8mKhL0mQ/3TP+/HMbAuR5wvxHGpB5mLHnesKs8RfJB8WXCFnF1h1nhhQesL
         b2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748601856; x=1749206656;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/zNmJT46XehqV1pRz+G08N/a40YkifYJ/rv0iAEbnlE=;
        b=wAZS12G3eVbH9TfUAllV98mNjsjDBavni8H/SVS9j4FBPFwBO6M9WGFZL/ErjuUQnp
         Xg1xQCgpVHpbUNQqNijeU2pXWHRE6u4sXPaN47k2AvAXFss93zzJKNaL3nfQGGHrluav
         HcR2qzCpGoChTB4f+f3tVOzPVYa95SIRFppj92yBWrQKj7ngIPYpSL8uaZTB4OHAlua0
         ttanl7Btuld4o7eWpHS6tlHsH+wPpQ2vDzXgllIAcpcoksDj/92VG4hfI39StZVDnXzn
         9eAmzRDIqIAtx4OGpniIM8IgJYwV6r2G9mVKD5o61BKa/lRG+z8gIpBUPk0PVpSPDXxf
         IhMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkPzpCqye5OBvzOi2+w8x493SFV8vxeNYA58HdqU3KS+2LdXQ8cPhZOkilQkx6KqfmNCNor7/eylfB@vger.kernel.org
X-Gm-Message-State: AOJu0YyOecrBk+ofFt9Z3GMv8K+I45Hf+/+qvAQrL4U0wpPZVdjbdF2+
	qA9CViu8FqBqZXhWtrmlp/vUEfvK5mEvElyjPkTe3Mz2fFbiWzpx0SmVdtAjecGtkJZyUs6uGFq
	cinin
X-Gm-Gg: ASbGncsAmPN8aq4BcfZ7osnzc/2DlCXlLliAu0M206xxAY8nUq3ExMl6tg43CRJm+Zj
	X28KLYn9pIGD8Bizqr71uvW7C/UeEKD2tfeFzVhMIARdJQ1nfisu0tt5du5AeUZYYL59Qrg6Q5M
	gLsGzdNaaJduwyzikf2I149fG6txDtrDoRIwNZcGIDacbuXzMQZNKEbS9h/H2wAjtcTV1FgF5/r
	m3WZUd8AVpVYiQ5h8ZonVWQZAlbe8RwvTLf213AFe2SueaNJGoh3Oze5zhK0ejg2WR4AY3OgOKy
	0FvLoCsF02Fq+Df7WK0XssaNINfK4UdR+hKPq4mLsTBRx9iySL+YwglIn7s=
X-Google-Smtp-Source: AGHT+IH9aKU4jvXd6jexnSJZZWWUKl/jerpsmEkPilRpP7dXKiCkEKj96YOuz1MNjv4fPU80z7yxMQ==
X-Received: by 2002:a05:6602:3a10:b0:861:c238:bf03 with SMTP id ca18e2360f4ac-86d000de92fmr359114039f.8.1748601856587;
        Fri, 30 May 2025 03:44:16 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e51bb6sm63235139f.4.2025.05.30.03.44.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 03:44:15 -0700 (PDT)
Message-ID: <80ef22a4-bde2-4581-b048-b7fb7d517930@kernel.dk>
Date: Fri, 30 May 2025 04:44:15 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.16-20250530
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org,
 song@kernel.org
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 johnny.chenyi@huawei.com
References: <20250530083043.1381901-1-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250530083043.1381901-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 2:30 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling following changes for md-6.16 on your block-6.16
> branch, this pull request contains:
> 
> - fix REQ_RAHEAD and REQ_NOWAIT IO err handling for raid1/10;
> - fix max_write_behind setting for dm-raid;
> - some minor cleanups;

Pulled, thanks.

-- 
Jens Axboe

