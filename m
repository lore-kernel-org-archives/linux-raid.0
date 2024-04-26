Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CDE78C7F
	for <linux-raid@vger.kernel.org>; Fri, 26 Apr 2024 10:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714127800; cv=none; b=q4lTBNwmNh91+shgobqCSEPiBStP0QtCXu7R3QjE3GyNJacqsdL9yAyYgzhRezIYsGP1bRDNW5wHmiezMFy+6gQUN1ee5WdfMEH/KWnfdGaHM3oW6LYwIKt8Z+y+s4smAdFjTxRL907wZv/AHdUeZH75+UGK6XcdB/zVqPAmEQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714127800; c=relaxed/simple;
	bh=DgJUzFr8skYdqk48iMdedMHMo1ZZWPq9jQdRLA4ZGK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agPILBUXJGCz9NMbsXvwPUkaCpLasIWRN1m2nPxKKT7tvBdxlK9WWbN64+MdOskSuzqgTCWjkZj1mVQH4o/aip3h20okQjxryndAY9cL2czUw2REZs9BNtRWMxFtlzTrNwBwqYlPZIITMRyqu69N3n++y8NakRzktcC8TS+OkN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZhgH1iSJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZhgH1iSJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DgJUzFr8skYdqk48iMdedMHMo1ZZWPq9jQdRLA4ZGK8=; b=ZhgH1iSJubwYIwBjMqK1o83CS6
	fse9M+EitTPNizaCtrPdqqWeP4ogB4SKan2oYoY2n/Xbfy4Fs0e68okkA2GzfZwmoL0oZuwj4+AsG
	uJokUHRb/4kyWH8OhePzW2kx39ht7CSMX4cvWhfSdcMtxUcEHqzATtOLH7CrOnVC+umFJjkA/HG/t
	swfXw9QiZtp7zZfcejVYCTpOvmlFeUdj/Ydy8HUVOIj8FbTVYFz7prAPSa1Wa5QUV6phdbpLHlsL6
	ZwpJ/Wn9CEJxgJLbBrMayHoutbomW2+WcXpvHEZ/m4rCGH1n0wlWWrhoHz8sAyNTA73dzn59nG1k8
	3fvu1gcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s0IwX-0000000CAUo-2NPs;
	Fri, 26 Apr 2024 10:36:37 +0000
Date: Fri, 26 Apr 2024 03:36:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Wols Lists <antlists@youngman.org.uk>,
	Paul E Luse <paul.e.luse@linux.intel.com>,
	John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
Subject: Re: Move mdadm development to Github
Message-ID: <ZiuDtQTn39HVgIH-@infradead.org>
References: <20240424084116.000030f3@linux.intel.com>
 <26154.50516.791849.109848@quad.stoffel.home>
 <20240424052711.2ee0efd3@peluse-desk5>
 <3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
 <20240426102239.00006eba@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240426102239.00006eba@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 26, 2024 at 10:22:39AM +0200, Mariusz Tkaczyk wrote:
> There are thousands repositories on Github you have to register to participate
> and I don't believe that Linux developers may don't have Github account. It is
> almost impossible to not have a need to sent something to Github.

There's plenty of us that refuse to create an account with an evil
megacorp just to re-centralize development for no reason at all.

But hey, I'm not a major mdadmin contributor anyway.

