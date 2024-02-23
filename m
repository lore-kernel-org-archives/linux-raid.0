Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBB37F7C1
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708702642; cv=none; b=K+Df0zwQ0reHvWCZ/GKrlpttUWeTMSOIKtEG39wlxbOD75H7Cx0RqWYxjUb1UJe/VXkCZN3zmdveYkv4mNRhqmuqIrskuP66yoo6EIKhcOvtH0ytoJ2uH62Na9jgEyWBc0gwqxTLRbr8J6v52dWqrWeJlxs0FXqLu4vmF+DkDkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708702642; c=relaxed/simple;
	bh=sGlav7UGynGoH+N9jCwjjiJ9r913j9SUhhPivEiYQOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSTbtq9T61lH3tSFZdBnZ3ngNvaHq0oTMhxmdVuqyiYF1KsBplYp4igGHAixDoJG+IJRaf+Ad90Tgns/rx1CKbBtmbgasstdSzaB9zCga1KnhWEjj5MOuF1a40SukMzDVwUGiB9knqYZka71A+ETzd6OipO05Nyc/gvKv+PKEts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8067168B05; Fri, 23 Feb 2024 16:37:13 +0100 (CET)
Date: Fri, 23 Feb 2024 16:37:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Heming Zhao <heming.zhao@suse.com>
Cc: song@kernel.org, guoqing.jiang@linux.dev, hch@lst.de,
	linux-raid@vger.kernel.org, colyli@suse.de, hare@suse.de
Subject: Re: [PATCH] md/md-bitmap: fix incorrect usage for sb_index
Message-ID: <20240223153713.GA1366@lst.de>
References: <20240223121128.28985-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223121128.28985-1-heming.zhao@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

... but if you're actually still actively using the bitmap code,
any chance you could try to look into updating it so that it doesn't
rely on ->bmap?

