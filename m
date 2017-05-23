From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Tue, 23 May 2017 11:07:21 +1000
Message-ID: <874lwcjs8m.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87o9ukykmk.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9ukykmk.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 22 2017, Nix wrote:

> [linux-bcache removed, not a bcache bug]
>
> On 22 May 2017, NeilBrown said this:
>
>> Congratulations.  You have found a bug that dates from 2011.
>
> Oh so not that old then! (My personal record, in a previous job, was a
> bug in allegedly critical functionality that entirely stopped it working
> and had been broken for around fourteen years. Like hell it was
> critical.)
>
>> Commit: 68866e425be2 ("MD: no sync IO while suspended")
>>
>> (I think).
>>
>> A write request gets to raid5_make_request() before mddev_suspend() sets
>> mddev->suspended.
>> raid5_make_request() needs md_write_start() to mark the array "dirty"
>> which it asks the md thread to do, but before the thread gets to the
>> task, mddev->suspend has been set, so md_check_recovery() doesn't update
>> the superblock, so md_write_start() doesn't proceed, so the request
>> never completes, so mddev_suspend() blocks indefinitely.
>
> Ooof. Looks like it's fsync()ing something -- not sure what, though.
> The previous time it was a metadata update...
>
> Hm. I note that ->events is meant to be for things like device additions
> and array starts. RAID5 -> RAID6 reshaping appears to push this up a
> lot:
>
>          Events : 1475948
>
> (it was at around 4000 before this -- itself rather mystifying, given
> that I've only rebooted this machine 27 times, and the array's probably
> been assembled less than 20 times, and was created with the same number
> of devices it has now.)

Originally, Events was for any metadata change, including
  clean <-> dirty
transitions.  This kept waking up spares though, so I change to
change by -1 when changing from dirty to clean, and not bother with
telling the spares.  That was a little problematic too, so no
it always increments except f or dirty->clean transitions where there
are spares.

For a reshape, the reshape is checkpointed quite frequently, and each
checkpoint increases the event counter.

>
> The other array has only 92 events (it was at 30-something before I
> tried this reshape).
>
>> I think that md_check_recovery() need to test for mddev->suspended
>> somewhere else.
>> It needs to allow superblock updates, and probably needs to reap the
>> recovery thread, but must not start a new recovery thread.
>
> My question would be, is all the intricate stuff md_check_recovery() is
> doing valid on an mddev that's not only suspended but detached? Because
> we detach right after the suspension in level_store()...

mddev_detach() kills the thread.  After it completes,
md_check_recovery() cannot possibly run.

However I now see that my patch was insufficient.
mddev_suspend() is called while mddev_lock() is held, and that prevents
md_check_recovery() from writing the superblock, so it can still
deadlock.
This will require more careful analysis.

>
> (btw, you probably want to remove the comment above enum array_state
> that says that "suspended" is "not supported yet", too.)

Yeah.... though it isn't supported by all personalities I think.

>
>> Probably something like this:
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f6ae1d67bcd0..dbca31be22a1 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8364,8 +8364,6 @@ static void md_start_sync(struct work_struct *ws)
>>   */
>>  void md_check_recovery(struct mddev *mddev)
>>  {
>> -	if (mddev->suspended)
>> -		return;
>>=20=20
>>  	if (mddev->bitmap)
>>  		bitmap_daemon_work(mddev);
>> @@ -8484,6 +8482,7 @@ void md_check_recovery(struct mddev *mddev)
>>  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>>=20=20
>>  		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
>> +		    mddev->suspended ||
>>  		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>>  			goto not_running;
>>  		/* no recovery is running.
>>
>> though it's late so don't trust anything I write.
>
> This may end up clearing MD_RECOVERY_INTR and MD_RECOVERY_DONE, but I
> guess in this context it's safe to do so... looks OK otherwise to the
> totally ignorant fool reading this patch!
>
> Hm, being picky now, md_check_recovery() might be slightly easier to
> read if that governing mutex_trylock() conditional was inverted:
>
> 	if (mddev_trylock(mddev))
> 		return;
>
> Then you could de-indent most of the function by one indentation
> level...

You could send a patch if you liked.... but as it looks like I have more
work to do there, I'll probably do it.

>
>> If you try again it will almost certainly succeed.  I suspect this is a
>> hard race to hit - well done!!!
>
> I'll give it a try -- I hit it twice in succession, once with a
> --backup-file, once without. Since mdadm does not warn about the lack of
> a --backup-file, I guess the statement in the manual that it is
> essential to provide one when changing RAID levels is untrue: I suspect
> that it's necessary *if* you're not increasing the number of disks at
> the same time, but since I'm growing into a spare, adding a
> --backup-file only slows it down?
>
> I might run a backup first though. :)

Always a good idea, if you can.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkji0kACgkQOeye3VZi
gblRCxAAmxMt/uwxeg6owTZ2XTRJol5+4iJVFl3XXlupHwuc9pijtTmMOO/rYIVt
cXxMTHb/8nb8sp4dRHlw9BpcvOoKg3frzQc+dZegmADowRIyfAY1Yg8NBzjS9MxG
irnCofgpFs4J2hhp4rLgGYIJRtGpKNcJBaUPrkdLRJJ+TWwV+rlCXsMXxScgRAZy
xcUzvDtSmZ3RLsPSsxWdCmz14MKk1Fni4qQVo/n8WyHiRKybFtHpOFy2P6OsovFv
DX+gTeom/71V/ktw58hHZWNuQ9zndgQAvXpv4DIbPo502Qfrq9Af4Elw2pF6/w+t
ZX14pVwONPGlp6Yi46wIZ9ls+Sh+ya3s3F59QbPbKVVWdgKnZ/o6Qs4e3Kckj1t2
PLlSPxsiGj3K9ylNv2HmLbkVSgagQUWYZVlMC5g0MKk2Jcr8i/gttMtCCJmuTYuT
3U29LNv9nwNvvienK68M/RvsjucSl13s45rzS6VWJMIAMDJeniM8HdZtNVa9auu+
BEVn3VFeOJ+3hMV/u+7+48S6jZcp8GA9Xxtghk6Lc1nLCO45eS6IhLSVBfrs/1mb
8bYj36R7vD2TKCcNX5FTH/1lOTLClVL40UrLArKuJiOMFFl91qhX1W4PUTlTpuJx
EBES6rW9z2YEAmCzhvYKSzKz69FsdBvcq6GI8E8yrTuba2wlH4k=
=p9U/
-----END PGP SIGNATURE-----
--=-=-=--
