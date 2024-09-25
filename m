Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2818D1487FF
	for <linux-raid@vger.kernel.org>; Wed, 25 Sep 2024 06:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727246393; cv=none; b=exbXpjpV4M24jYO8X4hq/0QbbrPaQLDwwlmxMbrQmbdODracUo0j8acKMOTnGcC4+Qi+Bix5d/ZXVnZftuHiTDKAsPmj9INlIw86qi/lz9kTo83rOcnlYvoOQnMU12/VHQhYqbOGhwDoK3EIQ3TIC7IT9LMgCnIa/0Ex79Af+OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727246393; c=relaxed/simple;
	bh=cS/7bIC5NKpyAbWYM+nrkGiqixgrkrPFZleHAHK2b/4=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=lBydIjN9Pl94HGYyGhtmasMxecxRpJre9siWeG4k62FVoNj+eRbn2nv3Zr3jB1c3KVnOdCJ/YiaGd4dfQ68ZnoTVs1nHcbkll1muLxrSX0i8/KzyDiQxgaw5tePqUIMUaIFqLFQNch3xFvfK3QN/R+ji3OqWKGpKmeE6wwwrG7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (2048-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=HzJVMTlO; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="HzJVMTlO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	s=dkim; h=In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:
	Date:Message-ID:Content-Type:Sender:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZUslx0HSqU1C1xsEnKb8TosSo2KLqwk9cs00eu6zwsM=; b=HzJVMTlO8uN8iQrLkMhoLtRsai
	3/g7SMjcKqVCpXp3aybNNuD6+tavJSG34zp1MHv6AkSjU7S/CC91sX0j0JHdr2Bpl69QRQd2YhwPE
	Fi6jyCcfbJGtAo635iRg7q2RRqviTNdo0VUIpS9fj3xsLT8MOvC6ETbOmx7tu2fdlzNVZ8MaEMqUn
	OIYvbMuNPvkUXhPuRSedaBtcOdndhvNwtIP/+FgjxxdX9mN2XAO5yaFAgBlefTDfIDS0JNT4gVTTv
	3kIGixs45IrfGnBDRxmUbP9Ens1qRj9q55wacmcESKlANMQ+z/EQMpU1uHY5d4/3dyPwHWnXOR2VX
	pcZd+aaQ==;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1stLgO-00000005jJe-2z3g;
	Wed, 25 Sep 2024 08:39:31 +0200
Content-Type: multipart/mixed; boundary="------------MWME976fS5z0JU0G06CUkqBY"
Message-ID: <2c0ba4e9-f48f-4a92-ad4d-697b60c01d9d@justnet.pl>
Date: Wed, 25 Sep 2024 08:39:24 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Reply-To: adam.niescierowicz@justnet.pl
Subject: Re: RAID 10 reshape is stuck - please help
To: William Morgan <therealbrewer@gmail.com>
Cc: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com>
 <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
 <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
 <CALtW_ajc4rx4Xfh4+6EtGLQm82A7upro8wF5y8WuXuHS=KJVEQ@mail.gmail.com>
 <89cde0bc-ebf6-48d6-80da-59d93fb4757f@justnet.pl>
 <CALc6PW5myLPmvzfopxQ6YZQeYxMT76J3w36mJpM+fszoSEWXrg@mail.gmail.com>
Content-Language: pl
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <CALc6PW5myLPmvzfopxQ6YZQeYxMT76J3w36mJpM+fszoSEWXrg@mail.gmail.com>
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------MWME976fS5z0JU0G06CUkqBY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


W dniu 23.09.2024 o 23:42, William Morgan pisze:
> On Thu, Sep 19, 2024 at 3:19 AM Adam Niescierowicz
> <adam.niescierowicz@justnet.pl> wrote:
>
>>    We had similar problem with disk reset.
>>
>> In our situation problem was with power. When array started check or
>> rebuild disk power consumption went up and circuit on the board doesn't
>> have enough capacity.
>>
>> --
>> ---
>> Regards,
>> Adam Nieścierowicz
> I find it hard to believe that my 850 watt power supply is not
> sufficient for 10 drives which draw 10 watts each (100 watts total).
> There is nothing else connected to that power supply.

In our case the problem wasn't power supply but connections.

Are the drives connected with one power line to power supply?

Each power line or power connector has a limit (depends on the power 
supply construction). We have like 12 drive and power supply 850W but 
power distribution wasn't good enough to support rebuild of the array 
and intensive all drive usage.

Remember that 850W is for all connection, like in attached spect power 
supply is 465W but 12V is only 340 separated on two outputs.

Power supply example: https://pasteboard.co/e6M0r3jW01Au.png


-- 
---
Pozdrawiam
Adam Nieścierowicz

--------------MWME976fS5z0JU0G06CUkqBY
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------MWME976fS5z0JU0G06CUkqBY--
