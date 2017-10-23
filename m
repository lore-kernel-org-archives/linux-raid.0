From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 1/5 v2] md: always hold reconfig_mutex when calling
 mddev_suspend()
Date: Sun, 22 Oct 2017 18:48:35 -0700
Message-ID: <20171023014835.6qlu4cpzimjuxgpu@kernel.org>
References: <150820826980.1646.6380214598725492144.stgit@noble>
 <150820840340.1646.12365558035859364361.stgit@noble>
 <20171018061107.42kpztc3nbnhbavi@kernel.org>
 <87efq0j4d2.fsf@notabene.neil.brown.name>
 <87lgk8gcmb.fsf@notabene.neil.brown.name>
 <20171019034420.sdxvirpv454vgx4h@kernel.org>
 <8760bbhcql.fsf@notabene.neil.brown.name>
 <20171020042820.iredht4f7lvatdst@kernel.org>
 <87sheaenow.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87sheaenow.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 23, 2017 at 11:02:23AM +1100, Neil Brown wrote:
> On Thu, Oct 19 2017, Shaohua Li wrote:
> >> >
> >> > For this one, my point is:
> >> >
> >> > 	wait_event(mddev->sb_wait, conf->log == NULL ||
> >> > 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
> >> > 	if (conf->log == NULL)
> >> > 		return;
> >> >
> >> > 	mddev_suspend(mddev);
> >> > 	log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
> >> > 	mddev_resume(mddev);
> >> >
> >> > does it work?
> >> 
> >> The
> >> 	lockdep_assert_held(&mddev->reconfig_mutex);
> >> in mddev_suspend() will complain.
> >> 
> >> If you put an mddev_lock() call in there to stop the complaint, and if
> >> the work item doesn't start before the reconfig_mutex is taken prior to
> >> stopping the array, then r5l_exit_log() can deadlock at
> >> 	flush_work(&log->disable_writeback_work);
> >
> > Ok, got it now. But really don't like this patch. The mddev_unlock is strange,
> > r5c_disable_writeback_async could skip disabling writeback too. Could we add a
> > new callback like .prepare_free, and flush workqueue there. After we drop the
> > reconfig_mutex in do_md_stop, we call the prepare_free. We can probably set a
> > flag, so later r5c_disable_writeback_async will bail out doing nothing. I think
> > this should work, right?
> 
> Might work, though it sounds more messy to me (assuming I understand).
> 
> I would like to get rid of disable_writeback_work altogether.
> Just set  log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH in
> r5c_update_on_rdev_error(), and make sure that does the right thing.
> 
> The distinction between write-through and write-back should be able to
> be a per-stripe_head distinction.  Once we set r5c_journal_mode, new
> stripe_heads will get the new mode, old ones are allowed to continue how
> they are.
> Maybe we could keep a counter of how many stripes are in WRITE_BACK
> mode, and test that counter in r5c_is_writeback()??
> 
> I don't know what all the issues are so it would need careful review,
> preferably by someone familiar with the code.

We check the writeback in several steps, would be problematical, but I didn't
take a close look yet.

> Short of that, I think my current patch is the best interim step.  I
> agree that it isn't the most elegant thing ever, but it is localized and
> I believe it works correctly.
> The "mddev_unlock()" shouldn't look too strange, it perfectly balances
> he mddev_try_lock().

Alright, we need this patch to avoid the lockdep warning, so I queued the patch
now. Once I got time, I'll check if the proposal works.

Thanks,
Shaohua
