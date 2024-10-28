Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72C41DF273;
	Mon, 28 Oct 2024 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131951; cv=none; b=F5QWf1PixN+1CBxXqGi0iz/GVshIZIckgMLlUOWicTbeNDfuC13tTA3A4XWm+b9v+NOJd9gV+KqPEaL1u/pjqq9hZxoCIld+CBNwXcGxZG5TuW2ARcyY2tJFZp8PxHhTe62RtzuGuYz2Cl61G7EkzmIS6R28ATbghZFpBo+RozQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131951; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsDvetbnWmrzxnfcDFMnDhojBSZ+z3g+GK+medwOR44EISI39gOOnIpz+VmR6nZp4ugg/EnVAwer5ZOBdX9eeNJ3Ew2TcuDlY1Nd9oGBc/BhAH4L/eF+iC4XHJzq8C0nEO0LQoT5WFsdgxhEnEEB/EdMJAZ1gAfVjp3MVG10eos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C13F968BEB; Mon, 28 Oct 2024 17:12:26 +0100 (CET)
Date: Mon, 28 Oct 2024 17:12:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	hare@suse.de, Johannes.Thumshirn@wdc.com
Subject: Re: [PATCH v2 3/7] block: Error an attempt to split an atomic
 write in bio_split()
Message-ID: <20241028161226.GC28829@lst.de>
References: <20241028152730.3377030-1-john.g.garry@oracle.com> <20241028152730.3377030-4-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028152730.3377030-4-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

