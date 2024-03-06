Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8743135418
	for <linux-raid@vger.kernel.org>; Wed,  6 Mar 2024 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709748994; cv=none; b=jovcbwHfiiIMMmct/s1SI4Tq+OTcia3pEqK4qjKJdqlKvdXAeuo5cbhL4IwvhToSW0v76g8duW9b7WBdEAyylszMKPmCBKlWyCo7g7NthSiZfZpUp8FrNeWthFZb2+OPotACUx90IDZXdDpFrHQD68FYe+Ndj8aqGvadFw5N8WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709748994; c=relaxed/simple;
	bh=pbEvCseieK6L2c3rcEGEsvWRILJg0nDOUunX4PpiElE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RQ/ObZIuQK06Sc9S43bARRyNEIm2Fis95xLiaQQoNxOzIGio/pNsGUNcxQDYclHbdXHf//2QG3sNh8Ffp6RN2Zo+rj+7YtX9W+S+o086Yv6bIYTnpx90smeKRrL64qIfpnlBirABZAnskzo5smdWRc4zx6FCldZIKdAI4nEEq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C0+1bPM8; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C0+1bPM8"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c495be1924so1259239f.1
        for <linux-raid@vger.kernel.org>; Wed, 06 Mar 2024 10:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709748990; x=1710353790; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+l/MrEAlbBKrCNbsFNy2QYcZrNF0TaMhrFqasjtFp7E=;
        b=C0+1bPM89f3lNqyrRjuLC6S2TNIWkvz8EOIOYq/HUY4lLl0A29tKCIFX8gvyABYChb
         Y83Nq+LX1DhetJKLc0nOrTRkU3w7T+gDGcMzzK2oChRSBQQ/Nyp1+4rTjR5fDbwcf2LP
         M5912LBSc6fVI9Bn7bmjeGaOvvDPrxtGJIx/ZZ7uF4w1lXaf89x9lkkKdrczQu10fITU
         a8at93BtLGCMH5TkF0sRkfqnxr+tbuWGBI0+OCjVILtgDjFLaJucclmKD5OgeiOQBkI9
         S5Jkj19SZ1DUmQygOeFzX+EV1DpGGsxtV1R8x8JI/xMWiAO7sG7OjGs3G/kL+d7ALUVQ
         mmFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709748990; x=1710353790;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+l/MrEAlbBKrCNbsFNy2QYcZrNF0TaMhrFqasjtFp7E=;
        b=u3WW2SfP68qSw2rjfFKnsHBjab/p+ZvYHP4qTJTp7z22Z1wZilx6fROvi2clxBM0nM
         VgRjvqrDFsnWw1f4PrpKKpKcAs663r6nvuy09FgHc7q1GwW3lqlmFf8GhfIVqpD1qv7W
         c9Q9XDhdGRXpIMpMNjSgUL5LZlN5wt5U6GTpSRuj8gduRGYjUn0PCRlfbf8ctutb0XJV
         e7MQQqF6dhGqXCCdvtEa4xsUvDXlAHjR1HLbXUEPshy1uHXqIufIYIgwkXyR8rEt4PyV
         BnqehRRlqHjeb4m8bsLkI2gwl+PoUhohmJvhzKaWXyanJgSEoGozDWXA+KMR/+YA6jbB
         GUzw==
X-Forwarded-Encrypted: i=1; AJvYcCUVnZseW+onC7YDQ5C2LJD7rZ0ow2PHc0r963yrjCiDD7wkSOzlDPab+b0MDOVVr0UZpSWR18ilKNJ/mTctIKwK8Eas2rxtQstsMg==
X-Gm-Message-State: AOJu0Yy7jroYcBlwY8qe1CSae+Sl0wkQNK5XoNEfMu3WaP1GETE5rbSb
	7b970GvGFSyYEsCwhGYbgITSzKz8CwbhjqlHs0yoC/aNzvlGsYKokjXKCk4oEh8=
X-Google-Smtp-Source: AGHT+IGMyqTag7tmYNyL6UvZ56l5Z8viSUuBX/9fvmY/Jvy4SmbtZSycErlRsDHsaibl8qfkfSpXww==
X-Received: by 2002:a05:6e02:19cd:b0:365:fe09:6431 with SMTP id r13-20020a056e0219cd00b00365fe096431mr298093ill.3.1709748990595;
        Wed, 06 Mar 2024 10:16:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v4-20020a056e020f8400b00365cdc51c7esm3507366ilo.30.2024.03.06.10.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 10:16:30 -0800 (PST)
Message-ID: <ba70eba5-a23c-4364-824b-83a70e26d0cc@kernel.dk>
Date: Wed, 6 Mar 2024 11:16:29 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240305
Content-Language: en-US
To: Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 Xiao Ni <xni@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Junxiao Bi <junxiao.bi@oracle.com>,
 Dan Moulding <dan@danm.net>
References: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com>
 <Zehh9BvpfsG0tAEs@infradead.org>
 <CAPhsuW4jfcYqpoPGT8gtyZsuYjLsWodC8UM9pL0dtnc4GSoumQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW4jfcYqpoPGT8gtyZsuYjLsWodC8UM9pL0dtnc4GSoumQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/6/24 10:27 AM, Song Liu wrote:
> Hi Christoph,
> 
> On Wed, Mar 6, 2024 at 4:30?AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> Hi Song,
>>
>> can you also send the queue limits changes on?  I'd really like to
>> have all non-scsi queue limits updates in 6.9 and have been working
>> hard on that.
> 
> Sure! Here it is.
> 
> Jens, could you please also pull the following changes.
> 
> This set by Christoph converts md to the atomic queue limits update API.

You could've just replied to the thread with "Reviewed-by" like I
suggested, would've saved both of us some time! Anyway, pulled.

-- 
Jens Axboe

