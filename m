From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 5/5] md: fast clone bio in bio_clone_mddev()
Date: Wed, 15 Feb 2017 11:20:25 -0800
Message-ID: <20170215192025.fo7jsew7pvagp5hv@kernel.org>
References: <1487086143-10255-1-git-send-email-tom.leiming@gmail.com>
 <1487086143-10255-6-git-send-email-tom.leiming@gmail.com>
 <20170214160109.GA32705@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170214160109.GA32705@infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Tue, Feb 14, 2017 at 08:01:09AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 14, 2017 at 11:29:03PM +0800, Ming Lei wrote:
> > Firstly bio_clone_mddev() is used in raid normal I/O and isn't
> > in resync I/O path.
> > 
> > Secondly all the direct access to bvec table in raid happens on
> > resync I/O except for write behind of raid1, in which we still
> > use bio_clone() for allocating new bvec table.
> > 
> > So this patch replaces bio_clone() with bio_clone_fast()
> > in bio_clone_mddev().
> > 
> > Also kill bio_clone_mddev() and call bio_clone_fast() directly, as
> > suggested by Christoph Hellwig.
> > 
> > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> 
> Looks fine,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, can you also tack on another patch to kill bio_alloc_mddev
> to be consistent?

I'll take care of this
