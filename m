Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605162F872
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745303099; cv=none; b=GeCI+VObzsjX9RHeto4mK/cSZWZSE5QanjzGAUDlTQmGrbDkLL4poyphfBr03/r+Ru4XJp5b0o/OuUg0sboSQ5Xq0mPbNmsrj01S07nZpGUD3xR+BkN+4oCNBrZJwJBcKOfQA8cd5lvb41fv7NOpPzeFu42CGY7OSoUPz+nGqHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745303099; c=relaxed/simple;
	bh=Owoxf0s2W6zlvv+Ly0up58TmIm/8VMYAwsM80E5/DAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZflxH8nhzT7hMqCsWOdDDPi4H+Rlw2MKh6P8TSSxKnludIenj6QYSd0QWM1h/M3vrGImZGKl+UV0cky8lw/XcCV1tsqpP9f/U2RXwT+5E3UGh0IbVRtHRyHC0YtMDBKVoB9LFe/jLAf8YRpBa1aaPaZKpLZjTCkAAPqONJV+2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A35BA68BFE; Tue, 22 Apr 2025 08:24:52 +0200 (CEST)
Date: Tue, 22 Apr 2025 08:24:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@meta.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
	hch@lst.de, willy@infradead.org, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH-RFC] md-bitmap: use page cache for file backed
Message-ID: <20250422062452.GA30127@lst.de>
References: <20250418015636.2457376-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418015636.2457376-1-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 17, 2025 at 06:56:36PM -0700, Keith Busch wrote:
> The md bitmap file had been using a custom page and buffer_head mapping,
> going around the filesystem. Use pages from the file's page cache
> instead, removing the abused buffer_head and bmap usage.
> 
> For file backed bitmaps, pages are initialized with read_mapping_page
> instead of allocating special pages. This returns pages synced with the
> backing file. Persisting changes just needs to set the dirty pages and
> initiate a write back as needed.

Using the page cache all the way down in the I/O stack introduces a
significant deadlock potential as we can't use mempool for it.

See the discussion related to Yu Kuai's lockless bitmap series.  Reading
the cover letter for that it is intended to be on-disk compatible to
the existing bitmap, so maybe we should concentrate on the new version
of that instead of having to parallel bitmap efforts?
