Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC31A239A
	for <linux-raid@vger.kernel.org>; Sat, 23 May 2026 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779576427; cv=none; b=Tl3S5ASp+Miv1F5RNlHftrIXSJ7R91tg9QHiFd0fEFxnYuU9GlgcTsRp2Snndv+c3K68q2zEm4hkEpW7+kG3asTS/W8fGUwTZXwq1xV5kNElbQLzUbHXFQk2Kq4JdsLfJ72SwUXd1iLIZHRr/eUeX+BKiS5GZUldCVx5DPKUcXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779576427; c=relaxed/simple;
	bh=MrQoh/EfmVdVKlBkhuV93gVYhJJ0ceMp+MEgn0RMivs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNNBhg5lYpElcG24qUdCle07RAAid5B2/UZQxwjec7ygY2l/egO9CSED8CUfcDEjrjbJtvUBtnyenBapkBcTrvOhdbjfpScLfZf6uubrbexaKXMsKJ1G9yrWbZDV74opzF5hPyXnk4N+xn//259wYRqEa8EG9WrVFTCyWrPDj/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ESHEu7Bl; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ESHEu7Bl"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49041e84237so16385045e9.1
        for <linux-raid@vger.kernel.org>; Sat, 23 May 2026 15:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779576424; x=1780181224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8Z1ek8TezGhOn7Xz7zUAnL28o0hfZqT/5T3cPIcBsjI=;
        b=ESHEu7BlmvE0PYE5l/ts4Yg8iUFaLUnTkokvPDqyaGGgCSCq1BTRfiCOyD+8EwV2qf
         EX4XrW0oU9Yg7b+DJWbrn3mtvVsEujsiYGQJsMEA+vz/A9MuPS45GF8pcM+Z7MfJeBkV
         KquyOlRUyxqs/1dxEim2iTfqfoctSNqoI//0AkkEPYmpxvs2aD2YDYmDm/xh6pAv/oBn
         xEeUf+RvQdOxLEr6ZYZtpsGNNemrslSak9e3Eyfq38dhCJmIge1FQ4VgcbxpzD/Qv4oI
         T0Bt89SetbYAxUsPa2iOLQKk1yolmFX90vSs/zQ1iELgZ6sfm79MgNCn87GB5GD1gQVg
         e1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779576424; x=1780181224;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Z1ek8TezGhOn7Xz7zUAnL28o0hfZqT/5T3cPIcBsjI=;
        b=V8uGcozMpdCtTrneNeWjXF3CsyAthwJoyN6ryCMA4UKiUXoxizxfq2b75yZfjOcgqZ
         t9eGodpuntKTFpGyFoBRZ3dz5NXYwvQZ9lBd+AFZv0MO1nedaieXoOGP8M9EUJtJHUHu
         Jyo5c0dUeB20XNFfAKzmqF3SpIzfPExzpMqieNI0AOmzsnqAbQz8MvMEYlrA4le/OiDE
         0Hj6oNZMQMlKaVEXSNF0CmvfwtjAT/OihDA//dUiXYRQ8nbphfDdK8ehpH9AZMEZ0OSO
         V/NEe6g16ychsdUmeuzJwoeJ1Qj+6Rw7LNaOsBRg5s9L+5l8eQEjlK+GF9gH9eVCz+jp
         onYw==
X-Forwarded-Encrypted: i=1; AFNElJ+gW2RIb3+a9LCFIx86i2Ki9gKSn53tJfxkFLNON7DEM3LjyX8/PhmCbJDpWd13NUo2nCrvB6wGfmv6@vger.kernel.org
X-Gm-Message-State: AOJu0Yya2fcayzGnCg2dFsN2bEdeS+QAuWxOFASL+/Tyzl1ATzRxG1FL
	OiptLoQAqPCzbUFV9f3+IeYF9zhawJH43sPVsu7p4x2yV85aDjZ9g/H4Pkcp0HlI1D4=
X-Gm-Gg: Acq92OFCasnfEbdwq98KoDPEU8DPFGAmY2YKe/yVpMrhA+Wo+Cb+jKPcz5Cb0w5GNf1
	09hkh+RuyvnhSG4ryO8RaniyhNqxLy+c7D125esZDKf2R6LMhDJDRKy7CAbBe4KVZ/tYlos4keY
	FJVClU02qCx9c1E7xIUqQQRNcDXsGOTt4hgiPhIV9YWJzGldTy+WHCJZ4k3j7fz6Klfcm1TrAet
	tbsDhpwslzv+UTdTifUlg0GzylTNuZbuLtnq5TAJMjYspRzaARHChlKiTGj/2P53vQN+3StrR+U
	WgPVwtbviARBq0itGOr1tnweLtV59Ps94eI8r+IeNJxApaRa2y1fxaqTbF+ZoKGS+uwVLZlOxDV
	/OvIl5gIwHNVg1zTI0zLIDaGW6lglaCuNvJEyaf/o8TRWoEU3eifi0fG3f6Nk9c413uedHev4dd
	YKxlfXH9RPAgUBjlj8n/P5wenuE8sBQ1MsnF/seAMOkb0gGaCmbZKGG45g7B/nawNJBjAbCxPG9
	e4IHVxt9eDpEq0PCj9/lODF7DIZ0Ikh8/lSR1+aya/ATrZekhP1YzF1jA==
X-Received: by 2002:a05:600d:108:10b0:490:53b0:9e5a with SMTP id 5b1f17b1804b1-49053b09ff3mr33788005e9.5.1779576424144;
        Sat, 23 May 2026 15:47:04 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56ce2cdsm53850345ad.29.2026.05.23.15.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 15:47:03 -0700 (PDT)
Message-ID: <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
Date: Sun, 24 May 2026 08:16:58 +0930
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
In-Reply-To: <20260523142344.GC183694@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/23 23:53, David Sterba 写道:
> On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
>> Recently kernel RAID56 lib is trying to remove the unexpected
>> single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
>> btrfs still supports such setup, which means in the long run btrfs has
>> to handle such corner case by ourselves.
>>
>> Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
>> P/Q stripes all match each other, rotation also makes no difference.
>>
>> This patch will disguise those single-data-RAID56 chunks as
>> RAID1/RAID1C3 chunks.
> 
> I don't think this is the right way to fix it. Calculations are an
> implementation detail and should be done at the time of the xor_gen or
> raid6_call, not touching the upper level structures related to format.
> 
> Instead, please add helpers that take the same parameters and do the
> switch if there's the edge case of raid5 or raid6, using memcpy. Thanks.

I'd say going dedicated memcpy() is an adhoc fix, and not any easier to 
maintain.

Now you have two paths, one from the raid56 lib, one from the btrfs 
specific handling for the single-data specific corner case, and that no 
one else is going to review/utilize that corner case.

 From this point of view, reusing the existing RAID1/RAID1C3 is way more 
reliable and sane.

