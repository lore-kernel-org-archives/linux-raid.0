From: Xiao Ni <xni@redhat.com>
Subject: Re: One patch just review the code
Date: Thu, 7 Aug 2014 06:06:19 -0400 (EDT)
Message-ID: <835401588.19232017.1407405979159.JavaMail.zimbra@redhat.com>
References: <705044700.17914512.1407222497904.JavaMail.zimbra@redhat.com> <1122994629.17915693.1407222727992.JavaMail.zimbra@redhat.com> <20140806164420.09e4df13@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140806164420.09e4df13@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "NeilBrown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <jes.sorensen@redhat.com>
> Sent: Wednesday, August 6, 2014 2:44:20 PM
> Subject: Re: One patch just review the code
> 
> On Tue, 5 Aug 2014 03:12:07 -0400 (EDT) Xiao Ni <xni@redhat.com> wrote:
> 
> > Hi all
> > 
> >    I'm reading the code of md. I find there is a problem. I know now there
> >    are arrays mark[SYNC_MARKS] mark_cnt[SYNC_MARKS]
> > store the information about how many sectors finish recovery and the
> > moment.
> > 
> > 
> > 7825       currspeed = ((unsigned
> > long)(io_sectors-mddev->resync_mark_cnt))/2
> > 7826          /((jiffies-mddev->resync_mark)/HZ +1) +1;
> >   
> >    But when calculate the speed of recovery, the sectors used to calculate
> >    contains
> > the sectors which are not finished recovery.
> > 
> >    When assign value to mark_cnt[next], it subtract the sectors which don't
> >    finish recovery.
> > So I think when calculate the recovery speed we should subtract the sectors
> > not finishing
> > recovery too.
> > 
> > 7638          mark_cnt[next] = io_sectors -
> > atomic_read(&mddev->recovery_active);
> > 
> >    So I try to modify and the patch is:
> > 
> > --- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
> > +++ fix/md.c   2014-07-31 16:40:57.151493177 +0800
> > @@ -7652,7 +7652,7 @@
> >        */
> >       cond_resched();
> >  
> > -     currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
> > +     currspeed = ((unsigned
> > long)(io_sectors-atomic_read(&mddev->recovery_active)-mddev->resync_mark_cnt))/2
> >          /((jiffies-mddev->resync_mark)/HZ +1) +1;
> >  
> >       if (currspeed > speed_min(mddev)) {
> > 
> >    Am I right?
> 
> Yes, that looks right.
> If you create a properly formatted patch, and wrap that long line nicely I'll
> apply it.
> 
> Thanks,
> NeilBrown
> 

I definite a new variable, do you allow me to do by this way?

Signed-off-by: Xiao Ni <xni@redhat.com>

diff -urN linux-stable/drivers/md/md.c fix/md.c
--- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
+++ fix/md.c   2014-08-07 16:07:12.559503942 +0800
@@ -7376,7 +7376,7 @@
   struct mddev *mddev2;
   unsigned int currspeed = 0,
       window;
-  sector_t max_sectors,j, io_sectors;
+  sector_t max_sectors,j, io_sectors, recovery_done;
   unsigned long mark[SYNC_MARKS];
   unsigned long update_time;
   sector_t mark_cnt[SYNC_MARKS];
@@ -7652,7 +7652,8 @@
       */  
      cond_resched();
 
-     currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
+     recovery_done = io_sectors - atomic_read(&mddev->recovery_active);
+     currspeed = ((unsigned long)recovery_done - mddev->resync_mark_cnt)/2 
         /((jiffies-mddev->resync_mark)/HZ +1) +1; 
 
      if (currspeed > speed_min(mddev)) {

