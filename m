From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] block: introduce polling on bio level
Date: Wed, 29 Jan 2020 21:01:49 -0700
Message-ID: <de27b35e-a713-dc9d-5164-0397c0dff285@kernel.dk>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>, song@kernel.org
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On 1/25/20 9:41 PM, Andrzej Jakowski wrote:
> In current implementation it is possible to perform IO polling if
> underlying device is block-mq device. Is is not possible however to do
> polled IO on stackable block devices like MD.
> 
> We have explored two paths for enabling IO polling on bio devices. First
> idea revolved around rewriting MD to block-mq interface but it proved to
> be complex. In the second idea we have built a prototype which
> introduced new operation on request_queue - bio_poll_fn. bio_poll_fn if
> provided by stackable block driver is called when user polls for IO
> completion. bio_poll_fn approach was initially discussed and confirmed
> with Jens.
> 
> We managed to collect performance data on RAID-0 volume built on top of
> 2xP4800X devices with polling on and off. Here are the results:
> Polling      QD       Latency         IOPS
> ----------------------------------------------
> off           1       12.03us         78800
> off           2       13.27us        144000
> off           4       15.83us        245000
> off           8       31.14us        253000
> off          16       63.03us        252000
> off          32      128.89us        247000
> off          64      259.10us        246000
> off         128      517.27us        247000
> on            1        9.00us        108000
> on            2        9.07us        214000
> on            4       12.00us        327000
> on            8       21.43us        369000
> on           16       43.18us        369000
> on           32       85.75us        372000
> on           64      169.87us        376000
> on          128      346.15us        370000

blk_poll() used to be a pointer in the queue, but since we just had
one implementation, we got rid of it. Might make sense to
reintroduce that, and just make it an optimized indirect call. I
think that would be prettier than add the bio hack in the middle of
it, and you're having to add a queue pointer anyway.

Alternatively, do it like you did, but have it be:

if (q->poll_fn)
	return q->poll_fn(...);

instead of duplicating most of the core of the function with essentially
the same thing, just calling ->bio_poll_fn() instead of mq_ops->poll().

In other words, I like the feature, but I think the implementation
currently leaves a lot to be desired. It should be nicely integrated,
not some hack off to the side.

-- 
Jens Axboe
