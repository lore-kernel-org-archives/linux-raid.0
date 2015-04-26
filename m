From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH] md/raid10: make sync_request_write() call bio_copy_data()
Date: Sat, 25 Apr 2015 22:42:46 -0700
Message-ID: <CAF1ivSYhyDnU-Xzi3utoigk0w9N89hbkampCfmeUqMxd4FMtug@mail.gmail.com>
References: <1429915930-22449-1-git-send-email-mlin@kernel.org>
	<20150425094726.GB14363@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150425094726.GB14363@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>
List-Id: linux-raid.ids

On Sat, Apr 25, 2015 at 2:47 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Apr 24, 2015 at 03:52:10PM -0700, Ming Lin wrote:
>> From: Kent Overstreet <kent.overstreet@gmail.com>
>>
>> Refactor sync_request_write() of md/raid10 to use bio_copy_data()
>> instead of open coding bio_vec iterations.
>
> Do you plan to submit an updated version of the immutable biovecs set
> soon?  In that case it would be good to merge this patch through
> the block tree, as it's a requirement for it AFAICS.  Might be worth to
> repost them together.

I have put the immutable biovecs set here:
https://git.kernel.org/cgit/linux/kernel/git/mlin/linux.git/log/?h=block-generic-req
Will add this patch also.

I'll submit the patch set soon after running some tests.
