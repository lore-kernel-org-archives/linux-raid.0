Received: from se.sotapeli.fi (se.sotapeli.fi [206.168.212.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBBE1DF75B;
	Tue, 25 Nov 2025 22:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.168.212.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110786; cv=none; b=H0tYQT/BZFWrf1WxrBA4FXbHAA7PuHlaSZ2m7u6dPsLe2l/9yAIUMWTNYmk2aehFoQ/Rw9iC4F2LSADWH/LVHFQ7Nv9Ab9eMEqu+JXgx7w0pCn4CS3xJAtQSplM317pMtYUFYsQmutk4KvhIUV68Y/k9O67eSHZY1L/tCceq1+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110786; c=relaxed/simple;
	bh=AXJBXw21+slc1wyBt2XSWVKwaTGgCJsu3+ROtMqOeDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g3g7oQOHek51q48ihp8iCFEqlFuGGQ8vaxZE/uugPaG170UpatHtsi9019IcZCOQM6BLr6/eMFabg6/OTXycy/keRx0DYZaCtMYW6sQN0+1MQOJkED7ZnYRJAMIlVx63MQUf/uiNvL280dadZLnJvpna7gbXou4KCjIyYjK8ukU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sotapeli.fi; spf=pass smtp.mailfrom=sotapeli.fi; dkim=pass (2048-bit key) header.d=sotapeli.fi header.i=@sotapeli.fi header.b=o1KMyBTq; arc=none smtp.client-ip=206.168.212.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sotapeli.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sotapeli.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sotapeli.fi header.i=@sotapeli.fi header.b="o1KMyBTq"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5A919181AA00;
	Tue, 25 Nov 2025 23:37:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sotapeli.fi; s=dkim;
	t=1764110235; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references:autocrypt;
	bh=hDjMNlZqfDqbIvK2U/5mC/00Bl2Hc2xccMDPXlkxTCc=;
	b=o1KMyBTqF7/Cf4k41ckSO6jHSI6GgsNgQERvK9BtgrJU5g9rLmwtCnksFNq3n9D4X1TPqw
	Wz0GA3ZouHNPpt+LjxOhxarh9V5lsj3cHy/bC2cPba+8lboiHjUxWQYkKqVa6pajBgw0Vh
	+lcj2fbEShDgYNXdqB3qDhNwyeNGUzu2yWjycTXpfVUvf9mnDwSuFl/oLGPB4AOSB3oU7m
	8vhRbkbCF2RqBEKcED9hh0h0p9CMEfA8hxBxanE8hIUigH3nYo9pLU3qDfGxj0PGOY3663
	n+1umShlz1x+Due5MvPnl/N+bHuWiKB/YqjwHPMZRJdMnHEMTZhpl2d1BZ0w7Q==
Message-ID: <8d03ba23-6677-4002-82cd-21502c42821a@sotapeli.fi>
Date: Wed, 26 Nov 2025 00:37:06 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org,
 linux-raid@vger.kernel.org
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
 <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
Content-Language: en-US
From: Jani Partanen <jiipee@sotapeli.fi>
Autocrypt: addr=jiipee@sotapeli.fi; keydata=
 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
In-Reply-To: <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

On 25/11/2025 17.19, Dragan Milivojević wrote:
>> Issue/Summary:
>> 1. Usually once a month, a random WD Red SN700 4TB NVME drive will
>> drop out of a NAS array, after power cycling the device, it rebuilds
>> successfully.
>>
> Seen the same, although far less frequent, with Samsung SSD 980 PRO on
> a Dell PowerEdge R7525.
> It's the nature of consumer grade drives, I guess.

I dont know if this WD issue is same issue that I had with WD_BLACK 
SN770 2TB drive, but I share what I know anyway.

That drive cannot handle 4K LBA. It works fine with 512k LBA, but with 
4K it will die sooner or later, usually when you hit it with heavy IO.

WD has know this for years and havent done anything. So I think it is 
safe to say that its hardware issue what cannot be fixed with firmware, 
other than disabling ability to even switch to 4K LBA but they havent 
done that. What it turns tell me how much they care. Good thing is that 
there is other brands.

Lot of talk about that issue here: 
https://github.com/openzfs/zfs/discussions/14793

I think there was also some other WD drives suffering this same issue.

And this is nothing to do with linux or zfs, its purely WD drive issue 
because I originally got it in windows, then switched drive to linux to 
test it out and same happened with linux.


// Jani


