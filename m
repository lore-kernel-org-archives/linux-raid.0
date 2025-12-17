Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7BB21772A
	for <linux-raid@vger.kernel.org>; Wed, 17 Dec 2025 07:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765957282; cv=none; b=PkHbX8cQzsVjiLddd4jSEwpzICxdfV0cvc+YTD8T5O7/cv312PohC/rbmaptSEUWb2zDIaI55Pbgt+ufH8A1WOrHTn+nRl8/vBEqaJ9gWSThoXzFGHAkwRqQbdG7Zm9K4u5BSW0FzBnztS6XyQtwkX6IqkCXO2r170TdxdyiOJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765957282; c=relaxed/simple;
	bh=gc7s9z0mCMLd31I/fcVEjVE4T8EBwefE/UsTn3a39MM=;
	h=From:Subject:Message-Id:Mime-Version:Content-Type:Date:References:
	 Cc:In-Reply-To:To; b=eWKeTTOtd8XGkZwxWMTANwoyGHHDcfPj9JYlxT/D63Bi5P6XIuzj9BR7hMZuNndce+k2vvYBxbTQTB1keGHv04+igrpcD31vOyBtrroXsc7GnnKGJ6TxX0t6EU4VFTkDe6XPoOY0GkWMZE5eATNcjhREE+3K5+SsKQZYhphwKLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=c/S33tsy; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="c/S33tsy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1765957273;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gc7s9z0mCMLd31I/fcVEjVE4T8EBwefE/UsTn3a39MM=;
 b=c/S33tsykDLNjTChPyhTgv+3hMEGSK6qjlzO3k9EuJprU075ODzQNaX28Eh+hjzR6H3B4L
 gFVwX9q+Fzce3s6rRc/CpI5PO6G6Hrs2QfP0Rm8PFoa+7wRoH8k7KwLFiW6XrYeNFerZ72
 WZer5BczLfhfYJrLQGFlNsR2shcD+JLeqbfcxf6mmLxX0wOEI8LbnDFFqtWLVGCHq8+fr2
 Z443jy+bCjnajZOAuoSNg2ofgaLhg7g17AJcuMKwa7oLalO19dEP1dr09To5sEPLhqwzwi
 jqqbtwfWDWD8lCHONyNTVKmgTmDxFM9ex7+3mg5Osw68IAuIt6Vf4Uz0BgNw5A==
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: Issues with md raid 1 on kernel 6.18 after booting kernel 6.19-rc1 once
Reply-To: yukuai@fnnas.com
Message-Id: <edbb5ba0-454a-4929-84a0-2e5b40d3ec25@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Wed, 17 Dec 2025 15:41:10 +0800
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Dec 2025 15:41:08 +0800
Content-Language: en-US
References: <b3e941b0-38d1-4809-a386-34659a20415e@gmail.com> <8fd97a33-eb5a-4c88-ac8a-bfa1dd2ced61@fnnas.com> <619a9b00-43dd-4897-8bb0-9ff29a760f52@gmail.com> <f20c3a92-d562-4ac2-98b6-39ff4f3e3bbf@fnnas.com> <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de>
User-Agent: Mozilla Thunderbird
Cc: <bugreports61@gmail.com>, <linux-raid@vger.kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <regressions@lists.linux.dev>, 
	"Linus Torvalds" <torvalds@linux-foundation.org>, <yukuai@fnnas.com>
In-Reply-To: <7cff4b89-eeff-4048-8af3-ef9d76bdedf8@molgen.mpg.de>
X-Lms-Return-Path: <lba+269425e97+04ae69+vger.kernel.org+yukuai@fnnas.com>
To: "Paul Menzel" <pmenzel@molgen.mpg.de>

Hi,

=E5=9C=A8 2025/12/17 15:33, Paul Menzel =E5=86=99=E9=81=93:
> Dear Kuai,
>
>
> Am 17.12.25 um 08:17 schrieb Yu Kuai:
>
>> =E5=9C=A8 2025/12/17 15:13, BugReports =E5=86=99=E9=81=93:
>>>
>>> ...
>>>
>>> We'll have to backport following patch into old kernels to make
>>> new arrays to assemble in old kernels. ....
>>>
>>> The md array which i am talking about was not created with kernel=20
>>> 6.19, it was created sometime in 2024.
>>>
>>> It was just used in kernel 6.19 and that broke compatibility with
>>> my 6.18 kernel.
>>
>> I know, I mean any array that is created or assembled in new kernels
>> will now have lsb field stored in metadata. This field is not
>> defined in old kernels and that's why array can't assembled in old
>> kernels, due to unknown metadata.
>>
>> This is what we have to do for new features, and we're planning to
>> avoid the forward compatibility issue with the above patch that I
>> mentioned.
> Is there really no way around it? Just testing a new kernel and being=20
> able to go back must be supported in my opinion, at least between one=20
> or two LTS versions.

As I said, following patch should be backported to LTS kernels to avoid the=
 problem.

https://lore.kernel.org/linux-raid/20251103125757.1405796-5-linan666@huawei=
cloud.com

>
>
> Kind regards,
>
> Paul

--=20
Thansk,
Kuai
