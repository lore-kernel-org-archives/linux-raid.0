Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BBD46AF1E;
	Wed, 17 Jun 2026 17:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716495; cv=none; b=WLDTPNVMQtP/Fb+kTJuBDJDSN3R4AZUjtxHhrcA1oR3wVm7r4GCXxyEbMalc6yEKfeAhCru279GzzTf0C1GXyiE0Ka7l08Waf1Chp2WJIe6LipQYkey34lc3yD/7cCwcv3rwNJwN461UT9DX4xB+VvgJBux4N3ps87/TQ1qF6JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716495; c=relaxed/simple;
	bh=UduCEupVCfQTOm+j7oSSWsfp3Mgf+6WUsP3hpFwCwis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qHNTerVQFc7L/bRZH1TzkhMxDicMe43xmJXwB1tDox7xXssZ42+J9NC9Xz565Itfehiz6fgsStTIJ75wYqwCF98GuRDxWySnRXcTa7XMsMm+TWFWBwjAvGjcTev3zDm0CvkRWFfvb8B2b5dWG1SzwzmnB/5wPnqFw/yZc+YVxA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFGdGmT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFGdGmT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BBD1F000E9;
	Wed, 17 Jun 2026 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781716490;
	bh=+MnClB8EaK+TmELFjzZxKBmIbf+Vtv/J2Z6hYQ4VnZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WFGdGmT4mD7rDcwQW9X2B5g5NFkEvbg5MEjb943bwTurphhAT6PzUek/6IbLIEEjb
	 jf26LZqo9GckerOJ1iqvhMue4Ezgh+t7xa5TUDD7z+Eql5/vCKTI9SmMS/ZWpCP0fA
	 QxIOFcx6X0m1rrEHM8NvoYGWn/XwnM2Zx6iSw/6U9q4rZzdaBQXAWY1gV+X0JLUEop
	 /yphOacLtCcqdK70tXUiwATdOI5COZXWspu9I6XOXaeqxW3j4+mHeTO1Gj+Ao+zIef
	 b6TZbAsKU701bF+3lA9GwQem++ag96jUsdv4nDcWUqvV1bjNnqcnKViBBvXvKWLNTG
	 KiR9WcCCwveww==
Date: Wed, 17 Jun 2026 17:14:48 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] xor/kunit: add a benchmark
Message-ID: <20260617171448.GD785086@google.com>
References: <20260617054416.3841334-1-hch@lst.de>
 <20260617054416.3841334-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617054416.3841334-3-hch@lst.de>

On Wed, Jun 17, 2026 at 07:44:04AM +0200, Christoph Hellwig wrote:
> diff --git a/lib/raid/xor/tests/xor_kunit.c b/lib/raid/xor/tests/xor_kunit.c
> index 659ae3edbc25..5939b78b3944 100644
> --- a/lib/raid/xor/tests/xor_kunit.c
> +++ b/lib/raid/xor/tests/xor_kunit.c
> @@ -125,8 +125,71 @@ static void xor_test(struct kunit *test)
>  	}
>  }
>  
> +#ifdef CONFIG_XOR_BENCHMARK
> +static void xor_benchmark(struct kunit *test)

The #ifdef can be avoided using kunit_skip(), as the crypto and CRC
tests do:

    if (!IS_ENABLED(CONFIG_XOR_BENCHMARK))
            kunit_skip(test, "not enabled");

> +		for (j = 0; j < ARRAY_SIZE(len_to_test); j++) {
> +			unsigned int len = len_to_test[j];
> +			const unsigned long num_iters = 1000;
> +
> +			KUNIT_ASSERT_GT(test, len, 0);
> +			KUNIT_ASSERT_LE(test, len, XOR_KUNIT_MAX_BYTES);
> +
> +			preempt_disable();
> +			t = ktime_get();
> +			for (l = 0; l < num_iters; l++)
> +				xor_gen(test_dest, test_buffers, nr, len);
> +			t = ktime_get_ns() - t;
> +			preempt_enable();

First one should be ktime_get_ns(), not ktime_get().

> +
> +			speed[j] = div_u64((u64)len * num_iters * nr, t);
> +		}
> +
> +		static_assert(ARRAY_SIZE(len_to_test) == 2);
> +		kunit_info(test, "%3u disks:\t%5llu  GB/s\t%5llu  GB/s\n",
> +				nr, speed[0], speed[1]);

As mentioned in the other thread, this measures the speed at which the
source data is consumed, which differs from the code in
lib/raid/xor/xor-core.c that measures the speed at which the destination
data is produced.  Probably best to make them consistent.

- Eric
