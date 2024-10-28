Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49901DED79;
	Mon, 28 Oct 2024 16:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131933; cv=none; b=nj7mwIdyR8XUjPfbFvchtl1bAQd6cyhAeqbOpV9Aq2pJvhMpMHSAzWxcM/1COnRhSEH+EoUGLWWQMCaE3MVPIC54NfjtFRF7rPvAptdTyFnKWBbCaCi2sJxabAbMbNqDT8yfAD7XjcAnr9eLH+8FJwnUMCNcER/IW2a/vQuyf4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131933; c=relaxed/simple;
	bh=OeQuNozZgfEJuinXN4v7Vk8kOUSJa9kUfQgC2TC/6hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NP2bLRSU2+egQ84+wSYFN26v7tyd1GlaAt/WeXMW/2CQaM390oUx1GZtEh5yid8xs17FWscURRxfn/P7bUW/Dmwbn9iiWa4nHA11OMaybaeXn6PDYXHKyNNtR2S0k96axJ5CeGhcc4R8DmalrGaW1k+41Wuz+z/o6WtdaU9CVRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 113B468BEB; Mon, 28 Oct 2024 17:12:09 +0100 (CET)
Date: Mon, 28 Oct 2024 17:12:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	hare@suse.de, Johannes.Thumshirn@wdc.com
Subject: Re: [PATCH v2 2/7] block: Rework bio_split() return value
Message-ID: <20241028161208.GB28829@lst.de>
References: <20241028152730.3377030-1-john.g.garry@oracle.com> <20241028152730.3377030-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028152730.3377030-3-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(hopefully I'll remember the change when I forward port my new code
using it :))

