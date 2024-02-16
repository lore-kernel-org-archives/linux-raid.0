Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F579148305
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 22:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708123497; cv=none; b=OV8ZXZ+4MWYs1XbrOrErgyc31d/5bCvhFUoHNzEwbJ0YuOXF4aSuhlltv2GGT+L9/DsARvxpbfbq/vRVDb5kY/tFTVANfjgT63eqG19m+BiC7d4nKymOOVttpkaorgpBE3SxDZOK9/5lxCPEdI+YhW+AWjfxZ2jtxJuV13fd2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708123497; c=relaxed/simple;
	bh=BdpfYbLQVcjDhgZPzz6N2zHq6gJTYgH9ATMvcXdiWJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BtKnWOVGK5YC9zFcfYtUXZgwlWEB/hkW5GEUIwXu+RRsL9dKVLhYGOH0ITIycCZN6OSwHvu50VOYJDQLri0ZzyVJ4i33QcRprLBJFE7eR/y0WxqeRtmdejxzaWoko5QAOn/iKxeQxHNyyKOCFo/u3e5FHeKkJvLQV3VGaCIbjIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IdaPb6zL; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IdaPb6zL"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1784705ab.1
        for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 14:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708123494; x=1708728294; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eI+reDDkqyRCtv4IqPmuwo9MYM1Bw7bk76brbla8nk0=;
        b=IdaPb6zLP1KOm85i53zdoJgoCgFyFeEqUYwewKDYRXBENaJWJbG2xH6H+//f593Czo
         EQGHgXlmIfFWEKqEJX25ArnegvWXIkWdVSUAQa1+Afo6V1BYR8lbb2mxOw1g6z/G/PPW
         ezxJQX+ln16Hj9kel9WTfxE1yaGoNcTlhJo2DgBzKNh5pcVp5KCjciTP5YJOvV3WWk8I
         UafCmlwVr36Rp9qqOQMB710UMmUuvyN4XJV+exb//2z3AAmnZj4I73CA/6v2aUlSjDq8
         qk6ls0Jmc16T4fEF53XG9VgU/QfN6ClMqX+PKM/gKjy6Rs4JFCuBmu/DfNUH7BHfFvwv
         ORZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708123494; x=1708728294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eI+reDDkqyRCtv4IqPmuwo9MYM1Bw7bk76brbla8nk0=;
        b=pG9SiCWCek83vGXJzxNLbZXKUE2x2YGiGn/C4p9ABdIz6c+ZBeJd8aL1P+Q/ShoEC3
         433w+TVZJ4KQi9PFUFr9bcnv+MKedg+FzeAFnwKzbeZGNe8y1pfr2o4X9+d7ow2rzG6F
         UyHmUwVrgy2n4qT70w2lROe5KvyE7otY8vfCulK+LO+x8NQJdC1Nc2qlumLciSS5VFwV
         ZF0ESvS4jZ/Fi/Urh0g78O1sY+6+gQ8npoo6plaeCpuh2nIbQCExftPV2L2nrnwsrmeG
         BUMlHoEwQ2rGZePpSLvSZHFghsAfZYAaSULy4NeTsjYg4+YsCnK63Z6ju1ZeYJuNUcSO
         XRpQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+whiAejs8CJoOuzEf38/3H0fm/0etsavfSRWjHolHMwskBxqvsEcYsi7m2hXpjn5xR8OX53RWYLQ6cAR1WfLTRy6vssTy6UmvTQ==
X-Gm-Message-State: AOJu0Yzm/q76XTA1pmIKkAOXEaVpKztwzBcaXkKzr7Gk5JnjfALUfOh2
	lcJnXUcYBAeV8YjpAg0q/wSUdLz/V6aTqskJ0HW1SdsIJkJL0t213vbfQcmHjwU=
X-Google-Smtp-Source: AGHT+IHYnJ2qaJf7tCAchnmUpouk7BvfU5R8fDXRIz0jLVVGTevcD6fqEj0MXhfXgxYOZI7yuCGucA==
X-Received: by 2002:a05:6602:2cd6:b0:7c4:9e06:b9c8 with SMTP id j22-20020a0566022cd600b007c49e06b9c8mr4334972iow.2.1708123494238;
        Fri, 16 Feb 2024 14:44:54 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c19-20020a6b4e13000000b007c47e7e549bsm181736iob.27.2024.02.16.14.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 14:44:53 -0800 (PST)
Message-ID: <f924601b-99bf-4aed-ab0a-95eb2d80622f@kernel.dk>
Date: Fri, 16 Feb 2024 15:44:53 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240216
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Li Nan <linan122@huawei.com>, Marc Zyngier <maz@kernel.org>,
 Li Lingfeng <lilingfeng3@huawei.com>
References: <BC4AC7C1-4B8F-457B-BA66-3D07082650AA@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <BC4AC7C1-4B8F-457B-BA66-3D07082650AA@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/24 1:38 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-6.9 on top of your
> for-6.9/block branch. The major changes are: 
> 
> 1. Cleanup redundant checks, by Yu Kuai.
> 2. Remove deprecated headers, by Marc Zyngier and Song Liu.
> 3. Concurrency fixes, by Li Lingfeng.
> 4. Memory leak fix, by Li Nan. 

Pulled, thanks.

-- 
Jens Axboe


