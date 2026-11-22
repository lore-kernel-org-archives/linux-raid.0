Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795378108;
	b=Umeo/ZAq3vZkYlA6AED3X8mBhWNdjiMM+nARoG6oqBw+ZRS5DtuCk3RGXFzDUCj9rZKG
	 q3xLwlSjIIvwYoSJ4AU/r4xt3gP0TkAaIzSQMjxUUcn6frxXZHKz/+26xz9vb3cSb5JZE
	 azQxR+pz2+Ho+A+ly2ilu+Kr1GTV/E9r/gcYvlsKckvqfBp7vDoIoEvlLS8KAVuM1Ituu
	 +t5TYuxUMNI0zFELvWg1zIQj40mUHPkByLTCClIr8EhYdKKlE2hsu2xaXpCO/Bpz4Szpt
	 ULTDS+4oUttwAD5VdTI9/MmXf8BtwD1TVkJ+5zV/9vinol1ri7xOWtdjMS1scJw+b6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795378108;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yf6/dQUXihL27/jHLiMZbebhoNVVTB4BDxBeUqlrUeo=;
	b=v+4cJczLDihWL8ZOaLwKMMSD6CUpVBAcjaEWSQfFckq/W5F4p8voL1EsXSjCCma1Ukvx
	 +tafIyuWIVaF8rA3vVfalRvqy8Bj4/eS+pEaTicRF7wO6qZgCxrzr8DdL+bCefxS5cGph
	 dIwWYkqEBHGUrN/L1fanaacn5Xi5VYkli2HxvzbR5NIFsH/2LmmHpMt+VGgaWg/VL5dxD
	 qdbhn8A52cuI5H44EHAmhr6P8Zw6OtpmjG8UwVeQWj7QAJWPvpd4hvIf0QZMzG1lxMhY1
	 FeR8CLWbOg9vC+41mKD0yfV9blKQ8BZRB5+8RNwu4MYRS1J01bSt5KjT60j4v3z6ONA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PUoYCt0L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46087606A31A;
	Sun, 22 Nov 2026 20:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PUoYCt0L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2366C1F000C4;
	Sun, 22 Nov 2026 20:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795378107;
	bh=yf6/dQUXihL27/jHLiMZbebhoNVVTB4BDxBeUqlrUeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PUoYCt0Lzzh99rroVaHKVV85F7cpgEGfN6tWgNCxQ6mgMoyJFt4E06uOlins35Zr3
	 UqEjhaC07Q29Nd8pIJXZ8elquSA0ujqNPoyvJxtCcRZZc/LnZJrCWMavu8U/4Krv0j
	 ywAW0+9mJ7D2uj6528sUqko3L18NztabFqvGIk39kyOdK6ofDbUGzxLMjqRt0TOwya
	 cyx9LjNqLe7D0r38mb/HoKAp39uivuCwkwxT3ml/NuRqC3VOvX4XiFNx2E1Zp5D7Sy
	 ObC9cCGYIpfS+d0PJ19LciDKseL0i1Ye2yWug8xqBJ8FdTutpyPsW3kWBa93PieyxS
	 Esvwrd/xXnoug==
Date: Sun, 22 Nov 2026 12:08:25 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Miroslav Cimerman <mc@raidlab.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Markus Stockhausen <markus.stockhausen@collogia.de>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] raid6: x86: asm constraints, sfence and prefetch in
 xor_syndrome
Message-ID: <20261122200825.GC2122@sol>
References: <20261122032933.2306875-1-mc@raidlab.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122032933.2306875-1-mc@raidlab.org>

On Sun, Nov 22, 2026 at 03:29:30AM +0000, Miroslav Cimerman wrote:
> This follows up on the review of "raid6: use normal stores in the x86 x4
> xor_syndrome functions" [1]. With that patch, none of the x86
> xor_syndrome() functions uses non-temporal stores, so their sfence
> orders nothing. Christoph suggested removing it [2]. Eric pointed out
> that the AVX-512 functions list P and Q as asm inputs only and rely on
> the "memory" clobber of that sfence, and suggested prefetcht0 for Q [3].
> 1/3 fixes the constraints, 2/3 removes the sfence, and 3/3 changes the
> prefetch of Q.
> 
> Based on mm-nonmm-unstable with [1] applied.
> 
> Testing:
> - Builds without warnings with W=1, gcc 15.2 and clang 21.1.
> - With 1/3, clang generates the same code as before. gcc reloads the
>   data pointers inside the loop of the AVX-512 functions (up to two
>   more instructions per function). With 2/3, the sfence instructions
>   are gone, and apart from alignment padding the code is the same.
>   3/3 only changes the six prefetch instructions.
> - The raid6 KUnit test passes in QEMU with -cpu max under KVM on a
>   Haswell host (avx2x1..x4) and with -cpu Westmere (sse2x1..x4). All
>   8 test cases pass in each run.
> - In userspace, gen_syndrome() and xor_syndrome() of all nine sse2,
>   avx2 and avx512 variants match a scalar reference (gen_syndrome for
>   2-24 data disks, xor_syndrome for every start/stop): sse2 natively on
>   a Core i5-2520M, avx2 natively on a Xeon E5-2699 v3, all variants
>   natively on a Xeon Gold 6130, and avx512 also with Intel SDE (-skx).
>   The AVX-512 functions were not run in a kernel. I have no AVX-512
>   machine with root access.
> 
> The patches and the tests were prepared with the help of an LLM. I
> reviewed everything.
> 
> [1] https://lore.kernel.org/linux-raid/20261109030805.25709-1-mc@raidlab.org/
> [2] https://lore.kernel.org/linux-raid/avqegZd_W0kce0UA@infradead.org/
> [3] https://lore.kernel.org/linux-raid/20261116210440.GE229817@google.com/
> 
> Miroslav Cimerman (3):
>   raid6: declare the AVX-512 P/Q stores as asm outputs
>   raid6: remove the sfence from the x86 xor_syndrome functions
>   raid6: prefetch Q with prefetcht0 in the x86 x4 xor_syndrome functions
> 
>  lib/raid/raid6/x86/avx2.c   |  7 ++-----
>  lib/raid/raid6/x86/avx512.c | 37 ++++++++++++++-----------------------
>  lib/raid/raid6/x86/sse2.c   |  7 ++-----
>  3 files changed, 18 insertions(+), 33 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
