From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Mon, 27 Jul 2015 10:07:37 +0200
Message-ID: <CAGRgLy5rE6Yuhcw2jA+4ymv5U489vX_NvSpNAuy0OPbcKnatFA@mail.gmail.com>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
	<CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
	<20140918110523.3ee5c064@notabene.brown>
	<CAGRgLy7+bN8ztaaN+oh6uATE7=Z=8LnU=R0m2CnVff4ZqgJFKg@mail.gmail.com>
	<20140922101704.53be2056@notabene.brown>
	<CAGRgLy5DsbiPsjJ2ZK_aOZ_UOqxa-zwbdDREv7hdpt7vLXCwOw@mail.gmail.com>
	<20150724092404.66dc284d@noble>
	<CAGRgLy7qkyQquRDGCShjJsuREQXNN+WaNGaq5wK2psMLQ6BGtw@mail.gmail.com>
	<20150727115653.530daba6@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150727115653.530daba6@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
Thanks for the comments. Hopefully now we have the complete fix.
I am posting what we have applied on top of 3.8.13 (now we are moving
to 3.18.19, which already has part of the fix, so I will need to apply
a delta, until both your latest patches reach Mr. Stable). Locking the
spinlock in "error" function is not there (but I will apply it to
3.18.19).

Below patch is a bit ugly:
- CONFIG_MD_ZADARA is a define that we add, so that every engineer can
clearly distinguish our changes vs the original code. I know it's
ugly.
- zklog is a macro that eventually ends up in printk. This is only to
have a bit more prints, and is not functionally needed. zklog also
prints current->pid, function name etc, to have more context.

Hopefully, gmail will not make the patch even uglier.

Thanks for your help!
Alex.


diff --git a/md/3.8.13-030813-generic/drivers/md/raid1.c
b/md/3.8.13-030813-generic/drivers/md/raid1.c
index c864a6e..32170e9 100644
--- a/md/3.8.13-030813-generic/drivers/md/raid1.c
+++ b/md/3.8.13-030813-generic/drivers/md/raid1.c
@@ -322,24 +322,36 @@ static void raid1_end_read_request(struct bio
*bio, int error)

     if (uptodate)
         set_bit(R1BIO_Uptodate, &r1_bio->state);
     else {
         /* If all other devices have failed, we want to return
          * the error upwards rather than fail the last device.
          * Here we redefine "uptodate" to mean "Don't want to retry"
          */
         unsigned long flags;
         spin_lock_irqsave(&conf->device_lock, flags);
+#ifndef CONFIG_MD_ZADARA
         if (r1_bio->mddev->degraded == conf->raid_disks ||
             (r1_bio->mddev->degraded == conf->raid_disks-1 &&
              !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
             uptodate = 1;
+#else/*CONFIG_MD_ZADARA*/
+        /* Make sure we retry read error from a recovering device */
+        if (r1_bio->mddev->degraded == conf->raid_disks ||
+            (r1_bio->mddev->degraded == conf->raid_disks-1 &&
+             test_bit(In_sync, &conf->mirrors[mirror].rdev->flags))) {
+            char b[BDEVNAME_SIZE];
+            zklog_rl(mdname(conf->mddev), Z_KERR, "READ
rdev=%s[%llu:%u] ERROR - not retrying (last good drive)",
+                     bdevname(conf->mirrors[mirror].rdev->bdev, b),
(unsigned long long)r1_bio->sector, r1_bio->sectors);
+            uptodate = 1;
+        }
+#endif/*CONFIG_MD_ZADARA*/
         spin_unlock_irqrestore(&conf->device_lock, flags);
     }

     if (uptodate) {
         raid_end_bio_io(r1_bio);
         rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
     } else {
         /*
          * oops, read error:
          */
@@ -1418,20 +1430,31 @@ static void status(struct seq_file *seq,
struct mddev *mddev)
     rcu_read_unlock();
     seq_printf(seq, "]");
 }


 static void error(struct mddev *mddev, struct md_rdev *rdev)
 {
     char b[BDEVNAME_SIZE];
     struct r1conf *conf = mddev->private;

+#ifdef CONFIG_MD_ZADARA
+    {
+        static DEFINE_RATELIMIT_STATE(_rs,
DEFAULT_RATELIMIT_INTERVAL, DEFAULT_RATELIMIT_BURST);
+        if (__ratelimit(&_rs)) {
+            zklog(mdname(mddev), Z_KERR, "rdev=%s failure InSync=%u
Failed=%u STACK:",
+                  bdevname(rdev->bdev, b), test_bit(In_sync,
&rdev->flags), test_bit(Faulty, &rdev->flags));
+            dump_stack();
+        }
+    }
+#endif/*CONFIG_MD_ZADARA*/
+
     /*
      * If it is not operational, then we have already marked it as dead
      * else if it is the last working disks, ignore the error, let the
      * next level up know.
      * else mark the drive as failed
      */
     if (test_bit(In_sync, &rdev->flags)
         && (conf->raid_disks - mddev->degraded) == 1) {
         /*
          * Don't fail the drive, act as though we were just a
@@ -1497,20 +1520,25 @@ static void close_sync(struct r1conf *conf)
     conf->r1buf_pool = NULL;
 }

 static int raid1_spare_active(struct mddev *mddev)
 {
     int i;
     struct r1conf *conf = mddev->private;
     int count = 0;
     unsigned long flags;

+#ifdef CONFIG_MD_ZADARA
+    /* we lock the whole function */
+    spin_lock_irqsave(&conf->device_lock, flags);
+#endif /*CONFIG_MD_ZADARA*/
+
     /*
      * Find all failed disks within the RAID1 configuration
      * and mark them readable.
      * Called under mddev lock, so rcu protection not needed.
      */
     for (i = 0; i < conf->raid_disks; i++) {
         struct md_rdev *rdev = conf->mirrors[i].rdev;
         struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
         if (repl
             && repl->recovery_offset == MaxSector
@@ -1530,21 +1558,24 @@ static int raid1_spare_active(struct mddev *mddev)
                     rdev->sysfs_state);
             }
         }
         if (rdev
             && !test_bit(Faulty, &rdev->flags)
             && !test_and_set_bit(In_sync, &rdev->flags)) {
             count++;
             sysfs_notify_dirent_safe(rdev->sysfs_state);
         }
     }
+#ifndef CONFIG_MD_ZADARA
+    /* we lock the whole function */
     spin_lock_irqsave(&conf->device_lock, flags);
+#endif /*CONFIG_MD_ZADARA*/
     mddev->degraded -= count;
     spin_unlock_irqrestore(&conf->device_lock, flags);

     print_conf(conf);
     return count;
 }


 static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 {
@@ -2027,20 +2058,27 @@ static void sync_request_write(struct mddev
*mddev, struct r1bio *r1_bio)
  *
  *    1.    Retries failed read operations on working mirrors.
  *    2.    Updates the raid superblock when problems encounter.
  *    3.    Performs writes following reads for array synchronising.
  */

 static void fix_read_error(struct r1conf *conf, int read_disk,
                sector_t sect, int sectors)
 {
     struct mddev *mddev = conf->mddev;
+#ifdef CONFIG_MD_ZADARA
+    {
+        char b[BDEVNAME_SIZE] = {'\0'};
+        zklog_rl(mdname(mddev), Z_KWARN, "attempting to fix READ
rdev=%s[%llu:%u]",
+                 bdevname(conf->mirrors[read_disk].rdev->bdev, b),
(unsigned long long)sect, sectors);
+    }
+#endif /*CONFIG_MD_ZADARA*/
     while(sectors) {
         int s = sectors;
         int d = read_disk;
         int success = 0;
         int start;
         struct md_rdev *rdev;

         if (s > (PAGE_SIZE>>9))
             s = PAGE_SIZE >> 9;

@@ -2078,33 +2116,41 @@ static void fix_read_error(struct r1conf
*conf, int read_disk,
             break;
         }
         /* write it back and re-read */
         start = d;
         while (d != read_disk) {
             if (d==0)
                 d = conf->raid_disks * 2;
             d--;
             rdev = conf->mirrors[d].rdev;
             if (rdev &&
+#ifndef CONFIG_MD_ZADARA
                 test_bit(In_sync, &rdev->flags))
+#else /*CONFIG_MD_ZADARA*/
+                !test_bit(Faulty, &rdev->flags))
+#endif /*CONFIG_MD_ZADARA*/
                 r1_sync_page_io(rdev, sect, s,
                         conf->tmppage, WRITE);
         }
         d = start;
         while (d != read_disk) {
             char b[BDEVNAME_SIZE];
             if (d==0)
                 d = conf->raid_disks * 2;
             d--;
             rdev = conf->mirrors[d].rdev;
             if (rdev &&
+#ifndef CONFIG_MD_ZADARA
                 test_bit(In_sync, &rdev->flags)) {
+#else /*CONFIG_MD_ZADARA*/
+                !test_bit(Faulty, &rdev->flags)) {
+#endif /*CONFIG_MD_ZADARA*/
                 if (r1_sync_page_io(rdev, sect, s,
                             conf->tmppage, READ)) {
                     atomic_add(s, &rdev->corrected_errors);
                     printk(KERN_INFO
                            "md/raid1:%s: read error corrected "
                            "(%d sectors at %llu on %s)\n",
                            mdname(mddev), s,
                            (unsigned long long)(sect +
                                rdev->data_offset),
                            bdevname(rdev->bdev, b));



On Mon, Jul 27, 2015 at 3:56 AM, NeilBrown <neilb@suse.com> wrote:
> On Sun, 26 Jul 2015 10:15:05 +0200 Alexander Lyakas
> <alex.bolshoy@gmail.com> wrote:
>
>> Hi Neil,
>>
>> On Fri, Jul 24, 2015 at 1:24 AM, NeilBrown <neilb@suse.com> wrote:
>> > Hi Alex
>> > thanks for noticing!
>> > Just to be sure we mean the same thing: this is the patch which is
>> > missing - correct?
>> >
>> > Thanks,
>> > NeilBrown
>> >
>> > From: NeilBrown <neilb@suse.com>
>> > Date: Fri, 24 Jul 2015 09:22:16 +1000
>> > Subject: [PATCH] md/raid1: fix test for 'was read error from last working
>> >  device'.
>> >
>> > When we get a read error from the last working device, we don't
>> > try to repair it, and don't fail the device.  We simple report a
>> > read error to the caller.
>> >
>> > However the current test for 'is this the last working device' is
>> > wrong.
>> > When there is only one fully working device, it assumes that a
>> > non-faulty device is that device.  However a spare which is rebuilding
>> > would be non-faulty but so not the only working device.
>> >
>> > So change the test from "!Faulty" to "In_sync".  If ->degraded says
>> > there is only one fully working device and this device is in_sync,
>> > this must be the one.
>> >
>> > This bug has existed since we allowed read_balance to read from
>> > a recovering spare in v3.0
>> >
>> > Reported-and-tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
>> > Fixes: 76073054c95b ("md/raid1: clean up read_balance.")
>> > Cc: stable@vger.kernel.org (v3.0+)
>> > Signed-off-by: NeilBrown <neilb@suse.com>
>> >
>> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> > index 166616411215..b368307a9651 100644
>> > --- a/drivers/md/raid1.c
>> > +++ b/drivers/md/raid1.c
>> > @@ -336,7 +336,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
>> >                 spin_lock_irqsave(&conf->device_lock, flags);
>> >                 if (r1_bio->mddev->degraded == conf->raid_disks ||
>> >                     (r1_bio->mddev->degraded == conf->raid_disks-1 &&
>> > -                    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
>> > +                    test_bit(In_sync, &conf->mirrors[mirror].rdev->flags)))
>> >                         uptodate = 1;
>> >                 spin_unlock_irqrestore(&conf->device_lock, flags);
>> >         }
>>
>> Yes, this was the missing piece.
>>
>> But you also advised to put the whole of "raid1_spare_active" under
>> the spinlock:
>> > 2/ extend the spinlock in raid1_spare_active to cover the whole function.
>> So we did this bit too. Can you pls comment if this is needed?
>
> When you say "we did this bit" it would help a lot to actually show the
> patch - helps avoid misunderstanding.  In fact I was probably hoping
> that you would post a patch once you had it fixed.... no mater.
> See below for that patch I have just queue.  There is an extra place
> were a spinlock is probably helpful.
>
>>
>> Also, will you be sending this patch to "stable"? We are moving to
>> kernel 3.18, so we should get this then.
>
> Putting "cc: stable@vger.kernel.org" means that it will automatically
> migrated to the stable kernels once it has appeared in Linus' kernel.
> So yes: it will go to -stable
>
>>
>> Thanks!
>> Alex.
>
> Thanks,
> NeilBrown
>
> From 04f58ef505b9d354dd06c477a94a7e314a38cb72 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.com>
> Date: Mon, 27 Jul 2015 11:48:52 +1000
> Subject: [PATCH] md/raid1: extend spinlock to protect raid1_end_read_request
>  against inconsistencies
>
> raid1_end_read_request() assumes that the In_sync bits are consistent
> with the ->degaded count.
> raid1_spare_active updates the In_sync bit before the ->degraded count
> and so exposes an inconsistency, as does error()
> So extend the spinlock in raid1_spare_active() and error() to hide those
> inconsistencies.
>
> This should probably be part of
>   Commit: 34cab6f42003 ("md/raid1: fix test for 'was read error from
>   last working device'.")
> as it addresses the same issue.  It fixes the same bug and should go
> to -stable for same reasons.
>
> Fixes: 76073054c95b ("md/raid1: clean up read_balance.")
> Cc: stable@vger.kernel.org (v3.0+)
> Signed-off-by: NeilBrown <neilb@suse.com>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index b368307a9651..742b50794dfd 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1476,6 +1476,7 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
>  {
>         char b[BDEVNAME_SIZE];
>         struct r1conf *conf = mddev->private;
> +       unsigned long flags;
>
>         /*
>          * If it is not operational, then we have already marked it as dead
> @@ -1495,14 +1496,13 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
>                 return;
>         }
>         set_bit(Blocked, &rdev->flags);
> +       spin_lock_irqsave(&conf->device_lock, flags);
>         if (test_and_clear_bit(In_sync, &rdev->flags)) {
> -               unsigned long flags;
> -               spin_lock_irqsave(&conf->device_lock, flags);
>                 mddev->degraded++;
>                 set_bit(Faulty, &rdev->flags);
> -               spin_unlock_irqrestore(&conf->device_lock, flags);
>         } else
>                 set_bit(Faulty, &rdev->flags);
> +       spin_unlock_irqrestore(&conf->device_lock, flags);
>         /*
>          * if recovery is running, make sure it aborts.
>          */
> @@ -1568,7 +1568,10 @@ static int raid1_spare_active(struct mddev *mddev)
>          * Find all failed disks within the RAID1 configuration
>          * and mark them readable.
>          * Called under mddev lock, so rcu protection not needed.
> +        * device_lock used to avoid races with raid1_end_read_request
> +        * which expects 'In_sync' flags and ->degraded to be consistent.
>          */
> +       spin_lock_irqsave(&conf->device_lock, flags);
>         for (i = 0; i < conf->raid_disks; i++) {
>                 struct md_rdev *rdev = conf->mirrors[i].rdev;
>                 struct md_rdev *repl = conf->mirrors[conf->raid_disks + i].rdev;
> @@ -1599,7 +1602,6 @@ static int raid1_spare_active(struct mddev *mddev)
>                         sysfs_notify_dirent_safe(rdev->sysfs_state);
>                 }
>         }
> -       spin_lock_irqsave(&conf->device_lock, flags);
>         mddev->degraded -= count;
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>
