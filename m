From: "Jansen, Frank" <fjansen@CROSSBEAMSYS.COM>
Subject: RE: Latency issues with MD-RAID
Date: Wed, 2 Mar 2011 19:17:48 +0000
Message-ID: <FE279AF0CA06284B8C26150408F3EB12078DB73F@CBSSEXM02P.crossbeamsys.com>
References: <FE279AF0CA06284B8C26150408F3EB12078DB4AA@CBSSEXM02P.crossbeamsys.com>
 <20110302090416.4ed26e03@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110302090416.4ed26e03@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

Thank you for your response and my apologies for the incomplete nature of the e-mail; I didn't do all the work myself, so have collected the rest of the data to help complete the picture.

> > We're doing some testing to determine performance of MD-RAID and
> suitability for our environment.
> 
> RAID0 ? RAID1?  RAID5 ?
> It helps to be specific.
Sorry.  Should have mentioned that we're seeing this both with RAID1 and RAID5, but not with RAID0.
> 
> >
> > One particular test is giving some cause for concern:
> >
> > - Run heavy I/O to a raw partition:
> >  # time dd if=/dev/zero of=/dev/md0p1 bs=131072 count=1000000
> > - Run single sync I/Os to the partition:
> >  # time dd if=/dev/zero of=/dev/md0p1 bs=4096 count=1 oflag=sync
> >
> > When we run this, latency for the single I/O completion can go as
> high as 5-10 seconds
> >
> > In investigating this, it looks like the following code in
> md_write_start causes most of the slow down:
> >
> >         if (mddev->in_sync) {
> >                 spin_lock_irq(&mddev->write_lock);
> >                 if (mddev->in_sync) {
> >                         mddev->in_sync = 0;
> >                         set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> >                         set_bit(MD_CHANGE_PENDING, &mddev->flags);
> >                         md_wakeup_thread(mddev->thread);
> >                         did_change = 1;
> >                 }
> >                 spin_unlock_irq(&mddev->write_lock);
> >         }
> >
> > When we change this to run about once every 10 seconds, our latency
> goes way down to a reasonable number of milliseconds.
> 
> What did you change exactly.
> 
> This code can be tuned by changing
>    /sys/block/mdXXX/md/safe_mode_timeout
> which is measured in seconds and is the delay before marking a clean
> array
> dirty.
> 
I have put the code changes at the end of this message, and I'll test the safe_mode_timeout setting.
> >
> > Questions:
> > - is the high latency for single sync I/Os something that we should
> expect?
> 
> Not necessarily.
> 
> > - the first time the thread runs, it was seen to take a lot longer.
> Is this due to more outstanding metadata or similar?
> 
> No idea without a lot more details.  What is "the thread"?  How much is
> "a
> lot longer"?
> 
Should have been clearer; the thread is the appropriate raid thread; i.e. raid1d or raid5d.  When we put some timers in the code, without other changes, and then start the sync I/O once per second, the first sync write often takes as much as 5-10 seconds, whereas most of the others will average around 1 second with spikes from 2-5 seconds.  Occasional spikes were seen up to 15 seconds to complete a write, but those are infrequent.
> 
> > - is the approach to run the thread less frequently reasonable, or
> does that open up huge problems?
> 
> Seeing you have said exactly what you mean by "run the thread less
> frequently", that is a very hard question to answer.
> 
The change is to delay the superblock update for up to 10 seconds in the raid thread.

> NeilBrown
> 
> 
> 
> >
> > Thanks,
> >
> > Frank
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

drivers/md$ diff -c 
/kernels/linux_src-2.6.18-53.el5_64/drivers/md/raid1.c raid1.c
*** /kernels/linux_src-2.6.18-53.el5_64/drivers/md/raid1.c    2008-11-19 
15:02:05.000000000 -0500
--- raid1.c    2011-03-01 14:10:21.347880000 -0500
***************
*** 750,755 ****
--- 750,756 ----
       struct page **behind_pages = NULL;
       const int rw = bio_data_dir(bio);
       int do_barriers;
+     unsigned long start, sbsync, diska, diskb, end;

       /*
        * Register the new request and wait if the reconstruction
***************
*** 760,766 ****
        * if barriers work.
        */

!     md_write_start(mddev, bio); /* wait on superblock update early */

       if (unlikely(!mddev->barriers_work && bio_barrier(bio))) {
           if (rw == WRITE)
--- 761,785 ----
        * if barriers work.
        */

!     diska = diskb = end = start = 0;
!     if(IOPRIO_PRIO_CLASS(current->ioprio) == IOPRIO_CLASS_RT)
!     {
!         static int count;
!         static unsigned long lastmw;
!
!         if(lastmw == 0)
!             lastmw = jiffies;
!         start = jiffies;
!         if((count++ > 40) || ((jiffies - lastmw) > (HZ*10)))
!         {
!             md_write_start(mddev, bio); /* wait on superblock update 
early */
!             count = 0;
!             lastmw = jiffies;
!         }
!     }
!     else
!         md_write_start(mddev, bio); /* wait on superblock update early */
!     sbsync = jiffies;

       if (unlikely(!mddev->barriers_work && bio_barrier(bio))) {
           if (rw == WRITE)
***************
*** 920,925 ****
--- 939,948 ----
           generic_make_request(bio);
   #endif

+     end = jiffies;
+     //if(start != 0)
+         //printk("Raid1 make_request sbsync %ld, total 
%ld\n",sbsync-start,end-start);
+
       return 0;
   }



