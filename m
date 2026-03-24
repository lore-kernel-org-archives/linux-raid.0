Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801C4286D4D;
	Tue, 24 Mar 2026 07:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338936; cv=none; b=S/rfQEKMnIdT/1fXLmlTkCr9SI4rRPV5CwzcC5Jy3czmg8pHjJhS7u3FH36A0ljZvdZffesN2H3TKQrl59pIyFrYlpOZk81z5JVs59nwnguASix8dXV4ZimMCKSd55DYPZjGyPaJ3TfEPe3qr0WueBsxWZbCs8gvLfKx8zf4/3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338936; c=relaxed/simple;
	bh=14QrmosV2u5MUe0pFSiuP/YiVslJNpt2Cv5+QdAInNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmjWJH9L6fZos7I7mrxWj2AbLuxbAirVFn1SR4dP5ka9T8OBX7u/Y+cS93ABKbHdoz6fNZU/lOaXNarEprTAG3DLnYIAcx5Db/9u1ECfdSGXDlXMML0/nknLR9lqhYt69IzqCuiAecj//8uRpIyi3jPxs0pIUXAmIUSz/VfaG2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JDeQQL8M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JDeQQL8M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=14QrmosV2u5MUe0pFSiuP/YiVslJNpt2Cv5+QdAInNg=; b=JDeQQL8MR8Tn6am/1H77Lx/45O
	+znCf+eQVpyG7eG9IXtD6W0SkOO/QExK6DwQfjK+0MktxNPo7MIFu09z7+wxm1fOfP1RLAauukp7i
	+7Pj0dnLj1rmhCV1hbAFbpLapWx67olS/fVGQwuxI1Sn7IAKchQbdS67g0Q2AvolPVvQ1am8sj8Xt
	ig7akcJz00/GNcay6bLqNfZcjV2pJe5G15IygRHdqT0kxboqDME8d2atN6Xj4AJ9mBIPhlTmHxNFa
	daKUcm7OieHJ73ibnsZvUDLBDk4wthZ4B5oPPjBViOaKvOykTUaNIVcfP6yNVxsKAjgrAUMoIx+Gm
	XQZ8nnnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4wbl-00000000vnu-3BlS;
	Tue, 24 Mar 2026 07:55:25 +0000
Date: Tue, 24 Mar 2026 00:55:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: sunliming@linux.dev
Cc: song@kernel.org, yukuai@fnnas.com, akpm@linux-foundation.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH RESEND v3 1/3] lib/raid6: Divide the raid6 algorithm
 selection process into two parts
Message-ID: <acJDbQ8QjzxIrVg7@infradead.org>
References: <20260320060750.31334-1-sunliming@linux.dev>
 <20260320060750.31334-2-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320060750.31334-2-sunliming@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I've fixed this slightly different in my "cleanup the RAID6 P/Q library"
series by simply not considering non-priority algorithms at all.

