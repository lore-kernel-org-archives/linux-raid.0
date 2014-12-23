From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: [RFC PATCH 12/17] md/raid10: make sync_request_write() call
 bio_copy_data()
Date: Tue, 23 Dec 2014 13:31:09 +0100
Message-ID: <20141223123109.GG15080@gmail.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
 <20141223104830.GD27600@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141223104830.GD27600@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23.12.2014 02:48, Christoph Hellwig wrote:
> On Mon, Dec 22, 2014 at 12:48:39PM +0100, Dongsu Park wrote:
> > From: Kent Overstreet <kmo@daterainc.com>
> > 
> > Refactor sync_request_write() of md/raid10 to use bio_copy_data()
> > instead of open coding bio_vec iterations.
> 
> Seems like another one for the prep sweries?

Right. I'll also move this to the prep series with iov_iter conversions etc.

Thanks,
Dongsu
