From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Mon, 22 May 2017 16:30:27 +0100
Message-ID: <87o9ukykmk.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a865jf9a.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 22 May 2017 21:35:29 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[linux-bcache removed, not a bcache bug]

On 22 May 2017, NeilBrown said this:

> Congratulations.  You have found a bug that dates from 2011.

Oh so not that old then! (My personal record, in a previous job, was a
bug in allegedly critical functionality that entirely stopped it working
and had been broken for around fourteen years. Like hell it was
critical.)

> Commit: 68866e425be2 ("MD: no sync IO while suspended")
>
> (I think).
>
> A write request gets to raid5_make_request() before mddev_suspend() sets
> mddev->suspended.
> raid5_make_request() needs md_write_start() to mark the array "dirty"
> which it asks the md thread to do, but before the thread gets to the
> task, mddev->suspend has been set, so md_check_recovery() doesn't update
> the superblock, so md_write_start() doesn't proceed, so the request
> never completes, so mddev_suspend() blocks indefinitely.

Ooof. Looks like it's fsync()ing something -- not sure what, though.
The previous time it was a metadata update...

Hm. I note that ->events is meant to be for things like device additions
and array starts. RAID5 -> RAID6 reshaping appears to push this up a
lot:

         Events : 1475948

(it was at around 4000 before this -- itself rather mystifying, given
that I've only rebooted this machine 27 times, and the array's probably
been assembled less than 20 times, and was created with the same number
of devices it has now.)

The other array has only 92 events (it was at 30-something before I
tried this reshape).

> I think that md_check_recovery() need to test for mddev->suspended
> somewhere else.
> It needs to allow superblock updates, and probably needs to reap the
> recovery thread, but must not start a new recovery thread.

My question would be, is all the intricate stuff md_check_recovery() is
doing valid on an mddev that's not only suspended but detached? Because
we detach right after the suspension in level_store()...

(btw, you probably want to remove the comment above enum array_state
that says that "suspended" is "not supported yet", too.)

> Probably something like this:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d67bcd0..dbca31be22a1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8364,8 +8364,6 @@ static void md_start_sync(struct work_struct *ws)
>   */
>  void md_check_recovery(struct mddev *mddev)
>  {
> -	if (mddev->suspended)
> -		return;
>  
>  	if (mddev->bitmap)
>  		bitmap_daemon_work(mddev);
> @@ -8484,6 +8482,7 @@ void md_check_recovery(struct mddev *mddev)
>  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>  
>  		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +		    mddev->suspended ||
>  		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>  			goto not_running;
>  		/* no recovery is running.
>
> though it's late so don't trust anything I write.

This may end up clearing MD_RECOVERY_INTR and MD_RECOVERY_DONE, but I
guess in this context it's safe to do so... looks OK otherwise to the
totally ignorant fool reading this patch!

Hm, being picky now, md_check_recovery() might be slightly easier to
read if that governing mutex_trylock() conditional was inverted:

	if (mddev_trylock(mddev))
		return;

Then you could de-indent most of the function by one indentation
level...

> If you try again it will almost certainly succeed.  I suspect this is a
> hard race to hit - well done!!!

I'll give it a try -- I hit it twice in succession, once with a
--backup-file, once without. Since mdadm does not warn about the lack of
a --backup-file, I guess the statement in the manual that it is
essential to provide one when changing RAID levels is untrue: I suspect
that it's necessary *if* you're not increasing the number of disks at
the same time, but since I'm growing into a spare, adding a
--backup-file only slows it down?

I might run a backup first though. :)
