From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: introduce polling on bio level
Date: Thu, 30 Jan 2020 22:35:27 -0800
Message-ID: <20200131063527.GC6267@infradead.org>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
 <de27b35e-a713-dc9d-5164-0397c0dff285@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de27b35e-a713-dc9d-5164-0397c0dff285@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Wed, Jan 29, 2020 at 09:01:49PM -0700, Jens Axboe wrote:
> blk_poll() used to be a pointer in the queue, but since we just had
> one implementation, we got rid of it. Might make sense to
> reintroduce that, and just make it an optimized indirect call. I
> think that would be prettier than add the bio hack in the middle of
> it, and you're having to add a queue pointer anyway.

Well, the other reason is to avoid an indirect call for the blk-mq
case, which are fairly expensive.  In fact I'm pretty sure we avoid
indirect calls from the bio layer into blk-mq entirely for the fast
path at the moment, and it would be great to keep it that way.
