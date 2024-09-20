Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6640D224F0;
	Fri, 20 Sep 2024 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726841281; cv=none; b=IvcJr1OL974n2vw8+jBbcFV6ajdUG66NLzGIOrEAVfaU8e8sEH7f5FH5HG6ksSlIEoNJzYZApyekh8AVShg2DM2+OWX0Wk0WXEdXoRPiYS9J8av8m5RBBalxxBFyzHn1P+U0bMfENZ3qrUiFPS6cP1KRchszNiwmNaT08hG/oa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726841281; c=relaxed/simple;
	bh=hwZAeAmd4HyEYoB1+Zh7kXvzw+mcdYaNfCR9YJJLVIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3eIUZoLyXGEw2fALTpBJeBdZg1cqQy16lNvSY3sFtAcM1Apytyn09tABOIj0LKYgvF9pmI3+sI1L4MLcZRoiDXXTQWo/GcqyDc250r3w9md7uEfi443xggRoixWTq54JQj4Zn2StF/38gBmSqrZNoXJ6tOd8Xuakakm+v3/sO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 384D9227AA8; Fri, 20 Sep 2024 16:07:54 +0200 (CEST)
Date: Fri, 20 Sep 2024 16:07:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH RFC 1/6] block: Rework bio_split() return value
Message-ID: <20240920140753.GA2517@lst.de>
References: <20240919092302.3094725-1-john.g.garry@oracle.com> <20240919092302.3094725-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919092302.3094725-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

This looks reasonable to me modulo the WARN_ON_ONCE comment from
Johannes.

