From: "bmoon" <bo@anthologysolutions.com>
Subject: Re: RAID 1+0 makes BUG in raid1.c, but 0+1 works?
Date: Fri, 3 Jan 2003 11:27:49 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00b501c2b35e$33730970$6a01a8c0@bmoon>
References: <20021225172009.Z1089@questra.com> <15891.33465.348466.886941@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>, Scott Mcdermott <smcdermott@questra.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I am using 2.4.x(2.4.5  and 2.4.20) but I do not have "sync_page_io(" on
/drivers/md/md.c.
I am using RAID10, too. If it is critical I need to fix it.
Should I try this patch?

Thanks,

Bo
----- Original Message -----
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: "Scott Mcdermott" <smcdermott@questra.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Wednesday, January 01, 2003 4:07 PM
Subject: Re: RAID 1+0 makes BUG in raid1.c, but 0+1 works?


> On Wednesday December 25, smcdermott@questra.com wrote:
> >
> > is there something I'm doing wrong or is this a bug? Should I not be
> > using RAID1+0 ? I just tried it with RAID0+1 instead and it seems to
> > work fine (although it's somewhat slower than I expected, and initial
> > sync goes 250K/s for some reason until I turn up the minimum).  This
> > makes no sense to me as I thought that RAID devices were a block-level
> > abstraction...so why would 0+1 work but not 1+0 ?? I really dislike the
> > additional probability of second-disk failure in RAID0+1 over RAID1+0,
> > and the ridiculous resync times, and I don't like the slow write speed
> > of RAID5.
>
> It is a bug.  Arguably, the bug is that the test and BUG() call are
> wrong, but  the patch below is probably the perferred fix in a stable
> kernel.
>
> I always recommend raid1 or raid5 at the bottom, and raid0/linear/lvm
> on top of that.
>
> NeilBrown
>
>  ----------- Diffstat output ------------
>  ./drivers/md/md.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
>
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~ 2002-12-17 15:20:57.000000000 +1100
> +++ ./drivers/md/md.c 2003-01-02 11:05:20.000000000 +1100
> @@ -489,7 +489,7 @@ static int sync_page_io(kdev_t dev, unsi
>   init_buffer(&bh, bh_complete, &event);
>   bh.b_rdev = dev;
>   bh.b_rsector = sector;
> - bh.b_state = (1 << BH_Req) | (1 << BH_Mapped);
> + bh.b_state = (1 << BH_Req) | (1 << BH_Mapped) | (1 << BH_Locked);
>   bh.b_size = size;
>   bh.b_page = page;
>   bh.b_reqnext = NULL;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

