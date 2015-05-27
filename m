From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Wed, 27 May 2015 10:15:49 +0200
Message-ID: <20150527081549.GA25575@lst.de>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org> <1432318723-18829-7-git-send-email-mlin@kernel.org> <20150525154829.4330f149@notabene.brown> <CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com> <20150525175414.6a1fc33d@notabene.brown> <20150525141708.GA26249@lst.de> <CAF1ivSajEe1ec_dCeUec=ER3keKVfhhNvv5pWiti_M++NRrBDQ@mail.gmail.com> <CAF1ivSYxfE+bZrPD7vpHPsU+XAD+S2Lkz=h84vA9yCy86h40ow@mail.gmail.com> <20150527090309.2cddf33b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150527090309.2cddf33b@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Ming Lin <mlin@kernel.org>, Christoph Hellwig <hch@lst.de>, lkml <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 27, 2015 at 09:03:09AM +1000, NeilBrown wrote:
> But I don't think the sequence is right.
> 
> You cannot remove ->merge_bvec_fn for *any* stacked device until *all* devices
> make use of blk_queue_split() (or otherwise handle arbitrarily large bios).
> 
> I think it would be easiest to:
>  - add blk_queue_split() and call it from common code before ->make_request_fn
>    is called.  The ensure all devices can accept arbitrarily large bios.
>  - driver-by-driver remove merge_bvec_fn and make sure the the driver can cope
>    with arbitrary bios themselve, calling blk_queue_split in the make_request
>    function only if needed
>  - finally remove the call to blk_queue_split from the common code.
> 
> Does that make sense to others?

Ok, sorry for leading in the wrong direction.  Because we stack
->merge_bvec_fn calls we do indeed need it until the end.

In that case I think it's better to just go back to something like the
original order and not split the patches up, everything else is just
getting too complicated unfrotunately.
