From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: "Robust Read"
Date: Sat, 19 Mar 2005 18:03:12 +0100
Message-ID: <gj2ug2-9q3.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru> <vvjtg2-t16.ln1@news.it.uc3m.es> <423C4E62.4070704@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> [-- text/plain, encoding 7bit, charset: KOI8-R, 74 lines --]
> 
> Peter T. Breuer wrote:
> []
> > The patch was originally developed for 2.4, then ported to 2.6.3, and
> > then to 2.6.8.1. Neil has recently been doing stuff, so I don't
> > think it applies cleanly to 2.6.10, but somebody WAS porting it for me
> > until they found that 2.6.10 didn't support their hardware ... and I
> > recall discussing with him what to do about the change of map() to
> > read_balance() in the code (essentially, put map() back). And finding
> > that the spinlocks have changed too.
> 
> Well, it turns out current code is easier to modify, including spinlocks.
> 
> But now, with read_balance() in place, which can pick a "random" disk
> to read from, we have to keep some sort of bitmap to mark disks which
> we tried to read from.

Yes - what one should do is replace the present call to read_balance()
(in the place where map() used to be) with the old call to map()
instead, and add in the patched definition of map().

> For the hack below I've added r1_bio->tried_disk of type unsigned long
> which has one bit per disk, so current scheme is limited to 32 disks
> in array.  This is really a hack for now -- I don't know much about
> kernel programming rules... ;)

Uh OK. As I recall one only needs to count, one doesn't need a bitwise
map of what one has dealt with.

> 
> > @@ -266,9 +368,19 @@
> >       /*
> >        * this branch is our 'one mirror IO has finished' event handler:
> >        */
> > -     if (!uptodate)
> > -             md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> > -     else
> > +     if (!uptodate) {
> > +#ifdef CONFIG_MD_RAID1_ROBUST_READ
> > +             /*
> > +                 * Only fault disk out of array on write error, not read.
> > +                 */
> > +             if (0)
> > +#endif /* CONFIG_MD_RAID1_ROBUST_READ */
> > +                     md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> > +#ifdef DO_ADD_READ_WRITE_CORRECT
> 
> What's this?
> Was it an attempt (incomplete) to do rewrite-after-failed-read?

Yes. I never tried it (not being brave). It is my indication of how to
do it.  Essentially, if we have retried a read, and succeeded on the
retry, now put the done request on the raid1d thread's list, of
syncy-thingies (careful to keep reference counts high), and mark it as
already having done the read half, and let the raid1d thread do a write
with it now.

> 
> > +             else    /* tell next time we're here that we're a retry */
> > +                     set_bit(R1BIO_ReadRetry, &r1_bio->state);
> > +#endif /* DO_ADD_READ_WRITE_CORRECT */

See - if we are planning on writing successfully retried reads, we want
to mark the retries.

> > +        } else

That was all the case when a read fails. We DON'T fault the disk.
Instead we drop through and will retry. A count will save us from doing
it in circles.

> >               /*
> >                * Set R1BIO_Uptodate in our master bio, so that
> >                * we will return a good error code for to the higher
> > @@ -285,8 +397,20 @@
> >       /*
> >        * we have only one bio on the read side
> >        */
> > -     if (uptodate)
> > -             raid_end_bio_io(r1_bio);
> > +     if (uptodate
> > +#ifdef CONFIG_MD_RAID1_ROBUST_READ
> > +                /* Give up and error if we're last */
> > +                || (atomic_dec_and_test(&r1_bio->remaining))
> > +#endif /* CONFIG_MD_RAID1_ROBUST_READ */

Yes, I told you there was a count! If we have already tried reading all
disks, then really really error. Thet "remaining" field was originally
not used in the read request case, but was used in the write request
case, so I co-opted it for reads too. I suppose it will be set when a
read request is made (according to the patch).


> > +                )
> > +#ifdef DO_ADD_READ_WRITE_CORRECT
> > +             if (uptodate && test_bit(R1BIO_ReadRetry, &r1_bio->state)) {
> > +                     /* Success at last - rewrite failed reads */
> > +                        set_bit(R1BIO_IsSync, &r1_bio->state);
> > +                     reschedule_retry(r1_bio);
> > +             } else
> > +#endif /* DO_ADD_READ_WRITE_CORRECT */

Well, if this is really a successful retried read request, then send
the  bio to the raid1d thread for writing everywhere, after first
setting a bit to trick it that it has done the read part of its work.

> > +                     raid_end_bio_io(r1_bio);

Ummmm.

> Hmm.  Should we do actual write here, instead of rescheduling a

Well, the rewrite code is untried, but the logic goes as I outlined
above. We just schedule the write.

> successeful read further, after finishing the original request?

Maybe, maybe not.  I don't know what or if anything crashes.  I don't
THINK the buffers in the i/o will disappear, and I THINK the user has
been advised that the i/o is done, and even if he hasn't been, he will
be shortly when the raid1d thread does its work, so why worry?  Yes,
this might delay, but read errors should be rare anyway.

I'm a little more worried about the end_io.

Apparently we end_io if we're

       uptodate  or  not uptodate and are the last possible read
and    not uptodate or not a retry

Ummm.

   1  not uptodate and are the last possible read
or 2  uptodate and not a retry
or 3  not uptodate and  not a retry and are the last possible read

Well, (1) is correct. We return an error.
      (2) is correct. We return success on first try
      (3) is correct. We only have one disk and we errored, and return error.

But what if we have success and we are not the first try?  Ah ..  I see.
We store the i/o for the raid1d thread and hope it advises the user when
finished. Something tells me that should be thought about.

> 
> /mjt
> 
> [-- text/plain, encoding 7bit, charset: US-ASCII, 103 lines, name: raid1_robust_read-2.6.11.diff --]
> 
> --- ./include/linux/raid/raid1.h.orig   Wed Mar  2 10:38:10 2005
> +++ ./include/linux/raid/raid1.h        Sat Mar 19 18:53:42 2005
> @@ -83,6 +83,7 @@ struct r1bio_s {
>          * if the IO is in READ direction, then this is where we read
>          */
>         int                     read_disk;
> +       unsigned long           tried_disks;    /* bitmap, disks we had tried to read from */


You don't need this because the count is in the "remaining" field. I
hope.


>         struct list_head        retry_list;
>         /*
> --- ./drivers/md/raid1.c.orig   Wed Mar  2 10:38:10 2005
> +++ ./drivers/md/raid1.c        Sat Mar 19 18:57:16 2005
> @@ -234,9 +234,13 @@ static int raid1_end_read_request(struct
>         /*
>          * this branch is our 'one mirror IO has finished' event handler:
>          */
> -       if (!uptodate)
> -               md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> -       else
> +
> +       update_head_pos(mirror, r1_bio);
> +

Oh well, if you say so! I suppose that indeed the heads have moved.

> +       /*
> +        * we have only one bio on the read side
> +        */
> +       if (uptodate) {
>                 /*
>                  * Set R1BIO_Uptodate in our master bio, so that
>                  * we will return a good error code for to the higher
> @@ -247,14 +251,8 @@ static int raid1_end_read_request(struct
>                  * wait for the 'master' bio.
>                  */
>                 set_bit(R1BIO_Uptodate, &r1_bio->state);
> -
> -       update_head_pos(mirror, r1_bio);

Hmm, it came from a bit lower down. I see.

> -
> -       /*
> -        * we have only one bio on the read side
> -        */
> -       if (uptodate)
>                 raid_end_bio_io(r1_bio);
> +       }

So if we are uptodate, we set the state bit and do end_io. Isn't this a
bit early to be doing that? Shouldn't we check first to see if we are a
retried read, and if we are, then try and trigger a write request from
the freshly read buffer? Or are you, like me, not going to be brave
enough to try the write part!

>         else {
>                 /*
>                  * oops, read error:
> @@ -332,6 +330,10 @@ static int raid1_end_write_request(struc
>   *
>   * The rdev for the device selected will have nr_pending incremented.
>   */
> +
> +#define disk_tried_before(r1_bio, disk)        ((r1_bio)->tried_disks & (1<<(disk)))
> +#define mark_disk_tried(r1_bio, disk)  ((r1_bio)->tried_disks |= 1<<(disk))
> +

Well, as I said, you don't have to do this if 

   a) you count using the "remaining" field, and
   b) you use the patched map() function instead of the read_balance()
      function to choose the target disk, and make sure that map()
      always chooses the next (active) disk along from where we are
      now.

Oooh - groovy, I still have the code.

#ifdef CONFIG_MD_RAID1_ROBUST_READ
static int map(mddev_t *mddev, int disk)
{
        conf_t *conf = mddev_to_conf(mddev);
        int i, disks = conf->raid_disks;

        /*
         * Later we do read balancing on the read side
         * now we use the first available disk.
         */

        spin_lock_irq(&conf->device_lock);
        /*
         * Uh, no. Choose the next disk if we can, not the first.
         */
        i = disk + 1;
        if (i >= disks)
                i = 0;
        for (; i < disks; i++) {
                mdk_rdev_t *rdev = conf->mirrors[i].rdev;
                if (rdev && i != disk && rdev->in_sync) {
                        atomic_inc(&rdev->nr_pending);
                        spin_unlock_irq(&conf->device_lock);
                        return i;
                }
        }
        /*
         * If for some reason we found nothing, dropthru and use the
         * old
         * routine.
         */
        for (i = 0; i < disks; i++) {
                mdk_rdev_t *rdev = conf->mirrors[i].rdev;
                if (rdev && rdev->in_sync) {
                        *rdevp = rdev;
                        atomic_inc(&rdev->nr_pending);
                        spin_unlock_irq(&conf->device_lock);
                        return i;
                }
        }
        spin_unlock_irq(&conf->device_lock);

        printk(KERN_ERR "raid1_map(): huh, no more operational devices?\n");
        return -1;
}
#endif /* CONFIG_MD_RAID1_ROBUST_READ */

and then in the raid1d function:

@@ -932,9 +1282,17 @@
                        sync_request_write(mddev, r1_bio);
                        unplug = 1;
                } else {
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+                       int disk = r1_bio->read_disk;
+                       bio = r1_bio->bios[disk];
+                       rdev = conf->mirrors[disk].rdev;
+                       if ((disk=map(mddev, disk)) < 0)
+#else
                        int disk;
                        bio = r1_bio->bios[r1_bio->read_disk];
-                       if ((disk=read_balance(conf, r1_bio)) == -1) {
+                       if ((disk=read_balance(conf, r1_bio)) == -1)
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
+                        {
                                printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
                                       " read error for block %llu\n",
                                       bdevname(bio->bi_bdev,b),


(if I count lines correctly - sorry, I am editing by hand).


>  static int read_balance(conf_t *conf, r1bio_t *r1_bio)
>  {
>         const unsigned long this_sector = r1_bio->sector;
> @@ -351,7 +353,8 @@ static int read_balance(conf_t *conf, r1
>                 new_disk = 0;
>  
>                 while (!conf->mirrors[new_disk].rdev ||
> -                      !conf->mirrors[new_disk].rdev->in_sync) {
> +                      !conf->mirrors[new_disk].rdev->in_sync ||
> +                      disk_tried_before(r1_bio, new_disk)) {

Yes, I don't think you should muck with read_balance at all! It's an
approach, but I don't think it's the right one. We just want to use the
function to change target disks with here.  Why not reinstate the old
"map" function which can do just that? Then no change to read_balancce
is needed. Rename map() to remap() if it sounds better!

>                         new_disk++;
>                         if (new_disk == conf->raid_disks) {
>                                 new_disk = -1;
> @@ -364,7 +367,8 @@ static int read_balance(conf_t *conf, r1
>  
>         /* make sure the disk is operational */
>         while (!conf->mirrors[new_disk].rdev ||
> -              !conf->mirrors[new_disk].rdev->in_sync) {
> +              !conf->mirrors[new_disk].rdev->in_sync ||
> +              disk_tried_before(r1_bio, new_disk)) {

Are you still in read_balance? I guess so. So you get read balance to
skip disks we've already tried. OK - it's an approach.

>                 if (new_disk <= 0)
>                         new_disk = conf->raid_disks;
>                 new_disk--;
> @@ -394,7 +398,8 @@ static int read_balance(conf_t *conf, r1
>                 disk--;
>  
>                 if (!conf->mirrors[disk].rdev ||
> -                   !conf->mirrors[disk].rdev->in_sync)
> +                   !conf->mirrors[disk].rdev->in_sync ||
> +                   disk_tried_before(r1_bio, new_disk))
>                         continue;

Same.

>  
>                 if (!atomic_read(&conf->mirrors[disk].rdev->nr_pending)) {
> @@ -415,6 +420,7 @@ rb_out:
>                 conf->next_seq_sect = this_sector + sectors;
>                 conf->last_used = new_disk;
>                 atomic_inc(&conf->mirrors[new_disk].rdev->nr_pending);
> +               mark_disk_tried(r1_bio, new_disk);

:-). We have gone aways down. Not sure where we are now.



>         }
>         rcu_read_unlock();
>  
> @@ -545,6 +551,7 @@ static int make_request(request_queue_t 
>         r1_bio->sector = bio->bi_sector;
>  
>         r1_bio->state = 0;
> +       r1_bio->tried_disks = 0;

Hmm. Ditto. I suppose we are making the read request here. Yes we are.
I had set the "remaining" count instead.


@@ -570,6 +754,19 @@
                read_bio->bi_end_io = raid1_end_read_request;
                read_bio->bi_rw = READ;
                read_bio->bi_private = r1_bio;
+#ifdef CONFIG_MD_RAID1_ROBUST_READ
+               atomic_set(&r1_bio->remaining, 0);
+               /* count source devices under spinlock */
+               spin_lock_irq(&conf->device_lock);
+               disks = conf->raid_disks;
+               for (i = 0;  i < disks; i++) {
+                       if (conf->mirrors[i].rdev &&
+                       !conf->mirrors[i].rdev->faulty) {
+                               atomic_inc(&r1_bio->remaining);
+                       } 
+               }
+               spin_unlock_irq(&conf->device_lock);
+#endif /* CONFIG_MD_RAID1_ROBUST_READ */
 
                generic_make_request(read_bio);
                return 0;
@@ -589,13 +786,53 @@

but that may need some change - there may even be a count of valid
disks somewhere.



>  
>         if (bio_data_dir(bio) == READ) {
>                 /*

What do you think of my comments above?



