Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEC02309AC
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 01:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731461130; cv=none; b=Wjr9iYGq03RK1+WssCEEHup30YJHaiH1i7EQqm1M0ISEXXio1821o3I5u6j3B2v5tvXdiwR8v4AYRFPYXHG3aj/qVaSqJz2jZWJIfoDo8zXGJJsgmjVBzbpiK29YX+Rib6k5xO9v6+K+SShPDVm2vvpIcU/w/vMdOyBa6hekmco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731461130; c=relaxed/simple;
	bh=vbgdxFKygzTwH0fH+i8mYqKSSbV8H0qFEv/FemMPSKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2TAPkpgZRdOSB9MbuZgM9o1zJcrLqMsnrQy+RnGtlp2q3sm89qfEthHHU7VMHXABS3vfS6aoxwjyWhDb5UGNL2J9mFjI8xBhkpbKmeZbb0DGtTlLr5DUJVXKdVu3roPWfYluEn+pRcrjT+VK7KescSl+3I8/Kh0Qfi00xe5tTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=pkm-inc.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=gjS9Yk6U; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="gjS9Yk6U"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa15ede48e0so257109166b.0
        for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 17:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1731461126; x=1732065926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jqbVv1BV13hd7p0GTnuathse5wdeIz+hilMwxG9iDfc=;
        b=gjS9Yk6U9UsAIDRivKQRXOn0t1tgIoRAKAlZ5H1+gO5K1ButAQoQMe85M6PZ8rNReD
         1/+IZsrPAQ4xR3I9P0+pQfGHaf2thCUmmSxxAdYBzyuAyETGqKKebzlsCuOR6EUHmrdp
         NecKyMT4wAFWg3JKnQx/2hgbJKmqwzXA6GB/RwO2lQ6xYmRB8i5KC50F+MCE6TF5F10n
         99dgKLRJ9UpvuPTHi9zfj+Zq/7Xo9+uoiqSeTID/9tYwLvFBIxduqRU4AH0HpPmCSmJT
         C4cSVqp+OhK39lQeJasoak6SGq0mmwlUeVKWYip8JQEYtASnrdAfv2Oxrrvyn4mqRyD6
         gYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731461126; x=1732065926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqbVv1BV13hd7p0GTnuathse5wdeIz+hilMwxG9iDfc=;
        b=Omh+bwKoqt3VdNbuexOWlNs5TVDF2JELI+3otLYcxEsL7ZR4PvxfNmT1GaIyKtxK7R
         CnVgUGlNG6QIVlCPnQ67WSkgVzbd0AjXj9h7KaxJSvwsE/URgN2Srxi9UYqJ2cgHIZTz
         6i+J66fbXe3X8NBrk+SITgqbxiKqW4o0ywMkcNnNpDoczow+fws/55xwuD5Stg6hBxif
         wFe7L6TtAp0rjM05PuSmF93kVL+LrTG25TWwcL00gIABdRRMx5FkJjqeE5O4OzRsk5pG
         nDgX5X39rUAUT96CAZW29V/Z9cH0be1Wom42OWGRwSNUcDMRmVOMrzKbRxnodjhgNC/Q
         bL9g==
X-Forwarded-Encrypted: i=1; AJvYcCX/2rJ3Bx5nMVn7KmEMqlkhsSIAilAsaykO1kmY+KOQ+r2CIvkpyZ1sWBB89jshCbv/3SQGXid95TEo@vger.kernel.org
X-Gm-Message-State: AOJu0Ywakz/z73AM31ayigRRiAalQ3Ou+qR2n/RFnv/BOso2ER0Wr33Y
	QL2O7bd/fpo0lVud9n8Jt1PvgXEu+YuBERhSGq7ctkYFTMi4QILwDjWBnqrK/Bg=
X-Google-Smtp-Source: AGHT+IHcfGp9iJW0VdcIMWymDr0AR0L6zRxuo6IjAzSntlZqX5icUcE0L8rNMuficyU4mrPddXwArw==
X-Received: by 2002:a17:907:36ca:b0:aa1:e695:f84 with SMTP id a640c23a62f3a-aa1f80801fbmr78837566b.36.1731461125580;
        Tue, 12 Nov 2024 17:25:25 -0800 (PST)
Received: from [10.8.0.8] (178-221-200-39.dynamic.isp.telekom.rs. [178.221.200.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9ee0a4c210sm788701866b.78.2024.11.12.17.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 17:25:24 -0800 (PST)
Message-ID: <0889814a-615a-491e-86ff-aaa7b9518dec@pkm-inc.com>
Date: Wed, 13 Nov 2024 02:25:22 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>, "yukuai (C)" <yukuai3@huawei.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "Luse, Paul E" <paul.e.luse@intel.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
 <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com>
 <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
 <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
 <36659c34-08bf-2103-a762-ce9e75e8262e@huaweicloud.com>
 <CALtW_ai-xfkphuch64f2n544cfWzg__59bwX3Yxkf-N61K-SvA@mail.gmail.com>
 <8dc1ee79-fd64-70d7-bb48-b38920c1cddd@huaweicloud.com>
 <cf00703f-f4bd-4b6a-9626-72d839ebaf7b@pkm-inc.com>
 <e9fd5484-619b-e8a9-984c-359bf5475b9f@huaweicloud.com>
 <e32688e7-310e-49fc-9f52-44dd183f9666@pkm-inc.com>
 <adae6bff-8401-b641-438c-d212b20a7430@huaweicloud.com>
Content-Language: en-GB
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
In-Reply-To: <adae6bff-8401-b641-438c-d212b20a7430@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/11/2024 02:18, Yu Kuai wrote:
>>> ram0:            981MiB/s
>>> non-bitmap:        132MiB/s
>>> internal-bitmap:    95.5MiB/s
>>>>

> 
> So, I waited for Paul to have a chance to give it a test for real disks,
> still, results are similar to above.

That is interesting. How are you running those tests?
I should try them on my hardware as well.

> 
> You can see examples here:
> 
> https://github.com/brendangregg/FlameGraph
> 
> To be short, while test is running:
> 
> perf record -a -g -- sleep 10
> perf script -i perf.data | ./stackcollapse-perf.pl | ./flamegraph.pl
> 
> BTW, you said that you're using production environment, this will
> probably make it hard to analyze performance.

I may be able to move things around for the weekend, we will see.

Thanks
Dragan

