Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB428C87C;
	Wed,  9 Jul 2025 15:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752074326; cv=none; b=Iam6wdsHBwWWMzkL1godWB91p0xSNNpXsdOgqrQ3sJvKe0gHArorYE/pIOEuJcmRcwaMjEDbdk1aVsvbzRT0YOajRAForsP7GEKuZjnsXOmCOf9ZdKApXGzo/qTJoIuJKf2NA0nB4pe4XPn7/d5yGec5uCA/2ju1xFVh4mD63KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752074326; c=relaxed/simple;
	bh=FaVcS3DeTBdZOX9KIsVJTG6tQNUQI5HpVTKpqL7N3yE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=stTzR8fnTz7fCXo4o59vk344RnhTtUtuqCBgF1UHaBcTjEy2NQUp07pCqZd94gbXgZzlJxQ2lu+O+NRMjNMyg1P+lzpHpCGnjeeEyWHfAybERm3dtvGYdLWJa4cpuVaImsgWGJySB696ooD7E7V+4kOxYtgu/e2jEmcKdgwaVJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id C4E3B41C06;
	Wed,  9 Jul 2025 15:18:38 +0000 (UTC)
Message-ID: <8a1b1610-02b1-46a8-9a10-c19c1580c017@ghiti.fr>
Date: Wed, 9 Jul 2025 17:18:38 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Fix a segmentation fault also add raid6test for
 RISC-V support
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdefjeeltdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhephffhuddtveegleeggeefledtudfhudelvdetudfhgeffffeigffgkeethfejudejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmegrjegvvdemrgguledvmeelrggsjeemfeduhegsnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmegrjegvvdemrgguledvmeelrggsjeemfeduhegspdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmegrjegvvdemrgguledvmeelrggsjeemfeduhegsngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopeiihhgrnhhgtghhuhhnhigrnhesihhstggrshdrrggtrdgtnhdprhgtphhtthhopehprghulhdrfigrlhhmshhlvgihsehsihhfihhvvgdrtghomhdprhgtp
 hhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprhgtphhtthhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtoheptghhrghrlhhivgesrhhivhhoshhinhgtrdgtohhmpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeihuhhkuhgrihefsehhuhgrfigvihdrtghomhdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhg
X-GND-Sasl: alex@ghiti.fr

Hi Chunyan,

Patch 2 was merged via fixes, do you plan on resending a new version for 
6.17 that takes into account Palmer's remarks?

Thanks,

Alex

On 6/10/25 12:12, Chunyan Zhang wrote:
> The first two patches are fixes.
> The last two are for userspace raid6test support on RISC-V.
>
> The issue fixed in patch 2/4 was probably the same which was spotted by
> Charlie [1], I couldn't reproduce it at that time.
>
> When running raid6test in userspace on RISC-V, I saw a segmentation fault,
> I used gdb command to print pointer p, it was an unaccessible address.
>
> With patch 2/4, the issue didn't appear anymore.
>
> [1] https://lore.kernel.org/lkml/Z5gJ35pXI2W41QDk@ghost/
>
> Chunyan Zhang (4):
>    raid6: riscv: clean up unused header file inclusion
>    raid6: riscv: Fix NULL pointer dereference issue
>    raid6: riscv: Allow code to be compiled in userspace
>    raid6: test: add support for RISC-V
>
>   lib/raid6/recov_rvv.c   |  9 +-----
>   lib/raid6/rvv.c         | 62 +++++++++++++++++++++--------------------
>   lib/raid6/rvv.h         | 15 ++++++++++
>   lib/raid6/test/Makefile |  8 ++++++
>   4 files changed, 56 insertions(+), 38 deletions(-)
>
