Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D402CAB
	for <linux-raid@vger.kernel.org>; Sun, 10 Nov 2024 03:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731208010; cv=none; b=JLSuRre5g7IjIS0VPJg5h37opREC14ZN4Xp+xuIkXUgDL98Id/lXt+otdRlzcIjeVoW0lth4EDUNlkFOEAsEm29YEtreGq+ymHWM0KcE43/DgB7ooBpl5QWtws652wEyF6Z32RY5kEEGE+99BEzmrIwsUszHoMYHSKWZWzna1/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731208010; c=relaxed/simple;
	bh=Wq1nctfFkqlD18LlJUbzynpXBzAag+f6AiSWJu7+S/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsyroiIAuTV5u4B6bkrb3lcJ2gKvZGbdzTwecjvFYg1GaBsscYLTJBoX7ZU/h5xIZ7mQJbErPIkK1Qlyo+vgBe5vVA0tFrG0LVz68IXRWsmb2zFfZaDknYAi9f77JM+eZ3fQT24rOK2t2mnLlg135nD2IfgDdzXmE+ILq+jf5SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e01UITnO; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e01UITnO"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2e2bd0e2c4fso2780848a91.3
        for <linux-raid@vger.kernel.org>; Sat, 09 Nov 2024 19:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731208006; x=1731812806; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OPEhiGw4ZPn3AtnVt4RUWAGew9yPzUEheLI5OksXEFA=;
        b=e01UITnOKPULqR0EzsbRsU9a/kZFCQsv+u65wOhRc0CiH5avOUZUS9Zj1IOabjhh0U
         UccwUt47OFEkJkPCOIddBTGRrUTXkIL7QyYlPCdrm7vq2Cq9JxM4zJSoSQjwuAged79n
         jNoDk9tbJcqBQu5bWGNDW/hp690Rhr78ETepX1XsYLoi3EujleKvF48jOIZJffTWaQhy
         2MsJbqxOv2ZG6tlux8W2CKWD598f+N+G2Y/Q79a8NtVWWAQEy2Ak41hMzl7Kv/RP/es9
         9dj/mvflalMd93AXkXOMYIpoulNKQftGU+KHDnL8PdFS/KRq1DNuZlwzjIx78rONdvhh
         48GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731208006; x=1731812806;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OPEhiGw4ZPn3AtnVt4RUWAGew9yPzUEheLI5OksXEFA=;
        b=Tt0oNTo4clhFTVS7jI8DWrjtxfutmmh+kE7Uf+hOO8LGS9BDDXBzDT0zo5wrWbpsrv
         KAHrKxRnOhtZ23Y74jXLlm7Xou5f52V2LY7AyZ2tP+Aly7k69cC0uKR1nX0HYt38kWRV
         JkWHmMVpeELvMfMM9hlmGZt6eZpoB8GPr1C+/H6Tv27Wgm40Sll0PkZslSY/jEl8ENkq
         cEx1W741uQri7UZdgrsqfx/LCFkr7JI8fkkX0KOt23PMsa9ZKbOnJFZpRtOU9CboCN1Y
         EHsF1KMMeKz74Gi1CxqyJDZTyItjuQ3wLuZFWaqP4Fi1jSiwOGNDoUXtXpQUbseRqTco
         yFXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUve6PpI+KjAQpM8RqTTXcSfGYMUBqYPLnw8DKBYetb2dIA4RGyzdCKAgogmvkqoVYOPz/cSsLEvCwF@vger.kernel.org
X-Gm-Message-State: AOJu0YyPbL452n1rKToSSR/4IrIqkcG/cRwSi/ucsrPSuxUB1cix83QO
	cVmNszMMJkiWhZ96p8UNEmo9NRHNtCWXiQHjZPTRtz/zcIcrZbachICVOqR9RrX+VBHdeXxcLbX
	A4b4=
X-Google-Smtp-Source: AGHT+IEpialI6QmFr3+B2izf2wG3t9KqtABSGp4B6JnmKOG6KvAdY9oFJDa30rJPfHU2Z4XlCZc0og==
X-Received: by 2002:a17:90b:48c7:b0:2e2:d74f:65b5 with SMTP id 98e67ed59e1d1-2e9b169a9abmr12604171a91.16.1731208006267;
        Sat, 09 Nov 2024 19:06:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e9a5fe8eb7sm6099106a91.50.2024.11.09.19.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Nov 2024 19:06:45 -0800 (PST)
Message-ID: <e9ca7b8e-07c0-43ad-acc9-21e8b21c7d05@kernel.dk>
Date: Sat, 9 Nov 2024 20:06:44 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.13 20241107
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Xiao Ni <xni@redhat.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>
References: <276F740C-6626-4DB7-8612-2DA8415EA6F0@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <276F740C-6626-4DB7-8612-2DA8415EA6F0@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/7/24 11:01 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.13 on top of your
> for-6.13/block branch. 
> 
> This set contains a raid5 fix by Xiao Ni and an update to MAINTAINERS. 

Pulled, thanks.

-- 
Jens Axboe

