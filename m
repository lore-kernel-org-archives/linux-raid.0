Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88397F9;
	Sun, 16 Mar 2025 06:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742106811; cv=none; b=qN/fY4BP7y/jqG0OC9hpGvIW13cfsz2dWy6gdap9WRTM6aRbeM5CJGDfyVKE6DLQDGnUH/LhMRN/2pCBe7idlleyNPq2/mfGFsjwF+E6aiTWqfZ1z+4135fNyp5n32PV2WbVvvgLUaqoYfoa1NR7sVpqagWuquIcN+2fqUtgVdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742106811; c=relaxed/simple;
	bh=htSNhGRDkjsmVx9njBdYdvXY3I/BATExC02A7Ahrk6k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=b8shWDX+aQtKjDNtHiSehVv7b8OGF5syTKmXf524Mw/+e9KpZ1TMGf0WuBn6FP0K+Se27j/0EGi011ODGlR5LKr7/YqtvkTqAI6HLySe3LqU0IPp2r/1nnpXqmEY5Oerh3e0kjVjWwlqehGYRxmohfkqOXxs5ONWJfEPtaNCLvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hw8pVJXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hw8pVJXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE24C4CEDD;
	Sun, 16 Mar 2025 06:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742106810;
	bh=htSNhGRDkjsmVx9njBdYdvXY3I/BATExC02A7Ahrk6k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Hw8pVJXxS9tzFvlaVL1aJjuewxC+i8ohbAjyX2p88Vmv0ecxuW3i9OTk1RMSSAGIY
	 gsVsbIKBKGoMlJvGhMLno6f1VejN0A9psjJE6CAfo1wySgHUTtYjuGwEdsxxBwvI3G
	 dBX+8SeezqRtxuSWpY569ZQR45SOS2ixZZrbdTfY=
Date: Sat, 15 Mar 2025 23:33:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-Id: <20250315233329.0b42e28a9f11e2c1b8b17ea0@linux-foundation.org>
In-Reply-To: <Z9Zm9nPjU9kT1lt5@gondor.apana.org.au>
References: <Z9U0_uj1E2MlYhGx@gondor.apana.org.au>
	<20250315210631.d79637b9c55c7ee3287aa426@linux-foundation.org>
	<Z9Zm9nPjU9kT1lt5@gondor.apana.org.au>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 16 Mar 2025 13:51:50 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > Is there any possibility that the MD drivers will point DMA hardware at
> > the global zero page, thereby invalidating that page from CPU caches in
> > some manner?
> 
> The only spots that can hand this off to DMA are:

Cool, thanks for checking.

> crypto/async_tx/async_pq.c:                     srcs[i] = (void*)raid6_empty_zero_page;
> crypto/async_tx/async_raid6_recov.c:                            ptrs[i] = (void *) raid6_empty_zero_page;
> crypto/async_tx/async_raid6_recov.c:                            ptrs[i] = (void*)raid6_empty_zero_page;
> 
> But they all turn out to be synchronous fallback code paths that
> do not involve DMA at all.

And all three cast a pointer to a void* ;)
