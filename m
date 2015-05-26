From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v4 06/11] md/raid5: get rid of bio_fits_rdev()
Date: Tue, 26 May 2015 15:32:38 -0700
Message-ID: <CAF1ivSYxfE+bZrPD7vpHPsU+XAD+S2Lkz=h84vA9yCy86h40ow@mail.gmail.com>
References: <1432318723-18829-1-git-send-email-mlin@kernel.org>
	<1432318723-18829-7-git-send-email-mlin@kernel.org>
	<20150525154829.4330f149@notabene.brown>
	<CAF1ivSY+ky5PD=m34KXU4z9gE_v4uztaFT=MuU4g69DtXD9vWA@mail.gmail.com>
	<20150525175414.6a1fc33d@notabene.brown>
	<20150525141708.GA26249@lst.de>
	<CAF1ivSajEe1ec_dCeUec=ER3keKVfhhNvv5pWiti_M++NRrBDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSajEe1ec_dCeUec=ER3keKVfhhNvv5pWiti_M++NRrBDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, NeilBrown <neilb@suse.de>, lkml <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Jens Axboe <axboe@kernel.dk>, Dongsu Park <dpark@posteo.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 26, 2015 at 7:33 AM, Ming Lin <mlin@kernel.org> wrote:
> On Mon, May 25, 2015 at 7:17 AM, Christoph Hellwig <hch@lst.de> wrote:
>> On Mon, May 25, 2015 at 05:54:14PM +1000, NeilBrown wrote:
>>> Did I write that?  I guess I did :-(
>>> I meant *after*.   Don't get rid of bio_fits_rdev until split_bio is in
>>> chunk_aligned_read().
>>
>> I suspect the whole series could use some reordering.
>
> Nice reordering.
> I'll do this.

Here is the reordering.
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=block-generic-req

I'll post it if you are OK.

[PATCH 01/15] block: add blk_queue_split()
[PATCH 02/15] md: remove ->merge_bvec_fn
[PATCH 03/15] dm: remov merge functions
[PATCH 04/15] drbd: remove ->merge_bvec_fn
[PATCH 05/15] pktcdvd: remove ->merge_bvec_fn
[PATCH 06/15] rbd: remove ->merge_bvec_fn
[PATCH 07/15] bcache: remove driver private bio splitting code
[PATCH 08/15] btrfs: remove bio splitting and merge_bvec_fn() calls
[PATCH 09/15] block: call blk_queue_split() in make_request functions
[PATCH 10/15] block: kill ->merge_bvec_fn and simplify bio_add_page
[PATCH 11/15] block: remove split code in blkdev_issue_discard
[PATCH 12/15] md/raid5: get rid of bio_fits_rdev()
[PATCH 13/15] block: remove bio_get_nr_vecs()
[PATCH 14/15] fs: use helper bio_add_page() instead of open coding on
[PATCH 15/15] Documentation: update notes in biovecs about

>
> Thanks.
>
>>
>> patch 1:
>>
>>  add ->bio_split and blk_queue_split
>>
>> patch 2..n:
>>
>>  one for each non-trivial driver that implements ->merge_bvec_fn to
>>  remove it and instead split bios in ->make_request.  The md patch
>>  to do the right thing in chunk_aligned_read goes into the general
>>  md patch here.  The bcache patch also goes into this series.
>>
>> patch n+1:
>>
>>  - add blk_queue_split calls for remaining trivial drivers
>>
>> patch n+2:
>>
>>  - remove ->merge_bvec_fn and checking of max_sectors a for all
>>    drivers, simplify bio_add_page
>>
>> patch n+2:
>>
>>  - remove splitting in blkdev_issue_discard
>>
>> patch n+3
>>
>>  - remove bio_fits_rdev
>>
>> patch n+4
>>
>>  - remove bio_get_nr_vecs
>>
>> patch n+4
>>
>>  - use bio_add_page
>>
>> patch n+5
>>
>>  - update documentation
