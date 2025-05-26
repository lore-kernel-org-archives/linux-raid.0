Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6431C3C18;
	Mon, 26 May 2025 06:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748240968; cv=none; b=RdVwe+dk13wsp6ztX5efuuMfB8Gf+CXJ41nvfe5YooO5Bg+zLnTiid04j9k+XorYpVvxQWhHcOFVHx8zdby9hj16LYFLFjg+dNZvTSadLLSyhN0fH7J80YXuT+mpYnybkmFR+xLzDPVE/UTVRG39z44B09BUOa+crEGIM0F43L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748240968; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cu2x86cOfUUEAj7xbNaPtSCpytJJOxu6U2J/moniRs03y466NF8ngXXzBmQWOOZu0OdxysZFP5nqdt4+SYTC8pxPMq5t7JAyzeDrLfrkjexGr4QDsPYzso2txNjRFB3t8u3rkdKr/c2X7dXFZCEJhdxQ2f3zWiPzbcne2EnGPXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E30B168AFE; Mon, 26 May 2025 08:29:22 +0200 (CEST)
Date: Mon, 26 May 2025 08:29:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 03/23] md/md-bitmap: cleanup bitmap_ops->startwrite()
Message-ID: <20250526062922.GC12730@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-4-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-4-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

