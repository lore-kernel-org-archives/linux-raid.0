From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 1/2] md: clear CHANGE_PENDING in readonly array
Date: Thu, 24 Sep 2015 09:47:20 -0700
Message-ID: <20150924164720.GA3706482@devbig084.prn1.facebook.com>
References: <bda150068cfdb69bf8b632c32dc2a7db17c919f4.1442596586.git.shli@fb.com>
 <87eghpy8k2.fsf@notabene.neil.brown.name>
 <20150923062302.GA2780132@devbig084.prn1.facebook.com>
 <87fv24wjiu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87fv24wjiu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, Sep 24, 2015 at 02:03:53PM +1000, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> 
> > On Wed, Sep 23, 2015 at 04:05:33PM +1000, Neil Brown wrote:
> >> Shaohua Li <shli@fb.com> writes:
> >> 
> >> > If faulty disks of an array are more than allowed degraded number, the
> >> > array enters error handling. It will be marked as read-only with
> >> > MD_CHANGE_PENDING/RECOVERY_NEEDED set. But currently recovery doesn't
> >> > clear CHANGE_PENDING bit for read-only array.  If MD_CHANGE_PENDING is
> >> > set for a raid5 array, all returned IO will be hold on a list till the
> >> > bit is clear. But recovery nevery clears this bit, the IO is always in
> >> > pending state and nevery finish. This has bad effects like upper layer
> >> > can't get an IO error and the array can't be stopped.
> >> >
> >> > Signed-off-by: Shaohua Li <shli@fb.com>
> >> > ---
> >> >  drivers/md/md.c | 1 +
> >> >  1 file changed, 1 insertion(+)
> >> >
> >> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> > index 95824fb..c596b73 100644
> >> > --- a/drivers/md/md.c
> >> > +++ b/drivers/md/md.c
> >> > @@ -8209,6 +8209,7 @@ void md_check_recovery(struct mddev *mddev)
> >> >  			md_reap_sync_thread(mddev);
> >> >  			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
> >> >  			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >> > +			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
> >> >  			goto unlock;
> >> >  		}
> >> >  
> >> > -- 
> >> > 1.8.1
> >> 
> >> Hi,
> >>  I can see that clearing MD_CHANGE_PENDING there is probably correct -
> >>  bug introduced by
> >>    Commit: c3cce6cda162 ("md/raid5: ensure device failure recorded before write request returns.")
> >> 
> >>  However I don't understand your reasoning.  You say that the array is
> >>  marked as read-only, but I don't see how that would happen.  What
> >>  causes the array to be marked "read-only"?
> >
> > It's set read-only by mdadm. I didn't look carefully, but looks there is
> > disk failure event, mdadm is invoked automatically by some background
> > daemon. It's a ubuntu distribution.
> 
> Thanks.
> This raises a couple of questions.
> 
> 1/ What should md_set_readonly do if it finds that MD_CHANGE_PENDING is
>    set?
>   Maybe it should wait for md_check_recovery to get run which should
>   clear the bit, after probably writing out the metadata.
> 
> 2/ Why didn't md_check_recovery already do that before mdadm had a
>    chance to set the array read-only?
>   I guess that is just a timing thing.  md_check_recovery could be
>   delayed, and mdadm could get called by udev rather quickly.
> 
> I think I'll get md_set_readonly to
> 	wait_event(mddev->sb_wait,
> 		   !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> 
> because I think that is the right thing to do.  But if the array is
> already read-only that won't help, so I'll still need you patch.
> 
> Would you be able to test that the following patch (without your patch)
> also fixes the symptom?

Yes, the wait_event patch fixes the issue (without my patch).

Thanks,
Shaohua
