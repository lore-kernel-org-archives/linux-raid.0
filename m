From: Matteo Croce <mcroce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] block: refactor duplicated macros
Date: Thu, 5 Mar 2020 00:24:35 +0100
Message-ID: <CAGnkfhxAHctB9MHD0LzSk8uh4tEoF-hw+iwYAEdfeY_=g3NT2A@mail.gmail.com>
References: <20200223165724.23816-1-mcroce@redhat.com> <CAPcyv4ijKqVhHixsp42kZL4p7uReJ67p3XoPyw5ojM-ZsOOUOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAPcyv4ijKqVhHixsp42kZL4p7uReJ67p3XoPyw5ojM-ZsOOUOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel <xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Wed, Mar 4, 2020 at 9:57 PM Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> On Sun, Feb 23, 2020 at 9:04 AM Matteo Croce <mcroce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > The macros PAGE_SECTORS, PAGE_SECTORS_SHIFT and SECTOR_MASK are defined
> > several times in different flavours across the whole tree.
> > Define them just once in a common header.
> >
> > Signed-off-by: Matteo Croce <mcroce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  block/blk-lib.c                  |  2 +-
> >  drivers/block/brd.c              |  3 ---
> >  drivers/block/null_blk_main.c    |  4 ----
> >  drivers/block/zram/zram_drv.c    |  8 ++++----
> >  drivers/block/zram/zram_drv.h    |  2 --
> >  drivers/dax/super.c              |  2 +-
>
> For the dax change:
>
> Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> However...
>
> [..]
> >  include/linux/blkdev.h           |  4 ++++
> [..]
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 053ea4b51988..b3c9be6906a0 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -910,6 +910,10 @@ static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
> >  #define SECTOR_SIZE (1 << SECTOR_SHIFT)
> >  #endif
> >
> > +#define PAGE_SECTORS_SHIFT     (PAGE_SHIFT - SECTOR_SHIFT)
> > +#define PAGE_SECTORS           (1 << PAGE_SECTORS_SHIFT)
> > +#define SECTOR_MASK            (PAGE_SECTORS - 1)
> > +
>
> ...I think SECTOR_MASK is misnamed given it considers pages, and
> should probably match the polarity of PAGE_MASK, i.e.
>
> #define PAGE_SECTORS_MASK            (~(PAGE_SECTORS - 1))
>

Makes sense. I just kept the same value as in drivers/block/null_blk_main.c

-- 
Matteo Croce
per aspera ad upstream
