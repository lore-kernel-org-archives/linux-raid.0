From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: introduce polling on bio level
Date: Fri, 31 Jan 2020 21:41:58 -0700
Message-ID: <ffb832a5-e946-2575-d820-8c8831e2ed99@kernel.dk>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
 <de27b35e-a713-dc9d-5164-0397c0dff285@kernel.dk>
 <20200131063527.GC6267@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200131063527.GC6267@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On 1/30/20 11:35 PM, Christoph Hellwig wrote:
> On Wed, Jan 29, 2020 at 09:01:49PM -0700, Jens Axboe wrote:
>> blk_poll() used to be a pointer in the queue, but since we just had
>> one implementation, we got rid of it. Might make sense to
>> reintroduce that, and just make it an optimized indirect call. I
>> think that would be prettier than add the bio hack in the middle of
>> it, and you're having to add a queue pointer anyway.
> 
> Well, the other reason is to avoid an indirect call for the blk-mq
> case, which are fairly expensive.  In fact I'm pretty sure we avoid
> indirect calls from the bio layer into blk-mq entirely for the fast
> path at the moment, and it would be great to keep it that way.

Sure, my suggestion was to provide it as an alternative - if set,
then call that. Though with the optimized indirect calls, at least
it's just a branch, actual call is the same.

This patch sets a bit in no mans land right now. It's duplicating
the main loop, and it's shoved in the middle of the function. This
has to get cleaned up.

-- 
Jens Axboe
