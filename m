From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2] md/bitmap: clear BITMAP_WRITE_ERROR bit before
 writing it to sb
Date: Sun, 12 Nov 2017 19:57:41 -0800
Message-ID: <20171113035741.c2fwwluld2yuatgc@kernel.org>
References: <20171106021125.40619-1-houtao1@huawei.com>
 <c30552cb-f913-63e9-c2ca-9443e0d76e5f@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c30552cb-f913-63e9-c2ca-9443e0d76e5f@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hou Tao <houtao1@huawei.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Mon, Nov 13, 2017 at 10:18:14AM +0800, Hou Tao wrote:
> Hi,
> 
> Any comments ?

already queued.
 
> On 2017/11/6 10:11, Hou Tao wrote:
> > For a RAID1 device using a file-based bitmap, if a bitmap write error
> > occurs but the later writes succeed, it's possible both BITMAP_STALE
> > and BITMAP_WRITE_ERROR bits will be written to the bitmap super block,
> > the BITMAP_STALE bit will be handled properly and be cleared, but the
> > BITMAP_WRITE_ERROR bit in sb->flags will make bitmap_create() to fail.
> > 
> > So clear it to protect against the write failure-and-then-recovery case.
> > 
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > 
> > ---
> > v2:
> > 	* clear the BITMAP_WRITE_ERROR bit before writing sb, not after
> > 	reading sb
> > v1:
> > 	* http://www.spinics.net/lists/raid/msg59590.html
> > ---
> >  drivers/md/bitmap.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> > index d212163..30e503d 100644
> > --- a/drivers/md/bitmap.c
> > +++ b/drivers/md/bitmap.c
> > @@ -459,7 +459,11 @@ void bitmap_update_sb(struct bitmap *bitmap)
> >  		/* rocking back to read-only */
> >  		bitmap->events_cleared = bitmap->mddev->events;
> >  	sb->events_cleared = cpu_to_le64(bitmap->events_cleared);
> > -	sb->state = cpu_to_le32(bitmap->flags);
> > +	/*
> > +	 * clear BITMAP_WRITE_ERROR bit to protect against the case that
> > +	 * a bitmap write error occurred but the later writes succeeded.
> > +	 */
> > +	sb->state = cpu_to_le32(bitmap->flags & ~BIT(BITMAP_WRITE_ERROR));
> >  	/* Just in case these have been changed via sysfs: */
> >  	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
> >  	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
