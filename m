Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1B1A239A;
	Wed, 16 Jul 2025 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752673255; cv=none; b=Ki9WoS0Nod5yUSVq8RUkvNaiE1xwPKCe89DUsOtqLahtXk8W6Cgg0FJNfJdnFMKhFQtBvejOXIozSE5o7nghquyS6x+Sc/KMNnA+9kXWdbfQrF9+pXjnJwKu87x4h85WzyUdLI7bP/6d4EAwKIMDZ/jA+/tXwldjGHcaFYDIlhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752673255; c=relaxed/simple;
	bh=40DqHiK4rh0x9LVXhFG9r7FwQUIOD7cMellgdwwCDy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AGfq9NpQIQ+6pvrU18X4FllqOIddYbYG4gYZRjlAu0MwDmDI5DYosusmbQ7wErLqJlCI0nKLAHlpp7LBw1GWDkS6ARTMd/CE4JV9UBmlkKpVnJjcSaqh92R81XWpqVDTUsUbxDF1gER3IZ6hI49vYU7/drgAZ8wONg44I2FBC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8D0A743A05;
	Wed, 16 Jul 2025 13:40:37 +0000 (UTC)
Message-ID: <8865f36d-c8a9-454b-aa55-741a82ca96b4@ghiti.fr>
Date: Wed, 16 Jul 2025 15:40:37 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/5] raid6: riscv: replace one load with a move to
 speed up the caculation
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
 <20250711100930.3398336-3-zhangchunyan@iscas.ac.cn>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250711100930.3398336-3-zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdehjeekhecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnheptdfhleefjeegheevgeeljeellefgvefhkeeiffekueejteefvdevhfelvdeggeeinecukfhppedvtddtudemkeeiudemfeefkedvmegvfheltdemleehtdgumehftgegieemjeejlegvmedvfhgvfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvtddtudemkeeiudemfeefkedvmegvfheltdemleehtdgumehftgegieemjeejlegvmedvfhgvfedphhgvlhhopeglkffrggeimedvtddtudemkeeiudemfeefkedvmegvfheltdemleehtdgumehftgegieemjeejlegvmedvfhgvfegnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepuddupdhrtghpthhtohepiihhrghnghgthhhunhihrghnsehishgtrghsrdgrtgdrtghnpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhivhgvrdgtohhmpdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtr
 dgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopegthhgrrhhlihgvsehrihhvohhsihhntgdrtghomhdprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephihukhhurghifeeshhhurgifvghirdgtohhmpdhrtghpthhtoheplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrgh
X-GND-Sasl: alex@ghiti.fr

On 7/11/25 12:09, Chunyan Zhang wrote:
> Since wp$$==wq$$, it doesn't need to load the same data twice, use move
> instruction to replace one of the loads to let the program run faster.
>
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>   lib/raid6/rvv.c | 60 ++++++++++++++++++++++++-------------------------
>   1 file changed, 30 insertions(+), 30 deletions(-)
>
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index b193ea176d5d..89da5fc247aa 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -44,7 +44,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
> @@ -117,7 +117,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
> @@ -218,9 +218,9 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      "vle8.v	v4, (%[wp1])\n"
> -			      "vle8.v	v5, (%[wp1])\n"
> +			      "vmv.v.v	v5, v4\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> @@ -310,9 +310,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      "vle8.v	v4, (%[wp1])\n"
> -			      "vle8.v	v5, (%[wp1])\n"
> +			      "vmv.v.v	v5, v4\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> @@ -440,13 +440,13 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      "vle8.v	v4, (%[wp1])\n"
> -			      "vle8.v	v5, (%[wp1])\n"
> +			      "vmv.v.v	v5, v4\n"
>   			      "vle8.v	v8, (%[wp2])\n"
> -			      "vle8.v	v9, (%[wp2])\n"
> +			      "vmv.v.v	v9, v8\n"
>   			      "vle8.v	v12, (%[wp3])\n"
> -			      "vle8.v	v13, (%[wp3])\n"
> +			      "vmv.v.v	v13, v12\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> @@ -566,13 +566,13 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      "vle8.v	v4, (%[wp1])\n"
> -			      "vle8.v	v5, (%[wp1])\n"
> +			      "vmv.v.v	v5, v4\n"
>   			      "vle8.v	v8, (%[wp2])\n"
> -			      "vle8.v	v9, (%[wp2])\n"
> +			      "vmv.v.v	v9, v8\n"
>   			      "vle8.v	v12, (%[wp3])\n"
> -			      "vle8.v	v13, (%[wp3])\n"
> +			      "vmv.v.v	v13, v12\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> @@ -754,21 +754,21 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      "vle8.v	v4, (%[wp1])\n"
> -			      "vle8.v	v5, (%[wp1])\n"
> +			      "vmv.v.v	v5, v4\n"
>   			      "vle8.v	v8, (%[wp2])\n"
> -			      "vle8.v	v9, (%[wp2])\n"
> +			      "vmv.v.v	v9, v8\n"
>   			      "vle8.v	v12, (%[wp3])\n"
> -			      "vle8.v	v13, (%[wp3])\n"
> +			      "vmv.v.v	v13, v12\n"
>   			      "vle8.v	v16, (%[wp4])\n"
> -			      "vle8.v	v17, (%[wp4])\n"
> +			      "vmv.v.v	v17, v16\n"
>   			      "vle8.v	v20, (%[wp5])\n"
> -			      "vle8.v	v21, (%[wp5])\n"
> +			      "vmv.v.v	v21, v20\n"
>   			      "vle8.v	v24, (%[wp6])\n"
> -			      "vle8.v	v25, (%[wp6])\n"
> +			      "vmv.v.v	v25, v24\n"
>   			      "vle8.v	v28, (%[wp7])\n"
> -			      "vle8.v	v29, (%[wp7])\n"
> +			      "vmv.v.v	v29, v28\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> @@ -948,21 +948,21 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
>   		asm volatile (".option	push\n"
>   			      ".option	arch,+v\n"
>   			      "vle8.v	v0, (%[wp0])\n"
> -			      "vle8.v	v1, (%[wp0])\n"
> +			      "vmv.v.v	v1, v0\n"
>   			      "vle8.v	v4, (%[wp1])\n"
> -			      "vle8.v	v5, (%[wp1])\n"
> +			      "vmv.v.v	v5, v4\n"
>   			      "vle8.v	v8, (%[wp2])\n"
> -			      "vle8.v	v9, (%[wp2])\n"
> +			      "vmv.v.v	v9, v8\n"
>   			      "vle8.v	v12, (%[wp3])\n"
> -			      "vle8.v	v13, (%[wp3])\n"
> +			      "vmv.v.v	v13, v12\n"
>   			      "vle8.v	v16, (%[wp4])\n"
> -			      "vle8.v	v17, (%[wp4])\n"
> +			      "vmv.v.v	v17, v16\n"
>   			      "vle8.v	v20, (%[wp5])\n"
> -			      "vle8.v	v21, (%[wp5])\n"
> +			      "vmv.v.v	v21, v20\n"
>   			      "vle8.v	v24, (%[wp6])\n"
> -			      "vle8.v	v25, (%[wp6])\n"
> +			      "vmv.v.v	v25, v24\n"
>   			      "vle8.v	v28, (%[wp7])\n"
> -			      "vle8.v	v29, (%[wp7])\n"
> +			      "vmv.v.v	v29, v28\n"
>   			      ".option	pop\n"
>   			      : :
>   			      [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),


Out of curiosity, did you notice a gain?

Anyway:

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks,

Alex

