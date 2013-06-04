From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: BUG - raid 1 deadlock on handle_read_error / wait_barrier
Date: Tue, 4 Jun 2013 12:52:02 +0300
Message-ID: <CAGRgLy7-mS_KoqJCnDsTRWj=GfSSaf12_q4z8C2LrQuaF3pX_w@mail.gmail.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
	<alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
	<CAGRgLy45byT7fxLBOqU6ZNjpOL0Xmq6nNsiwJSCTq+kd1Ya7Jg@mail.gmail.com>
	<20130520171753.002f07d9@notabene.brown>
	<CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
	<CAGRgLy4zTwopPS-cVwT1RKBr8pE7f3n-X3YLyFpktooQtTYGuQ@mail.gmail.com>
	<20130604114924.37e4573c@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=bcaec54857e87e3a3704de5108aa
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130604114924.37e4573c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, yair@zadarastorage.com
List-Id: linux-raid.ids

--bcaec54857e87e3a3704de5108aa
Content-Type: text/plain; charset=ISO-8859-1

Hello Neil,
thanks for your response.

On Tue, Jun 4, 2013 at 4:49 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 2 Jun 2013 15:43:41 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hello Neil,
>> I believe I have found what is causing the deadlock. It happens in two flavors:
>>
>> 1)
>> # raid1d() is called, and conf->pending_bio_list is non-empty at this point
>> # raid1d() calls md_check_recovery(), which eventually calls
>> raid1_add_disk(), which calls raise_barrier()
>> # Now raise_barrier will wait for conf->nr_pending to become 0, but it
>> cannot become 0, because there are bios sitting in
>> conf->pending_bio_list, which nobody will flush, because raid1d is the
>> one supposed to call flush_pending_writes(), either directly or via
>> handle_read_error. But it is stuck in raise_barrier.
>>
>> 2)
>> # raid1_add_disk() calls raise_barrier(), and waits for
>> conf->nr_pending to become 0, as before
>> # new WRITE comes and calls wait_barrier(), but this thread has a
>> non-empty current->bio_list
>> # In this case, the code allows the WRITE to go through
>> wait_barrier(), and trigger WRITEs to mirror legs, but these WRITEs
>> again end up in conf->pending_bio_list (either via raid1_unplug or
>> directly). But nobody will flush conf->pending_bio_list, because
>> raid1d is stuck in raise_barrier.
>>
>> Previously, for example in kernel 3.2, raid1_add_disk did not call
>> raise_barrier, so this problem did not happen.
>>
>> Attached is a reproduction with some prints that I added to
>> raise_barrier and wait_barrier (their code also attached). It
>> demonstrates case 2. It shows that once raise_barrier got called,
>> conf->nr_pending drops down, until it equals the number of
>> wait_barrier calls, that slipped through because of non-empty
>> current->bio_list. And at this point, this array hangs.
>>
>> Can you please comment on how to fix this problem. It looks like a
>> real deadlock.
>> We can perhaps call md_check_recovery() after flush_pending_writes(),
>> but this only makes the window smaller, not closes it entirely. But it
>> looks like we really should not be calling raise_barrier from raid1d.
>>
>> Thanks,
>> Alex.
>
> Hi Alex,
>  thanks for the analysis.
>
> Does the following patch fix it?  It makes raise_barrier  more  like
> freeze_array().
> If not, could you try making the same change to the first
> wait_event_lock_irq in raise_barrier?
>
> Thanks.
> NeilBrown
>
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 328fa2d..d34f892 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -828,9 +828,9 @@ static void raise_barrier(struct r1conf *conf)
>         conf->barrier++;
>
>         /* Now wait for all pending IO to complete */
> -       wait_event_lock_irq(conf->wait_barrier,
> -                           !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
> -                           conf->resync_lock);
> +       wait_event_lock_irq_cmd(conf->wait_barrier,
> +                               !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
> +                               conf->resync_lock, flush_pending_writes(conf));
>
>         spin_unlock_irq(&conf->resync_lock);
>  }

Yes, this patch fixes the problem, thanks! Actually, yesterday, I
attempted a similar fix[1] and it also seemed to work.
I have several comments about this patch:

# It fully fixes case 1, and almost fully closes the race window for
case 2. I attach a reproduction, in which it can be seen, that while
raise_barrier is waiting, new bios slip through wait_barrier (because
of non-empty current->bio_list), and raise_barrier is awaken more than
once to flush them. Eventually it takes 2 seconds for raise_barrier to
complete. This is still much better than sleeping forever though:)

# We are now calling flush_pending_writes() while mddev_lock() is
locked. It doesn't seem problematic to call generic_make_request()
under this lock, but flush_pending_writes() also does bitmap_unplug(),
which may wait for superblock update etc. Is this ok? I found one or
two other places, where we wait for superblock update under mddev_lock
(ADD_NEW_DISK, for example), so it's probably ok?

# I am concerned that raise_barrier is also called from sync_request,
so it may also attempt to flush_pending_writes. Can we make a more
conservative patch, like this:
        /* Now wait for all pending IO to complete */
-       wait_event_lock_irq(conf->wait_barrier,
-                           !conf->nr_pending && conf->barrier < RESYNC_DEPTH,
-                           conf->resync_lock);
+       if (conf->mddev->thread && conf->mddev->thread->tsk == current) {
+               /*
+                * If we are called from the management thread (raid1d), we
+                * need to flush the bios that might be sitting in
conf->pending_bio_list,
+                * otherwise, we will wait for them here forever
+                */
+               wait_event_lock_irq_cmd(conf->wait_barrier,
+                                       !conf->nr_pending &&
conf->barrier < RESYNC_DEPTH,
+                                       conf->resync_lock,
flush_pending_writes(conf));
+       } else {
+               wait_event_lock_irq(conf->wait_barrier,
+                                   !conf->nr_pending && conf->barrier
< RESYNC_DEPTH,
+                                   conf->resync_lock);
+       }
+

        spin_unlock_irq(&conf->resync_lock);

Thanks again. I will work & reply on other issues I mentioned, for
some of them I already made patches.
Alex.


[1]
 	/* block any new IO from starting */
 	conf->barrier++;

+	/* if we are raising the barrier while inside raid1d (which we
really shouldn't)... */
+	if (conf->mddev->thread && conf->mddev->thread->tsk == current) {
+		while (!(!conf->nr_pending && conf->barrier < RESYNC_DEPTH)) {
+			int nr_pending = conf->nr_pending;
+
+			spin_unlock_irq(&conf->resync_lock);
+
+			if (nr_pending)
+				flush_pending_writes(conf);
+			wait_event_timeout(conf->wait_barrier,
+				!conf->nr_pending && conf->barrier < RESYNC_DEPTH,
+				msecs_to_jiffies(100));
+
+			spin_lock_irq(&conf->resync_lock);
+		}
+
+		spin_unlock_irq(&conf->resync_lock);
+
+		return;
+	}
 	/* Now wait for all pending IO to complete */
 	wait_event_lock_irq(conf->wait_barrier,
 			    !conf->nr_pending && conf->barrier < RESYNC_DEPTH,

--bcaec54857e87e3a3704de5108aa
Content-Type: application/x-gzip; name="repro.tgz"
Content-Disposition: attachment; filename="repro.tgz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhiwq5ox1

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
--bcaec54857e87e3a3704de5108aa--
