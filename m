From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] block: make __blk_rq_prep_clone() copy most command flags
Date: Wed, 1 Sep 2010 17:30:27 +0200
Message-ID: <20100901153027.GA2744@lst.de>
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1283162296-13650-2-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, snitzer@redhat.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Mon, Aug 30, 2010 at 11:58:12AM +0200, Tejun Heo wrote:
> Currently __blk_rq_prep_clone() copies only REQ_WRITE and REQ_DISCARD.
> There's no reason to omit other command flags and REQ_FUA needs to be
> copied to implement FUA support in request-based dm.
> 
> REQ_COMMON_MASK which specifies flags to be copied from bio to request
> already identifies all the command flags.  Define REQ_CLONE_MASK to be
> the same as REQ_COMMON_MASK for clarity and make __blk_rq_prep_clone()
> copy all flags in the mask.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
