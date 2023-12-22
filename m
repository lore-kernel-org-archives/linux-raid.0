Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8089828E32
	for <linux-raid@vger.kernel.org>; Fri, 22 Dec 2023 17:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w2UHI16Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
	bh=SCIOMakM7X1yeuLy2EnY3J2gTIxDIEIUsW0aSrHRabo=; b=w2UHI16YQP3yQd/uln/N06IS6X
	h9iNA2aE3xGjdGHEZswXckLNJAzYqcpk0WHJyZo02tctADJ4Lf62GOzNCpc9vUqxLQxHzBAFxzpoE
	9K9qJwgQvWjyoJ8rXVmbBt50XlOU/0FDfqxYJvlrTe8nzqEJbX8/GoKq7WHQIfGSRvWa5ciO6Hyw9
	0eumQ52ydTtKLzgNl98FJyMG2TjekKV/+gCHk+FWrMcQ+AEcCby7OdAqMKJVcVP7qWeqHLIP3dilX
	4hLJQYSmMUmUXwDPaD2Aq92fr3wYNlRsdA0Sl86Zb+96xZMAwBZ0QBwdRoFGgKxrh+NvgQSIo+FeJ
	tRwHXnpg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGjMk-006VOI-2d;
	Fri, 22 Dec 2023 17:31:18 +0000
Date: Fri, 22 Dec 2023 09:31:18 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Coly Li <colyli@suse.de>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
	Joel Granados <j.granados@samsung.com>, song@kernel.org,
	linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] Revert "raid: Remove now superfluous sentinel element
 from ctl_table array"
Message-ID: <ZYXH5vtBkkHRaVJ2@bombadil.infradead.org>
References: <20231221044925.10178-1-colyli@suse.de>
 <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
 <ZYSPS+yUlzTYETgh@bombadil.infradead.org>
 <B44FA0F9-2A85-41C7-830E-C552E796222C@suse.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B44FA0F9-2A85-41C7-830E-C552E796222C@suse.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Dec 22, 2023 at 06:17:47PM +0800, Coly Li wrote:
> 
> 
> > 2023年12月22日 03:17，Luis Chamberlain <mcgrof@kernel.org> 写道：
> > 
> > On Thu, Dec 21, 2023 at 02:19:56PM +0800, Yu Kuai wrote:
> >> I can't find this by code review, and I think
> >> maybe it's better to fix this in sysctl error path.
> > 
> > Indeed, we want to fix anything in the way to remove the empty sentinel,
> > we continue to do that in queued work on sysctl-next [0]. Although I
> > won't be able to diagnose this right away, could you try the out of
> > bounds fix by Joel [1] instead?
> > 
> > We want to identify what caused this and fix it within sysctl code.
> > 
> > [0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=sysctl-next
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/commit/?h=sysctl-next&id=fd696ee2395755a292f7d49bf4c701a5bab2f076
> 
> Hi Luis,
> 
> Thanks of the above information. IMHO your code is good, When I cherry
> pick the upstream md code for testing, the sysctl related change
> leaked from my eyes. please ignore my noise. 

Great thanks for the heads up! Happy holidays.

  Luis
