Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C53A2576;
	Mon, 12 May 2025 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747025846; cv=none; b=ggkIZJD1ooUJ8C4GJpnz97uPcf9OebMU47oJzm7bVZXJMH6p6ODO0kBfVtTKN35dKSTNbm8uNjDL7zWR3moSLv3MVEiUUj7h96pI7+ywQ3YoGz4LEGOqr8/oQJ7h0jEvwdoDMgxnLYg0Zh5DWti+r/BFRKZMmFzejE672iFW8j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747025846; c=relaxed/simple;
	bh=psWwzrMpJp7cTWX5luQvyXy4eLvNowrlLY+xfNTgmWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLCC2UtL0czhUjD+yC75pBhMvRzzKEJ8dbw03G1bAPP9W4L/Tnb/7r7dbg2FkwmF+6rB9SxLYzgnYH+ZY1HOmyvECt7K08iPfk3TpkK94T4QKgmaUSR/s3O28ndoVhUILrfjGJmwBJB4EG9T1S8F7rMM7PawE6ByYTx3FfAu9Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E3DFB68AA6; Mon, 12 May 2025 06:57:21 +0200 (CEST)
Date: Mon, 12 May 2025 06:57:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 08/19] md/md-bitmap: add a new helper
 blocks_synced() in bitmap_operations
Message-ID: <20250512045721.GH868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-9-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-9-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, both for the previous and this patch: function pointers in
structures are methods, not helpers.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

