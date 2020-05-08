From: Ming Lei <ming.lei@redhat.com>
Subject: Re: remove a few uses of ->queuedata
Date: Sat, 9 May 2020 06:13:21 +0800
Message-ID: <20200508221321.GD1389136@T590>
References: <20200508161517.252308-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
List-Id: linux-raid.ids

On Fri, May 08, 2020 at 06:15:02PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> various bio based drivers use queue->queuedata despite already having
> set up disk->private_data, which can be used just as easily.  This
> series cleans them up to only use a single private data pointer.
> 
> blk-mq based drivers that have code pathes that can't easily get at
> the gendisk are unaffected by this series.

Yeah, before adding disk, there still may be requests queued to LLD
for blk-mq based drivers.

So are there this similar situation for these bio based drivers?


Thanks,
Ming
