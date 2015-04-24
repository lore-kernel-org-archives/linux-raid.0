From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 2/4] md/raid10: make sync_request_write() call
 bio_copy_data()
Date: Fri, 24 Apr 2015 00:08:57 -0700
Message-ID: <20150424070857.GB8648@infradead.org>
References: <1429830275-6792-1-git-send-email-mlin@kernel.org>
 <1429830275-6792-3-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1429830275-6792-3-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dongsu.park@profitbricks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 23, 2015 at 04:04:33PM -0700, Ming Lin wrote:
> From: Kent Overstreet <kent.overstreet@gmail.com>
> 
> Refactor sync_request_write() of md/raid10 to use bio_copy_data()
> instead of open coding bio_vec iterations.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
