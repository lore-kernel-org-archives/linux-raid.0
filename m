From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [patch 7/7] blk: use correct sectors limitation for discard
 request
Date: Tue, 13 Mar 2012 12:00:24 -0400
Message-ID: <20120313160024.GH29169@redhat.com>
References: <20120312030412.375458948@fusionio.com>
 <20120312031306.030156009@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120312031306.030156009@fusionio.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

On Mon, Mar 12, 2012 at 11:04:19AM +0800, Shaohua Li wrote:
> max_discard_sectors doesn't equal to max_sectors/max_hw_sectors. Without this,
> discard request merge might be ignored.
> 
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  block/blk-merge.c      |    9 +++++++--
>  include/linux/blkdev.h |    5 +++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> Index: linux/block/blk-merge.c
> ===================================================================
> --- linux.orig/block/blk-merge.c	2012-03-09 14:05:35.562062857 +0800
> +++ linux/block/blk-merge.c	2012-03-09 14:07:55.432062246 +0800
> @@ -228,13 +228,16 @@ no_merge:
>  int ll_back_merge_fn(struct request_queue *q, struct request *req,
>  		     struct bio *bio)
>  {
> -	unsigned short max_sectors;
> +	unsigned int max_sectors;
>  
>  	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
>  		max_sectors = queue_max_hw_sectors(q);
>  	else
>  		max_sectors = queue_max_sectors(q);
>  
> +	if (unlikely(req->cmd_flags & REQ_DISCARD))
> +		max_sectors = queue_max_discard_sectors(q);
> +

May be make above check an "else if" condition above instead of starting
another "if" block.

Thanks
Vivek
