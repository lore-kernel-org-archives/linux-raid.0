From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] Recovery speed is wrong
Date: Fri, 8 Aug 2014 03:36:47 -0400 (EDT)
Message-ID: <2083091497.19925833.1407483407203.JavaMail.zimbra@redhat.com>
References: <1888683818.19423710.1407418230213.JavaMail.zimbra@redhat.com> <1135772294.19428712.1407418661354.JavaMail.zimbra@redhat.com> <20140808122155.306ab784@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140808122155.306ab784@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Friday, August 8, 2014 10:21:55 AM
> Subject: Re: [PATCH] Recovery speed is wrong
> 
> On Thu, 7 Aug 2014 09:37:41 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > Hi all
> > 
> >    When we calculate the speed of recovery, the numerator that contains the
> >    recovery done sectors.
> > It's need to subtract the sectors which don't finish recovery.
> 
> Thanks,
> I've applied the patch.  However it needed some fixing up first.  If you are
> going to be sending more patches, you need to get these details right.
> 
> I suggest using "quilt" to create patches.  There are other options, I mostly
> use 'git' and 'stg' myself, but quilt is easy to get started with:
> > 
> > 
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > 
> > diff -urN linux-stable/drivers/md/md.c fix/md.c
> > --- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
> > +++ fix/md.c   2014-08-07 16:07:12.559503942 +0800
> 
> This makes it look like the file "fix/md.c" is being patched, which confuses
> programs that apply patches (like "git am").
> If you really want to do it by hand, then:
> 
>   cp drivers/md/md.c drivers/md/md.c.orig
>   # edit drivers/md/md.c
>   # compile and test
>   diff -u drivers/md/md.c.orig drivers/md/md.c > /tmp/diff
> 
> and post /tmp/diff.
> 
> > @@ -7376,7 +7376,7 @@
> >    struct mddev *mddev2;
> >    unsigned int currspeed = 0,
> >        window;
> > -  sector_t max_sectors,j, io_sectors;
> > +  sector_t max_sectors,j, io_sectors, recovery_done;
> >    unsigned long mark[SYNC_MARKS];
> >    unsigned long update_time;
> >    sector_t mark_cnt[SYNC_MARKS];
>  ^^^^
> 
> There are spaces here.  They should be 'tabs'.  Probably your mail program
> thinks it knows better and is converting spaces to tabs.
> If you cannot get it not to do that, then add the patch as an attachment.
> I MUCH prefer patches to be inline in the text, not as an attachment, but an
> attachment is MUCH better than converting all the tabs to spaces.
> 
> > @@ -7652,7 +7652,8 @@
> >        */
> >       cond_resched();
> >  
> > -     currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
> > +     recovery_done = io_sectors - atomic_read(&mddev->recovery_active);
> > +     currspeed = ((unsigned long)recovery_done - mddev->resync_mark_cnt)/2
> >          /((jiffies-mddev->resync_mark)/HZ +1) +1;
> 
> I also kept the inner brackets, so that reads:
> 
> > +     currspeed = ((unsigned long)(recovery_done -
> > mddev->resync_mark_cnt))/2
> 
> I think the extra brackets make it clear that it is the difference that needs
> to be cast, not just the first value.  The result is the same, but this very
> is (to me) more readable.
> 
> Thanks,
> NeilBrown
> 
> 
> >  
> >       if (currspeed > speed_min(mddev)) {
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Hi Neil

   Thanks very much for the detailed information. I need to study the git tools to create and sendmail
patches. I'll notice those problems.

Best Regards
Xiao
