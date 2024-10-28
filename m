Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758FA1DE88D;
	Mon, 28 Oct 2024 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730131895; cv=none; b=tR6i8G1pWK2Or1ObzpV+qSSex/TZJH9MyUusb3hsodNh3Q/vuNpBtBTWrXxMaEwPS7Ot50Pe0To7um55BN75H9muMlgZojuVDP00K0V6rPbuZk1oNHLVstB3CdWgQ4Z/OJG5UBX3Ps+JNn8CGR2J+OYBd4+B8pdI/66M3KfBkT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730131895; c=relaxed/simple;
	bh=34f/7hgZE5uqGQBXPVNcfIRZLX6rC13d7zC/uBNENY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LsKyXTZZQHd3Y4ZKnJ3X3m+iuDwT8Hv/q+Y2JjyGkQMmymnBhm5+FipnUbIIYDS/5q27shB5lQAaxQz0XVhpLc0MOLzSzrhjrxBLbxGOrfjh80mn6S5icQo5IJPoSNeUYuK+QTOpgkhFaHBwISS3xw7ozgN807lEZRsk9UhnjlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DEE3768BEB; Mon, 28 Oct 2024 17:11:28 +0100 (CET)
Date: Mon, 28 Oct 2024 17:11:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, hch@lst.de,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	hare@suse.de, Johannes.Thumshirn@wdc.com
Subject: Re: [PATCH v2 1/7] block: Use BLK_STS_OK in bio_init()
Message-ID: <20241028161128.GA28829@lst.de>
References: <20241028152730.3377030-1-john.g.garry@oracle.com> <20241028152730.3377030-2-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028152730.3377030-2-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 28, 2024 at 03:27:24PM +0000, John Garry wrote:
> Use the proper blk_status_t value to init the bi_status.

I think 0 as ok is a very wide spread assumption and intentional.
Personally I think 0 is fine, as it also is special case by
__bitwise types, but if Jens prefers it this way I'm fine with that
too.

