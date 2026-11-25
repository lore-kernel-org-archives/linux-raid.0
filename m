Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795583017;
	b=XpkS01W95hV85zWQnjVgpmVvzblIf+dXIwaAj2agFnbzs9ObSaCgxRy1exlCCV13gbGR
	 mkH1ioL4rqgQ4I81pdOqUtGIklgtYJymLExyBBRYgN6VYK/kgkZ4sD53WSNB/TTOEr1h7
	 RpJ3RF+yfoorUsESAWB/Qr2HhzZOHJOp+XvmGyUukMRCqr8IkREqCX0L0B+JWqJ1GNQ0n
	 Ifp7pgerhVvrJ9YRvg5KzO+tKHCYVa+KZ0TxMw7FBLUbjQaPEWlbwuGfVu0JwZhFPpu8q
	 zQS5L0e+BQZuVM0sYpBLRRCaAlGeHRa3IM/30Up9aysMqaJH4jyKQQqhsnFSkY/cULA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795583017;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=lBwceiwm98ReJuMPuSgjaP5OOtf3D+hnyit6ozIv9SY=;
	b=dKkbS8A0Fosn5RrqpcZfc+dYQLwPVRomt1Owurw/oFsPZt5NZY/dE6MD7p7ZrJ4a/F6K
	 U1l1Xg8iDn8547NAJZtNsfBfQRVhePkah5Ru/HONHFmj/Pa45tUh/S8Rvcml+0gPLvWLU
	 zLXULrBeQKFo3j+D2nS5XjdiQgEuE6spKQdygs5TO1X1NHZA+pyQ4ozACrQkT0p7coI5C
	 itmwsVXTbl5ZIaWEQqEsrgWOBcBDH47jr22K3tf8YkBy1JrNRapE9AIIip8cAblBgThEQ
	 zQ2JCN7c2ZG/2KEc1X+/00lflTmhVf84bqa5fljMHsKqNfGRwECEdk3c6fJBK5UYzWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dJUXJlnL;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B30606A31E
	for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2026 05:03:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2B30606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=dJUXJlnL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lBwceiwm98ReJuMPuSgjaP5OOtf3D+hnyit6ozIv9SY=; b=dJUXJlnL2W606rxWFE8Kig79nW
	0CeMsGBgT/28ajbGzS/oTSc07qDJkKBA75T7xTNLAyAQwIOiSrtVH1yJg6UMo8LZyZ3uckyQX757T
	+3yIsJ2YUTodQc3HA8encfr76S/VjBH8uF81I6ljBd6/fI0OkrLtYOZPzMe6fTqzbcxJo7W1dKPb+
	IEBHQOIQ9ALvaNfR+7TQy8hKJFGVKQqprx2M+w9lznby2YtFZOCLbOSgBZzETzcaaqlmxxypVrleL
	4AqIBO+DzLrmlPOq125UUX560lAABfwSnHfOgajLuPXKY4sp26gj112vTwGJT0uvHF+cij0Brivhl
	Ni7p2vMA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW5AN-00000008RHv-3VLn;
	Wed, 25 Nov 2026 05:03:35 +0000
Date: Tue, 24 Nov 2026 21:03:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhou Minqiang <zhouminqiang2@huawei.com>
Cc: song@kernel.org, yukuai@fygo.io, neilb@suse.com,
	artur.paszkiewicz@intel.com, shli@kernel.org, axboe@kernel.dk,
	linux-raid@vger.kernel.org, chengzhihao1@huawei.com,
	yangerkun@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH] md/raid10: reset bi_offset in sync_request_write()
Message-ID: <awZsJ5H6uEH4so8D@infradead.org>
References: <20261124060856.559865-1-zhouminqiang2@huawei.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124060856.559865-1-zhouminqiang2@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 24, 2026 at 02:08:56PM +0800, Zhou Minqiang wrote:
> +++ b/drivers/md/raid10.c
> @@ -2330,6 +2330,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>  	fbio = r10_bio->devs[i].bio;
>  	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
>  	fbio->bi_iter.bi_idx = 0;
> +	fbio->bi_iter.bi_offset = 0;
>  	fpages = get_resync_pages(fbio)->pages;

Directly messing with the iterator is a really bad idea.  This needs to
use bio_reuse or bio_reset.

