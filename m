From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 robust read and read/write correct patch
Date: Wed, 23 Feb 2005 12:50:49 +0100
Message-ID: <p97ue2-1ld.ln1@news.it.uc3m.es>
References: <421C628D.8080908@getsu.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

J. David Beutel <jdb@getsu.com> wrote:
> I'd like to try this patch 
> http://marc.theaimsgroup.com/?l=linux-raid&m=110704868115609&w=2 with 
> EVMS BBR.
> 
> Has anyone tried it on 2.6.10 (with FC2 1.9 and EVMS patches)?  Has 
> anyone tried the rewrite part at all?  I don't know md or the kernel or 
> this patch, but the following lines of the patch seem suspicious to me.  
> Should it set R1BIO_ReadRewrite instead?  That bit gets tested later, 
> whereas it seems like R1BIO_ReadRetry is never tested and 
> R1BIO_ReadRewrite is never set.
> 
> +#ifdef DO_ADD_READ_WRITE_CORRECT
> +               else    /* tell next time we're here that we're a retry */
> +                       set_bit(R1BIO_ReadRetry, &r1_bio->state);
> +#endif /* DO_ADD_READ_WRITE_CORRECT */

Quite possibly - I never tested the rewrite part of the patch, just
wrote it to indicate how it should go and stuck it in to encourage
others to go on from there.  It's disabled by default.  You almost
certainly don't want to enable it unless you are a developer (or a
guinea pig :).

As I recall I set a new flag (don't remember offhand what it is called)
to help the code understand that it is dealing with a retry, which in
turn helps the patch be more modular and not introduce extra program
state.

Let me look ...

Yes, the only flag added for the write correction stuff was this in raid1.h:

+#ifdef DO_ADD_READ_WRITE_CORRECT
+#define R1BIO_ReadRewrite  7
+#endif /* DO_ADD_READ_WRITE_CORRECT */

So hmmmmmmm. Let me look at what the "hidden" (disabled, whatever) part
of the patch does. It's a patch entirely to raid1.c (plus one bit
definition in raid1.h).

The first part of the patch is the couple of lines you noted above,
which simply mark the master bio to say that we have had a failure
on read here that would normally cause a disk expulsion, and we haven't
done it. Those lines are harmless in themselves (out of context). They
are in raid1_end_read_request() and the (mirrored) request in question
has just failed to read on its target device.

The second part of the patch is lower down in the same function and
will not be activated in the situation that the previous hunk was
activated. The hunk says:

#ifdef DO_ADD_READ_WRITE_CORRECT
                if (uptodate && test_bit(R1BIO_ReadRewrite, &r1_bio->state)) {
                        /* Success at last - rewrite failed reads */
                        set_bit(R1BIO_IsSync, &r1_bio->state);
                        reschedule_retry(r1_bio);
                } else
#endif /* DO_ADD_READ_WRITE_CORRECT */


(the "uptdate" guarantees that we're not in the same invocation as
before if we get here, because the previous hunk was active only in the
!uptodate case). I believe therefore that a previous failed
read retried on another target and we are now in the retry, which has
succeeded. I therefore believe that we should be testing the same bit
as we set before. The R1BIO_ReadRetry bit is not tested anywhere else -
I  believe it should be tested now. That will tell us that this is a
retry and we want to try and start a write based on our successful
read, hoping that the write will mend whatever has gone wrong on the
disk.

So yes, the patch in the second hunk should read


#ifdef DO_ADD_READ_WRITE_CORRECT
                if (uptodate && test_bit(R1BIO_ReadRetry, &r1_bio->state)) {
                        /* Success at last - rewrite failed reads */
                        set_bit(R1BIO_IsSync, &r1_bio->state);
                        reschedule_retry(r1_bio);
                } else
#endif /* DO_ADD_READ_WRITE_CORRECT */

I clearly wasn't concentrating on the name of the bit. I was more
worried about the mechanism that might trigger a rewrite attempt
(sufficiently worried not to test it myself!). The idea is that
we launch reschedule_retry() which should put the request on a queue to
be dealt with by the raid1d daemon thread.

This thread normally handles resyncs, but it'll do its read-then-write
trick given half a chance. By setting the IsSync bit we make it think
that the read has already been done (well, it has!), and that it's time
to send out a write based on it to all mirrors. I expect that the
completed read will have signalled all the interested kernel buffers
that the data is available. I am unsure if I need to increment a
reference counter on those buffers to stop them vanishing while we are
doing a write from them in raid1d.

That appears to be the whole patch!

Peter

