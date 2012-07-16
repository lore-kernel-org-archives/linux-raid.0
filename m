From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid1 repair: sync_request() aborts if one of the drives has bad
 block recorded
Date: Mon, 16 Jul 2012 11:45:12 +0300
Message-ID: <CAGRgLy6JZXiHFg11Z-_3krj8iKp_Wk7X_wz8OyikyvhLpxzcxg@mail.gmail.com>
References: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
	<20120716133753.1a34e149@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716133753.1a34e149@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
thanks for your comments.

> I don't see that MD_RECOVERY_REQUESTED is really an issue is it?
> We the wrong thing happen in any case where there just one device with no bad
> block, and at least one device with a bad block.  In that case we want to
> skip forward by the number of bad blocks, not skip to the end of the array.

I think that MD_RECOVERY_REQUESTED has some meaning here. Because
there are only two places where we increase "write_targets":
Here:
		} else if (!test_bit(In_sync, &rdev->flags)) {
			bio->bi_rw = WRITE;
			bio->bi_end_io = end_sync_write;
			write_targets ++;
and
	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
		/* extra read targets are also write targets */
		write_targets += read_targets-1;

So if we'll see a device that is not In_sync, we will increase
write_targets and won't fall into that issue. That's why I was
thinking to check for MD_RECOVERY_REQUESTED.

>
> So this?
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 240ff31..c443f93 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2422,7 +2422,10 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
>                 /* There is nowhere to write, so all non-sync
>                  * drives must be failed - so we are finished
>                  */
> -               sector_t rv = max_sector - sector_nr;
> +               sector_t rv;
> +               if (min_bad > 0)
> +                       max_sector = sector_nr + min_bad;
> +               rv = max_sector - sector_nr;
>                 *skipped = 1;
>                 put_buf(r1_bio);
>                 return rv;
>

I tested it and it works. However, I have a question: shouldn't we try
to clear bad blocks during "repair" in particular or during any
kind-of-sync in general?

Because currently the following is happening:
- In sync_request devices are selected as candidates for READs and for
WRITEs (using various criteria)
- Then we issue the READs and eventually end up in sync_request_write()
- Here we schedule WRITEs (without consulting bad blocks or WriteErrorSeen bit)
- In end_sync_write, we check if we can clear some bad blocks, and if
yes, eventually we end up in handle_sync_write_finished(), where we
clear bad blocks

So getting back to sync_request(), the issue is this: if we consider a
device for READs, we check for badblocks. If we find a badblock, we
skip it and don't consider this device neither for READs nor for
WRITEs. How about:
- We consider a device for READs
- If it has a bad block, we consider it for WRITEs instead (so we have
a 3rd place where we consider the device for WRITE).
- We may consult WriteErrorSeen bit as we do in normal make_request(),
but not sure, because right now on sync path, we don't consult it

So this patch:
--- c:/work/code_backups/psp13/raid1.c  Sun Jul 15 16:39:07 2012
+++ ubuntu-precise/source/drivers/md/raid1.c    Mon Jul 16 11:35:40 2012
@@ -2385,20 +2385,25 @@
                                        if (wonly < 0)
                                                wonly = i;
                                } else {
                                        if (disk < 0)
                                                disk = i;
                                }
                                bio->bi_rw = READ;
                                bio->bi_end_io = end_sync_read;
                                read_targets++;
                        }
+                       else {
+                               bio->bi_rw = WRITE;
+                               bio->bi_end_io = end_sync_write;
+                               write_targets ++;
+                       }
                }
                if (bio->bi_end_io) {
                        atomic_inc(&rdev->nr_pending);
                        bio->bi_sector = sector_nr + rdev->data_offset;
                        bio->bi_bdev = rdev->bdev;
                        bio->bi_private = r1_bio;
                }
        }
        rcu_read_unlock();
        if (disk < 0)


I tested this patch (together with yours) and it cleared the bad
blocks, but not sure what else I might be missing. My Linux kernel
programming skills are still ... questionable.

Thanks,
Alex.



>
> Thanks,
> NeilBrown
>
