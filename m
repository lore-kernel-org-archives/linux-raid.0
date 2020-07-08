From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] mmc: remove the call to check_disk_change
Date: Wed, 8 Jul 2020 16:22:12 +0200
Message-ID: <20200708142212.GA22601@lst.de>
References: <20200708122546.214579-1-hch@lst.de> <20200708122546.214579-7-hch@lst.de> <CAPDyKFr5+LRRGMYhWM2At=O9LQSPmFAp0YuQiwmRiV1a6Tx6=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPDyKFr5+LRRGMYhWM2At=O9LQSPmFAp0YuQiwmRiV1a6Tx6=g@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xtensa@linux-xtensa.org, linux-block <linux-block@vger.kernel.org>, linux-raid@vger.kernel.org, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 08, 2020 at 04:17:26PM +0200, Ulf Hansson wrote:
> On Wed, 8 Jul 2020 at 14:41, Christoph Hellwig <hch@lst.de> wrote:
> >
> > The mmc driver doesn't support event notifications, which means
> > that check_disk_change is a no-op.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I can queue this via my mmc tree, but perhaps you have plans for some
> additional cleanups on top? In such a case, it may be better that this
> goes through Jens' tree?

I have some vague plans.  They might or might not hit this merge window,
so if you are fine with Jens picking up the whole thing that would
avoid any potential problems.
