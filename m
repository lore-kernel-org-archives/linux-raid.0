Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889A229D19;
	Tue, 10 Jun 2025 19:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749583415; cv=none; b=c6xEDRT9oApkWWXnCwthc7WoxgOhE5WE+V7XKpu6DU8Px9Jz8nsWcWRLoe9dZuUn93yNTrQo+OJxjzt7Wg9OasotYJff7YrfDRaqj5xFEVFC2weE/9POrw0iEYU1dRNqjDZZvZkCA7cSe5mfmtVW584CphOn8i3QMJ7fxBxdFVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749583415; c=relaxed/simple;
	bh=uXminS12Vy7FhZAo0yUkVPFxkhTMBTlWxDz0v3a9ZGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AA9TYZoM33aKY29O+uCtCTqhW89v178iJvP+aKF26xUpOtb4RI4iVeY6C/xeTnym35x2FUZpUXfi0I9wOWfz+cn1AbZJ3SKKmeG7Y8EEAOMXN3S/8w2yM3FW0XTMEbx/lOGLa5aqQ3qYvA+aamWe3hV/GcYi5imwWNxTQYdmKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 50479441D4;
	Tue, 10 Jun 2025 19:23:19 +0000 (UTC)
Message-ID: <d052f010-410a-4405-9ae6-f679649851ea@ghiti.fr>
Date: Tue, 10 Jun 2025 21:23:18 +0200
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
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddugdduudduhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnhephffhuddtveegleeggeefledtudfhudelvdetudfhgeffffeigffgkeethfejudejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepvddttddumeekiedumeeffeekvdemvghfledtmegtgeduugemfedukeeimedvugdvvdemugehvdgtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepvddttddumeekiedumeeffeekvdemvghfledtmegtgeduugemfedukeeimedvugdvvdemugehvdgtpdhhvghloheplgfkrfggieemvddttddumeekiedumeeffeekvdemvghfledtmegtgeduugemfedukeeimedvugdvvdemugehvdgtngdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhnsggprhgtphhtthhopeduuddprhgtphhtthhopeiihhgrnhhgtghhuhhnhigrnhesihhstggrshdrrggtrdgtnhdprhgtphhtthhopehprghulhdrfigrlhhmshhlvgihsehsihhfihhvvgdrtghomhdprhgtp
 hhtthhopehprghlmhgvrhesuggrsggsvghlthdrtghomhdprhgtphhtthhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupdhrtghpthhtoheptghhrghrlhhivgesrhhivhhoshhinhgtrdgtohhmpdhrtghpthhtohepshhonhhgsehkvghrnhgvlhdrohhrghdprhgtphhtthhopeihuhhkuhgrihefsehhuhgrfigvihdrtghomhdprhgtphhtthhopehlihhnuhigqdhrihhstghvsehlihhsthhsrdhinhhfrhgruggvrggurdhorhhg
X-GND-Sasl: alex@ghiti.fr

Hi Chunyan,

On 6/10/25 12:12, Chunyan Zhang wrote:
> The first two patches are fixes.
> The last two are for userspace raid6test support on RISC-V.
>
> The issue fixed in patch 2/4 was probably the same which was spotted by
> Charlie [1], I couldn't reproduce it at that time.
>
> When running raid6test in userspace on RISC-V, I saw a segmentation fault,
> I used gdb command to print pointer p, it was an unaccessible address.


Can you give me your config, kernel and toolchain versions? I can't 
reproduce the segfault on my machine.

Thanks for the fixes and the test, I'll take a look this week.

Alex


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
