From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Tue, 26 May 2015 07:33:45 -0700
Message-ID: <CAF1ivSajEe1ec_dCeUec=ER3keKVfhhNvv5pWiti_M++NRrBDQ@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
	<20150525154829.4330f149@notabene.brown>
	<CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
	<20150525175414.6a1fc33d@notabene.brown>
	<20150525141708.GA26249@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150525141708.GA26249@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: NeilBrown <neilb@suse.de>, Ming Lin <mlin@kernel.org>, lkml <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 25, 2015 at 7:17 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, May 25, 2015 at 05:54:14PM +1000, NeilBrown wrote:
>> Did I write that?  I guess I did :-(
>> I meant *after*.   Don't get rid of bio_fits_rdev until split_bio is in
>> chunk_aligned_read().
>
> I suspect the whole series could use some reordering.

Nice reordering.
I'll do this.

Thanks.

>
> patch 1:
>
>  add ->bio_split and blk_queue_split
>
> patch 2..n:
>
>  one for each non-trivial driver that implements ->merge_bvec_fn to
>  remove it and instead split bios in ->make_request.  The md patch
>  to do the right thing in chunk_aligned_read goes into the general
>  md patch here.  The bcache patch also goes into this series.
>
> patch n+1:
>
>  - add blk_queue_split calls for remaining trivial drivers
>
> patch n+2:
>
>  - remove ->merge_bvec_fn and checking of max_sectors a for all
>    drivers, simplify bio_add_page
>
> patch n+2:
>
>  - remove splitting in blkdev_issue_discard
>
> patch n+3
>
>  - remove bio_fits_rdev
>
> patch n+4
>
>  - remove bio_get_nr_vecs
>
> patch n+4
>
>  - use bio_add_page
>
> patch n+5
>
>  - update documentation
