Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1E7395D80;
	Tue, 24 Mar 2026 07:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338976; cv=none; b=lFuahN3ckMKFV2yUilrOH4k3YLyFgZu23V2iEwCswtcNk7zJbCvN6BeW8JJk0KyJJOU4xUXqfqevjDuu81m2ydA2VtGK8KTqulUSuE/adXolrNmv7fAfaZDcr0meukEyFzHyrCNmsoQM4JLTMMP7gI2O/fY/xIFf4DKtrSL9mng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338976; c=relaxed/simple;
	bh=hQNBvN4tnA/IpTaTEJQ7oOOaKJQhomJ43OLtrAdUteQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkLOYaYJazUTbvHOnFP16JWK8ycIbEfFsIdse6brmQ4J6kxKxUgTjffn6O4h6Bja3v8kQbUG5/lYnexuq8kU7GUQgqMszrv0EJHwm2/+jaooFlfCrkFLhwIugC2ngnsKj3Pc1jAVApWteB3p70eHv3gIwkYsouN2ajBS+xa8IzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wfnAmu8Y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wfnAmu8Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Tcb1g/wb3F6Z/N4rtBqF2rESOqfBtzV7pLzFHoAxE7c=; b=wfnAmu8Y8qmNFBytg6uQpQ0ikJ
	8g1kC1auEltkQno7+ZbhlDhnYivWpUsxGET1siMfhYTuwsB1g3FGijxtCDn3Lpy1HNBIoZH09M9Fa
	neeEslj7o3mfclN9HJYb5xxLNixYZ4sussf4WpunbpBz7QZDBYmpn/Ny1uknefaf3oqJvMRg3yhN7
	5voCLQGww62YWOAVZb8WG0ADEFxTd/OWSYs27vs/DHB1d4XVBKpwMV9awfBYchPw3sr8nA+raogg2
	nFBuoFwyC6YBHnJv7rzoXsp10V/z5pXAoKKAYqfgRg+0q0F+6o/Wtc/LIJ29nx16KUJC39YFwtA63
	i5JZX60A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4wcP-00000000vsd-25Mk;
	Tue, 24 Mar 2026 07:56:05 +0000
Date: Tue, 24 Mar 2026 00:56:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: sunliming@linux.dev
Cc: song@kernel.org, yukuai@fnnas.com, akpm@linux-foundation.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH RESEND v3 2/3] lib/raid6: Optimizing the
 raid6_select_algo time through asynchronous processing
Message-ID: <acJDlYgX-PW7foRv@infradead.org>
References: <20260320060750.31334-1-sunliming@linux.dev>
 <20260320060750.31334-3-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320060750.31334-3-sunliming@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 20, 2026 at 02:07:49PM +0800, sunliming@linux.dev wrote:
> From: sunliming <sunliming@kylinos.cn>
> 
> Optimizing the raid6_select_algo time. In raid6_select_algo(), an raid6 gen
> algorithm is first selected quickly through synchronous processing, while
> the time-consuming process of selecting the optimal algorithm via benchmarking
> is handled asynchronously. This approach speeds up the overall startup time
> and ultimately ensures the selection of an optimal algorithm.

Offloading the selection means it run in parallem with other code,
which could affect different test algorithms differently, so this is not
a good idea.

