Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9C359F8E;
	Wed, 17 Dec 2025 13:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765976845; cv=none; b=fb95SaWqd2WOuBGiyZRi0J6FQSVVNjXsu2JBukiM+df1EfBFFV+3Xx2/NugYe7GYCU8lNIAGzejH0UnvyZFOMVYLXmlwYqVrMTxSOzTaGExdbiV4eBT3dBYjCpHNNGlvmUDNBuHPqkIGQo1cFGWe/ahM7Els776x1+KwGtNhNn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765976845; c=relaxed/simple;
	bh=3j5lxOlZ+HboqJPioazJsC5pw6X+bAHt29g9hKcSzko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OtaVSs7KP5XsN27k84ZnVeYY1AIFOtSSC72veSP3ZNlfbMinsPbPyhOAIRYg/QLYNplhOA7aoa0RiL68EzSR1I36B5jF0qwOx8lmqrnKRCbMTpfrsdBL6tRr6Kmvf2yAAEFCPZgR8KOxLxGsDEr81RBzuf5X0BTR4sSUpdXmUdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=mWX6ENJF; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="mWX6ENJF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=7dZ/jh8iJ5MnrEWUt/6nzdzwUfQ+B3gqxq5MzyY5eFo=; t=1765976843;
	x=1766408843; b=mWX6ENJFZmmEK+eNysdroKJ5KifGUVyOpUV3WsikoCJC9EZblN/n5o5Q7jwDd
	Lu4DF2PcaMzYECbIKlvVr8jgHqWI6xQKRnWsFHTPvvaDbnvX5WX9KfuBeKH/Vgro2irBziyRvCCO+
	w5d8La/EkI1aUWy1uzwzn3b7HUzZg/MEja/M40J/YrMe+JgLsZGRdv0cI1Bo890tUzoPky4OOz3XF
	EjmX2yrrfYzNTkcny+jIs2nnCNanbuqX9NXHWxXS3MuMbwYaeG6egQTdrk98Ni1+8rNH8aBPukEFp
	jISVV9EdMt4QDTOL4WKSxvOtIdFBKH8iMErQWIcYHefFjNHY2g==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1vVrFL-00FQiV-0E;
	Wed, 17 Dec 2025 14:07:15 +0100
Message-ID: <d29e8783-84a8-4e90-9251-c63189b71630@leemhuis.info>
Date: Wed, 17 Dec 2025 14:07:14 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel
 6.19-rc1 once
To: Jens Axboe <axboe@kernel.dk>
Cc: bugreports61@gmail.com, linux-raid@vger.kernel.org, linan122@huawei.com,
 xni@redhat.com, regressions@lists.linux.dev, yukuai@fnnas.com,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Paul Menzel <pmenzel@molgen.mpg.de>, Reindl Harald <h.reindl@thelounge.net>,
 Song Liu <song@kernel.org>
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com>
 <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com>
 <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com>
 <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com>
 <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de>
 <edbb5ba0-454a-4929-84a0-2e5b40d3ec25@fnnas.com>
 <2339e7f8-2369-4d77-a2fc-57b72dff6c94@thelounge.net>
 <e8ed6876-7a27-4ef4-a4ea-841cf251f656@fnnas.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <e8ed6876-7a27-4ef4-a4ea-841cf251f656@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1765976843;8fc02ab2;
X-HE-SMSGID: 1vVrFL-00FQiV-0E

Bringing Jens in (and Son Liu, too), as the patches that cause this
afaics went through his tree -- so he is the right point of contact in
the hierarchy.

FWIW, thread starts here:
https://lore.kernel.org/all/b3e941b0-38d1-4809-a386-34659a20415e@gmail.com/

Problem rough and short afaiui: mdraids assembled with 6.19-rc1 can not
be mounted with 6.18 any more; see below for details. That to my
understanding of things is not okay, even if it could be fixed by
backporting a patch (which is a option here)

Ciao, Thorsten

On 12/17/25 09:33, Yu Kuai wrote:
> 在 2025/12/17 16:02, Reindl Harald 写道:
>> Am 17.12.25 um 08:41 schrieb Yu Kuai:
>>>>>> We'll have to backport following patch into old kernels to make
>>>>>> new arrays to assemble in old kernels. ....
>>>>>>
>>>>>> The md array which i am talking about was not created with kernel
>>>>>> 6.19, it was created sometime in 2024.
>>>>>>
>>>>>> It was just used in kernel 6.19 and that broke compatibility with
>>>>>> my 6.18 kernel.
>>>>>
>>>>> I know, I mean any array that is created or assembled in new kernels
>>>>> will now have lsb field stored in metadata. This field is not
>>>>> defined in old kernels and that's why array can't assembled in old
>>>>> kernels, due to unknown metadata.
>>>>>
>>>>> This is what we have to do for new features, and we're planning to
>>>>> avoid the forward compatibility issue with the above patch that I
>>>>> mentioned.
>>>> Is there really no way around it? Just testing a new kernel and being
>>>> able to go back must be supported in my opinion, at least between one
>>>> or two LTS versions.
>>>
>>> As I said, following patch should be backported to LTS kernels to 
>>> avoid the problem.
>>> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huaweicloud.com 
>>>
>>
>> that's nothing you can rely on - yo can write as many pachtes as you 
>> will but if and when they are included in random binary kernels is not 
>> controllable
>>
>> the current situation is somebody tests a new kernel and after that 
>> his RAID got unrevertable changed and can't be used with the previous 
>> kernel
>>
>> that's not expectable nor acceptable
> 
> I'll explain a bit more about the lbs.
> 
> There is a long long term problem from day one, and reported several times, that array data
> can be broken when:
>   - user add a new disk to the array;
>   - some member disks are failed;
> 
> lbs in metadata is used to fix this problem. However, mdraid is designed to refuse new metadata
> fields, this doesn't make sense but that's the fact.
> 
> Any array that is assembled or created in new kernels will have lbs filed stored in metadata, to
> prevent the data loss problem. I know we're not expecting forward compatibility issue, but I don't
> think this is not acceptable. We'll provide a solution but we can't guarantee for any binary
> kernels.
> 

