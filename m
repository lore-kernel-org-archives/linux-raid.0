Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72346205ACF
	for <linux-raid@vger.kernel.org>; Thu, 13 Feb 2025 07:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739430605; cv=none; b=XGpErNUktvd2XGyZQX+f8kBhqwmNnkjRTyg5NX6Gfl+HFqg6f8aAqtYudRoK+FCbWo3EMuF4MIlddGjxJC71xn0IT1iT/OxcNyWucYNGIpNyuvl8Njg0rTxFa++Z8arDUb0TT/Gh6XELS+7AmvxQn13ecfvs6zJ2S/Q/F0gXOTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739430605; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KV+5tYXGFCsEOmJkHdwfDhVlwZxuq/n9Uj19n37nDcHM6+danxYOGCmHtGQyBIRFZ8FDh3g724nNeE2YQ8m9AbmiNCpwPBW+ITaCeI63ZBbd5x2CLsBAAsCo92KPXVD3ZqBWXRYGsYfU2aiTqBQd02ElKios8jpvKt80upPlL3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9981D67373; Thu, 13 Feb 2025 08:09:58 +0100 (CET)
Date: Thu, 13 Feb 2025 08:09:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
	Yu Kuai <yukuai3@huawei.com>, Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md/raid*: Fix the set_queue_limits implementations
Message-ID: <20250213070958.GA21226@lst.de>
References: <20250212171108.3483150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212171108.3483150-1-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

