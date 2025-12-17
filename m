Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E2834AAFC
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 13:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765979165; cv=none; b=Ydo72EsB3XeaNAkf1uFVRZzWjIpjYN2eCMLADcpl3VROHJlNl1Grez74TApDGlvh/GiFWnSrniKe0uI2dhVDGyuurGhOce5I2E22fK4VfyV64Jcsd1yn/oMHRZYdfdAlKnIHLfey/PxeXoYZv3p9ZbBP71Wby6d71ePGf6V3Y9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765979165; c=relaxed/simple;
	bh=0BNAMe0dW+gA/iHtvm6pPp+zOapexna2wUlbZVkq/x8=;
	h=In-Reply-To:Mime-Version:Content-Type:To:Cc:Date:Message-Id:
	 References:From:Subject; b=TKNe8zPvbHB+THhLPIEvaaEuAjtM9GqwbrtfeT9QTj97pYcMPxwoiGzrPNxScHAX5856YvJ8ddmYMTrSFLa5/tUUmFfycbzu1aDk2LN2GcQxQo5ieX7QZRriQid4v9KcirMrYoCzOhmcyvgFb1bvcnpttTY7am2QHTUzBEKoYik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=r22hX8Co; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="r22hX8Co"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1765979149;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dp4m0nD5Jic4FiKmiZGDkOzNEeU71Bjv7chlXUlMRP0=;
 b=r22hX8CogRGhoDQ7yR1mdaG9M56BVRdbMlbs++VAVLIgWGEdomtmCY3Yr5/oZBHkRwQQId
 59uo7msHvSnbhlQLOQR1ZO12RBAX5KQAxQfNGvy827bZh7NosrXTSo/JhIgQ2Z5NN+5Exz
 n8m21YL07HEofHnAcuELaAeFpPwEzi7gyYtbjpNKq9FlsMg2DsbOU79uyN6HRB2t0BmagO
 kNWN/dQ76/qIjnqz8BfkMVbeAyTUvFEm7ff0bTqhJaZFDNdkDLeJcUAkgIODfYEhmg8G6Z
 a6raM2dy7EA4osda5gQIAh/moiwVHqlcauNWJ95Y5270PWrNQyWRYmawiuCVkg==
In-Reply-To: <d29e8783-84a8-4e90-9251-c63189b71630@leemhuis.info>
X-Lms-Return-Path: <lba+26942b40b+fc4673+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Wed, 17 Dec 2025 21:45:46 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
To: "Thorsten Leemhuis" <regressions@leemhuis.info>, 
	"Jens Axboe" <axboe@kernel.dk>
Cc: <bugreports61@gmail.com>, <linux-raid@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <regressions@lists.linux.dev>, 
	"Linus Torvalds" <torvalds@linux-foundation.org>, 
	"Paul Menzel" <pmenzel@molgen.mpg.de>, 
	"Reindl Harald" <h.reindl@thelounge.net>, "Song Liu" <song@kernel.org>, 
	<yukuai@fnnas.com>
Date: Wed, 17 Dec 2025 21:45:44 +0800
Message-Id: <0f44559f-7732-4506-922f-04a244d54c35@fnnas.com>
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com> <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com> <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com> <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com> <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de> <edbb5ba0-454a-4929-84a0-2e5b40d3ec25@fnnas.com> <2339e7f8-2369-4d77-a2fc-57b72dff6c94@thelounge.net> <e8ed6876-7a27-4ef4-a4ea-841cf251f656@fnnas.com> <d29e8783-84a8-4e90-9251-c63189b71630@leemhuis.info>
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19-rc1 once

Hi,

=E5=9C=A8 2025/12/17 21:07, Thorsten Leemhuis =E5=86=99=E9=81=93:
> Bringing Jens in (and Son Liu, too), as the patches that cause this
> afaics went through his tree -- so he is the right point of contact in
> the hierarchy.
>
> FWIW, thread starts here:
> https://lore.kernel.org/all/b3e941b0-38d1-4809-a386-34659a20415e@gmail.co=
m/
>
> Problem rough and short afaiui: mdraids assembled with 6.19-rc1 can not
> be mounted with 6.18 any more; see below for details. That to my
> understanding of things is not okay, even if it could be fixed by
> backporting a patch (which is a option here)

AFAIK, possible options:
1) always set lbs for arrays for new kernel, and backport the patch for
old kernels so that users can still assemble the array.(current option)
2) only set lbs by default for new array, for assembling the array still
left the lbs field unset, in this case the data loss problem is not fixed,
we should also print a warning and guide users to set lbs to fix the proble=
m,
with the notification the array will not be assembled in old kernels.
3) revert the new feature to set lbs for mdraids.

>
> Ciao, Thorsten
>
> On 12/17/25 09:33, Yu Kuai wrote:
>> =E5=9C=A8 2025/12/17 16:02, Reindl Harald =E5=86=99=E9=81=93:
>>> Am 17.12.25 um 08:41 schrieb Yu Kuai:
>>>>>>> We'll have to backport following patch into old kernels to make
>>>>>>> new arrays to assemble in old kernels. ....
>>>>>>>
>>>>>>> The md array which i am talking about was not created with kernel
>>>>>>> 6.19, it was created sometime in 2024.
>>>>>>>
>>>>>>> It was just used in kernel 6.19 and that broke compatibility with
>>>>>>> my 6.18 kernel.
>>>>>> I know, I mean any array that is created or assembled in new kernels
>>>>>> will now have lsb field stored in metadata. This field is not
>>>>>> defined in old kernels and that's why array can't assembled in old
>>>>>> kernels, due to unknown metadata.
>>>>>>
>>>>>> This is what we have to do for new features, and we're planning to
>>>>>> avoid the forward compatibility issue with the above patch that I
>>>>>> mentioned.
>>>>> Is there really no way around it? Just testing a new kernel and being
>>>>> able to go back must be supported in my opinion, at least between one
>>>>> or two LTS versions.
>>>> As I said, following patch should be backported to LTS kernels to
>>>> avoid the problem.
>>>> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@h=
uaweicloud.com
>>>>
>>> that's nothing you can rely on - yo can write as many pachtes as you
>>> will but if and when they are included in random binary kernels is not
>>> controllable
>>>
>>> the current situation is somebody tests a new kernel and after that
>>> his RAID got unrevertable changed and can't be used with the previous
>>> kernel
>>>
>>> that's not expectable nor acceptable
>> I'll explain a bit more about the lbs.
>>
>> There is a long long term problem from day one, and reported several tim=
es, that array data
>> can be broken when:
>>    - user add a new disk to the array;
>>    - some member disks are failed;
>>
>> lbs in metadata is used to fix this problem. However, mdraid is designed=
 to refuse new metadata
>> fields, this doesn't make sense but that's the fact.
>>
>> Any array that is assembled or created in new kernels will have lbs file=
d stored in metadata, to
>> prevent the data loss problem. I know we're not expecting forward compat=
ibility issue, but I don't
>> think this is not acceptable. We'll provide a solution but we can't guar=
antee for any binary
>> kernels.
>>
--=20
Thansk,
Kuai
