Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84574260569
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 08:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.118.73.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765959592; cv=none; b=BGVncstLwUyddGw2Pro3G3ybqXSMrErVLNBEEKadDhourm52ZITz7gCKLU0E0B8sqygoVCX79Lp5pC2lqVgSwgjODMpaIyqHri5NAfKa/WHPb8sUMxfOaarBJighkXJhYJ8lxtpg3dMiXoqJ08Ft9jzmnLP5DvbVhR2ejHaJtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765959592; c=relaxed/simple;
	bh=5aiJ/6jFdRt6+GAhD3PaJmFsFLWy5GzrRgO9iyYBD4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fO/pWWaAUAlkYsvEGuDAzhe8/6/2HFEJUXcLnTS66OHmq+XTiBWV3SFCLEV9FCEH3oqYD1jjaF3qFN0eOB/cbejq7NT2TmQODOBYAUwpo+IsQTHtBq0JEHedy8/jSwENoFT8hmGOxpuYBRi3k3LadTOAxKWPFsUzEi7SokbOG9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net; spf=pass smtp.mailfrom=thelounge.net; arc=none smtp.client-ip=91.118.73.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelounge.net
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: h.reindl@thelounge.net)
	by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4dWR8q5B1lzXlL;
	Wed, 17 Dec 2025 09:02:03 +0100 (CET)
Message-ID: <2339e7f8-2369-4d77-a2fc-57b72dff6c94@thelounge.net>
Date: Wed, 17 Dec 2025 09:02:03 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel
 6.19-rc1 once
Content-Language: en-US
To: yukuai@fnnas.com, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: bugreports61@gmail.com, linux-raid@vger.kernel.org, linan122@huawei.com,
 xni@redhat.com, regressions@lists.linux.dev,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
 <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
 <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de>
 <edbb5ba0-454a-4929-84a0-2e5b40d3ec25@fnnas.com>
From: Reindl Harald <h.reindl@thelounge.net>
Autocrypt: addr=h.reindl@thelounge.net; keydata=
 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
 K4rYsjPimkSIVdrNM//wVKdCTbO+
Organization: the lounge interactive design
In-Reply-To: <edbb5ba0-454a-4929-84a0-2e5b40d3ec25@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



Am 17.12.25 um 08:41 schrieb Yu Kuai:
>>>> We'll have to backport following patch into old kernels to make
>>>> new arrays to assemble in old kernels. ....
>>>>
>>>> The md array which i am talking about was not created with kernel
>>>> 6.19, it was created sometime in 2024.
>>>>
>>>> It was just used in kernel 6.19 and that broke compatibility with
>>>> my 6.18 kernel.
>>>
>>> I know, I mean any array that is created or assembled in new kernels
>>> will now have lsb field stored in metadata. This field is not
>>> defined in old kernels and that's why array can't assembled in old
>>> kernels, due to unknown metadata.
>>>
>>> This is what we have to do for new features, and we're planning to
>>> avoid the forward compatibility issue with the above patch that I
>>> mentioned.
>> Is there really no way around it? Just testing a new kernel and being
>> able to go back must be supported in my opinion, at least between one
>> or two LTS versions.
> 
> As I said, following patch should be backported to LTS kernels to avoid the problem.
> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huaweicloud.com

that's nothing you can rely on - yo can write as many pachtes as you 
will but if and when they are included in random binary kernels is not 
controllable

the current situation is somebody tests a new kernel and after that his 
RAID got unrevertable changed and can't be used with the previous kernel

that's not expectable nor acceptable

