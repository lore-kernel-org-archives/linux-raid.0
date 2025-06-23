Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355CD2907;
	Mon, 23 Jun 2025 03:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750650360; cv=none; b=kBuGOlknb42O2qt3cdhsDQ0r9UoSvcLVLCjs9tmXo0eYDmtX1FNL7hTwLmjzcmPzQp/O8xGvEo1tXcAducwOnekQ+q+jQbh+mLvFynCShZ2zRuda/sDhyEbvstPojTxyfW9+0iqFOBm7Ddyw4MTVp3RJQosC+7/Bo3O+CxEQA+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750650360; c=relaxed/simple;
	bh=G5Uc5D02m76z4ScjY7e+hO5tY6bfNFOQgKMduFLxKEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W+TYX6SWb3vdtlWC9IhLlxcSoPheOwittEF3Gx9X3pRYwKugIXSAbooyIMbgADtfdZ1IN1/2u/k83a+eDxA3p6NtQo5AtXfwK309KPdQQntPzPujg5ZiDof+3/J00s4INTY5ucJrAOW/eW53YVySyi7SzCnyCVKwZMDhCfUtZUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Otv4NTSs; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Otv4NTSs"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2366e5e4dbaso29475555ad.1;
        Sun, 22 Jun 2025 20:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750650358; x=1751255158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=46czZ5RTorkh2CcgjyXvPjRLRUA/PdHb71pPU7kVdIg=;
        b=Otv4NTSshc31T4o4xGSUsuSqy6ThHQhqyBG5hiACBJ/epOleqz8SIskbSBOZhDDzes
         SoQCwbGBP7tCc3Ksp0nebRQUoFxkVul20UFKGO+URWd+o8j3D3yVqWkmLltgfCLU4Gq+
         ZvZYE3xigoCekTYr1M5CDCPa6+uW1T0Kcir5HyNWv4xtn22mGmfZk4gcSqoElC7ltH1Z
         5Po/bdNnscPWS1iCOVc6rmD9UBTAR03c8tP1clfZA5MJI+BMkgrBKnqXueHU+K5Xxkef
         Ih8PQvC2CGvv3svdRmUyg7QvXO4vB8GXGEWiwXGvOzBp2WMHintS6j8+DL6FKK1Ytttx
         cG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750650358; x=1751255158;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=46czZ5RTorkh2CcgjyXvPjRLRUA/PdHb71pPU7kVdIg=;
        b=U8K4fVo8FspoRUufT5amHE6dcQJv+jcbEMWELylJ3gvRg0IQ0vGRepN/Vyw3oiXnle
         4kXDy/NQFO2POeDlRbhqzYeMIdBIQBMBz76hrVoRTeusXa+yUmo5SpHUHPgqxCd6vw+4
         bryi4YAHhrrhPlwkmyYT5Hu/1V+u+ArhBSIhVGmzUkEqCk9R5ssdNaZBt5XGpXeQS+jo
         b4mF5ezzd6lD3yk2bN3/2anQGN4JqAEWP9WbJYrxLCQ8qQ1Gj5E3p5rj1wdXgUQFGZaO
         jv5SeYVLaRvfXlxcRWkkL8uBFAwc1PZa04fxqOzDr1WtZKKUBFtQms4ldcI3MwO1niPw
         uNhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrRlfHOUsxN9O8nXKixVyqXHJv3Byrif1D8DYUfEJEUQxEfhcvaA2WUIRUcSPrF4BrzIr4740Ug7SXgHg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmG+SEhkDCVW/mbaW8qfwRw2b5ATn8m0xv+gaO+YKiUNjLyMH7
	CBhcMuDdkSvAbDSjtD/+SYJqFyWZHMKzUmJck6Bi1rfwzSkD5cWbtNyq
X-Gm-Gg: ASbGncuAhL3o2klMUeYz+Z2DfibbtvcVQhzDvu88C11wW3gpNFza/W8ypXsXN+OuIhH
	y8+Wib1XQUF8mEzR+f5g3Id2cxhscgwM/mffXpFAmhvvUhxgf57ZJhvBeT6prLlN1gsNnEdwfx1
	d7O/WCSnRuifjdeJWhT181SOuG+8wJeHgyL1PGi2U1PYJCTD1y5wVfLFFOmq5hfZIsJU1iy2zkz
	TIc9+ZeprKSOS7sZX2vn+cm79u/0pOpWJAmR5wSoLXi9ioEpRC7tsBFiQaKOIUzwxE8hD88GXWP
	6+/hLo/Wai2CCLfNOmXUPnlpf3X1boEfcCgQ3PDX0ziL
X-Google-Smtp-Source: AGHT+IGDZUf9WAoOlziNtYa2tatWnL25kiOuHa+V3kHYAJ6nw7Y6HGb319q2Ags8nZVZ35i0HZvl8A==
X-Received: by 2002:a17:902:d50a:b0:215:b1e3:c051 with SMTP id d9443c01a7336-237dafecd35mr150827205ad.11.1750650358292;
        Sun, 22 Jun 2025 20:45:58 -0700 (PDT)
Received: from [127.0.0.1] ([2604:a840:3::1028])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d8393292sm71356235ad.13.2025.06.22.20.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Jun 2025 20:45:58 -0700 (PDT)
Message-ID: <0b9376b8-6132-4b48-a5bd-75eacd121561@gmail.com>
Date: Mon, 23 Jun 2025 11:45:54 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid1: change r1conf->r1bio_pool to a pointer type
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
 linux-kernel@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250618114120.130584-1-wangjinchao600@gmail.com>
 <35358897-5009-4843-8234-136bd5756e0b@gmail.com>
 <dd532c80-2597-deff-4a3e-3d8ce88cbc19@huaweicloud.com>
From: Wang Jinchao <wangjinchao600@gmail.com>
In-Reply-To: <dd532c80-2597-deff-4a3e-3d8ce88cbc19@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/23/25 11:26, Yu Kuai wrote:
> Hi,
> 
> 在 2025/06/23 11:18, Wang Jinchao 写道:
>> Comparing mempool_create_kmalloc_pool() and mempool_create(), the 
>> former requires the pool element size as a parameter, while the latter 
>> uses r1bio_pool_alloc() to allocate new elements, with the size 
>> calculated based on poolinfo->raid_disks.
>> The key point is poolinfo, which is used for both r1bio_pool and 
>> r1buf_pool.
>> If we change from mempool_create() to mempool_create_kmalloc_pool(), 
>> we would need to introduce a new concept, such as r1bio_pool_size, and 
>> store it somewhere. In this case, the original conf->poolinfo would 
>> lose its meaning and become just r1buf_poolinfo.
>> So I think keeping poolinfo is a better fit for the pool in RAID1.
>>
> 
> I said multiple times it's a fixed size and won't change, you don't need
> to store it. Not sure if you get this. :(
> 
> conf->r1bio_pool = mempool_create_kmalloc_pool(NR_RAID_BIOS,
>              offsetof(struct r1bio, bios[mddev->raid_disks *2]);
> 
> Thanks,
> Kuai
> 

This time I got it.
I used to think it was a pointer, but now I realize it’s actually a 
pointer cast from a fixed value.
I can change it to use mempool_create_kmalloc_pool now.
I will also reconsider your three previous suggestions.
Thanks for your patience.

---
Jinchao
