From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 19:37:44 +0100
Message-ID: <okuab2-u4c.ln1@news.it.uc3m.es>
References: <41E17117.2090500@tls.msk.ru> <200501092028.j09KSr918180@www.watkins-home.com> <jsh8b2-5g6.ln1@news.it.uc3m.es> <jsm9b2-iqp.ln1@news.it.uc3m.es> <i69ab2-onm.ln1@news.it.uc3m.es> <p0cab2-s27.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > Hmm ...  I must be crackers at 7.39 in the morning.  Surely if the bio
> 
> Perhaps this is more obviously correct (or less obviously incorrect).

So I'll do the commentary for it now. The last hunk of this three hunk
patch is the easiest to explain:


> --- linux-2.6.3/drivers/md/raid1.c.orig Tue Dec 28 00:39:01 2004
> +++ linux-2.6.3/drivers/md/raid1.c      Mon Jan 10 14:05:46 2005
> @@ -708,6 +720,18 @@
>                 read_bio->bi_end_io = raid1_end_request;
>                 read_bio->bi_rw = r1_bio->cmd;
>                 read_bio->bi_private = r1_bio;
> +#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
> +               atomic_set(&r1_bio->remaining, 0);
> +               /* count source devices under spinlock */
> +               spin_lock_irq(&conf->device_lock);
> +               for (i = 0;  i < disks; i++) {
> +                       if (conf->mirrors[i].rdev &&
> +                       !conf->mirrors[i].rdev->faulty) {
> +                               atomic_inc(&r1_bio->remaining);
> +                       } 
> +               }
> +               spin_unlock_irq(&conf->device_lock);
> +#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
>  
>                 generic_make_request(read_bio);
>                 return 0;
>

That simply adds to the raid1 make_request code in the READ branch
the same stanza that appears in the WRITE branch already, namely a
calculation of how many working disks there are in the array, which
is put into the "remaining" field of the raid1 master bio being
set up.

So we put the count of valid disks in the "remaining" field during
construction of a raid1 read bio.

If I am off by one, I apologize.  The write size code starts the count
at 1 instead of 0, and I don't know why. 

If anyone wants to see the WRITE side equivalent, it goes:


        for (i = 0;  i < disks; i++) {
                if (conf->mirrors[i].rdev &&
                    !conf->mirrors[i].rdev->faulty) {
                        ...
                        r1_bio->write_bios[i] = bio;
                } else
                        r1_bio->write_bios[i] = NULL;
        }

        atomic_set(&r1_bio->remaining, 1);

        for (i = 0; i < disks; i++) {
                if (!r1_bio->write_bios[i])
                        continue;
                ...
                atomic_inc(&r1_bio->remaining);
                generic_make_request(mbio);
        }

so I reckon that's equivalent, apart from the off-by-one. Explain me
somebody.


In the end_request code, simply, instead of erroring
the current disk out of the array whenever an error happens, do it
only if a WRITE is being handled. We still won't mark the request
uptodate as that's in the else part of the if !uptodate, where we don't
touch. That's the first hunk here.

The second hunk is in the same routine, but down in the READ side of
the code split, further on.  We finish the request not only if we are
utodate (success), but also if we are not uptodate but we are plain out
of disks to try and read from (so the request will be errored since it
is not marked yuptodate still).  We decrement the "remaining" count in
the test.


> @@ -354,9 +354,15 @@
>         /*
>          * this branch is our 'one mirror IO has finished' event handler:
>          */
> -       if (!uptodate)
> -               md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> -       else
> +       if (!uptodate) {
> +#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
> +                /*
> +                 * Only fault disk out of array on write error, not read.
> +                 */
> +                if (r1_bio->cmd == WRITE)
> +#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
> +                       md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> +        } else
>                 /*
>                  * Set R1BIO_Uptodate in our master bio, so that
>                  * we will return a good error code for to the higher
> @@ -375,7 +381,12 @@
>                 /*
>                  * we have only one bio on the read side
>                  */
> -               if (uptodate)
> +               if (uptodate
> +#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
> +                        /* Give up and error if we're last */
> +                        || atomic_dec_and_test(&r1_bio->remaining)
> +#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
> +                        )
>                         raid_end_bio_io(r1_bio);
>                 else {
>                         /*
 

Peter

