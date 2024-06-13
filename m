Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF50B13A24A
	for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.118.73.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718312002; cv=none; b=ig4HRMKKxr4rGCyD4oz3wVKlrNf3ax0qompXJXNQI6ZCNz73AkB4LnH1HGKlnp7uYGNwsDKRUSCwJi3hetINuSDa9V+Hwpqxmf77PBNLV/XtYH/9Kk8YGifAX//70i5BrSyTFWgNwEHx9u272ASVX1qiuvhS6JwP92hWzJWJyqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718312002; c=relaxed/simple;
	bh=Uccs7gDmgUYzcy3gY1iaWLa4LGLv1SJyw1G0Q2u1gLE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s7Q82TNOB3IbBsQiltaYWyPc7Jp/f6haiuxpmb+NtjlPZpwem2ZC5GSsPR7c4okpDqfCB21wECRmajRJ+j50yjvnNsjMC/Sfkm45h5R6NZBMzC4ZOeQrdOA/a+zYwQnbC1da6OxyADID0PZxu/5WdEHX7lEihMTFUvUyDLQ7ams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net; spf=pass smtp.mailfrom=thelounge.net; arc=none smtp.client-ip=91.118.73.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thelounge.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thelounge.net
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: h.reindl@thelounge.net)
	by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4W0ZPR23NFzXKn;
	Thu, 13 Jun 2024 22:53:15 +0200 (CEST)
Message-ID: <776ce696-818d-404c-95b5-cf8f3238b22d@thelounge.net>
Date: Thu, 13 Jun 2024 22:53:15 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID-10 near vs. RAID-1
Content-Language: en-US
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: linux-raid@vger.kernel.org
References: <ZmiYHFiqK33Y-_91@lazy.lzy>
 <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
 <ZmnZYgerX5g8S9Cp@lazy.lzy>
 <8eea69b5-4abb-46b6-8c7b-05c7ea0bf591@thelounge.net>
 <CALtW_ai69FCuHCMRDMzTxiEb6Yg22yd9vr+2d5_Ya1GSPbacRA@mail.gmail.com>
 <393c09c3-605b-475a-a61c-8e0306c7e9e6@thelounge.net>
 <CALtW_agtMXsss_Y=A2HH+D5zTceJ0jv5eWM5OeKiRZphvVeXZw@mail.gmail.com>
 <599595a2-fa5e-45ca-b358-5fb573a8920e@thelounge.net>
 <CALtW_aiOGWYZicL2h+KcFRhoXb2bAZM=dwG-=zVzCcS_eVm+sg@mail.gmail.com>
 <fb61f96f-a92b-414d-a990-76c7accb9d8b@thelounge.net>
 <CALtW_ageds8cA-3CgbSNW5sFmRvWGmqoM0vA1vbi5LxWLhgt7g@mail.gmail.com>
From: Reindl Harald <h.reindl@thelounge.net>
Autocrypt: addr=h.reindl@thelounge.net; keydata=
 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
 K4rYsjPimkSIVdrNM//wVKdCTbO+
Organization: the lounge interactive design
In-Reply-To: <CALtW_ageds8cA-3CgbSNW5sFmRvWGmqoM0vA1vbi5LxWLhgt7g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Am 13.06.24 um 22:27 schrieb Dragan Milivojević:
>>> full test log: https://pastebin.com/raw/eq2CbjY7
>> not very appealing
>>
>> Sequential 4k read, single disk                  |  828k | 3233MiB/s
>> Sequential 4k read, 2 disk RAID10F2, 64k chunk   |  523k | 2044MiB/s
>>
>> RAID0 is off-topic when it comes to RAID1/RAID10 with two disk and not a
>> RAID at all
> 
> There is a reason why I included the RAID0 results. It seems that you desire
> to argue for the sake of argument, so I will stop responding to your messages.

i am thrilled to hear the reason why you compare RADI0 with RAID10 but 
no RAID1 when the whole question is "do i gain anything with a cripppled 
RAID10 with two disks versus a ordinary RAID1"

i could understand the reason to *additionally* add RAID0 while 
everybody knows it's faster but the opposite of redundancy

coming up with "RAID10 versus RAID0" is idiotic
