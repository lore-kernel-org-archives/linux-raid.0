Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D80238C1F
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 06:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805237; cv=none; b=SeL4nevFqbZFf2CDcR/y5cEtVnnBBqJoFdNyNmXSntRDvAHzXSU2OhoGFe7O1GnVUtG3PPfuO2o+NPWvEBGGWHFvou6WsjgtOln7ahhSn370zV4bXscPkLXIBfxnNyDBfVNYA021GTVD+6Ac6w9kQQKeiikaDcfQBoczCDjIAOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805237; c=relaxed/simple;
	bh=xHew7SEQpp4AwbOSGe1Iz1atqUCmbhOdN+LqBQTEtmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nfcyt4S3pfFUzuEM8QeMlbGavTuwbpGnGilkDwR490W9sV9Q1dDHuPseEJjQrT2WFQfos7QlHzJ8lxOWz0bs2hH2T4BMi5bOIFsgXyz4/9WPioXOzyY6MWZiKTKVmLzQjA6lmPQXlJIDx9EFxcyJgooGwFJlkFBZ9WX9BPfSqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rMhkCmSC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rMhkCmSC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pU9SXdLXInW2gX6mMYFdFq41/WMFLji3BYmHiXv4XrM=; b=rMhkCmSCzp6LvVZBNxFnjfTOat
	3M6/QKAsnCN8OZOVIDn/a7smgOB8nuapmuhK46iVQZklXY7oepSXEk3RdwuUUlqj3Y8LkuBUL8h9G
	VlFLPd7fAxoyIy4wzqUcsk7y1l7uVcGmZg/VqQW4Vvh3K3KUkIZ9DqZomQ7v1gmaiye6/WyADjF4U
	n+d/5lMuEWO4tiGlAOG+pnyGWAmmc7qYkbwC2FdRxWk1dcdaqdFhAYKJoxKRwQC235iz7Vk2srh5P
	VAurrQNnyuqIuMA+lQqCvU8OxE9BVqypZO+lUJ27oemM64iJVzxYlG4qLIcV/aB6jwYkh6nybP6Jj
	cJSt6Klg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhj2h-00000001Qm9-3LyU;
	Mon, 19 Jan 2026 06:47:15 +0000
Date: Sun, 18 Jan 2026 22:47:15 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
	linan122@huawei.com, xni@redhat.com, dan.carpenter@linaro.org
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Message-ID: <aW3Tc66fqSwv319o@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-8-yukuai@fnnas.com>
 <aWpUYD1D1n-HJR9u@infradead.org>
 <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Jan 18, 2026 at 07:40:23PM +0800, Yu Kuai wrote:
> No, the chunk_sectors and io_opt are different, and align io to io_opt
> is not a general idea, for now this is the only requirement in mdraid.

The chunk size was added for (hardware) devices that require I/O split at
a fixed granularity for performance reasons.  Which seems to e exactly
what you want here.

This has nothing to do with max_sectors.

