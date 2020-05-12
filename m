From: Christoph Hellwig <hch@lst.de>
Subject: Re: remove a few uses of ->queuedata
Date: Tue, 12 May 2020 10:08:20 +0200
Message-ID: <20200512080820.GA2336@lst.de>
References: <20200508161517.252308-1-hch@lst.de> <CAPcyv4j3gVqrZWCCc2Q-6JizGAQXW0b+R1BcvWCZOvzaukGLQg@mail.gmail.com> <20200509082352.GB21834@lst.de> <CAPcyv4ggb7_rwzGbhHNXSHd+jjSpZC=+DMEztY6Cu8Bc=ZNzag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4ggb7_rwzGbhHNXSHd+jjSpZC=+DMEztY6Cu8Bc=ZNzag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, linux-m68k@lists.linux-m68k.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linux-block@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-bcache@vger.kernel.org, linux-raid <linux-raid@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-Id: linux-raid.ids

On Sat, May 09, 2020 at 08:07:14AM -0700, Dan Williams wrote:
> > which are all used in the I/O submission path (generic_make_request /
> > generic_make_request_checks).  This is mostly a prep cleanup patch to
> > also remove the pointless queue argument from ->make_request - then
> > ->queue is an extra dereference and extra churn.
> 
> Ah ok. If the changelogs had been filled in with something like "In
> preparation for removing @q from make_request_fn, stop using
> ->queuedata", I probably wouldn't have looked twice.
> 
> For the nvdimm/ driver updates you can add:
> 
>     Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ...or just let me know if you want me to pick those up through the nvdimm tree.

I'd love you to pick them up through the nvdimm tree.  Do you want
to fix up the commit message yourself?
