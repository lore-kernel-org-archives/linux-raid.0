Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFA02FA0FD
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024555; cv=none; b=KBz1jKD3NPr4EhxE++WQeNUT8pfh7xql/uZ2Y20nrMtTWzZj7wI/po5bwnWcSQknaaYELMdrxxut9r4nkoUIy4hju7xm73PCx1xC4KCBLFUTGUrdOhK8DVXj+K0Y8RKxMFjVH8W9dlG5W3+JZ3Ot14tQxrw5n/J1Yi4+mfSlgVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024555; c=relaxed/simple;
	bh=2o/grmn5F1mArJnQlt422/kbofkdfSefEOGOaNsSm98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=spH0gLFXu0WdrVpT5T+X5x/sIXjkLjPsjTxRgavXVSyQl1dN/cQwV6HJ/Y+sDie4B41PfhtX9tnOnyfMTrV7Cb7jLmZSBQJtEk/emYHFsFAv4WB2Xvx2iaKIdMctPvhNiDuXXohpPhkVnrMswmWzEkJhGIeA/R3KY5UNrxyJBWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.202] (p5dc555db.dip0.t-ipconnect.de [93.197.85.219])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 5021061E647BA;
	Tue, 12 Aug 2025 20:48:47 +0200 (CEST)
Message-ID: <9eede1df-1ebb-4dd8-9e97-ef077c661ab5@molgen.mpg.de>
Date: Tue, 12 Aug 2025 20:48:45 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>
Cc: yukuai1@huaweicloud.com, linux-raid@vger.kernel.org, yukuai3@huawei.com,
 mpatocka@redhat.com, luca.boccassi@gmail.com
References: <20250812074947.61740-1-xni@redhat.com>
 <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
 <CALTww29wxGA=o2+pcsF=SBffL_v0tZqrAqM1sCjwHTf+S79wqA@mail.gmail.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CALTww29wxGA=o2+pcsF=SBffL_v0tZqrAqM1sCjwHTf+S79wqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Am 12.08.25 um 14:20 schrieb Xiao Ni:

> On Tue, Aug 12, 2025 at 5:58 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:

[…]

>> Am 12.08.25 um 09:49 schrieb Xiao Ni:
>>> commit 9e59d609763f ("md: call del_gendisk in control path") changes the
>>> async way to sync way of calling del_gendisk. But it breaks mdadm
>>> --assemble command. The assemble command runs like this:
>>> 1. create the array
>>> 2. stop the array
>>> 3. access the sysfs files after stopping
>>>
>>> The sync way calls del_gendisk in step2, so all sysfs files are removed.
>>> Now to avoid breaking mdadm assemble command, this patch adds a parameter
>>
>> … the parameter legacy_async_del_gendisk …
> 
> ok
>>
>>> that can be used to choose which way. The default is async way. In future,
>>> we can remove this parameter when users upgrade to mdadm 4.5 which removes
>>> step2.
>>
>> step 2
> 
> ok
>>
>> Maybe say to first change the default, and then remove it.
> 
> I don't follow this. What's the meaning of "to first change the default"?

I mean, after, for example, the next LTS release, change the default of 
the parameter to false, and then after another LTS release to remove the 
parameter entirely. Or, seeing that the code is not that vast, leave the 
parameter even longer. So, not remove the parameter, but first change 
the default.

[…]


Kind regards,

Paul
