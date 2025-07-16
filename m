Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7634B14E2F2;
	Wed, 16 Jul 2025 13:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752673443; cv=none; b=hpEoN9PPZQGLldtADYDNhgYayfInvBNgES6ZtJPAqdJkKCnGS7rvUTAgrs4fAKpWL620ypGso4d/1Xpmj5Tj1qflkwcs/JVnkJkbl90PGHvuRrFpJ/uvO4IM4hTkgL60dyOSW9cZuv5NDMDXjvs1gVHiAgw7DjlOgL64R2z/Zlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752673443; c=relaxed/simple;
	bh=kS/40bE/zM/6/7R//qc+nfv0lv6CQa4dRTg7fHyyFBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=koVbm2eZaPLRR4J/uW7G59zPTXP6pEgFxBkCJS/rkgII1MxQh4TkKZ9svsCB9bUyuT+vQ4dfZCjuUHbkIFUYgUS4RKiFrgPutEgAWIcd31vWMvZT4q5wevwUKgLLdOBmLQwma7MBlU5Jzuvf4aGhLRnKprp4LWM6fgdgMa/8HsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1196C4395C;
	Wed, 16 Jul 2025 13:43:56 +0000 (UTC)
Message-ID: <69e3f295-3b43-4a13-bb84-3f9a89171331@ghiti.fr>
Date: Wed, 16 Jul 2025 15:43:55 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/5] raid6: riscv: Add a compiler error
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
 <20250711100930.3398336-4-zhangchunyan@iscas.ac.cn>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250711100930.3398336-4-zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdehjeekhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnheptdfhleefjeegheevgeeljeellefgvefhkeeiffekueejteefvdevhfelvdeggeeinecukfhppedvtddtudemkeeiudemfeefkedvmegvfheltdemleehtdgumehftgegieemjeejlegvmedvfhgvfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvtddtudemkeeiudemfeefkedvmegvfheltdemleehtdgumehftgegieemjeejlegvmedvfhgvfedphhgvlhhopeglkffrggeimedvtddtudemkeeiudemfeefkedvmegvfheltdemleehtdgumehftgegieemjeejlegvmedvfhgvfegnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepuddupdhrtghpthhtohepiihhrghnghgthhhunhihrghnsehishgtrghsrdgrtgdrtghnpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhivhgvrdgtohhmpdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtr
 dgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopegthhgrrhhlihgvsehrihhvohhsihhntgdrtghomhdprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephihukhhurghifeeshhhurgifvghirdgtohhmpdhrtghpthhtoheplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrgh
X-GND-Sasl: alex@ghiti.fr

First, the patch title should be something like:

"raid6: riscv: Prevent compiler with vector support to build already 
vectorized code"

Or something similar.

On 7/11/25 12:09, Chunyan Zhang wrote:
> The code like "u8 **dptr = (u8 **)ptrs" just won't work when built with


Why wouldn't this code ^ work?

I guess preventing the compiler to vectorize the code is to avoid the 
inline assembly code to break what the compiler could have vectorized no?


> a compiler that can use vector instructions. So add an error for that.
>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>   lib/raid6/rvv.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index 89da5fc247aa..015f3ee4da25 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -20,6 +20,10 @@ static int rvv_has_vector(void)
>   	return has_vector();
>   }
>   
> +#ifdef __riscv_vector
> +#error "This code must be built without compiler support for vector"
> +#endif
> +
>   static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>   {
>   	u8 **dptr = (u8 **)ptrs;
