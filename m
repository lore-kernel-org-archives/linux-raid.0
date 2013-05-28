From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: RAD1 doesn't fail WRITE that was written only on a rebuilding drive
Date: Tue, 28 May 2013 15:46:33 +0300
Message-ID: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hello Neil,
we continue testing last-drive RAID1 failure cases.
We see the following issue:

# RAID1 with drives A and B; drive B was freshly-added and is rebuilding
# Drive A fails
# WRITE request arrives to the array. It is failed by drive A, so
r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
succeeds in writing it, so the same r1_bio is marked as
R1BIO_Uptodate.
# r1_bio arrives to handle_write_finished, badblocks are disabled,
md_error()->error() does nothing because we don't fail the last drive
of raid1
# raid_end_bio_io()  calls call_bio_endio()
# As a result, in call_bio_endio():
	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
		clear_bit(BIO_UPTODATE, &bio->bi_flags);
this code doesn't clear the BIO_UPTODATE flag, and the whole master
WRITE succeeds, back to the upper layer.

# This keeps happening until rebuild aborts, and drive B is ejected
from the array[1]. After that, there is only one drive (A), so after
it fails a WRITE, the master WRITE also fails.

It should be noted, that I test a WRITE that is way ahead of
recovery_offset of drive B. So after such WRITE fails, subsequent READ
to the same place would fail, because drive A will fail it, and drive
B cannot be attempted to READ from there (rebuild has not reached
there yet).

My concrete suggestion is that this behavior is not reasonable, and we
should only count a successful WRITE to a drive that is marked as
InSync. Please let me know what do you think?

Thanks,
Alex.

[1]  Sometimes, it takes up to 2 minutes to eject the drive B, because
rebuild stops and keeps restarting constantly. I am still to debug why
rebuild aborts and then immediately restarts, and this keeps happening
for a long time.
May 27 20:44:09 vc kernel: [ 6470.446899] md: recovery of RAID array md4
May 27 20:44:09 vc kernel: [ 6470.446903] md: minimum _guaranteed_
speed: 10000 KB/sec/disk.
May 27 20:44:09 vc kernel: [ 6470.446905] md: using maximum available
idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
May 27 20:44:09 vc kernel: [ 6470.446908] md: using 128k window, over
a total of 477044736k.
May 27 20:44:09 vc kernel: [ 6470.446910] md: resuming recovery of md4
from checkpoint.
May 27 20:44:09 vc kernel: [ 6470.543922] md: md4: recovery done.
May 27 20:44:10 vc kernel: [ 6470.727096] md: recovery of RAID array md4
May 27 20:44:10 vc kernel: [ 6470.727100] md: minimum _guaranteed_
speed: 10000 KB/sec/disk.
May 27 20:44:10 vc kernel: [ 6470.727102] md: using maximum available
idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
May 27 20:44:10 vc kernel: [ 6470.727105] md: using 128k window, over
a total of 477044736k.
May 27 20:44:10 vc kernel: [ 6470.727108] md: resuming recovery of md4
from checkpoint.
May 27 20:44:10 vc kernel: [ 6470.797421] md: md4: recovery done.
May 27 20:44:10 vc kernel: [ 6470.983361] md: recovery of RAID array md4
May 27 20:44:10 vc kernel: [ 6470.983365] md: minimum _guaranteed_
speed: 10000 KB/sec/disk.
May 27 20:44:10 vc kernel: [ 6470.983367] md: using maximum available
idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
May 27 20:44:10 vc kernel: [ 6470.983370] md: using 128k window, over
a total of 477044736k.
May 27 20:44:10 vc kernel: [ 6470.983372] md: resuming recovery of md4
from checkpoint.
May 27 20:44:10 vc kernel: [ 6471.109254] md: md4: recovery done.
...

Up to now, I see that md_do_sync() is triggered by raid1d() calling
md_check_recovery() first thing it does. Then
md_check_recovery()->md_register_thread(md_do_sync).
