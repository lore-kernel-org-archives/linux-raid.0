From: Christoph Hellwig <hch@lst.de>
Subject: Re: remove a few uses of ->queuedata
Date: Sat, 9 May 2020 10:23:52 +0200
Message-ID: <20200509082352.GB21834@lst.de>
References: <20200508161517.252308-1-hch@lst.de> <CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-Id: linux-raid.ids

On Fri, May 08, 2020 at 11:04:45AM -0700, Dan Williams wrote:
> On Fri, May 8, 2020 at 9:16 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hi all,
> >
> > various bio based drivers use queue->queuedata despite already having
> > set up disk->private_data, which can be used just as easily.  This
> > series cleans them up to only use a single private data pointer.
> 
> ...but isn't the queue pretty much guaranteed to be cache hot and the
> gendisk cache cold? I'm not immediately seeing what else needs the
> gendisk in the I/O path. Is there another motivation I'm missing?

->private_data is right next to the ->queue pointer, pat0 and part_tbl
which are all used in the I/O submission path (generic_make_request /
generic_make_request_checks).  This is mostly a prep cleanup patch to
also remove the pointless queue argument from ->make_request - then
->queue is an extra dereference and extra churn.
