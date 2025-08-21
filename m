Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC9A2EE608;
	Thu, 21 Aug 2025 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767775; cv=none; b=dBEusaANfOqZLLNvGuGxZ62rflpUn1RtH9wD52yN3IAM1pgTxLxYy66f00ohoLcpGPUM6xbdMo5RLgwNMbg5pVn0FN4B76BGHWonzBTtZkjNRBysXrAKlo1VrJ26i6xiynlHThrfpk0EwUvOiqn9Hoa7g7sOmCkKTXINPwOaaGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767775; c=relaxed/simple;
	bh=IlBbD7/2oGs6Lk8SfFRvt28SijXC66fJ1NtknqYDkus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVsUQ4jzjHBbo4giQXpoKSBhvzyfj6DZmsHoopOXnMes7W8UNL2W4b/tS7ajhlYXrHItVxn9yxccDchKOI4XCSaaC4OQH1UHoIrkzxmevBD3GelmXg9wqoSmnprvYRDQ2ZL+Mz0HXtCATVNERG97JCHk+LLCWphWMST0UoEYWxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=st9OtkkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="st9OtkkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C03C4CEEB;
	Thu, 21 Aug 2025 09:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755767773;
	bh=IlBbD7/2oGs6Lk8SfFRvt28SijXC66fJ1NtknqYDkus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=st9OtkkVMeEbhLP7hFmGaBqvP669DHm9wEkEvTVzgI47xye8cZEtrnuq2dgWF3yAJ
	 5290eIihqNF/CGNT78N+CE5kc88ichZ5fnxpITOQ7mQmm0RDal6/dnoiMwNkxtQYHZ
	 7cXNtqMHXq5yiLBZA2hI9VRo3FAjCmJN8ITAuoUz981+IfcO+gpHgeH+Jo2U0wcxQ2
	 n6sewcW6NjcceyKoATHS7zMDcDNecJmeMWj7gimxhBvwDEIuouW0hrw0zjDIHgV1wS
	 Snj+sNSIjj495JPcbGhyn1GRPhSK88OOKkttpt6jqtwXL6mImr8NsLhn7pH65yL939
	 pwAM4ibF6IrBw==
Date: Thu, 21 Aug 2025 17:16:08 +0800
From: Coly Li <colyli@kernel.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, neil@brown.name, akpm@linux-foundation.org, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xni@redhat.com, yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
Subject: Re: [PATCH] block: fix disordered IO in the case recursive split
Message-ID: <7dro5o7u5t64d6bgiansesjavxcuvkq5p2pok7dtwkav7b7ape@3isfr44b6352>
References: <20250821074707.2604640-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250821074707.2604640-1-yukuai1@huaweicloud.com>

On Thu, Aug 21, 2025 at 03:47:06PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently, split bio will be chained to original bio, and original bio
> will be resubmitted to the tail of current->bio_list, waiting for
> split bio to be issued. However, if split bio get split again, the IO
> order will be messed up, for example, in raid456 IO will first be
> split by max_sector from md_submit_bio(), and then later be split
> again by chunksize for internal handling:
> 
> For example, assume max_sectors is 1M, and chunksize is 512k
> 
> 1) issue a 2M IO:
> 
> bio issuing: 0+2M
> current->bio_list: NULL
> 
> 2) md_submit_bio() split by max_sector:
> 
> bio issuing: 0+1M
> current->bio_list: 1M+1M
> 
> 3) chunk_aligned_read() split by chunksize:
> 
> bio issuing: 0+512k
> current->bio_list: 1M+1M -> 512k+512k
> 
> 4) after first bio issued, __submit_bio_noacct() will contuine issuing
> next bio:
> 
> bio issuing: 1M+1M
> current->bio_list: 512k+512k
> bio issued: 0+512k
> 
> 5) chunk_aligned_read() split by chunksize:
> 
> bio issuing: 1M+512k
> current->bio_list: 512k+512k -> 1536k+512k
> bio issued: 0+512k
> 
> 6) no split afterwards, finally the issue order is:
> 
> 0+512k -> 1M+512k -> 512k+512k -> 1536k+512k
> 
> This behaviour will cause large IO read on raid456 endup to be small
> discontinuous IO in underlying disks. Fix this problem by placing chanied
> bio to the head of current->bio_list.
> 
> Test script: test on 8 disk raid5 with 64k chunksize
> dd if=/dev/md0 of=/dev/null bs=4480k iflag=direct
> 
> Test results:
> Before this patch
> 1) iostat results:
> Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz  aqu-sz  %util
> md0           52430.00   3276.87     0.00   0.00    0.62    64.00   32.60  80.10
> sd*           4487.00    409.00  2054.00  31.40    0.82    93.34    3.68  71.20
> 2) blktrace G stage:
>   8,0    0   486445    11.357392936   843  G   R 14071424 + 128 [dd]
>   8,0    0   486451    11.357466360   843  G   R 14071168 + 128 [dd]
>   8,0    0   486454    11.357515868   843  G   R 14071296 + 128 [dd]
>   8,0    0   486468    11.357968099   843  G   R 14072192 + 128 [dd]
>   8,0    0   486474    11.358031320   843  G   R 14071936 + 128 [dd]
>   8,0    0   486480    11.358096298   843  G   R 14071552 + 128 [dd]
>   8,0    0   486490    11.358303858   843  G   R 14071808 + 128 [dd]
> 3) io seek for sdx:
> Noted io seek is the result from blktrace D stage, statistic of:
> ABS((offset of next IO) - (offset + len of previous IO))
> 
> Read|Write seek
> cnt 55175, zero cnt 25079
>     >=(KB) .. <(KB)     : count       ratio |distribution                            |
>          0 .. 1         : 25079       45.5% |########################################|
>          1 .. 2         : 0            0.0% |                                        |
>          2 .. 4         : 0            0.0% |                                        |
>          4 .. 8         : 0            0.0% |                                        |
>          8 .. 16        : 0            0.0% |                                        |
>         16 .. 32        : 0            0.0% |                                        |
>         32 .. 64        : 12540       22.7% |#####################                   |
>         64 .. 128       : 2508         4.5% |#####                                   |
>        128 .. 256       : 0            0.0% |                                        |
>        256 .. 512       : 10032       18.2% |#################                       |
>        512 .. 1024      : 5016         9.1% |#########                               |
> 
> After this patch:
> 1) iostat results:
> Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz  aqu-sz  %util
> md0           87965.00   5271.88     0.00   0.00    0.16    61.37   14.03  90.60
> sd*           6020.00    658.44  5117.00  45.95    0.44   112.00    2.68  86.50
> 2) blktrace G stage:
>   8,0    0   206296     5.354894072   664  G   R 7156992 + 128 [dd]
>   8,0    0   206305     5.355018179   664  G   R 7157248 + 128 [dd]
>   8,0    0   206316     5.355204438   664  G   R 7157504 + 128 [dd]
>   8,0    0   206319     5.355241048   664  G   R 7157760 + 128 [dd]
>   8,0    0   206333     5.355500923   664  G   R 7158016 + 128 [dd]
>   8,0    0   206344     5.355837806   664  G   R 7158272 + 128 [dd]
>   8,0    0   206353     5.355960395   664  G   R 7158528 + 128 [dd]
>   8,0    0   206357     5.356020772   664  G   R 7158784 + 128 [dd]
> 2) io seek for sdx
> Read|Write seek
> cnt 28644, zero cnt 21483
>     >=(KB) .. <(KB)     : count       ratio |distribution                            |
>          0 .. 1         : 21483       75.0% |########################################|
>          1 .. 2         : 0            0.0% |                                        |
>          2 .. 4         : 0            0.0% |                                        |
>          4 .. 8         : 0            0.0% |                                        |
>          8 .. 16        : 0            0.0% |                                        |
>         16 .. 32        : 0            0.0% |                                        |
>         32 .. 64        : 7161        25.0% |##############                          |
> 
> BTW, this looks like a long term problem from day one, and large
> sequential IO read is pretty common case like video playing.
> 
> And even with this patch, in this test case IO is merged to at most 128k
> is due to block layer plug limit BLK_PLUG_FLUSH_SIZE, increase such
> limit and cat get even better performance. However, we'll figure out
> how to do this properly later.
> 
> Fixes: d89d87965dcb ("When stacked block devices are in-use (e.g. md or dm), the recursive calls")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

BTW, this issue was not originally caught by me, my colleague Tie Ren found it.

Please consider to add,
	Reported-by: Tie Ren <tieren@fnnas.com>

Thanks.

Coly Li

> ---
>  block/blk-core.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4201504158a1..0d46d10edb22 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -745,12 +745,16 @@ void submit_bio_noacct_nocheck(struct bio *bio)
>  	 * to collect a list of requests submited by a ->submit_bio method while
>  	 * it is active, and then process them after it returned.
>  	 */
> -	if (current->bio_list)
> -		bio_list_add(&current->bio_list[0], bio);
> -	else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO))
> +	if (current->bio_list) {
> +		if (bio_flagged(bio, BIO_CHAIN))
> +			bio_list_add_head(&current->bio_list[0], bio);
> +		else
> +			bio_list_add(&current->bio_list[0], bio);
> +	} else if (!bdev_test_flag(bio->bi_bdev, BD_HAS_SUBMIT_BIO)) {
>  		__submit_bio_noacct_mq(bio);
> -	else
> +	} else {
>  		__submit_bio_noacct(bio);
> +	}
>  }
>  
>  static blk_status_t blk_validate_atomic_write_op_size(struct request_queue *q,
> -- 
> 2.39.2
> 
> 
