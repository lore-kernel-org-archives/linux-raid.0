Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD402248BE;
	Thu, 10 Jul 2025 07:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752133536; cv=none; b=a9EH2cFrVFkfvLeiVAkBrmIIAks5gcPG25rHQH6yKQ7FcR+aioZZpnGUfvTzrxvNUdGJ1s9He8XHvDASDJKa6b+2xPdelHWrWyWefFvd1GPcq7xoKk+aCjgbj1pP5GuJ55wzBdjmoWOEde42Zx2H2gduyM1DXY0rOiyBl3o4ZL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752133536; c=relaxed/simple;
	bh=NV5y/BofAISyGUlHGlIjCJ0LG0tZLilDuSDy+VR3zag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShBGPGvzSyA8Zb5FJRxd9w1/KwwmTulvrAGVK+djuT8BTgc8XRwNkcoO45s540uakJCDv8yGONXUaQHkryzJH13FOo6CeqFUkPpJtkF4bJJS9uQlET6xu1mB5Cp61g6srT036SZvwS3qx14cN0zFNCAJBgLt3GPcLn53qtVk0jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 41E0C44362;
	Thu, 10 Jul 2025 07:45:26 +0000 (UTC)
Message-ID: <6d7dad19-bf05-4109-93ac-7d688b390e1c@ghiti.fr>
Date: Thu, 10 Jul 2025 09:45:25 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Fix a segmentation fault also add raid6test for
 RISC-V support
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn>
 <8a1b1610-02b1-46a8-9a10-c19c1580c017@ghiti.fr>
 <CAAfSe-s1g8h+HpYz8FmW4n7h+hhi5W0_N-jpfAD5Ldai8NjwHw@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAAfSe-s1g8h+HpYz8FmW4n7h+hhi5W0_N-jpfAD5Ldai8NjwHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdefleekjecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhephffhuddtveegleeggeefledtudfhudelvdetudfhgeffffeigffgkeethfejudejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmegsfehfudemjegtiegrmegsheduleemrghfsgdtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmegsfehfudemjegtiegrmegsheduleemrghfsgdtpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmegsfehfudemjegtiegrmegsheduleemrghfsgdtngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopeiihhgrnhhgrdhlhihrrgesghhmrghilhdrtghomhdprhgtphhtthhopeiihhgrnhhgtghhuhhnhigrnhesihhstggrshdrrggtrdgtnhdprhgtphhtthhop
 ehprghulhdrfigrlhhmshhlvgihsehsihhfihhvvgdrtghomhdprhgtphhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprhgtphhtthhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtoheptghhrghrlhhivgesrhhivhhoshhinhgtrdgtohhmpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeihuhhkuhgrihefsehhuhgrfigvihdrtghomh
X-GND-Sasl: alex@ghiti.fr

On 7/10/25 03:44, Chunyan Zhang wrote:
> Hi Alex,
>
> On Wed, 9 Jul 2025 at 23:18, Alexandre Ghiti <alex@ghiti.fr> wrote:
>> Hi Chunyan,
>>
>> Patch 2 was merged via fixes, do you plan on resending a new version for
>> 6.17 that takes into account Palmer's remarks?
> Yes, I'm preparing the patches these days, just haven't figured out
> how to set NSIZE properly for user space.


Just use hwprobe() to make sure V is supported and then csr_read(VLENB) 
to retrieve this value, no?


>
> I probably should split the patchset, send out one today.
>
> Thanks,
> Chunyan
>
>> Thanks,
>>
>> Alex
>>
>> On 6/10/25 12:12, Chunyan Zhang wrote:
>>> The first two patches are fixes.
>>> The last two are for userspace raid6test support on RISC-V.
>>>
>>> The issue fixed in patch 2/4 was probably the same which was spotted by
>>> Charlie [1], I couldn't reproduce it at that time.
>>>
>>> When running raid6test in userspace on RISC-V, I saw a segmentation fault,
>>> I used gdb command to print pointer p, it was an unaccessible address.
>>>
>>> With patch 2/4, the issue didn't appear anymore.
>>>
>>> [1] https://lore.kernel.org/lkml/Z5gJ35pXI2W41QDk@ghost/
>>>
>>> Chunyan Zhang (4):
>>>     raid6: riscv: clean up unused header file inclusion
>>>     raid6: riscv: Fix NULL pointer dereference issue
>>>     raid6: riscv: Allow code to be compiled in userspace
>>>     raid6: test: add support for RISC-V
>>>
>>>    lib/raid6/recov_rvv.c   |  9 +-----
>>>    lib/raid6/rvv.c         | 62 +++++++++++++++++++++--------------------
>>>    lib/raid6/rvv.h         | 15 ++++++++++
>>>    lib/raid6/test/Makefile |  8 ++++++
>>>    4 files changed, 56 insertions(+), 38 deletions(-)
>>>
