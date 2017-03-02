From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2 04/13] md: prepare for managing resync I/O pages in
 clean way
Date: Thu, 2 Mar 2017 10:09:14 +0800
Message-ID: <CACVXFVMJ-h+TwKT8eVbg3AxUjBzzEsCV0SeuDUaQ3FvFdfni3w@mail.gmail.com>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-5-git-send-email-tom.leiming@gmail.com> <20170228233011.rdqtde22zwsimbz7@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170228233011.rdqtde22zwsimbz7@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

Hi Shaohua,

On Wed, Mar 1, 2017 at 7:30 AM, Shaohua Li <shli@kernel.org> wrote:
> On Tue, Feb 28, 2017 at 11:41:34PM +0800, Ming Lei wrote:
>> Now resync I/O use bio's bec table to manage pages,
>> this way is very hacky, and may not work any more
>> once multipage bvec is introduced.
>>
>> So introduce helpers and new data structure for
>> managing resync I/O pages more cleanly.
>>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  drivers/md/md.h | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 54 insertions(+)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 1d63239a1be4..b5a638d85cb4 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -720,4 +720,58 @@ static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
>>  #define RESYNC_BLOCK_SIZE (64*1024)
>>  #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>>
>> +/* for managing resync I/O pages */
>> +struct resync_pages {
>> +     unsigned        idx;    /* for get/put page from the pool */
>> +     void            *raid_bio;
>> +     struct page     *pages[RESYNC_PAGES];
>> +};
>
> I'd like this to be embedded into r1bio directly. Not sure if we really need a
> structure.

There are two reasons we can't put this into r1bio:
- r1bio is used in both normal and resync I/O, not fair to allocate more
in normal I/O, and that is why this patch wouldn't like to touch r1bio or r10bio

- the count of 'struct resync_pages' instance depends on raid_disks(raid1)
or copies(raid10), both can't be decided during compiling.

>
>> +
>> +static inline int resync_alloc_pages(struct resync_pages *rp,
>> +                                  gfp_t gfp_flags)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < RESYNC_PAGES; i++) {
>> +             rp->pages[i] = alloc_page(gfp_flags);
>> +             if (!rp->pages[i])
>> +                     goto out_free;
>> +     }
>> +
>> +     return 0;
>> +
>> + out_free:
>> +     while (--i >= 0)
>> +             __free_page(rp->pages[i]);
>> +     return -ENOMEM;
>> +}
>> +
>> +static inline void resync_free_pages(struct resync_pages *rp)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < RESYNC_PAGES; i++)
>> +             __free_page(rp->pages[i]);
>
> Since we will use get_page, shouldn't this be put_page?

You are right, will fix in v3.

>
>> +}
>> +
>> +static inline void resync_get_all_pages(struct resync_pages *rp)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < RESYNC_PAGES; i++)
>> +             get_page(rp->pages[i]);
>> +}
>> +
>> +static inline struct page *resync_fetch_page(struct resync_pages *rp)
>> +{
>> +     if (WARN_ON_ONCE(rp->idx >= RESYNC_PAGES))
>> +             return NULL;
>> +     return rp->pages[rp->idx++];
>
> I'd like the caller explicitly specify the index instead of a global variable
> to track it, which will make the code more understandable and less error prone.

That is fine, but the index has to be per bio, and finally the index
has to be stored
in 'struct resync_pages', so every user has to call it in the following way:

          resync_fetch_page(rp, rp->idx);

then looks no benefit to pass index explicitly.

>
>> +}
>> +
>> +static inline bool resync_page_available(struct resync_pages *rp)
>> +{
>> +     return rp->idx < RESYNC_PAGES;
>> +}
>
> Then we don't need this obscure API.

That is fine.


Thanks,
Ming Lei
