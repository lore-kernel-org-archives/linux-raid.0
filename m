Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F742E266C;
	Wed,  9 Sep 2026 06:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788935434; cv=none; b=lbUc0TcKLYsPGv0JqUnrc9a+2QvPFIxlr6T+bCtfzJAODjYkJwPe173f/lBLuYLSvNSA/eZymBQFRUl+BrjtP/hwpBOuliDRPB0l7Z1LID9PBcYVD1ovgKOmovKpAUe7OxyhR0802uEB6vygLs2Xda0LjiNx6+fj6YntugXQ+hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788935434; c=relaxed/simple;
	bh=FzNeiwdDjd9MdcPlAnZJaZs2z0Jg4eBM4GwLkaBsTpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WToAXUWeF9wdCDzIZJXpHqg76tFPPJR1PlX/kXC06aAAn6J5DgjiqoXobMCsWVS2AqgMuQPnRs6S0YaWn+GYcr04uUU+mn/+lCOe5fD5CnJ9qGR9xiCccCe24JHFz8he1XI0C5hKMaNYWCQL3Kk/FK399QwoACQTl0iNLo/q0zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF89868BFE; Wed,  9 Sep 2026 08:30:29 +0200 (CEST)
Date: Wed, 9 Sep 2026 08:30:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Jack Wang <jinpu.wang@ionos.com>, Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com, linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>, tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 0/6] md: don't wait for q->limits_lock while md holds
 back I/O
Message-ID: <20260909063029.GC29874@lst.de>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com> <f95804a4-c5ed-498f-b24d-107b2f00d858@wdc.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f95804a4-c5ed-498f-b24d-107b2f00d858@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 08, 2026 at 07:00:55PM +0200, Johannes Thumshirn wrote:
>>    for i in $(seq 20); do
>>        mdadm /dev/md111 --fail /dev/ram0
>>        mdadm /dev/md111 --remove /dev/ram0
>>        mdadm /dev/md111 --add /dev/ram0
>>        mdadm --wait /dev/md111
>>    done
>
> This sounds like something that is worth a blktest, isn't it?

Yes.  Or the mdadm testsuite, although that one drіves me crazy.
Migrating those tests to blktests might be a nice little side
project.
