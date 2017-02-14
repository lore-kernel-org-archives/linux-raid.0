From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 1/5] block: introduce bio_clone_bioset_partial()
Date: Tue, 14 Feb 2017 08:01:51 -0800
Message-ID: <20170214160151.GB32705@infradead.org>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
 <1486724177-14817-2-git-send-email-tom.leiming@gmail.com>
 <20170213134654.GB22818@infradead.org>
 <CACVXFVNN3Gtm4Ut5KCmx8REbMYnh3Y2+sAZPto7F40fvGyZ=zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVNN3Gtm4Ut5KCmx8REbMYnh3Y2+sAZPto7F40fvGyZ=zw@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Tue, Feb 14, 2017 at 09:04:26AM +0800, Ming Lei wrote:
> On Mon, Feb 13, 2017 at 9:46 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Feb 10, 2017 at 06:56:13PM +0800, Ming Lei wrote:
> >> md still need bio clone(not the fast version) for behind write,
> >> and it is more efficient to use bio_clone_bioset_partial().
> >>
> >> The idea is simple and just copy the bvecs range specified from
> >> parameters.
> >
> > Given how few users bio_clone_bioset has I wonder if we shouldn't
> > simply add the two new arguments to it instead of adding another
> > indirection.
> 
> For md write-behind, looks we have to provide the two arguments,
> could you explain a bit how we can do that by adding another indirection?

I meant to just pass the additional arguments that 
bio_clone_bioset_partial has to bio_clone_bioset.
