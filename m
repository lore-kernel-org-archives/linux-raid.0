From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] md: simplify code with bio_io_error
Date: Fri, 2 Jun 2017 22:57:42 -0700
Message-ID: <20170603055742.GA19486@infradead.org>
References: <20170602074914.26842-1-gqjiang@suse.com>
 <20170602162926.onnaflcf26ahuoti@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170602162926.onnaflcf26ahuoti@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 02, 2017 at 09:29:26AM -0700, Shaohua Li wrote:
> On Fri, Jun 02, 2017 at 03:49:14PM +0800, Guoqing Jiang wrote:
> > bio_io_error was introduced in the commit 4246a0b
> > ("block: add a bi_error field to struct bio"), so
> > use it to simplify code.
> > 
> > Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> 
> Applied, thanks! There are several other places which could use conversion, I added

Ugg.  I have a massive series pending for the block layer that changes
the error values.  Applying these cleanups now will just introduce
conflicts all over.
