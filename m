Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347263546E8
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779704712; cv=none; b=ZrP/J3GwV6FnCwz3tFkRudbXIBvmahDJ3tg6bPl8NDrdz0vnfyGLitGNyDi55Uu/if1oFKDDNH4EPpIhLxNHT53AacumSlfJjTsKqLgWJFvhLBFNWvNUDYh9jGakaYeGBBY+bdrxb/ezfn6e9EsNEqku50t2GAx8tcs39KWcgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779704712; c=relaxed/simple;
	bh=4lynDydB72Mj7/FDZmw2cWlodOseOvJOImwySeJTuqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mHNpGbSJYtprdpeNFOMFexG3fZlUWevaZ+uK+9SoJih9gqKCTfOvb6xxxODFfRiudzm0qBQkFQMzmy3CCPuT7x9dV9OdjbrDMoIJ2fzuw5tggFaFre12m2rGMOR3uL5SHzk8Rf72u+XhocnTPZTZRquSYRWYWf+W7kcpydybKPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bpxbom7R; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bpxbom7R"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49056b9f04aso21182635e9.0
        for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 03:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779704708; x=1780309508; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=WYyCEe15Cxgf15kMtvEvAHTT6I/VjMUvnOAajgqtAdo=;
        b=Bpxbom7R5mWFZ0CmYde+MgJ6EClDred7tWhf1ofOfOEZ+BAxum+uVdPgaeyn7xJSpl
         r81Xh4gv4wcrJNge9d90nqoqTR9ekJtHbc12TGv6Dz86K3gAOWmUKbj+F9HjuQLotT/k
         LesVhMBbZtvqGLG/Qv29CzzPj+eGEZh+U5YWdGRgbo3NZzJdUQy3p7NdU1UArJ8aH/Et
         5VjBVw5524J7B8RU9i3mjBbSDsMi35kq83F+E7BFrHy34G0qD7YP6Fu5SVFMhRsr70oo
         JrVOcajVGTu01VQQIt119YmSVpu45NfiKSrL1BiDP6UjELU9G6MUOVzTyx1PJy4kYHTY
         MX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779704708; x=1780309508;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WYyCEe15Cxgf15kMtvEvAHTT6I/VjMUvnOAajgqtAdo=;
        b=hgwpj/59CRxRbDo0gTl+0Y2Z9R534lYXuz7Wq8VOmIp+5uMRNw2A4SwA5imXicLxTd
         lQS2fxWQQCsjTxr6H0s6D8IY+Kd9WvCXvsDrcoh7j5TBghMwnyymzhbqmQUU5ZY0BDvK
         PeuW5Ff4iF49XHgstwit52iwnf/4I/W4YUPCV8yGEEWxIQcs+11ZKY6PAOe5L/o2jWjc
         QdY2nl+oNxNr80ntZ0O7yTwOS5tOEBXOIq+EidRMT3q7j+I8ef/jAgkOkfFk9FoBDb3M
         5yct8M0Pnxqyl51i4g2rRvMoUPjhYYO6fZPsUy9g7cIYnIoiGL0gmZVCH4yMKf1Bo0Du
         85yQ==
X-Forwarded-Encrypted: i=1; AFNElJ9LmQnqzdeSUzJm7G4i9MeUM08k1K1OJ8v1iYz1sc1aNoXjYqJgkoCP4s3rIFJHMr8cr7KG5xZBnn49@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2SfhR6Dt5/2Iw9tDam4tJgarP+32Xz06WrTWVpEFq4YdU3byu
	rt59PKcv6YprSDwCCH8B5Pjn0haxa9zsBYYdEQ+amyfkOxwCQLHzEIf0Lc4fjAA3E1UMBHT7lyA
	x9HMw
X-Gm-Gg: Acq92OEEb7h+e0SIfFoQ32SIyyyAkFyvqZnjdi07VFBzWoQImRb/Hcie1cqZKO9PtBJ
	lKnjUE2CMCm/kqNGaoCWaujnL2zlUuvAozZefw6ouJ32i4NTkSnuqGMk1CxGOuFoekezBksww5m
	QzUarfEkFiIRq2Zy3ZA3ptLrUoHAnlCAVI9+yx/zZKzXABUFQlcr4EqjhTamr/tA0pGZBrDLlEY
	K+S4Uimkzbbt6ynVBicbM7tJ7d8p0t1CCGSqu8uYS64DmlBU7EizwjiFieQMzuD/pTgZYAmc9MY
	uF+WGL3iBJhdoBO89WTVqvdi+B06xM1p4PH8NlW+dvAbjruHRax554Y7H4sqbaAUpm7p05LulBI
	xhMcD9Z9kzIRaD7BKmv6j7yqZuOCkvaEMmnMgXPt2r0cFNYJpc+y3or5BlbFeQ4EueDWJqoA5m7
	mWeB1Fy29aB72Q5ZgUJe23EFeW7iLp+GpoBNWAA1JnfX/gBR71EmER4J5yr1ULYjnfxTnqsB2/0
	2NvSEZUbQUixAWxgNgymtX/689DD35oKl/1JvgqwiQKQec=
X-Received: by 2002:a05:600c:1f90:b0:490:5e2a:dbaf with SMTP id 5b1f17b1804b1-4905e2adc0dmr79923055e9.21.1779704708337;
        Mon, 25 May 2026 03:25:08 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ff7d80sm10209860b3a.56.2026.05.25.03.25.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 03:25:07 -0700 (PDT)
Message-ID: <f8fa4b33-4bca-4c0a-a651-e0ad8a527621@suse.com>
Date: Mon, 25 May 2026 19:55:02 +0930
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz>
 <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
 <1b5c39fe-df28-4a21-bace-fc742498945e@suse.com>
 <20260525101236.GU12792@suse.cz>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260525101236.GU12792@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/25 19:42, David Sterba 写道:
> On Sun, May 24, 2026 at 01:43:54PM +0930, Qu Wenruo wrote:
>> I tried the idea, and it doesn't look elegant at all, we need a lot of
>> if () checks around every xor_gen()/raid6_call.
>>
>> Sure the end result is not that huge (and I have only compile tested
>> it), but if we had some parameters passed wrongly, or some corner case
>> missed, it can be very hard to notice.
>>
>> Just paste the adhoc fix for reference:
> 
> I ended up with something similar, but replaced the open coded ifs with
> a helper so there's not that much churn at the call sites.
> 
>> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
>> index 08ee8f316d96..50fefe33bbe3 100644
>> --- a/fs/btrfs/raid56.c
>> +++ b/fs/btrfs/raid56.c
>> @@ -1410,11 +1410,17 @@ static void generate_pq_vertical_step(struct
>> btrfs_raid_bio *rbio, unsigned int
>>    				rbio_qstripe_paddr(rbio, sector_nr, step_nr));
>>
>>    		assert_rbio(rbio);
>> -		raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
>> +		if (rbio->nr_data > 1) {
>> +			raid6_call.gen_syndrome(rbio->real_stripes, step, pointers);
>> +		} else {
>> +			memcpy(pointers[1], pointers[0], step);
>> +			memcpy(pointers[2], pointers[0], step);
>> +		}
>>    	} else {
>>    		/* raid5 */
>>    		memcpy(pointers[rbio->nr_data], pointers[0], step);
>> -		xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
>> +		if (rbio->nr_data > 1)
>> +			xor_gen(pointers[rbio->nr_data], pointers + 1, rbio->nr_data - 1,
>>    				step);
>>    	}
>>    	for (stripe = stripe - 1; stripe >= 0; stripe--)
>> @@ -1987,11 +1993,17 @@ static void recover_vertical_step(struct
>> btrfs_raid_bio *rbio,
>>    		}
>>
>>    		if (failb == rbio->real_stripes - 2) {
>> -			raid6_datap_recov(rbio->real_stripes, step,
>> -					  faila, pointers);
>> +			if (unlikely(rbio->nr_data == 1))
>> +				memcpy(pointers[0], pointers[rbio->real_stripes - 1], step);
>> +			else
>> +				raid6_datap_recov(rbio->real_stripes, step,
>> +						  faila, pointers);
>>    		} else {
>> -			raid6_2data_recov(rbio->real_stripes, step,
>> -					  faila, failb, pointers);
>> +			if (unlikely(rbio->nr_data == 1))
>> +				memcpy(pointers[0], pointers[rbio->real_stripes - 2], step);
> 
> The 2data recovery needs to do 2 memcpy

Nope. The recovery is only to repair the data stripe.
We do not need to bother the failed P or Q stripe here.

And I think this explains exactly why doing adhoc fix is a stupid idea 
in the first place.

We're wasting time on useless corner cases, and corner cases inside 
corner cases.
It makes no sense to waste all the time reviewing those useless details, 
when we have a much better solution to avoid all those hassles.


