Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4EC2C0284
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 08:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765960409; cv=none; b=FJwPzlVNR8fWEypveDF/rgFbRduaWc23Fze5UiZVvAXmJaSK71l/Je7mpGZoQ3zjprFuUs2LZZL2RZp0DRIfssL8NYMzxpKz8v3eE053T5FKk/9MrvVwpMT4MUa/vy3vg2a/NAdHAvvZ1NRjKstwyt8MebplZjy/KppVQVd3xQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765960409; c=relaxed/simple;
	bh=cEhqQF+oEye5LxtG32jLoz/HcM6kT9fPsW1x6b/48t4=;
	h=To:References:In-Reply-To:Mime-Version:Content-Type:Cc:Subject:
	 Message-Id:From:Date; b=Rdrl6s/KGq+px05uc3IDpV1dgKGHzF7nHfYTrZqIaKeANTENdJP8nx3mT4IXMy/xkP74HSXI+RaNJakBdxONHTyYj2CQt3hb7YZokNJ8Ft7BS4e/RG3nlRqK2iocI8eux8QMI4D6lQ9B56EkdtbBlc7cz4blF7+TipxwUSu0840=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=h/tBQ9H5; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="h/tBQ9H5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1765960399;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=XFicmXaUPXJZtX7J0cd76Tgy9ZjX5dYeS4C5ywpYBA0=;
 b=h/tBQ9H5fkl3G3/fxEKuyTtBJwjMd0YyDuB4ZkX1frcjXSHs7axt6qEEOu2PYzxVA3zmse
 w2jewKwzPfC4/sJFTFWXR7RUrah+c+rNJPrEc+cqWVI/eYJGuD9TGF1OQav+G4gD8CgUjH
 9+pguXpIJ4uVAYBmpJahYU5vkcVRAKxN3OsZrGPqd1MzT+Eci2h6FFzYYND+WHkyw6e03M
 ozw/UKUSOG2MnLW6FptUwpoAya4BjnQC64O8E0jkt+v3l9se9lABu48W5xLgFg4Chrc6Mm
 50kRsL42ID/351ZfHqSwkMl3gWXekfXY7aja4Sik9Xu1X+N2uE6vi8xfLLL1Jg==
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
To: "Reindl Harald" <h.reindl@thelounge.net>, 
	"Paul Menzel" <pmenzel@molgen.mpg.de>
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com> <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com> <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com> <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com> <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de> <edbb5ba0-454a-4929-84a0-2e5b40d3ec25@fnnas.com> <2339e7f8-2369-4d77-a2fc-57b72dff6c94@thelounge.net>
In-Reply-To: <2339e7f8-2369-4d77-a2fc-57b72dff6c94@thelounge.net>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Wed, 17 Dec 2025 16:33:15 +0800
Content-Type: text/plain; charset=UTF-8
Cc: <bugreports61@gmail.com>, <linux-raid@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <regressions@lists.linux.dev>, 
	"Linus Torvalds" <torvalds@linux-foundation.org>, <yukuai@fnnas.com>
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19-rc1 once
Content-Transfer-Encoding: quoted-printable
Message-Id: <e8ed6876-7a27-4ef4-a4ea-841cf251f656@fnnas.com>
X-Lms-Return-Path: <lba+269426acd+f2a5bd+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Wed, 17 Dec 2025 16:33:14 +0800

Hi,

=E5=9C=A8 2025/12/17 16:02, Reindl Harald =E5=86=99=E9=81=93:
>
>
> Am 17.12.25 um 08:41 schrieb Yu Kuai:
>>>>> We'll have to backport following patch into old kernels to make
>>>>> new arrays to assemble in old kernels. ....
>>>>>
>>>>> The md array which i am talking about was not created with kernel
>>>>> 6.19, it was created sometime in 2024.
>>>>>
>>>>> It was just used in kernel 6.19 and that broke compatibility with
>>>>> my 6.18 kernel.
>>>>
>>>> I know, I mean any array that is created or assembled in new kernels
>>>> will now have lsb field stored in metadata. This field is not
>>>> defined in old kernels and that's why array can't assembled in old
>>>> kernels, due to unknown metadata.
>>>>
>>>> This is what we have to do for new features, and we're planning to
>>>> avoid the forward compatibility issue with the above patch that I
>>>> mentioned.
>>> Is there really no way around it? Just testing a new kernel and being
>>> able to go back must be supported in my opinion, at least between one
>>> or two LTS versions.
>>
>> As I said, following patch should be backported to LTS kernels to=20
>> avoid the problem.
>> https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@hua=
weicloud.com=20
>>
>
> that's nothing you can rely on - yo can write as many pachtes as you=20
> will but if and when they are included in random binary kernels is not=20
> controllable
>
> the current situation is somebody tests a new kernel and after that=20
> his RAID got unrevertable changed and can't be used with the previous=20
> kernel
>
> that's not expectable nor acceptable

I'll explain a bit more about the lbs.

There is a long long term problem from day one, and reported several times,=
 that array data
can be broken when:
  - user add a new disk to the array;
  - some member disks are failed;

lbs in metadata is used to fix this problem. However, mdraid is designed to=
 refuse new metadata
fields, this doesn't make sense but that's the fact.

Any array that is assembled or created in new kernels will have lbs filed s=
tored in metadata, to
prevent the data loss problem. I know we're not expecting forward compatibi=
lity issue, but I don't
think this is not acceptable. We'll provide a solution but we can't guarant=
ee for any binary
kernels.

--=20
Thansk,
Kuai
