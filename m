Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TtW7VWes"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E044113
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 22:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Lln/MLNoxESo+IJkYPxF+z/r1tUOxzWlL589Q/PQRxo=; b=TtW7VWesIzm+isqWMkapn1tfsS
	AVvAclAyyJx0k3KdrAAgVVGmhl4xAB0D8dhHTGQ/YJ+9h/C7greX7jOnmPHC6Wi2fDvMaugbUhms2
	2u6l6ymjM0t0zmTFQndWP+LixXy43ZZvN6Aoq+ctcL31qPJOvvOHXQNazbJVqP70tBwuFzLzxJhl/
	eibkz9jXp2DBQNMiv7Wd9mTZUUUiWZchMv3ImG+Ar73fOo66EHEgz6pxfncV9XsBjG16c7rnm1lA6
	T6CBZaIJNA/gW0ar7+KzY3jf754GdEpiAy+4Jcg0pR0lVNjMic5PBfVkkpIkTmnMAOTwb2g66DWO/
	CijLHeiQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7VML-001b9n-1Q;
	Mon, 27 Nov 2023 06:44:45 +0000
Date: Sun, 26 Nov 2023 22:44:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yiming Xu <teddyxym@outlook.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, paul.e.luse@intel.com,
	firnyee@gmail.com
Subject: Re: [RFC] md/raid5: optimize RAID5 performance.
Message-ID: <ZWQ63SpjIE4bc+pi@infradead.org>
References: <SJ2PR11MB75742EC42986F1532F7A0977D8BEA@SJ2PR11MB7574.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ2PR11MB75742EC42986F1532F7A0977D8BEA@SJ2PR11MB7574.namprd11.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Shushu,

the work certainly looks interesting!

However:

> Optimized by using fine-grained locks, customized data structures, and
> scattered address space. Achieves significant improvements in both
> throughput and latency.

this is a lot of work for a single Linux patch, we usually do that work
pice by pice instead of complete rewrite, and for such signigicant
changes the commit logs also tend to be a bit extensive.

I'm also not quite sure what scattered address spaces are - I bet
reading the paper (I plan to get to that) would explain it, but it also
helps to explain the idea in the commit message.

That's my high level nitpicking for now, I'll try to read the paper and
the patch in detail and come back later.

