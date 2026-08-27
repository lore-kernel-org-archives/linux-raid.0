Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A2B35F5F8;
	Thu, 27 Aug 2026 03:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787802661; cv=none; b=XloXxX4hUM47XA0bx3+EvYEN/G0aHPnT2SrswZj7ZFbFuuatsQLkVlItySBFywTj0MlkquRxOLjF8s1HBSkrEguSREMgpXSYELkaiW5/ZvjQFoVbND44yzObySDi79pAHL25SkCPxiyZMy/Z8RpoFfVKSj/ZrknnHqcaraiTfBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787802661; c=relaxed/simple;
	bh=EMDPAWPZChNYmhS0Iee1/zh34O+qUpYo70tQuhnELXk=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=fPTEHaKYrOh5JuM1ot29DimdV7fi+8o+X37YSxLikLEtfD34cM64cHkcbjRV/6V9VZ1XdWvzYVIMsWwCNkQl/73DYrSPeYUaJ2fAlL5SFvpcmdIISo+gMAeeKEquFX1UUbiZFDsSIOfqE/6Nm6U5Kr1xBGalu2IlSe4qFmeDnOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2Yy7Omh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2Yy7Omh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8FD1F000E9;
	Thu, 27 Aug 2026 03:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787802659;
	bh=thQS821qTxu5TzC0ykYtUXsEixfTPWZ6df0tl62+wpM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2Yy7Omh35GMjHda2depsUetItEEjsJn9CGtag461uYteQ+Q5zGDvSFnS6DgOiFFSB
	 C0v43xI2h22v9ADWY9ZjiJq2hPLQXKs2BGwvokkUzvcOZMEa/0hPbyk3lP/9Z3f43+
	 /CXEeE8GeC+XsGTYL7gp11W7yJGFDva7u9FPdLnE=
Date: Wed, 26 Aug 2026 20:50:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>, Eric Biggers <ebiggers@kernel.org>, Ard
 Biesheuvel <ardb@kernel.org>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH] raid/kunit: Enable RAID6 PQ and XOR benchmarks if
 KUNIT_ALL_TESTS=m
Message-Id: <20260826205058.a6ff019d0584f75c7f50430b@linux-foundation.org>
In-Reply-To: <64c6e0191bd8ccef0074ffbb09bd0584680d710b.1787584360.git.geert@linux-m68k.org>
References: <64c6e0191bd8ccef0074ffbb09bd0584680d710b.1787584360.git.geert@linux-m68k.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Aug 2026 17:14:01 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Enabling the (possibly long-running benchmarks) by default may cause a
> big delay in boot time in case of built-in tests.  However, they can
> still safely be enabled by default if all tests are modular, as they
> would only run when requested explicitly by the system administrator.
> 
> ...
>
> --- a/lib/raid/Kconfig
> +++ b/lib/raid/Kconfig
> @@ -32,6 +32,7 @@ config XOR_KUNIT_TEST
>  config XOR_BENCHMARK
>  	bool "Benchmark for xor_gen"
>  	depends on XOR_KUNIT_TEST
> +	default y if KUNIT_ALL_TESTS=m
>  	help
>  	  Include benchmarks in the KUnit test suite for xor_gen.
>  
> @@ -63,6 +64,7 @@ config RAID6_PQ_KUNIT_TEST
>  config RAID6_PQ_KUNIT_BENCHMARK
>  	bool "Benchmark for RAID6 PQ"
>  	depends on RAID6_PQ_KUNIT_TEST
> +	default y if KUNIT_ALL_TESTS=m
>  	help
>  	  Include benchmarks in the KUnit test suite for raid P/Q generation.

OK, thanks, but...

hp2:/usr/src/mm> scripts/get_maintainer.pl -f --no-rolestats lib/raid
[not linux-raid@vger.kernel.org]

Patches enthusiastically accepted ;)
