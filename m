From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID 5 Grow
Date: Sat, 16 Jul 2005 14:54:28 +1000
Message-ID: <17112.37636.345831.676818@cse.unsw.edu.au>
References: <1121457052.3012.36.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Forrest Taylor on Friday July 15
Sender: linux-raid-owner@vger.kernel.org
To: Forrest Taylor <ftaylor@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday July 15, ftaylor@redhat.com wrote:
> I am doing some RAID scenarios on a single disc (testing purposes) on
> RHEL4.  I have some partitions as follows:
> 
> /dev/hda5  100M
> /dev/hda6  200M
> /dev/hda7  200M
> /dev/hda8  200M
> /dev/hda9  200M
> 
> I create a RAID 5 set with /dev/hda{5,6,7,8}.  I fail/remove /dev/hda5
> and add /dev/hda9, at which point I can grow the RAID.  Running:
> 
> mdadm -G /dev/md0 -z max
> 
> will increase the RAID size, however, it sets off a infinite resync.  I
> have tested with mdadm-1.6.0-2, and with mdadm-1.12.0-1 rebuilt from the
> source rpm.

What kernel were you running?  There were problems with looping
resyncs, but I think they have been fixed.

I just repeated your experiment on 2.6.13-rc1-mm1 and didn't get an
infinite loop, but it took < 1second to sync the second 200M, whereas
the first 100M took 7 seconds, so I'm a bit worried...

Ahh, found the problem.  The following patch is required to make it
resync properly, and with it the experiment does what is expected.
Thanks for helping me find that.

NeilBrown

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-07-16 14:41:19.000000000 +1000
+++ ./drivers/md/md.c	2005-07-16 14:41:21.000000000 +1000
@@ -2580,6 +2580,7 @@ static int update_array_info(mddev_t *md
 			if (avail < ((sector_t)info->size << 1))
 				return -ENOSPC;
 		}
+		mddev->resync_max_sectors =  (sector_t)info->size *2; /*default */
 		rv = mddev->pers->resize(mddev, (sector_t)info->size *2);
 		if (!rv) {
 			struct block_device *bdev;
