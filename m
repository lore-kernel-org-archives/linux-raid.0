Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD6634FF
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WNCbZ6fr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DlRKv6PsLrQACZGaDUgKMaQbrAqnXXOfOFsz/BXTrhE=; b=WNCbZ6fru9KNmDdXwxFhS428KC
	xH2L9C3UWSIED1JH/eCMWgNhFoXlM29pXMRSBnsqfHk1QPHubq6BbG55v69ileliwAPgwk/7Jslux
	4UXIOrkTXMcLsmdGCjo7FfdAvkcZ+ceXb5JYzEJUs0A/zTkLTLNA4YDK21psY3ep6sIRD54MZtS3S
	rsZIfzTjSIlXnpl54U2VzukOqmpy2pnIt98+ICG2vLjY0dPVqD02+7m9HIZAJmClrGTfs9HM7yzQ4
	qQ4j72f9vi1UQHyAW3+fndkmcF5a5c75XV66c9yth5eyu8B0PgPZe/g2PO3EA5wf4TSJJdYla0DJy
	c6zci18Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGOXz-003txC-1K;
	Thu, 21 Dec 2023 19:17:31 +0000
Date: Thu, 21 Dec 2023 11:17:31 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>,
	Joel Granados <j.granados@samsung.com>
Cc: Coly Li <colyli@suse.de>, song@kernel.org, linux-raid@vger.kernel.org,
	Joel Granados <j.granados@samsung.com>,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] Revert "raid: Remove now superfluous sentinel element
 from ctl_table array"
Message-ID: <ZYSPS+yUlzTYETgh@bombadil.infradead.org>
References: <20231221044925.10178-1-colyli@suse.de>
 <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Thu, Dec 21, 2023 at 02:19:56PM +0800, Yu Kuai wrote:
> I can't find this by code review, and I think
> maybe it's better to fix this in sysctl error path.

Indeed, we want to fix anything in the way to remove the empty sentinel,
we continue to do that in queued work on sysctl-next [0]. Although I
won't be able to diagnose this right away, could you try the out of
bounds fix by Joel [1] instead?

We want to identify what caused this and fix it within sysctl code.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=sysctl-next
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/commit/?h=sysctl-next&id=fd696ee2395755a292f7d49bf4c701a5bab2f076

  Luis
