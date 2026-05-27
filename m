Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951C926E706;
	Wed, 27 May 2026 07:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867144; cv=none; b=HTh1daAWE71L/lETzs5ibzIs6kXFrSQwmnyQiw/TlK78LPht1H6Hr2GKOt+heeHUgnhPi9W6VoZWDD8NCKOk+mMhBPpJ8k6pRdU9zkx8pAeDtfwomDsd3eXXl3YTI2y4n5xCKVkBB6bJK+8DCwmFq2vVohTSnCpKfKHjSwHUcAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867144; c=relaxed/simple;
	bh=Bnqm1PUlXcpQOpp83CzY3yA/a3r130J/7y9wVWWZawI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQjGl6+pk0naN91f+E0HpMq5GJQDJoCATE9P+NOnFkHj1HawoBPR/+oRmuk50Deq8fNFz4U182POAiHsLEdcD8WEt/upVCAU1Rnh6N3JqsEDBQVhqSJ+mr3Vy48hRYTouGv5rEJNRGXtrmdh0EF6qxxs8jHl1XnjfhjwZ4xEbP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dOZxfO6U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dOZxfO6U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bnqm1PUlXcpQOpp83CzY3yA/a3r130J/7y9wVWWZawI=; b=dOZxfO6UtgiIeNFOXrwCMM3pqn
	070nwCYciZpWBVLEeX64F6HFhhvVuXTu1lsrU6UASi5mmCK1CjcvdzJe0NS0xkyhUg2E1CGhuIvEH
	S2CkR+x4mU7iiDVJaEI6Ju1TclaMS9kqP1uR9YKbab+If7znbwLkTdWZjWmGYpo7LEs0BCcZfw6JG
	TVgypKRGxTMlUeJhLxcRzhdEGrv7hlTjPqc4MY4NP6HlfZZZV4mVLFkPDggkhLQQtYO27spuyZwE0
	I/Iy6D3hqPHFLIWEFkj4ltLV6L2tlyaGYs4oZT9hs85UM00jpV4M5Qr5mZTHJzD+i7qH3hF/0a2Yl
	C6wIip8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8kU-00000003TAQ-3QMz;
	Wed, 27 May 2026 07:32:18 +0000
Date: Wed, 27 May 2026 00:32:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lib/raid: use kvmalloc() in calibrate_xor_blocks()
Message-ID: <ahaeAngWN7sMboRE@infradead.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
 <20260526-lib-v2-1-ca3f0fc24b14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526-lib-v2-1-ca3f0fc24b14@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Can you stick to the xor: prefix used for all commits since moving it
to lib?

