Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA172E339D;
	Sun, 16 Mar 2025 05:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742104322; cv=none; b=bi91LAGLe4SNueSfB6J+kOfbLQBbKn18OMDAgpHdHOz9RkGbyM8ek1v5XPepQxpGsxCHUSnugbeCbDkENpuKVA/QkGXR6m9ZrzE0zMni5uwv3R4hHTjEc0LIJ6xmYnq/IglbnTm3iUmsCl5dVb0cnzDhAQ80GDE5w8iaoNzGd28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742104322; c=relaxed/simple;
	bh=TY9C0Pv79aB1kyNdfzmaq24tYMm7D6IgwS1kACVC+2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JC7t9NnCiD8Z/ptO06tMExJEOeR32jid7azFoOHY3cVgkC2uuA379kLMdmzKJ67u1hUwMkH/J9AExdjCOd+OFtiZeE6VkVHf1myUcQLMvVY/OReIP0PlT7/nYqEoCrxesyCMMcPouugZblWo2DE2dR7IwjlVd42q1mepCP0Zbpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pM2k5UnL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pM2k5UnL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=q4jWHu1d2pPb7fealiXsY0hC2fptvir263Ji4MGN2Ns=; b=pM2k5UnLec3pB0rImY3Y/+bdQ6
	6RXuJTK+79i57Xbq4moFaeAhjZntF3N6eGcchItM7CU0AZ/8dbBZ7vF91SuPklEnBE6bDLG8kx8zc
	dkuKGOem0Gz8Wye+bTiA3mYChfwYaLIJ0LO6lu+Zad+naSvLW7I6YWBUMaeMIVlORSb5eyjP/wtpq
	G2K5IH0bN15hphr2Tj1RFXnvLv6AwkhoPQXk+MsA982AgdjIR+BF1WyB7sqEcnnMbAzkniRYaZHfv
	qpqukAfVbnGQyo9ouGsFugBXodNg2dkah6FPI98A4UrEVsRH8wFGo7g/SWr4mHpmD3eQZf38/w33J
	RQG1I1Kw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttgud-006zQa-01;
	Sun, 16 Mar 2025 13:51:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Mar 2025 13:51:51 +0800
Date: Sun, 16 Mar 2025 13:51:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <Z9Zm9nPjU9kT1lt5@gondor.apana.org.au>
References: <Z9U0_uj1E2MlYhGx@gondor.apana.org.au>
 <20250315210631.d79637b9c55c7ee3287aa426@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315210631.d79637b9c55c7ee3287aa426@linux-foundation.org>

On Sat, Mar 15, 2025 at 09:06:31PM -0700, Andrew Morton wrote:
>
> I do think it would be nicer to write this as a real inlined C function
> and to convert usage sites to raid6_empty_zero_page().  IOW, let's tell
> the truth rather than pretending that raid6_empty_zero_page is a global
> variable.

OK I can do that.
 
> Is there any possibility that the MD drivers will point DMA hardware at
> the global zero page, thereby invalidating that page from CPU caches in
> some manner?

The only spots that can hand this off to DMA are:

crypto/async_tx/async_pq.c:                     srcs[i] = (void*)raid6_empty_zero_page;
crypto/async_tx/async_raid6_recov.c:                            ptrs[i] = (void *) raid6_empty_zero_page;
crypto/async_tx/async_raid6_recov.c:                            ptrs[i] = (void*)raid6_empty_zero_page;

But they all turn out to be synchronous fallback code paths that
do not involve DMA at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
