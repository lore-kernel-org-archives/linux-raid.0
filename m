From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 000 of 2] Introduction
Date: Mon, 31 Oct 2005 17:44:46 +1100
Message-ID: <17253.48478.962445.586736@cse.unsw.edu.au>
References: <20051031165552.8151.patches@notabene>
	<20051030233432.238d0020.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Sunday October 30
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 30, akpm@osdl.org wrote:
> NeilBrown <neilb@suse.de> wrote:
> >
> > 
> >  I'd like to review the sysfs a bit more before it goes to Linus, but
> >  the rest can go anytime.
> 
> umm, what does "the sysfs" refer to?

Sorry.. "the sysfs related patches".

Those marked as 'THIS' below.  

However I think a couple that come after those won't simple move
backwards (largely due to
md-convert-faulty-and-in_sync-fields-to-bits-in-flags-field).

I'll make sure you have a full set that I am happy to go to Linus by
the end of the week.

Thanks,
NeilBrown


> 
> Current md patches in -mm:
> 
> md-better-handling-of-readerrors-with-raid5.patch
THIS > md-initial-sysfs-support-for-md.patch
THIS > md-extend-md-sysfs-support-to-component-devices.patch
THIS > md-add-kobject-sysfs-support-to-raid5.patch
THIS > md-allow-a-manual-resync-with-md.patch
THIS > md-teach-raid5-the-difference-between-check-and-repair.patch
> md-provide-proper-rcu_dereference--rcu_assign_pointer-annotations-in-md.patch
THIS > md-fix-ref-counting-problems-with-kobjects-in-md.patch
THIS > md-minor-md-fixes.patch
THIS > md-change-raid5-sysfs-attribute-to-not-create-a-new-directory.patch
> md-improvements-to-raid5-handling-of-read-errors.patch
> md-convert-faulty-and-in_sync-fields-to-bits-in-flags-field.patch
> md-make-md-on-disk-bitmaps-not-host-endian.patch
> md-support-bio_rw_barrier-for-md-raid1.patch
> drivers-md-fix-up-schedule_timeout-usage.patch
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
