From: Eric Mei <meijia@gmail.com>
Subject: Last working drive in RAID1
Date: Wed, 04 Mar 2015 12:55:43 -0700
Message-ID: <54F7633F.3020503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

It is interesting to notice that RAID1 won't mark the last working drive 
as Faulty no matter what. The responsible code seems here:

static void error(struct mddev *mddev, struct md_rdev *rdev)
{
         ...
         /*
          * If it is not operational, then we have already marked it as dead
          * else if it is the last working disks, ignore the error, let the
          * next level up know.
          * else mark the drive as failed
          */
         if (test_bit(In_sync, &rdev->flags)
             && (conf->raid_disks - mddev->degraded) == 1) {
                 /*
                  * Don't fail the drive, act as though we were just a
                  * normal single drive.
                  * However don't try a recovery from this drive as
                  * it is very likely to fail.
                  */
                 conf->recovery_disabled = mddev->recovery_disabled;
                 return;
         }
         ...
}

The end result is that even if all the drives are physically gone, there 
still one drive remains in array forever, and mdadm continues to report 
the array is degraded instead of failed. RAID10 also has similar behavior.

Is there any reason we absolutely don't want to fail the last drive of 
RAID1?

Thanks
Eric
