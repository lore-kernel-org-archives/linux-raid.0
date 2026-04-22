Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FAC2C0307
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 06:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776838977; cv=none; b=nsnU43IKcc0s7I2HUC/AI6bPj1PADS/udwPxu4LCXsBRXe042C+e3BeCfBZ/VXun6LN1rqb8t8buM3sfl2Uwx8HMqNDMt/OdPQ6Y+wE6Fyg8R2auoMCfjONktGD8Pv45ERnnHbWe2tZaVOsvDegQ+ngaEMnqjYNarNG9PiMAQYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776838977; c=relaxed/simple;
	bh=Rq5jcE3CJlCJsrJnRcjIAxYfuRkDbL+6lfQTh+4VpOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7sDz1oCByV7z5eCMQnLiAAah44CVFcKvJSsX+ivm5ayeqXtl1sovehj2yjKZgW2bQJP0gggjvJcoz3788L8cUDW/7FYwFIC8z1e4nx/K5ztx+Hvs82ycC0hwiSQw3BNRto5jf1vtgNOttyYrKmiemaURyJsFhH+vs/fD7kOiZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 09BAA68D07; Wed, 22 Apr 2026 08:22:51 +0200 (CEST)
Date: Wed, 22 Apr 2026 08:22:50 +0200
From: "hch@lst.de" <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: "song@kernel.org" <song@kernel.org>,
	"yukuai@fnnas.com" <yukuai@fnnas.com>,
	"linan122@huawei.com" <linan122@huawei.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	Kiran Modukuri <kmodukuri@nvidia.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>
Subject: Re: [PATCH V3 0/2] md/nvme: Enable PCI P2PDMA support for RAID0
 and NVMe Multipath
Message-ID: <20260422062250.GH5391@lst.de>
References: <20260416212633.72650-1-kch@nvidia.com> <3c4d2714-cbd4-40ce-b845-be9a02561d71@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c4d2714-cbd4-40ce-b845-be9a02561d71@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 21, 2026 at 10:32:14PM +0000, Chaitanya Kulkarni wrote:

[full quote deleted]

> If there is no objection is it possible to merge this via
> linux-block/for-next ?

We're too late for 7.1, so let's wait for the block tree to open.

