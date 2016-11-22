From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/12] bcache: debug: avoid to access .bi_io_vec directly
Date: Mon, 21 Nov 2016 23:30:51 -0800
Message-ID: <20161122073051.GA21957@infradead.org>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
 <1478865957-25252-6-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1478865957-25252-6-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Guoqing Jiang <gqjiang@suse.com>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 11, 2016 at 08:05:33PM +0800, Ming Lei wrote:
> Instead we use standard iterator way to do that.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
