From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: mismatches after growing raid1 and re-adding a failed drive
Date: Fri, 6 Jun 2014 14:59:32 +0300
Message-ID: <CAGRgLy6YHMe-CRB1h4WHC-1xtdy5nURecf51LWu9WRaCy8Nw6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,
testing the following scenario:

1) create a raid1 with drives A and B, wait for resync to complete
(verify mismatch_cnt is 0)
2) drive B fails, array continues to operate as degraded, new data is
written to array
3) add a fresh drive C to array (after zeroing any possible superblock on C)
4) wait for C recovery to complete

At this point, for some reason "bitmap->events_cleared" is not
updated, it remains 0, although the bitmap is clear.

5) grow the array by one slot:
mdadm --grow /dev/md1 --raid-devices=3 --forc
6) re-add drive B back
mdadm --manage /dev/md1 --re-add /dev/sdb

MD accepts this drive, because in super_1_validate:
        /* If adding to array with a bitmap, then we can accept an
         * older device, but not too old.
         */
        if (ev1 < mddev->bitmap->events_cleared)
            return 0;
Since events_cleared==0, this condition DOES NOT hold, and drive B is accepted

7) recovery begins and completes immediately as the bitmap is clear
8) issuing "echo check > ..." yields in a lot of mismatched
(naturally, as B's data was not synced)

Is this a valid scenario? Any idea why events_cleared is not updated?
Kernel is 3.8.13

Thanks,
Alex.
