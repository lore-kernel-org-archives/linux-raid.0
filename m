From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 13/13] md: raid10: avoid direct access to bvec table in handle_reshape_read_error
Date: Fri, 3 Mar 2017 10:30:08 +0800
Message-ID: <CACVXFVMLGPmO1s=MOkQJN30RdMnitL3=3POSc77iscxGr6BwNg@mail.gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-14-git-send-email-tom.leiming@gmail.com> <20170228234627.3h6tospuz33yhdig@kernel.org>
 <CACVXFVN8aE_Cd=ssBuhmVRK5YYRe2q4+jXoxsfztFLZiimH_xA@mail.gmail.com> <20170302074753.6zsdspg5e67l24xu@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170302074753.6zsdspg5e67l24xu@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Thu, Mar 2, 2017 at 3:47 PM, Shaohua Li <shli@kernel.org> wrote:
> On Thu, Mar 02, 2017 at 10:37:49AM +0800, Ming Lei wrote:
>> Hi Shaohua,
>>
>> On Wed, Mar 1, 2017 at 7:46 AM, Shaohua Li <shli@kernel.org> wrote:
>> > On Tue, Feb 28, 2017 at 11:41:43PM +0800, Ming Lei wrote:
>> >> The cost is 128bytes(8*16) stack space in kernel thread context, and
>> >> just use the bio helper to retrieve pages from bio.
>> >>
>> >> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> >> ---
>> >>  drivers/md/raid10.c | 12 ++++++++++--
>> >>  1 file changed, 10 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> >> index 0b97631e3905..6ffb64ab45f8 100644
>> >> --- a/drivers/md/raid10.c
>> >> +++ b/drivers/md/raid10.c
>> >> @@ -4670,7 +4670,15 @@ static int handle_reshape_read_error(struct mddev *mddev,
>> >>       struct r10bio *r10b = &on_stack.r10_bio;
>> >>       int slot = 0;
>> >>       int idx = 0;
>> >> -     struct bio_vec *bvec = r10_bio->master_bio->bi_io_vec;
>> >> +     struct bio_vec *bvl;
>> >> +     struct page *pages[RESYNC_PAGES];
>> >> +
>> >> +     /*
>> >> +      * This bio is allocated in reshape_request(), and size
>> >> +      * is still RESYNC_PAGES
>> >> +      */
>> >> +     bio_for_each_segment_all(bvl, r10_bio->master_bio, idx)
>> >> +             pages[idx] = bvl->bv_page;
>> >
>> > The reshape bio is doing IO against the memory we allocated for r10_bio, I'm
>> > wondering why we can't get the pages from r10_bio. In this way, we don't need
>> > access the bio_vec any more.
>>
>> Reshap read is special and the bio(r10_bio->master_bio) isn't allocated from
>> .r10buf_pool, please see reshape_request().
>
> Why does this matter? The bio is still doing IO to the memory allocated in
> r10_bio. bi_private->r10_bio->the pages.

Good question, :-)

>
> My guess why you think the reshape read is special is the bio->bi_private
> doesn't pointer to resync_pages. And since you let resync_pages pointer to
> r10_bio and not vice versa, we can't find r10_bio, correct? I think this is
> another reason why r10_bio embeds resync_pages (I mean a pointer to
> resync_pages). With this way I suggested, the reshape read isn't special at

We still can get the resync_pages for r10_bio->master_bio via
r10_bio->devs[0].bio in handle_reshape_read_error(), will do that in v3.

> all. If we allocate memory for r10_bio/r1_bio, we shouldn't need access any bio
> bvec.

Right.



Thanks,
Ming Lei
