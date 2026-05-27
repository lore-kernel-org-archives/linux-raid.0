Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA57D3603DB;
	Wed, 27 May 2026 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867195; cv=none; b=Mwv4oLBD7xugGDtHqSLJFgQ0bhpydpdNbHn/3zvrYhP39gXiZF+HOamvAfbGRT8gIkyNJAHnb8vxcnqlejK5lNi1hqlACfyCh49ccFrsUIZXc0ddIVJE1kH0yKAUMT5o6ESiTTH5n3SwevFM9/CuXeQFUXd/7IxmaNyPO8lSJ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867195; c=relaxed/simple;
	bh=CaR6k388gQ4mgCsIMny1yKyYgs9PsCBspKn5KTEv2ys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uknkVsaiR24scWCwMV1V99hQlBnDL6GqVpaLGhZX/TwTtvMaM7ufHsbf4rsoSsRnQsnRZXGNtEpEAUSFPkbKns3Uws4Jsu3Nm9ujXAUcuA11U8kwzrD5d64ytf2yxOWrJDGgK1OGPqE//MvMsWYon6AIQpaQlf1QGZRr/nnYFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U6snnG1n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U6snnG1n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CaR6k388gQ4mgCsIMny1yKyYgs9PsCBspKn5KTEv2ys=; b=U6snnG1nOqO34XUk5lvYXxxT8Q
	t4Yt5NBhocvasjjbqCxsAWA1lLEnYlxmvJQ+F5kjflsnRvNRbbn77zvy67zivP0DprdLP5b/et29M
	oJH7+KCLcafkpcp9jZRUUcjDcGD4+9O6ivrMhOJ0V6R9/CBl3JZ/RiBSe6blU5CREZbi+LxJeoQkT
	zMCRfsjDd7Dr0UpDg7LyymYigasthG6H//cX4lqKGRBTYLIHJyYR4xRmt0Glut56MJXQuiLusnsVl
	UrJgcGmku2fvUStnI7U8lJkOVxpVgmkPfXHtGn6SadITL6aYXuf0oOvSU/ToQC+SX4pzKKOWtCCuw
	BPIfaRBw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8lM-00000003TEw-1GDi;
	Wed, 27 May 2026 07:33:12 +0000
Date: Wed, 27 May 2026 00:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-ID: <ahaeOOkuVZmIXFpN@infradead.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
 <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please stick to the raid6: prefix used for all commits since the move
and most before that.

