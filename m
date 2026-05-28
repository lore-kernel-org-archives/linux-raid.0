Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF423ECBE3;
	Thu, 28 May 2026 12:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779972468; cv=none; b=AmXytJVOLh8ofwQTZYqbnT5tnyKdeQoEEV85hb0aWARSL/Fmnve1EIPJWAlBZ3qezthxG1CpxM77H0ESxC77aG0LxiJMgkxev9jHAw96bL4cJeAEae+4+ssynvpoZG9RfNhNN+HoYdfCNrDuHqf59fIj5+x46bm3z1XaQQ7NJ/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779972468; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFAc4RdB+JCCXIU6M+YPTnX49qdNgRdclJ8/ABr2r1LWPfGDhFHePjwDkBm+7HSgvcBUy7ZLj77K70uwHsjJToF/XszRc5Y7cSn9OGRMpfAhj6qv9fEYhjSh0BwpkWP09LJr7yU0eWjb7We745I7S3zIyYtEY20//nXVipLCTuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Rpt0pUFA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rpt0pUFA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Rpt0pUFAIa9nSS9CGU3dMqfeCD
	a8YQU/79H2ACOklJuXj3Kr08pgWJTpsUATRMMilHXk/G636/TgZxl0KEBgIiCQjzA7ChSl20tvool
	jAbbZ+flzyZwAm3cLqtxb2g3qH+QnXiXHy7wreQq28hjJaRaho2LGzdMvkb4Ef6leddHK7T7j2eHU
	rvI9o8evYJ5MBhuyGy4UN1akBx4npkn3nDNJ0mG90orlcjaicbduuN7jjT6dPuAJUAFuF/c5yEuzq
	DDp6RLQ6bup0ExTOSFen2ax3tUhDJs3O9Wo+7SWR4PvT5JKgxHZGfqwqBCHO2esd6govgamAvH+5m
	QFR7lv3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa9F-00000005jo6-3Cxr;
	Thu, 28 May 2026 12:47:41 +0000
Date: Thu, 28 May 2026 05:47:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Message-ID: <ahg5bR2IZma0pB9i@infradead.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
 <20260528-lib-v4-1-4e3ad1277279@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-lib-v4-1-4e3ad1277279@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

