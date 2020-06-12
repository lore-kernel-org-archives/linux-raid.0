From: allenpeng <allenpeng@synology.com>
Subject: [PATCH] mdadm/Grow: prevent md's fd from being occupied during delayed time
Date: Fri, 12 Jun 2020 17:00:39 +0800
Message-ID: <1591952439-8768-1-git-send-email-allenpeng@synology.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jes.sorensen@gmail.com, allenpeng <allenpeng@synology.com>
List-Id: linux-raid.ids

If we start reshaping on md which shares sub-devices with another
resyncing md, it may be forced to wait for others to complete. mdadm
occupies the md's fd during this time, which causes the md can not be
stopped and the filesystem can not be mounted on the md. We can close
md's fd earlier to solve this problem.

Reproducible Steps:

1. create two partitions on sda, sdb, sdc, sdd
2. create raid1 with sda1, sdb1
mdadm -C /dev/md1 --assume-clean -l1 -n2 /dev/sda1 /dev/sdb1
3. create raid5 with sda2, sdb2, sdc2
mdadm -C /dev/md2 --assume-clean -l5 -n3 /dev/sda2 /dev/sdb2 /dev/sdc2
4. start resync at md1
echo repair > /sys/block/md1/md/sync_action
5. reshape raid5 to raid6
mdadm -a /dev/md2 /dev/sdd2
mdadm --grow /dev/md2 -n4 -l6 --backup-file=/root/md2-backup

Now mdadm is occupying the fd of md2, causing md2 unable to be stopped

6.Try to stop md2, an error message shows
mdadm -S /dev/md2
mdadm: Cannot get exclusive access to /dev/md3:Perhaps a running process,
mounted filesystem or active volume group?

Reviewed-by: Alex Wu <alexwu@synology.com>
Reviewed-by: BingJing Chang <bingjingc@synology.com>
Reviewed-by: Danny Shih <dannyshih@synology.com>
Signed-off-by: ChangSyun Peng <allenpeng@synology.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index a4be7e7..5b8f774 100644
--- a/Grow.c
+++ b/Grow.c
@@ -3514,6 +3514,7 @@ started:
 			return 0;
 		}
 
+	close(fd);
 	/* Now we just need to kick off the reshape and watch, while
 	 * handling backups of the data...
 	 * This is all done by a forked background process.
@@ -3566,7 +3567,6 @@ started:
 			mdstat_wait(30 - (delayed-1) * 25);
 	} while (delayed);
 	mdstat_close();
-	close(fd);
 	if (check_env("MDADM_GROW_VERIFY"))
 		fd = open(devname, O_RDONLY | O_DIRECT);
 	else
-- 
2.7.4
