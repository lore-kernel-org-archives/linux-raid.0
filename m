From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 1/5] block: introduce bio_clone_bioset_partial()
Date: Mon, 13 Feb 2017 05:46:54 -0800
Message-ID: <20170213134654.GB22818@infradead.org>
References: <1486724177-14817-1-git-send-email-tom.leiming@gmail.com>
 <1486724177-14817-2-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486724177-14817-2-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Fri, Feb 10, 2017 at 06:56:13PM +0800, Ming Lei wrote:
> md still need bio clone(not the fast version) for behind write,
> and it is more efficient to use bio_clone_bioset_partial().
> 
> The idea is simple and just copy the bvecs range specified from
> parameters.

Given how few users bio_clone_bioset has I wonder if we shouldn't
simply add the two new arguments to it instead of adding another
indirection.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
