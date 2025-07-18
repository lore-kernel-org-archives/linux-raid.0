Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB53414F9D6;
	Fri, 18 Jul 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752847747; cv=none; b=Fjs0FIZgP9SH5/P0Uql5V7bKgUm9KxAr7x9U8qgzCtgpa8yjhfBQxq+7osUqzMRHP1DHxh1KthBknaH+t+TfB0YgG46FhxNO6lwJffL2GBTrvPcIh9FFf5JqiHk8TCZgPNY205g70epY/5FCfN49mwI+ukCzvOqLGZySb/MJAlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752847747; c=relaxed/simple;
	bh=ch70mrtc7rj4uVdS4p1RQXoZ33iYC/vKFAhTH1w4xy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egeioPSfs9cbYPLqy+qR3o0oAA0di0RJeDGTHXr+n539rhr8VzJdrCGk0S1KX2HDa3J5WRAXYuYJBQlt3RHWC4N8q+QcurMV0Ezj5IuAcFLr92PkpTu6DUwck03hY2ehEQuQMtCFJNRMRZQDhnYUvddoVBvMbv0UaCpSZ0Se+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id B700B43A0D;
	Fri, 18 Jul 2025 14:08:58 +0000 (UTC)
Message-ID: <00a97b26-0269-4c07-99b9-33bb759067f5@ghiti.fr>
Date: Fri, 18 Jul 2025 16:08:58 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] raid6: test: Add support for RISC-V
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>
Cc: linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn>
 <20250718072711.3865118-6-zhangchunyan@iscas.ac.cn>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20250718072711.3865118-6-zhangchunyan@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdeifeeiiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfitefpfffkpdcuggftfghnshhusghstghrihgsvgenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpeetlhgvgigrnhgurhgvucfihhhithhiuceorghlvgigsehghhhithhirdhfrheqnecuggftrfgrthhtvghrnheptdfhleefjeegheevgeeljeellefgvefhkeeiffekueejteefvdevhfelvdeggeeinecukfhppedvtddtudemkeeiudemfeefkedvmegvfheltdemfedtfhgtmeegtdejtgemieehgehfmeefvdhfleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvtddtudemkeeiudemfeefkedvmegvfheltdemfedtfhgtmeegtdejtgemieehgehfmeefvdhfledphhgvlhhopeglkffrggeimedvtddtudemkeeiudemfeefkedvmegvfheltdemfedtfhgtmeegtdejtgemieehgehfmeefvdhflegnpdhmrghilhhfrhhomheprghlvgigsehghhhithhirdhfrhdpnhgspghrtghpthhtohepuddupdhrtghpthhtohepiihhrghnghgthhhunhihrghnsehishgtrghsrdgrtgdrtghnpdhrtghpthhtohepphgruhhlrdifrghlmhhslhgvhiesshhifhhivhgvrdgtohhmpdhrtghpthhtohepphgrlhhmvghrsegurggssggvlhhtr
 dgtohhmpdhrtghpthhtoheprghouhesvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopegthhgrrhhlihgvsehrihhvohhsihhntgdrtghomhdprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohephihukhhurghifeeshhhurgifvghirdgtohhmpdhrtghpthhtoheplhhinhhugidqrhhishgtvheslhhishhtshdrihhnfhhrrgguvggrugdrohhrgh
X-GND-Sasl: alex@ghiti.fr

Hi Chunyan,

On 7/18/25 09:27, Chunyan Zhang wrote:
> From: Chunyan Zhang <zhang.lyra@gmail.com>
>
> Add RISC-V code to be compiled to allow the userspace raid6test program
> to be built and run on RISC-V.
>
> Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
> ---
>   lib/raid6/test/Makefile | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> index 8f2dd2210ba8..09bbe2b14cce 100644
> --- a/lib/raid6/test/Makefile
> +++ b/lib/raid6/test/Makefile
> @@ -35,6 +35,11 @@ ifeq ($(ARCH),aarch64)
>           HAS_NEON = yes
>   endif
>   
> +ifeq ($(findstring riscv,$(ARCH)),riscv)
> +        CFLAGS += -I../../../arch/riscv/include -DCONFIG_RISCV=1
> +        HAS_RVV = yes
> +endif
> +
>   ifeq ($(findstring ppc,$(ARCH)),ppc)
>           CFLAGS += -I../../../arch/powerpc/include
>           HAS_ALTIVEC := $(shell printf '$(pound)include <altivec.h>\nvector int a;\n' |\
> @@ -63,6 +68,9 @@ else ifeq ($(HAS_ALTIVEC),yes)
>                   vpermxor1.o vpermxor2.o vpermxor4.o vpermxor8.o
>   else ifeq ($(ARCH),loongarch64)
>           OBJS += loongarch_simd.o recov_loongarch_simd.o
> +else ifeq ($(HAS_RVV),yes)
> +        OBJS   += rvv.o recov_rvv.o
> +        CFLAGS += -DCONFIG_RISCV_ISA_V=1
>   endif
>   
>   .c.o:


Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Thanks for the new version, I'll take that for 6.17,

Alex

