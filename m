From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 13:31:46 +0100
Message-ID: <i69ab2-onm.ln1@news.it.uc3m.es>
References: <41E17117.2090500@tls.msk.ru> <200501092028.j09KSr918180@www.watkins-home.com> <jsh8b2-5g6.ln1@news.it.uc3m.es> <jsm9b2-iqp.ln1@news.it.uc3m.es>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> --- linux-2.6.3/drivers/md/raid1.c.orig Tue Dec 28 00:39:01 2004
> +++ linux-2.6.3/drivers/md/raid1.c      Mon Jan 10 07:39:38 2005
> @@ -354,9 +354,15 @@
>         /*
>          * this branch is our 'one mirror IO has finished' event handler:
>          */
> -       if (!uptodate)
> -               md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> -       else
> +       update_head_pos(mirror, r1_bio);
> +       if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
> +               if (!uptodate
> +#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
> +                        && atomic_dec_and_test(&r1_bio->remaining)
> +#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
> +                        ) { /* PTB remove next line to be much fairer! */
> +                       md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> +                } else

Hmm ...  I must be crackers at 7.39 in the morning.  Surely if the bio
is not uptodate but the read attampt's time is not yet up, we don't want
to tell the master bio that the io was successful (the "else")!  That
should have read "if if", not "if and".  I.e.

-       if (!uptodate)
-               md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-       else
+       update_head_pos(mirror, r1_bio);
+       if ((r1_bio->cmd == READ) || (r1_bio->cmd == READA)) {
+               if (!uptodate) {
+#ifndef DO_NOT_ADD_ROBUST_READ_SUPPORT
+                        if (atomic_dec_and_test(&r1_bio->remaining))
+#endif /* DO_NOT_ADD_ROBUST_READ_SUPPORT */
+                        /* PTB remove next line to be much fairer! */
+                                md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
+                } else

So if the bio is not uptodate we just drop through (after decrementing
the count on the master) into the existing code which checks this
bio uptodateness and sends a retry if it is not good. Yep.

I'll send out another patch later, with rewrite on read fail too. When
I've woken up.

Peter

