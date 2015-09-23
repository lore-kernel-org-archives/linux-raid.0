From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 1/2] md: clear CHANGE_PENDING in readonly array
Date: Tue, 22 Sep 2015 23:23:12 -0700
Message-ID: <20150923062302.GA2780132@devbig084.prn1.facebook.com>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com>
 <87eghpy8k2.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87eghpy8k2.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, Sep 23, 2015 at 04:05:33PM +1000, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> 
> > If faulty disks of an array are more than allowed degraded number, the
> > array enters error handling. It will be marked as read-only with
> > MD_CHANGE_PENDING/RECOVERY_NEEDED set. But currently recovery doesn't
> > clear CHANGE_PENDING bit for read-only array.  If MD_CHANGE_PENDING is
> > set for a raid5 array, all returned IO will be hold on a list till the
> > bit is clear. But recovery nevery clears this bit, the IO is always in
> > pending state and nevery finish. This has bad effects like upper layer
> > can't get an IO error and the array can't be stopped.
> >
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/md.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 95824fb..c596b73 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -8209,6 +8209,7 @@ void md_check_recovery(struct mddev *mddev)
> >  			md_reap_sync_thread(mddev);
> >  			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> >  			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> > +			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
> >  			goto unlock;
> >  		}
> >  
> > -- 
> > 1.8.1
> 
> Hi,
>  I can see that clearing MD_CHANGE_PENDING there is probably correct -
>  bug introduced by
>    Commit: c3cce6cda162 ("md/raid5: ensure device failure recorded before write request returns.")
> 
>  However I don't understand your reasoning.  You say that the array is
>  marked as read-only, but I don't see how that would happen.  What
>  causes the array to be marked "read-only"?

It's set read-only by mdadm. I didn't look carefully, but looks there is
disk failure event, mdadm is invoked automatically by some background
daemon. It's a ubuntu distribution.

Thanks,
Shaohua
