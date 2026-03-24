Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF77B3D6461
	for <linux-raid@vger.kernel.org>; Tue, 24 Mar 2026 14:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363246; cv=none; b=s75Dh59qAIDO2G0fjJBADej0wQVHp1ZqGbOMxDGmA/gXQ+hqwRR7Jr6LTXjvvyen0yLXdbR1YdG71wYbmcoKFiK9X9cfLnaSl9JIVR87rBPdZQN5rwopzZY+bd70y0W3fmSUpk64c9O2Duww4wWhSwoKprutjJ0OpJvYkpNiN3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363246; c=relaxed/simple;
	bh=QsUM4AaoWAJ6Duqz0b/ac5qONFjO3dFtd6bjcD+Lakk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvZ3XJbXUv5OQNjIBVbiv2gY+f7uBjCGVut9OuAYtR2VoQ00uyY3tCapW/5Kw7zTj7d0x35R86I3zMsLJyCKrAR+eAa5Z4jm7zjfYkMIhFXSnyYHFXIm1yhAAV3DW4UOX1ega19h9eJRXYU5bQNGNkXrDQAs1n8ym7vOjP7hW6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5IdS4Un; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5IdS4Un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB81C2BCB5;
	Tue, 24 Mar 2026 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774363246;
	bh=QsUM4AaoWAJ6Duqz0b/ac5qONFjO3dFtd6bjcD+Lakk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P5IdS4Un5DoUWzsnA4/oOhLECgnDY64Kz/1wxRdil0BEqukrMG4hVc6AU75I1u8S+
	 My7HNMn6ASDpU5JSLjy8JnKiP9cO5yOvCS+v8IdyMuge1w+tBQwDK1Dvd4/jBMPVHy
	 L1pUdzky533xCnAF8LtMW/GS3XMm2gNDmrkQtxviRvNNFpoBSJstuDtWP5HabqWWgj
	 LmYzWXjyt6PoJBPqlCWFntAsf6N1AmeNA8FGCSXbU/I/EetbQRT4sgoakWHIAx+E3K
	 M7fETVG+JituyLONoU2Gz/bD4AtbX50Ra9bgYp49omsoyjqqP3pGNwK6ic/3DmoNGX
	 szhGwjd9Rkbiw==
Date: Tue, 24 Mar 2026 08:40:44 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, axboe@kernel.dk, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Message-ID: <acKibPVk578SwyFR@kbusch-mbp>
References: <20260323234416.46944-1-kch@nvidia.com>
 <20260323234416.46944-3-kch@nvidia.com>
 <20260324064937.GB1409@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324064937.GB1409@lst.de>

On Tue, Mar 24, 2026 at 07:49:37AM +0100, Christoph Hellwig wrote:
> On Mon, Mar 23, 2026 at 04:44:16PM -0700, Chaitanya Kulkarni wrote:
> > diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> > index ba00f0b72b85..c49fca43ef19 100644
> > --- a/drivers/nvme/host/multipath.c
> > +++ b/drivers/nvme/host/multipath.c
> > @@ -737,6 +737,9 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
> >  		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
> >  	if (head->ids.csi == NVME_CSI_ZNS)
> >  		lim.features |= BLK_FEAT_ZONED;
> > +	if (ctrl->ops && ctrl->ops->supports_pci_p2pdma &&
> > +	    ctrl->ops->supports_pci_p2pdma(ctrl))
> > +		lim.features |= BLK_FEAT_PCI_P2PDMA;
> 
> This assumes all controllers support P2P, but we allow matching
> over different transports.  So you'll need to do the same scheme
> as for MD RAID that checks that every member supports P2P.

If that is a possible setup, then you could add a path that is non-P2P
capable sometime after the MD volume was setup with P2P supported, so
that case might need special handling to notify the stacking device of
the new limits.
