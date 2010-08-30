From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for
 request-based dm
Date: Mon, 30 Aug 2010 15:08:35 -0400
Message-ID: <20100830190835.GA8458@redhat.com>
References: <1283162296-13650-1-git-send-email-tj@kernel.org>
 <1283162296-13650-5-git-send-email-tj@kernel.org>
 <20100830132836.GB5283@redhat.com>
 <4C7BB932.1070405@kernel.org>
 <4C7BC942.7070703@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C7BC942.7070703@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com, jamie@shareable.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Mon, Aug 30 2010 at 11:07am -0400,
Tejun Heo <tj@kernel.org> wrote:

> On 08/30/2010 03:59 PM, Tejun Heo wrote:
> > Ah... that's probably from "if (!elv_queue_empty(q))" check below,
> > flushes are on a separate queue but I forgot to update
> > elv_queue_empty() to check the flush queue.  elv_queue_empty() can
> > return %true spuriously in which case the queue won't be plugged and
> > restarted later leading to queue hang.  I'll fix elv_queue_empty().
> 
> I think I was too quick to blame elv_queue_empty().  Can you please
> test whether the following patch fixes the hang?

It does, thanks!

Tested-by: Mike Snitzer <snitzer@redhat.com>
