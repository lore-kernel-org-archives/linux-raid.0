From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 3/3] md: separate flags for superblock changes
Date: Thu, 8 Dec 2016 21:16:41 -0800
Message-ID: <20161209051641.gfo46pcu2g6zuiyo@kernel.org>
References: <cover.1481240632.git.shli@fb.com>
 <a836dcdaef1cecec422f492cca1c4e525034d0e6.1481240632.git.shli@fb.com>
 <87lgvp1zld.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87lgvp1zld.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 09, 2016 at 03:43:58PM +1100, Neil Brown wrote:
> On Fri, Dec 09 2016, Shaohua Li wrote:
> 
> > The mddev->flags are used for different purposes. There are a lot of
> > places we check/change the flags without masking unrelated flags, we
> > could check/change unrelated flags. These usage are most for superblock
> > write, so spearate superblock related flags. This should make the code
> > clearer and also fix real bugs.
> >
> > Signed-off-by: Shaohua Li <shli@fb.com>
> 
> That real bug would be:
> 
> >  		md_wakeup_thread(mddev->thread);
> > -		wait_event(mddev->sb_wait, mddev->flags == 0 ||
> > +		wait_event(mddev->sb_wait, mddev->sb_flags == 0 ||
> >  			   test_bit(MD_RECOVERY_INTR, &mddev->recovery));

Yes, for the reshape hang.

> 
> mddev->flags used to be called mddev->sb_dirty, before
> Commit: 850b2b420cd5 ("[PATCH] md: replace magic numbers in sb_dirty with well defined bit flags")
> 
> Then we added lots of other flags.  Now we are going back to the same
> idea :-)
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> 
> Thanks,
> NeilBrown


