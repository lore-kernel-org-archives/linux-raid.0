From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: raid1_end_read_request does not retry failed READ from a recovering drive
Date: Sun, 7 Sep 2014 17:18:16 +0300
Message-ID: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
we see the following issue:

# RAID1 has 2 drives A and B, drive B is recovering
# READ request arrives
# read_balanace selects drive B to read from, because READ sector
comes before B->recovery_offset
# READ is issued to drive B, but fails (drive B fails again)

Now raid1_end_read_request() has the following code:

    if (uptodate)
        set_bit(R1BIO_Uptodate, &r1_bio->state);
    else {
        /* If all other devices have failed, we want to return
         * the error upwards rather than fail the last device.
         * Here we redefine "uptodate" to mean "Don't want to retry"
         */
        unsigned long flags;
        spin_lock_irqsave(&conf->device_lock, flags);
        if (r1_bio->mddev->degraded == conf->raid_disks ||
            (r1_bio->mddev->degraded == conf->raid_disks-1 &&
             !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
            uptodate = 1;
        spin_unlock_irqrestore(&conf->device_lock, flags);
    }

According to this code uptodate wrongly becomes 1, because:
r1_bio->mddev->degraded == conf->raid_disks-1 is TRUE
and
!test_bit(Faulty, &conf->mirrors[mirror].rdev->flags) is also TRUE

Indeed, drive B is not marked as Faulty, but also not marked as In_sync.
However, this function treats !Faulty being equal to In_Sync, so it
decides that the last good drive failed, so it does not retry the
READ.

As a result, there is IO error, while we should have retried the READ
from the healthy drive.

This is happening in 3.8.13, but your master branch seems to have the
same issue.

What is a reasonable fix?
1) Do not read from drives which are !In_sync (a bit scary to read
from such drive)
2) replace !Faulty to In_sync check
3) do both

 Can you pls advise?

Thanks,
Alex.
