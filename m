Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E2D2D46B4;
	Thu, 12 Feb 2026 10:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770891358; cv=none; b=OcHkFOzESOpvxDsSwBdMFDSqqoCPvHmXKoDK04rMIKNeJHxraIhVGEQY9jNVeN8a3HfOGcTNRqdNjZi1CPaZBGCDAYn0vRmEVWrqjcZnd/1l5MI2lyicgrgKAkens9zMhuQYHpNEfO1mWFlvyACWuOdEFD1QcZ2+8rU64nk4dVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770891358; c=relaxed/simple;
	bh=Lc55MufeLpU24ZftEABb3grhkBRFAd1Jlyep8ro3YWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vC86kPWlpP84jfecQaFGe0Lvp3PVI+ClrBZ7XXsg6+Rx/lDOtsWFrekMZ4thsG1yDMyLr0o6CmPWyRQTGnJLA1dNQjX6BsZIpf5ghzmWc6qBIBn6Xh4sbbop2DdGB9tRaH8fGyFIWjQlKYrRGBZvQihTfka4papSS1enwRc5McQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 29A3E68D09; Thu, 12 Feb 2026 11:15:54 +0100 (CET)
Date: Thu, 12 Feb 2026 11:15:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: linan122@huawei.com, song@kernel.org, yukuai@fnnas.com, hch@lst.de,
	sagi@grimberg.me, axboe@kernel.dk, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org
Subject: Re: [PATCH V4 0/3] block: ignore discard return value
Message-ID: <20260212101553.GB8615@lst.de>
References: <20260211204438.22568-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260211204438.22568-1-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

And maybe Jens can pick this up for 7.0 so that we have a clean
slate for the new merge window?

