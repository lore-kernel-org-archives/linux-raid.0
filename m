Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FD1C433ED
	for <linux-raid@archiver.kernel.org>; Mon, 19 Apr 2021 12:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97308611CE
	for <linux-raid@archiver.kernel.org>; Mon, 19 Apr 2021 12:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238784AbhDSMGT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Apr 2021 08:06:19 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:52165 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238738AbhDSMGS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 19 Apr 2021 08:06:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UW4X65e_1618833946;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UW4X65e_1618833946)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 19 Apr 2021 20:05:46 +0800
Subject: Re: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
 request queue
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        Christoph Hellwig <hch@lst.de>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
 <20210415103310.1513841-3-ming.lei@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
Date:   Mon, 19 Apr 2021 20:05:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210415103310.1513841-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/15/21 6:33 PM, Ming Lei wrote:
> For bio based request queue, the queue usage refcnt is only grabbed
> during submission, which isn't consistent with request base queue.
> 
> Queue freezing has been used widely, and turns out it is very useful
> to quiesce queue activity.
> 
> Support to freeze bio based request queue by the following approach:
> 
> 1) grab two queue usage refcount for blk-mq before submitting blk-mq
> bio, one is for bio, anther is for request;


Hi, I can't understand the sense of grabbing two refcounts on the
@q_usage_count of the underlying blk-mq device, while
@q_usage_count of the MD/DM device is kept untouched.

In the following calling stack

```
queue_poll_store
	blk_mq_freeze_queue(q)
```

Is the input @q still the request queue of MD/DM device?


> 
> 2) add bio flag of BIO_QUEUE_REFFED for making sure that only one
> refcnt is grabbed for each bio, so we can put the refcnt when the
> bio is going away
> 
> 3) nvme mpath is a bit special, because same bio is used for both
> mpath queue and underlying nvme queue. So we put the mpath queue's
> usage refcnt before completing the nvme request.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/bio.c                   | 12 ++++++++++--
>  block/blk-core.c              | 23 +++++++++++++++++------
>  drivers/nvme/host/core.c      | 16 ++++++++++++++++
>  drivers/nvme/host/multipath.c |  6 ++++++
>  include/linux/blk-mq.h        |  2 ++
>  include/linux/blk_types.h     |  1 +
>  include/linux/blkdev.h        |  7 ++++++-
>  7 files changed, 58 insertions(+), 9 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 303298996afe..941a306e390b 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1365,14 +1365,18 @@ static inline bool bio_remaining_done(struct bio *bio)
>   **/
>  void bio_endio(struct bio *bio)
>  {
> +	struct block_device *bdev;
> +	bool put_queue;
>  again:
> +	bdev = bio->bi_bdev;
> +	put_queue = bio_flagged(bio, BIO_QUEUE_REFFED);
>  	if (!bio_remaining_done(bio))
>  		return;
>  	if (!bio_integrity_endio(bio))
>  		return;
>  
> -	if (bio->bi_bdev)
> -		rq_qos_done_bio(bio->bi_bdev->bd_disk->queue, bio);
> +	if (bdev)
> +		rq_qos_done_bio(bdev->bd_disk->queue, bio);
>  
>  	/*
>  	 * Need to have a real endio function for chained bios, otherwise
> @@ -1384,6 +1388,8 @@ void bio_endio(struct bio *bio)
>  	 */
>  	if (bio->bi_end_io == bio_chain_endio) {
>  		bio = __bio_chain_endio(bio);
> +		if (bdev && put_queue)
> +			blk_queue_exit(bdev->bd_disk->queue);
>  		goto again;
>  	}
>  
> @@ -1397,6 +1403,8 @@ void bio_endio(struct bio *bio)
>  	bio_uninit(bio);
>  	if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
> +	if (bdev && put_queue)
> +		blk_queue_exit(bdev->bd_disk->queue);
>  }
>  EXPORT_SYMBOL(bio_endio);
>  
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 09f774e7413d..f71e4b433030 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -431,12 +431,13 @@ EXPORT_SYMBOL(blk_cleanup_queue);
>  int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  {
>  	const bool pm = flags & BLK_MQ_REQ_PM;
> +	const unsigned int nr = (flags & BLK_MQ_REQ_DOUBLE_REF) ? 2 : 1;
>  
>  	while (true) {
>  		bool success = false;
>  
>  		rcu_read_lock();
> -		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
> +		if (percpu_ref_tryget_many_live(&q->q_usage_counter, nr)) {
>  			/*
>  			 * The code that increments the pm_only counter is
>  			 * responsible for ensuring that that counter is
> @@ -446,7 +447,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
>  			    !blk_queue_pm_only(q)) {
>  				success = true;
>  			} else {
> -				percpu_ref_put(&q->q_usage_counter);
> +				percpu_ref_put_many(&q->q_usage_counter, nr);
>  			}
>  		}
>  		rcu_read_unlock();
> @@ -480,8 +481,18 @@ static inline int bio_queue_enter(struct bio *bio)
>  	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
>  	bool nowait = bio->bi_opf & REQ_NOWAIT;
>  	int ret;
> +	blk_mq_req_flags_t flags = nowait ? BLK_MQ_REQ_NOWAIT : 0;
> +	bool reffed = bio_flagged(bio, BIO_QUEUE_REFFED);
>  
> -	ret = blk_queue_enter(q, nowait ? BLK_MQ_REQ_NOWAIT : 0);
> +	if (!reffed)
> +		bio_set_flag(bio, BIO_QUEUE_REFFED);
> +
> +	/*
> +	 * Grab two queue references for blk-mq, one is for bio, and
> +	 * another is for blk-mq request.
> +	 */
> +	ret = blk_queue_enter(q, q->mq_ops && !reffed ?
> +			(flags | BLK_MQ_REQ_DOUBLE_REF) : flags);
>  	if (unlikely(ret)) {
>  		if (nowait && !blk_queue_dying(q))
>  			bio_wouldblock_error(bio);
> @@ -492,10 +503,11 @@ static inline int bio_queue_enter(struct bio *bio)
>  	return ret;
>  }
>  
> -void blk_queue_exit(struct request_queue *q)
> +void __blk_queue_exit(struct request_queue *q, unsigned int nr)
>  {
> -	percpu_ref_put(&q->q_usage_counter);
> +	percpu_ref_put_many(&q->q_usage_counter, nr);
>  }
> +EXPORT_SYMBOL_GPL(__blk_queue_exit);
>  
>  static void blk_queue_usage_counter_release(struct percpu_ref *ref)
>  {
> @@ -920,7 +932,6 @@ static blk_qc_t __submit_bio(struct bio *bio)
>  			return blk_mq_submit_bio(bio);
>  		ret = disk->fops->submit_bio(bio);
>  	}
> -	blk_queue_exit(disk->queue);
>  	return ret;
>  }
>  
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 34b8c78f88e0..791638a7164b 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -323,14 +323,30 @@ static inline enum nvme_disposition nvme_decide_disposition(struct request *req)
>  static inline void nvme_end_req(struct request *req)
>  {
>  	blk_status_t status = nvme_error_status(nvme_req(req)->status);
> +	const bool mpath = req->cmd_flags & REQ_NVME_MPATH;
> +	unsigned int nr = 0;
> +	struct bio *bio;
> +	struct nvme_ns *ns;
>  
>  	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
>  	    req_op(req) == REQ_OP_ZONE_APPEND)
>  		req->__sector = nvme_lba_to_sect(req->q->queuedata,
>  			le64_to_cpu(nvme_req(req)->result.u64));
>  
> +	if (mpath) {
> +		ns = req->q->queuedata;
> +		__rq_for_each_bio(bio, req)
> +			nr++;
> +	}
>  	nvme_trace_bio_complete(req);
>  	blk_mq_end_request(req, status);
> +
> +	/*
> +	 * We changed multipath bio->bi_bdev, so have to drop the queue
> +	 * reference manually
> +	 */
> +	if (mpath && nr)
> +		__blk_queue_exit(ns->head->disk->queue, nr);
>  }
>  
>  void nvme_complete_rq(struct request *req)
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index a1d476e1ac02..017487c835fb 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -312,6 +312,12 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
>  	srcu_idx = srcu_read_lock(&head->srcu);
>  	ns = nvme_find_path(head);
>  	if (likely(ns)) {
> +		/*
> +		 * this bio's ownership is transferred to underlying queue, so
> +		 * clear the queue reffed flag and let underlying queue to put
> +		 * the multipath queue for us.
> +		 */
> +		bio_clear_flag(bio, BIO_QUEUE_REFFED);
>  		bio_set_dev(bio, ns->disk->part0);
>  		bio->bi_opf |= REQ_NVME_MPATH;
>  		trace_block_bio_remap(bio, disk_devt(ns->head->disk),
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 2c473c9b8990..b96ac162e703 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -445,6 +445,8 @@ enum {
>  	BLK_MQ_REQ_RESERVED	= (__force blk_mq_req_flags_t)(1 << 1),
>  	/* set RQF_PM */
>  	BLK_MQ_REQ_PM		= (__force blk_mq_req_flags_t)(1 << 2),
> +	/* double queue reference */
> +	BLK_MQ_REQ_DOUBLE_REF	= (__force blk_mq_req_flags_t)(1 << 3),
>  };
>  
>  struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 57099b37ef3a..e7f7d67198cc 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -305,6 +305,7 @@ enum {
>  	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
>  	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
>  	BIO_REMAPPED,
> +	BIO_QUEUE_REFFED,	/* need to put queue refcnt */
>  	BIO_FLAG_LAST
>  };
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 62944d06a80f..6ad09b2ff2d1 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -925,7 +925,7 @@ extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
>  extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
>  
>  extern int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags);
> -extern void blk_queue_exit(struct request_queue *q);
> +extern void __blk_queue_exit(struct request_queue *q, unsigned int nr);
>  extern void blk_sync_queue(struct request_queue *q);
>  extern int blk_rq_map_user(struct request_queue *, struct request *,
>  			   struct rq_map_data *, void __user *, unsigned long,
> @@ -947,6 +947,11 @@ blk_status_t errno_to_blk_status(int errno);
>  
>  int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
>  
> +static inline void blk_queue_exit(struct request_queue *q)
> +{
> +	__blk_queue_exit(q, 1);
> +}
> +
>  static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
>  {
>  	return bdev->bd_disk->queue;	/* this is never NULL */
> 

-- 
Thanks,
Jeffle
