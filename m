From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAD1 doesn't fail WRITE that was written only on a rebuilding drive
Date: Tue, 28 May 2013 23:12:38 +0300
Message-ID: <CAGRgLy6qAmn8Fx08BPoAp7uYqWdO4KHuTqkmbTGHAGkWhWF9sg@mail.gmail.com>
References: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
I have found why recovery is triggered again and again.

After initial recovery aborts, raid1d() calls md_check_recovery(),
which calls remove_and_add_spares().
So remove_and_add_spares wants to eject the rebuilding drive from the
array, but cannot because rdev->nr_pending>0:
		if (rdev->raid_disk >= 0 &&
		    !test_bit(Blocked, &rdev->flags) &&
		    (test_bit(Faulty, &rdev->flags) ||
		     ! test_bit(In_sync, &rdev->flags)) &&
		    atomic_read(&rdev->nr_pending)==0) {
if (mddev->pers->hot_remove_disk(
...

So instead it goes ahead and triggers another recovery in the
following condition (by incrementing "spares"):
	rdev_for_each(rdev, mddev) {
		if (rdev->raid_disk >= 0 &&
		    !test_bit(In_sync, &rdev->flags) &&
		    !test_bit(Faulty, &rdev->flags))
			spares++;

So another recovery starts, aborts, is triggered again, aborts and so forth.

Because conditions:
test_bit(Faulty, &rdev->flags) || ! test_bit(In_sync, &rdev->flags)
and
!test_bit(In_sync, &rdev->flags) &&  !test_bit(Faulty, &rdev->flags))
can both be true at the same time.

Problem is that IOs keep coming in, because MD does not fail them as I
discussed in the previous email. So nr_pending never gets to zero, or
it takes it a long time to get to zero (totally racy), and we keep
triggering and aborting recovery.

Can we fix remove_and_add_spares() the following way:

"if a drive qualifies for being removed from array, but cannot be
removed because of nr_pending, don't try to trigger another recovery
on it by returning doing spares++".

This issue, however, is less critical, than the issue in the previous
email, because the previous issue causes real data corruption: we
WRITE only to the rebuilding drive, but we will not be reading from
this drive, because it's still rebuilding. So the WRITEs are lost.

Thanks,
Alex.







On Tue, May 28, 2013 at 3:46 PM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Hello Neil,
> we continue testing last-drive RAID1 failure cases.
> We see the following issue:
>
> # RAID1 with drives A and B; drive B was freshly-added and is rebuilding
> # Drive A fails
> # WRITE request arrives to the array. It is failed by drive A, so
> r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
> succeeds in writing it, so the same r1_bio is marked as
> R1BIO_Uptodate.
> # r1_bio arrives to handle_write_finished, badblocks are disabled,
> md_error()->error() does nothing because we don't fail the last drive
> of raid1
> # raid_end_bio_io()  calls call_bio_endio()
> # As a result, in call_bio_endio():
>         if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>                 clear_bit(BIO_UPTODATE, &bio->bi_flags);
> this code doesn't clear the BIO_UPTODATE flag, and the whole master
> WRITE succeeds, back to the upper layer.
>
> # This keeps happening until rebuild aborts, and drive B is ejected
> from the array[1]. After that, there is only one drive (A), so after
> it fails a WRITE, the master WRITE also fails.
>
> It should be noted, that I test a WRITE that is way ahead of
> recovery_offset of drive B. So after such WRITE fails, subsequent READ
> to the same place would fail, because drive A will fail it, and drive
> B cannot be attempted to READ from there (rebuild has not reached
> there yet).
>
> My concrete suggestion is that this behavior is not reasonable, and we
> should only count a successful WRITE to a drive that is marked as
> InSync. Please let me know what do you think?
>
> Thanks,
> Alex.
>
> [1]  Sometimes, it takes up to 2 minutes to eject the drive B, because
> rebuild stops and keeps restarting constantly. I am still to debug why
> rebuild aborts and then immediately restarts, and this keeps happening
> for a long time.
> May 27 20:44:09 vc kernel: [ 6470.446899] md: recovery of RAID array md4
> May 27 20:44:09 vc kernel: [ 6470.446903] md: minimum _guaranteed_
> speed: 10000 KB/sec/disk.
> May 27 20:44:09 vc kernel: [ 6470.446905] md: using maximum available
> idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> May 27 20:44:09 vc kernel: [ 6470.446908] md: using 128k window, over
> a total of 477044736k.
> May 27 20:44:09 vc kernel: [ 6470.446910] md: resuming recovery of md4
> from checkpoint.
> May 27 20:44:09 vc kernel: [ 6470.543922] md: md4: recovery done.
> May 27 20:44:10 vc kernel: [ 6470.727096] md: recovery of RAID array md4
> May 27 20:44:10 vc kernel: [ 6470.727100] md: minimum _guaranteed_
> speed: 10000 KB/sec/disk.
> May 27 20:44:10 vc kernel: [ 6470.727102] md: using maximum available
> idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> May 27 20:44:10 vc kernel: [ 6470.727105] md: using 128k window, over
> a total of 477044736k.
> May 27 20:44:10 vc kernel: [ 6470.727108] md: resuming recovery of md4
> from checkpoint.
> May 27 20:44:10 vc kernel: [ 6470.797421] md: md4: recovery done.
> May 27 20:44:10 vc kernel: [ 6470.983361] md: recovery of RAID array md4
> May 27 20:44:10 vc kernel: [ 6470.983365] md: minimum _guaranteed_
> speed: 10000 KB/sec/disk.
> May 27 20:44:10 vc kernel: [ 6470.983367] md: using maximum available
> idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> May 27 20:44:10 vc kernel: [ 6470.983370] md: using 128k window, over
> a total of 477044736k.
> May 27 20:44:10 vc kernel: [ 6470.983372] md: resuming recovery of md4
> from checkpoint.
> May 27 20:44:10 vc kernel: [ 6471.109254] md: md4: recovery done.
> ...
>
> Up to now, I see that md_do_sync() is triggered by raid1d() calling
> md_check_recovery() first thing it does. Then
> md_check_recovery()->md_register_thread(md_do_sync).
