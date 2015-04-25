From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] md/raid10: make sync_request_write() call bio_copy_data()
Date: Sat, 25 Apr 2015 02:47:26 -0700
Message-ID: <20150425094726.GB14363@infradead.org>
References: <1429915930-22449-1-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429915930-22449-1-git-send-email-mlin@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>
List-Id: linux-raid.ids

On Fri, Apr 24, 2015 at 03:52:10PM -0700, Ming Lin wrote:
> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> Refactor sync_request_write() of md/raid10 to use bio_copy_data()
> instead of open coding bio_vec iterations.

Do you plan to submit an updated version of the immutable biovecs set
soon?  In that case it would be good to merge this patch through
the block tree, as it's a requirement for it AFAICS.  Might be worth to
repost them together.
