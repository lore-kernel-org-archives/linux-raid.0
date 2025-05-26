Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADC31D61BC;
	Mon, 26 May 2025 06:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748240921; cv=none; b=sFN/Ns01Ct6RSPDcKCIahOxtiOhMGicCB+UTM8Bf3wJ2PPztNr6vSRsYEqd2cymbbGcAFpTLiiOt5j9kUz7JYWAUPt4cHKxSFw4cGt29pc/74eTTbVHA/I+laP68UJVixcFEbv5eLSnArn87bJzZYMsNYUDkQv96yYDA18jmZ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748240921; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYO01fgYe+tJD8g8Ew4tYgkImJDxWUl/8VT5zvf491oNG3YcdstQsnoNf0IF1ZgmV6/IeH/gJiRgBcRmPrFW8p6NZQFFRtZX3FCucHASNS2tsCOMIYEAdAgpd2ca7Xk3QlMRsv2csqNml2CkarsPGlC3nb10r+ekIVSX6KmxOAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9AFF668AFE; Mon, 26 May 2025 08:28:35 +0200 (CEST)
Date: Mon, 26 May 2025 08:28:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, song@kernel.org,
	yukuai3@huawei.com, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 02/23] md: factor out a helper raid_is_456()
Message-ID: <20250526062835.GB12730@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-3-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250524061320.370630-3-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

