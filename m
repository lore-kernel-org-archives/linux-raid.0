Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B576613B797;
	Tue, 27 Feb 2024 15:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047576; cv=none; b=HJGFKN3KOraCIjaG7EVDz7Uprvui1a/gl7erzFWbm6FUYOBqi80VtTonm7nbBM/GwEaJoibePyvpeGouzeOPfDfQHQjtxQ/G5a3zUUHySLe8mq4W0fWufj5gzwoGUYb0EAw8+pPcxdMswe3PrcFTwjsEp1bqFpdXTKiQK7tSd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047576; c=relaxed/simple;
	bh=ZSlAs43820JIBdvWc7RP1dsjFfScHC9aO3TYLd71TJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRCjW9M6bw5/BGiZSYN82BOeM6E6NK+vS1NJxAWxgcp91hSuxhXq7n3ni8KfqIaqP25gEMvEgIlYvSMPwdZJkm31g0Atuq94hmbOBrKHYI1MnsHlAqHlpJsum1NjDsGCXPaDbfLhSqcxM8poCZx6s2zhR69tTh2ZyD7l/vtatcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 479A968D05; Tue, 27 Feb 2024 16:26:10 +0100 (CET)
Date: Tue, 27 Feb 2024 16:26:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	drbd-dev@lists.linbit.com, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 06/16] md/raid1: use the atomic queue limit update APIs
Message-ID: <20240227152609.GA14782@lst.de>
References: <20240226103004.281412-1-hch@lst.de> <20240226103004.281412-7-hch@lst.de> <b4828284-87ec-693b-e2c3-84bdafcbda65@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4828284-87ec-693b-e2c3-84bdafcbda65@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 26, 2024 at 07:29:08PM +0800, Yu Kuai wrote:
> Hi,
>
> 在 2024/02/26 18:29, Christoph Hellwig 写道:
>> Build the queue limits outside the queue and apply them using
>> queue_limits_set.  Also remove the bogus ->gendisk and ->queue NULL
>> checks in the are while touching it.
>
> The checking of mddev->gendisk can't be removed, because this is used to
> distinguish dm-raid and md/raid. And the same for following patches.

Ah.  Well, we should make that more obvious then.  This is what I
currently have:

http://git.infradead.org/?p=users/hch/block.git;a=shortlog;h=refs/heads/md-blk-limits

particularly:

http://git.infradead.org/?p=users/hch/block.git;a=commitdiff;h=24b2fd15f57f06629d2254ebec480e1e28b96636

